# Architecture — deep reference

Load when wiring up the data layer, migrations, or shared state. The three layers are: pure core (`src/<domain>/`), server-only store (`src/db/`), glue (`lib/`), routes (`app/`), UI (`components/`).

## The pure core (`src/<domain>/`)

The product's brain, and the **single home for every derived value**. Imports nothing from React, Next, or the DB. Works in plain data — domain entities, and plain numbers in major units where a quantity is exact — returns explicit typed result objects, and **throws on invalid input** rather than guessing. *All* derivation lives here: status counts, filters, streaks, summaries — plus any real computation a domain carries (a unit conversion, a projection from history). One rule, no exceptions: **a derived value? → the core, always.** `lib/` never aggregates; it maps rows and calls the core (see The glue).

- Keep one file per concept — `summary.ts` / `filters.ts`, plus `rules.ts` for business-rule predicates (below) — and an `index.ts` barrel.
- Higher-level helpers (`analyzeX`, `summarizeX`) compose the primitives and return the per-row shapes the UI renders.
- Shared helpers (a status-grouping reducer, a period/loop iterator) avoid duplicating the same traversal across features.
- Because it's pure, it's trivially unit-tested and reusable by a future CLI.

**Business rules live in the action's guard step.** A rule that needs DB context ("can't mark a project done while it has open tasks," "can't delete a tag that's in use") runs in the server action: load the needed rows, check, throw a typed domain error before writing (see Routes) — inline is fine, the way the reference implementation does it. When rules grow or you want them unit-tested, **extract them to pure predicates** in `rules.ts` (`canMarkDone(project, tasks): Result`) and have the action call those — a derived boolean is just more core logic. Optional structure, not a mandate.

## The store (`src/db/`, `server-only`)

`node:sqlite`'s `DatabaseSync` — no native addon, so the app compiles into one file. Requires **Node ≥ 22.5** (`--experimental-sqlite` on 22.x; unflagged on Node ≥ 23 / Node 24). Pin the floor in CI.

```
src/db/
  schema.ts       BASE_SCHEMA exported as a TS string (NOT a .sql file read at runtime)
  migrations.ts   versioned migrations + runInTransaction wrapper
  index.ts        openDatabase() → typed query API; runs migrations on boot
```

**Open the connection once, hardened.** Set the pragmas every local-SQLite app needs, and guard the singleton against Next's dev HMR (which re-evaluates modules and would reopen the file → "database is locked"):

```ts
// src/db/index.ts
declare global { var __db: DatabaseSync | undefined }
export const getDb = () => (globalThis.__db ??= open());   // survives HMR; server-only

function open(): DatabaseSync {
  const db = new DatabaseSync(resolveDbPath());
  db.exec(`
    PRAGMA journal_mode = WAL;     -- concurrent readers during a write (server components render in parallel)
    PRAGMA synchronous = NORMAL;   -- safe with WAL, far faster than FULL
    PRAGMA busy_timeout = 5000;    -- retry on lock contention instead of failing instantly
    PRAGMA foreign_keys = ON;      -- per-connection; OFF by default
  `);
  db.exec("PRAGMA optimize");      // keep the query planner's stats current
  migrate(db);
  return db;
}
```

Without WAL + `busy_timeout`, a server action writing while a server component reads throws `SQLITE_BUSY` — not a tuning nicety, a reliability fix.

This is the recommended baseline, not a guarantee every real app already has it — it's easy to ship with only `WAL` + `foreign_keys` and not notice the gap until a write races a read under real load. Add the full pragma set from day one rather than retrofitting it later.

- **Schema as a TS string export.** `readFileSync(join(process.cwd(), ...))` ENOENTs next to a shipped binary — inline it. Define tables **parent-before-child** in `BASE_SCHEMA` — a `REFERENCES` to a not-yet-defined table errors with FKs on.
- **Versioned migrations** tracked by `PRAGMA user_version`, run on boot. On a **fresh DB** (no tables): run `BASE_SCHEMA`, then set `user_version` to the *current max migration version* — skipping all migrations. On an **existing DB**: run each migration with `version > user_version`, in order. Each migration is idempotent (`CREATE IF NOT EXISTS`, guarded `ALTER TABLE ... ADD COLUMN`) and runs **inside one transaction together with its `user_version` bump**, so a multi-statement migration can't half-apply and desync the counter:

```ts
function applyMigration(db: DatabaseSync, m: Migration) {
  runInTransaction(db, () => {
    m.up(db);
    db.exec(`PRAGMA user_version = ${m.version}`);   // atomic with the DDL above
  });
}
```

- **`runInTransaction(db, fn)`** — node:sqlite has no `db.transaction()`. Use `BEGIN IMMEDIATE` on write paths so lock contention surfaces up front (predictable with `busy_timeout`) instead of mid-transaction:

```ts
export function runInTransaction<T>(db: DatabaseSync, fn: () => T): T {
  db.exec("BEGIN IMMEDIATE");
  try { const result = fn(); db.exec("COMMIT"); return result; }
  catch (error) { db.exec("ROLLBACK"); throw error; }
}
```

- Expose a **small typed query API** (`createX`, `addY`, `requireX`, batched aggregates to avoid N+1), not raw SQL at call sites. `.all()` returns `Record<string, unknown>[]` — assert each query fn's return type at that seam (an `as Row[]` cast or a zod parse on reads) so call sites stay typed. Compile hot statements once (module-level `db.prepare(...)`), not per call.
- **`requireX` calls Next's `notFound()`** (`next/navigation`) on a missing row — a thrown plain `Error` is a 500; `notFound()` renders the route's `not-found.tsx` as a 404.
- `getDb()` is `server-only`. Resolve the data dir via one helper: an env override (`<APP>_DATA_DIR`, set by the desktop entrypoint) else `./data`; `mkdirSync(..., { recursive: true })`. **In a packaged binary the env var is mandatory** — `./data` is CWD-relative, so it follows wherever the user launched the binary from. `./data` is dev-only.
- Gitignore `data/`, `*.sqlite`, `*.sqlite-wal`, `*.sqlite-shm`, `.next/`.

## The glue (`lib/`)

`lib/` is **plumbing, not logic** — it assembles data and shapes it for screens, and calls the core for every derived value. It never aggregates on its own (that rule lives in The pure core).

- `'server-only'` loaders the server pages call (`loadX()` = `getDb()` + query + map). A loader may *call* core helpers (`summarizeProject(project, tasks)`) but holds no rollup logic itself.
- zod schemas, one per write boundary (`lib/schemas/<entity>.ts`); formatters; the color module; config defaults.
- **Two row shapes, not one** — a lightweight **list row** (scalar columns + cheap counts) and a **detail aggregate** (the row + its children + a core summary; a superset of the list row). A `toX(row, derived)` mapper builds each. Don't claim one shape serves every screen — the two loaders return different shapes by design.
- **Sibling-props is a valid alternative for shallow relationships.** When the detail view doesn't need a merged summary type — just the row plus a child list rendered as-is — a single unified `toX(row)` mapper reused for both list and detail, with children fetched by a separate loader call and passed to the component as a sibling prop (not folded into the mapper's output), is simpler and equally correct. Reach for the two-shape split when detail needs a core-computed aggregate over the children; skip it when the children are just displayed.
- **A third shape: metadata + opaque computed-data blob**, for a bespoke calculator/report bolted onto an otherwise-CRUD app. Model it as a row (`slug, name, note, data` where `data` is a JSON blob with no fixed schema) auto-seeded the first time its screen is visited, produced by a code-registered `build(...)` function keyed on `slug`, and re-run on demand via a "refresh" action that overwrites `data`. This isn't a list row or a detail aggregate — closer to a cache with a rebuild button — and it's the shape to reach for instead of forcing a one-off computation into the list-row/detail-aggregate pair.

## Routes & server actions (`app/`)

- Each data page is a server component with `export const dynamic = "force-dynamic"`; it loads via a `lib/` loader and passes plain rows to a `'use client'` child.
- Writes are `'use server'` actions: zod `.parse()` → **rule guard** (load needed rows, check the rule — inline, or an optional `rules.ts` predicate — throw a typed domain error if violated) → typed DB call → `revalidatePath()`. Validate at this boundary; never trust raw input.
- **`force-dynamic` and `revalidatePath` are not redundant.** `force-dynamic` keeps the *server* render fresh (no full-route cache); `revalidatePath` busts the *client* Router Cache after a write, so an already-visited route (the list you navigate back to) refreshes instead of showing a stale snapshot. You need both.

## CRUD as screens (no modals)

Every operation on an entity is its own addressable route — never modal state. The URL is the source of truth, so every screen is deep-linkable, refresh-safe, and works with browser back/forward. Mirror this layout for *every* entity:

```
app/<entity>/
  page.tsx             list      server page → loadEntities()       → <EntityList>   (per-entity)
  new/page.tsx         create    server page → defaults             → <FormScreen>   (shared shell)
  [id]/page.tsx        detail    server page → loadEntityDetail(id) → <EntityDetail> (per-entity)
  [id]/edit/page.tsx   edit      server page → loadEntityDetail(id) → <FormScreen mode="edit">
  actions.ts           'use server' createEntity / updateEntity / deleteEntity
  not-found.tsx        rendered when requireX → notFound()  (bad [id] → 404, not 500)
  error.tsx            catches unexpected throws (incl. the core's deliberate throws)
  loading.tsx          optional — shown while a slow server page resolves
```

**Next 15: `params` and `searchParams` are async.** Page components must `await` them (`const { projectId } = await searchParams`) — synchronous access type-errors and silently misbehaves. The FK-prefill pattern (below) depends on this.

**Edit is the create screen, prefilled.** One `<EntityForm>` component owns the field set; `new` mounts it empty, `edit` mounts it with the loaded row via a `mode` prop. The action branches on presence of an id. This guarantees the two screens never drift.

**One schema, two consumers — bridged by `z.coerce`.** The entity's zod schema lives once in `lib/schemas/<entity>.ts` and is the authority on both sides. Use `z.coerce.*` for every non-string field so the *same* schema validates native types in the browser AND survives a server round-trip:

```ts
// lib/schemas/project.ts — the one schema
export const ProjectInput = z.object({
  id: z.coerce.number().int().optional(),                  // present on edit, absent on create
  name: z.string().min(1),
  targetCount: z.coerce.number().int().nonnegative(),
  archived: z.coerce.boolean().optional().default(false),  // unchecked box = absent → default
});
export type ProjectInput = z.infer<typeof ProjectInput>;
```

**Submit via Mantine `useForm`, not a raw `<form action>`.** The controlled form gives inline client validation through `zodResolver`; `onSubmit` calls the action inside `startTransition`; on a server-side failure the action *returns* field errors and the client maps them with `form.setErrors()`:

```tsx
// components/ProjectForm.tsx — 'use client'
const form = useForm({ initialValues, validate: zodResolver(ProjectInput) });
const [pending, start] = useTransition();
<form onSubmit={form.onSubmit(values => start(async () => {
  const result = await saveProject(values);        // typed values object, NOT FormData
  if (result?.errors) form.setErrors(result.errors);
}))}>
```
```ts
// app/projects/actions.ts — 'use server'; receives the typed values object
"use server";
import { ProjectInput } from "@/lib/schemas/project";
export async function saveProject(values: unknown) {
  const parsed = ProjectInput.safeParse(values);           // authority; z.coerce handles any stray strings
  if (!parsed.success) return { errors: parsed.error.flatten().fieldErrors };
  const input = parsed.data;
  const db = getDb();
  let id: number;
  if (input.id) { updateProject(db, input); id = input.id; }
  else { id = Number(createProject(db, input)); }          // lastInsertRowid is bigint → Number()
  revalidatePath("/projects");
  revalidatePath(`/projects/${id}`);
  redirect(`/projects/${id}`);                             // PRG: land on the canonical detail URL
}
```

`redirect()` throws internally, so the lines after it never run and `runInTransaction` re-throws it cleanly. (Prefer `useFormStatus` over `useTransition` for pending? It only works in a component nested *inside* the `<form>`, not the one rendering it.)

**Delete — the one modal exception.** Data entry is always a screen, but a destructive yes/no is the single allowed dialog: Mantine `openConfirmModal`, with children showing the **cascade blast radius** from the detail loader's counts (`also deletes 4 tasks`). It needs `<ModalsProvider>` in the root provider stack (see UI.md), and the async action must run inside `startTransition` or its pending state breaks:

```tsx
openConfirmModal({
  title: "Delete project?",
  children: <Text>Also deletes {project.tasks.length} tasks.</Text>,
  labels: { confirm: "Delete", cancel: "Cancel" },
  confirmProps: { color: "red" },
  onConfirm: () => startTransition(() => deleteProject(project.id)),   // → revalidatePath → redirect to list
});
```

Don't build a delete *screen*; don't delete without the count.

**The form shell is the high-value reuse.** The one shell worth sharing from day one is the **form/editor** — a `<FormScreen>` (a.k.a. an `EditorShell`) that every entity's new+edit screens mount, so create and edit share identical chrome and only the inner `<EntityForm>` fields differ:

- `<FormScreen>` — title ("New X" / "Edit X"), the `<EntityForm>`, cancel/save bar; identical for create and edit. **Always share this one.**
- **List & detail are usually per-entity components** (`CardList`, `CardDetail`) — they diverge more (each entity's table columns, detail layout, and `<RelatedList>` sections differ), so a generic `<ListScreen>`/`<DetailScreen>` shell often costs more than it saves. Promote them to shared shells only once the duplication is real. Don't mandate a three-shell triad up front.

## Review-deck triage (periodic re-verification)

Some entity sets need recurring re-checking, not one-off CRUD — items due for a follow-up, records that have gone stale, anything where the question is "which of these N need attention right now." A list screen with row actions works but forces the user to scan and decide; a **review deck** turns it into one decision at a time:

- **Selection is a pure core function.** `itemsDueForReview(items, now): Item[]` (or several named selectors — due-for-payment, stale, needs-replacement) live in `src/<domain>/`, same as any other derived value. They take the current time as an argument rather than reading it, so they stay pure and testable.
- **One card at a time**, not a table: the current item, 1-2 actions (e.g. confirm / skip / dismiss), advanced by swipe or keyboard shortcut.
- **A progress indicator** (`3 of 12`) so the user knows how much triage is left.
- **Explicit empty and done states** — "nothing needs review right now" on an empty selection, and a distinct "you cleared the queue" state after the last card, not just an empty screen.

This is a screen shape alongside list/detail/form, not a replacement for them — the deck reads from the same entities and the same store, it just applies a different selector and a different UI for the triage moment.

## Relationships between entities

Entities reference each other with **real foreign keys**, joins are **assembled in loaders**, and the **pure core never follows a relation**.

→ Full 1:N + N:N worked examples (schema, store, loaders, `<RelatedList>`, the at-scale read/write pattern for a real N:N relationship): **[references/RELATIONSHIPS.md](./RELATIONSHIPS.md)**

## Adding an entity (touch these, in order)

The per-entity cost is real and the shape repeats. To add entity `X`:

1. **`src/<x>/`** — types, `summary.ts` (derivations), `rules.ts` (predicates), `index.ts` barrel.
2. **`src/db/`** — add the table to `BASE_SCHEMA` (parent-before-child), a migration if the DB already ships, and the typed query fns (`listX`, `requireX`, `createX`, `updateX`, `deleteX`, batched `countYByX`).
3. **`lib/schemas/<x>.ts`** — the one zod schema (`z.coerce.*` on non-strings).
4. **`lib/<x>.ts`** — list loader (+counts), detail loader (+aggregate), the row types, the `toX` mapper.
5. **`app/<x>/`** — `page` / `new` / `[id]` / `[id]/edit` / `actions.ts` / `not-found` / `error`.
6. **`components/<X>Form.tsx`** + per-entity `<X>List` / `<X>Detail` — the form reuses the shared `<FormScreen>` shell (`zodResolver` inside); list/detail stay per-entity until duplication justifies shared shells.
7. **Wire relationships** — a `<RelatedList>` on each parent's detail screen, a back-link on the child, FK-prefill on `+ New`.

This is deliberately *not* hidden behind a factory — the duplication is mechanical but explicit, and each entity stays independently editable. If steps 2 + 4 (the data plumbing) start to chafe across many entities, that's the first place a typed-store helper would earn its keep.

## Shared derived state for multi-step / tabbed flows

When several tabs or a wizard need the *same* computed data, hoist it into a **context provider above the tabs** that owns the raw inputs AND the derived analysis (it calls the pure-core helpers; no logic lives in it).

The hard requirement: **the user's selections and computed results must survive navigating Next/Back across steps.** Don't recompute per tab or let state reset on step change. A "stale selection" guard should fire if an upstream change invalidates a downstream choice (e.g. the chosen term was deselected).

## Component consolidation

The UI converges on a few shared presentational primitives — reuse them instead of bespoke variants:

- the shared **form shell** (`<FormScreen>` / `EditorShell`) every entity's new+edit screens reuse (list/detail stay per-entity until duplication justifies shared shells),
- once an app has several entities, **detail-page chrome converges too** — a shared `PageShell` (title + actions row) and `PageActions` (an Edit button plus the delete-confirm button from CRUD as screens) standardize every detail page the same way `<FormScreen>` standardizes forms. Promote to this once duplication across detail screens is real — same threshold logic as the form shell,
- a `<RelatedList>` for every parent→child section, with a **1:N mode** (rows link out, `+ New` prefills the FK) and an **N:N mode** (attach/detach controls) — one component, one mode prop,
- a controlled grouped-columns table (parent owns which column groups show),
- a chart renderer with a built-in bar/line toggle,
- multi-select filter pills,
- a filtered-section render-prop that hands selected groups to its children.

Parent owns filter state; children are dumb. One pill selection filters a table and its chart together.

## Background jobs (long-running sync)

When a write triggers work that outlasts a single request — an API sync, a bulk import — model it as a **job row**, not a blocking action. This is optional machinery: skip it for a pure manual-entry CRUD app, reach for it once an action would otherwise leave the user staring at a spinner for more than a couple seconds.

- **A job table** — `id, kind, status (queued/running/done/error), phase, total, done, error, created_at, finished_at`. The UI polls or subscribes to this row, never the raw operation.
- **Kick off from a detached promise held in a module-level `Set`**, so the work survives the response instead of getting cut off when the action returns:

```ts
// app/actions.ts — 'use server'
const runningJobs = new Set<Promise<void>>();   // holds the promise so it isn't GC'd after the response

export async function startSyncAction() {
  const db = getDb();
  const jobId = createJob(db, { kind: "sync", status: "running" });
  const work = runSync(jobId).catch(err => failJob(getDb(), jobId, String(err)));
  runningJobs.add(work);
  work.finally(() => runningJobs.delete(work));
  return { jobId };
}
```

- **Client polls the job row** (every ~2s while `status === "running"`) and renders progress from `done`/`total` — a small `useJob(jobId)` hook or a progress-provider context is enough; no websocket needed for a single-user app.
- **Boot-time reconciliation.** Any job still `running` from a previous process (the server restarted mid-sync) is stale — mark it `error` on startup so the UI never shows a permanently-stuck spinner.
- **Gate auto-run behind a timestamp, not "always on mount."** If the app syncs automatically on launch, check a `last_run` value first — repeated mounts (HMR, navigation) shouldn't fire duplicate syncs.

## External APIs, caching, and dedup

Beyond a single SSRF-guarded proxy route (see SKILL.md's Examples), a sync-heavy app talks to several third-party APIs, each with its own auth, rate limit, and failure mode. Isolate each behind its own `lib/sources/<name>.ts` module — one function per operation, its own throttle, no cross-source coupling.

- **Throttle per source, not globally** — a slow/rate-limited API shouldn't stall a fast one. A `sleep(THROTTLE_MS)` between calls in a loop, tuned per source, is enough for a single-user app's call volume.
- **Cache-first, including negative results.** Cache a successful lookup *and* a confirmed miss (store `null`/a sentinel) so an item with no match doesn't get re-queried on every sync — only an explicit "retry" clears it.
- **Per-item failure isolation.** A sync over N items must not abort on the first failure — catch per item, record the error alongside the successful results, and surface a partial-success summary (`{ succeeded: 12, failed: 2, errors: [...] }`) rather than throwing.
- **Dedup by natural key on import.** A source's ID won't reliably match an existing row — normalize the title/name and match against existing rows before inserting a duplicate:

```ts
// src/import/normalize.ts — pure
export const normalizeTitle = (title: string) =>
  title.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();

// lib/items.ts
export function findExistingMatch(db: DatabaseSync, title: string) {
  const key = normalizeTitle(title);
  return listItems(db).find(item => normalizeTitle(item.title) === key);
}
```

- **Secrets exception.** SKILL.md's "no server-side secrets" line assumes a hosted multi-user service; a local single-user app legitimately stores third-party API keys. Keep them in a `settings` table (or `.env` in dev), never echo them back to the client once saved, and never log them.

## Your data is one file

Local-first's payoff: the entire dataset is a single SQLite file at the data-dir path.

- **Backup** = copy that file (plus its `-wal`/`-shm` siblings, or run `PRAGMA wal_checkpoint(TRUNCATE)` first to fold the WAL back in). No service, no export pipeline required.
- **Export/import** for portability: a "download my data" that streams the file, or a per-table JSON dump, is a few lines — name it as a feature, it's a core selling point of going local-first.
- **Reads load everything, filter in the browser** — fine for a personal tracker into the low tens of thousands of rows. Past that, push filtering/pagination into the query (`LIMIT`/`OFFSET`, or keyset) rather than shipping every row to the client.
