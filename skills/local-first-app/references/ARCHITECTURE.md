# Architecture — deep reference

Load when wiring the data layer, migrations, or shared state. The hard rule is **import purity**: `src/<domain>/` imports no React, no Next, no DB.

## The pure core (`src/<domain>/`)

The single home for every derived value — status counts, filters, streaks, summaries, and any real computation (a unit conversion, a projection from history). Works in plain data, returns explicit typed result objects, and **throws on invalid input** rather than guessing.

- One file per concept — `summary.ts` / `filters.ts`, plus `rules.ts` for business-rule predicates — and an `index.ts` barrel.
- Higher-level helpers (`analyzeX`, `summarizeX`) compose the primitives and return the per-row shapes the UI renders.
- Shared helpers (a status-grouping reducer, a period iterator) avoid duplicating the same traversal across features.

**Business rules live in the action's guard step.** A rule needing DB context ("can't mark a project done while it has open tasks") runs in the server action: load the rows, check, throw a typed domain error before writing. Inline is fine. Extract to pure predicates in `rules.ts` (`canMarkDone(project, tasks): Result`) once they grow or need tests — a derived boolean is just more core logic.

## The store (`src/db/`, `server-only`)

`node:sqlite`'s `DatabaseSync` — no native addon, so the app compiles into one file. Unflagged from **v22.13.0 / v23.4.0** ([nodejs.org/api/sqlite.html](https://nodejs.org/api/sqlite.html)); pin the CI floor at 22.13. The `ExperimentalWarning` on import is expected.

```
src/db/
  schema.ts       BASE_SCHEMA exported as a TS string (NOT a .sql file read at runtime)
  migrations.ts   versioned migrations + runInTransaction wrapper
  index.ts        openDatabase() → typed query API; runs migrations on boot
```

**Open the connection once, hardened**, and guard the singleton against Next's dev HMR (which re-evaluates modules and would reopen the file → "database is locked"):

```ts
// src/db/index.ts
declare global { var __db: DatabaseSync | undefined }

let migratedThisModule = false;

export function getDb(): DatabaseSync {                    // server-only
  const db = (globalThis.__db ??= open());                 // connection survives HMR
  if (!migratedThisModule) {                               // module state does NOT — that's the hook
    migrate(db);                                           // cheap: user_version gate
    migratedThisModule = true;
  }
  return db;
}

function open(): DatabaseSync {
  const db = new DatabaseSync(resolveDbPath());
  db.exec(`
    PRAGMA journal_mode = WAL;     -- concurrent readers during a write
    PRAGMA synchronous = NORMAL;   -- safe with WAL, far faster than FULL
    PRAGMA busy_timeout = 5000;    -- retry on lock contention instead of failing instantly
    PRAGMA foreign_keys = ON;      -- per-connection; OFF by default
  `);
  snapshotBeforeMigrate(db);       // fatal on failure
  pruneSnapshots(backupDir());     // separate call — must NOT be fatal
  migrate(db);
  db.exec("PRAGMA optimize");      // AFTER migrate: stats for the new schema, not the old one
  resolveStuckJobs(db);            // only if the app has a background-job table
  return db;
}
```

Ship the full pragma set from day one. Without WAL + `busy_timeout`, a server action writing while a server component reads throws `SQLITE_BUSY`.

**Cache the handle, not the query API.** `globalThis.__db` holds the bare `DatabaseSync`; query functions stay free functions taking `db` first (`listTasksByProject(db, projectId)`). That seam lets a unit test pass an in-memory DB instead of stubbing a global, and keeps HMR honest since a re-evaluated module re-exports the new functions.

### Pre-migration snapshots (required)

Local-first means no server-side copy, so a bad migration is unrecoverable user data. State it as a requirement of this layer — an app can satisfy every other rule, pass every gate it runs, and still have no protection here.

The snapshot directory sits **outside whatever a routine reset removes**, which resolves two ways for the same reason. In a checkout it's a sibling of the data dir — `rm -rf data/` is a normal dev reset and must not take the snapshots protecting that data with it. In a packaged build the entire app directory is disposable, so it resolves to the OS per-user data dir (`~/Library/Application Support/<app>`, `%APPDATA%`, `$XDG_DATA_HOME`). Branch once in `resolveBackupDir()`; every caller below takes what it returns.

```ts
function snapshotBeforeMigrate(db: DatabaseSync) {          // throws
  const current = db.prepare("PRAGMA user_version").get() as { user_version: number };
  if (current.user_version >= LATEST_VERSION) return;   // nothing pending
  if (current.user_version === 0) return;               // fresh DB — nothing to protect yet

  const dir = resolveBackupDir();                           // outside anything a reset removes
  mkdirSync(dir, { recursive: true });

  const target = uniqueTarget(dir, `v${String(current.user_version).padStart(4, "0")}-${stamp()}`);
  if (target.includes("'")) throw new Error(`backup path contains a quote: ${target}`);
  db.exec(`VACUUM INTO '${target}'`);                       // no bound params in VACUUM INTO
}

function uniqueTarget(dir: string, base: string): string {
  let candidate = join(dir, `${base}.sqlite`);
  for (let counter = 2; existsSync(candidate); counter++) {   // ms stamps DO collide
    candidate = join(dir, `${base}-${counter}.sqlite`);
  }
  return candidate;
}

function pruneSnapshots(dir: string, keep = 20) {           // never throws
  try {
    const snapshots = readdirSync(dir)
      .filter((file) => file.endsWith(".sqlite"))
      .map((file) => ({ file, modified: statSync(join(dir, file)).mtimeMs }))
      .sort((left, right) => left.modified - right.modified);  // oldest first, by TIME
    for (const stale of snapshots.slice(0, -keep)) rmSync(join(dir, stale.file));
  } catch (error) {
    console.warn("snapshot rotation failed; the snapshot itself is intact", error);
  }
}
```

Four rules the obvious version gets wrong:

1. **Gate on pending migrations**, or every dev-server restart writes a snapshot.
2. **Break filename ties with a counter.** ISO-8601 bottoms out at the millisecond and two programmatic calls land inside one. Relying on `VACUUM INTO` throwing gives one of two shipped failures: catch it and you migrate with **no backup**; treat it as fatal and the app **refuses to start**.
3. **Prune by timestamp, globally.** Sorting by filename puts `v10-…` before `v2-…`, so an oldest-first prune deletes the *newest* snapshots past v9. "Keep 20" means 20 backups total — prune under the versioned prefix and you keep a full set per version, growing without bound, and `v0001` prefix-matches `v0010`.
4. **Two functions, opposite failure policies.** A failed snapshot is fatal; refusing to migrate without one is the point. A failed rotation must not be — the snapshot exists, and dying in cleanup blocks the migration it just protected.

**Pre-migration snapshots are not a backup schedule.** They fire only when a migration is pending, so an app shipping no schema change for a month is protecting a month-old copy of data that changed daily. Add a periodic snapshot — on boot and on a fixed interval — through the same writer and the same rotation. Its failure policy is the opposite of the pre-migration one: a failed scheduled backup logs and the app starts anyway, because nothing destructive is about to happen.

**Restore is a UI surface, not a README paragraph** — for any app that also follows PACKAGING.md. That bundle's recipient has no checkout, no README and no terminal, so "copy the file back" documents a procedure they cannot perform. List the snapshots, restore in place, and clear the cached handle so the next `getDb()` reopens the restored file without an app restart. An app that will only ever run from a checkout can stop at the documented file copy.

Test the restore, not the backup: open the copy and read a row back.

### Migrations

- **Schema as a TS string export.** `readFileSync(join(process.cwd(), ...))` ENOENTs next to a shipped binary. Define tables **parent-before-child** — a `REFERENCES` to a not-yet-defined table errors with FKs on.
- **`BASE_SCHEMA` is migration v1**, so there is exactly one way to construct a schema: every database runs each migration with `version > user_version`, in order, and a fresh DB starts at 0 and replays the chain. A fast path that runs `BASE_SCHEMA` and jumps `user_version` to the max makes them two definitions kept in manual agreement, and the drift is invisible to whoever introduces it (dev machines replay and stay green) while breaking **every new install and every packaged binary**.
- Each migration is idempotent (`CREATE IF NOT EXISTS`, guarded `ALTER TABLE ... ADD COLUMN`) and runs **inside one transaction with its `user_version` bump**, so a multi-statement migration can't half-apply and desync the counter:

```ts
function applyMigration(db: DatabaseSync, m: Migration) {
  runInTransaction(db, () => {
    m.up(db);
    db.exec(`PRAGMA user_version = ${m.version}`);   // atomic with the DDL above
  });
}
```

- **Re-run migrations once per module load.** Migrations run inside `open()`, which the `globalThis` cache skips — so a migration shipped while `next dev` runs never applies, and queries on the new columns 500 while vitest and any fresh boot pass. Module state resets on HMR reload while the cache doesn't; that asymmetry is why `getDb()` carries the `migratedThisModule` recheck. The `user_version` gate makes re-entry two PRAGMA reads.
- **`runInTransaction(db, fn)`** — node:sqlite has no `db.transaction()`. Use `BEGIN IMMEDIATE` on write paths so lock contention surfaces up front instead of mid-transaction:

```ts
export function runInTransaction<T>(db: DatabaseSync, fn: () => T): T {
  db.exec("BEGIN IMMEDIATE");
  try { const result = fn(); db.exec("COMMIT"); return result; }
  catch (error) { db.exec("ROLLBACK"); throw error; }
}
```

### Query API and paths

- Expose a **small typed query API** (`createX`, `requireX`, batched aggregates to avoid N+1), not raw SQL at call sites. `.all()` returns `Record<string, unknown>[]` — assert the return type at that seam (an `as Row[]` cast or a zod parse on reads). Compile hot statements once at module level.
- **`requireX` calls `notFound()`** (`next/navigation`) on a missing row; a thrown plain `Error` is a 500.
- `getDb()` is `server-only`. Resolve the data dir via one helper: an env override (`<APP>_DATA_DIR`, set by the desktop entrypoint) else `./data`. **In a packaged binary the env var is mandatory** — `./data` is CWD-relative, so it follows wherever the user launched from.
- Gitignore `data/`, `*.sqlite`, `*.sqlite-wal`, `*.sqlite-shm`, `.next/`.

**Resolve stuck jobs on boot** *(only with a background-job table)*. A process killed mid-flight leaves rows in `running` forever; a single-user app has one process, so a `running` job at boot has a dead owner.

```ts
function resolveStuckJobs(db: DatabaseSync) {
  db.exec(`UPDATE jobs SET status = 'failed', error = 'interrupted by restart'
            WHERE status = 'running'`);
}
```

## The glue (`lib/`)

Plumbing, not logic. It assembles data, shapes it for screens, and calls the core for every derived value.

- `'server-only'` loaders the server pages call (`loadX()` = `getDb()` + query + map). A loader may *call* core helpers but holds no rollup logic.
- zod schemas, one per write boundary (`lib/schemas/<entity>.ts`); formatters; the color module; config defaults.
- **Two row shapes:** a **list row** (scalar columns + cheap counts) and a **detail aggregate** (the row + children + a core summary). A `toX(row, derived)` mapper builds each.
- **Sibling-props is a valid alternative for shallow relationships.** When detail needs no merged summary type — just the row plus a child list rendered as-is — one unified `toX(row)` mapper for both, with children fetched separately and passed as a sibling prop, is simpler and equally correct. Take the two-shape split when detail needs a core-computed aggregate over the children.
- **A third shape: metadata + opaque computed blob**, for a calculator/report bolted onto a CRUD app. A row (`slug, name, note, data` where `data` is a schemaless JSON blob) auto-seeded on first visit, produced by a code-registered `build(...)` keyed on `slug`, re-run via a "refresh" action that overwrites `data`. Closer to a cache with a rebuild button than to either row shape.

## Routes & server actions (`app/`)

Each data page is a server component with `export const dynamic = "force-dynamic"`, loading via a `lib/` loader and passing plain rows to a `'use client'` child. Writes are `'use server'` actions: zod `.parse()` → rule guard → typed DB call → `revalidatePath()`.

**`force-dynamic` and `revalidatePath` are not redundant.** `force-dynamic` keeps the *server* render fresh (no full-route cache); `revalidatePath` busts the *client* Router Cache after a write, so a route you navigate back to refreshes instead of showing a stale snapshot.

**Next 15: `params` and `searchParams` are async.** `await` them (`const { projectId } = await searchParams`); synchronous access type-errors. The FK-prefill pattern depends on this.

**One schema, two consumers — bridged by `z.coerce`.** The schema lives once and is the authority on both sides. Use `z.coerce.*` for every non-string field so the same schema validates native types in the browser and survives a server round-trip:

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

**Submit via Mantine `useForm`, not a raw `<form action>`.** The controlled form gives inline client validation through `zodResolver`; `onSubmit` calls the action inside `startTransition`; on server-side failure the action *returns* field errors and the client maps them with `form.setErrors()`:

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
export async function saveProject(values: unknown) {
  const parsed = ProjectInput.safeParse(values);           // authority
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

`redirect()` throws internally, so lines after it never run and `runInTransaction` re-throws it cleanly. `useFormStatus` only works in a component nested *inside* the `<form>`, not the one rendering it — hence `useTransition`.

**Delete — the one modal.** A hand-rolled controlled `<Modal>` (`<ConfirmDeleteButton>`), not `@mantine/modals`. The async action runs inside `startTransition` or its pending state breaks:

```tsx
<ConfirmDeleteButton
  entityLabel="project"
  cascade={`${project.tasks.length} tasks`}          // from the detail loader's counts
  onConfirm={() => deleteProject(project.id)}        // → revalidatePath → redirect to list
/>
```

The same component carries option-bearing confirms (an "also delete the source file" checkbox). Full implementation: **[CHROME.md](./CHROME.md)**.

## Screen shells

- **`<FormScreen>`** — title ("New X" / "Edit X"), the `<EntityForm>`, cancel/save bar; identical for create and edit. **Always share this one.**
- **List & detail stay per-entity** (`CardList`, `CardDetail`) — table columns, detail layout and `<RelatedList>` sections diverge, so a generic shell often costs more than it saves. Promote once duplication is real.
- **Detail-page chrome converges later** — a shared `PageShell` (title + actions row) and `PageActions` (Edit + the delete-confirm button) standardize detail pages the way `<FormScreen>` standardizes forms. Same threshold.

## Review-deck triage

For entity sets needing recurring re-checking rather than one-off CRUD — items due for follow-up, records gone stale.

- **Selection is a pure core function.** `itemsDueForReview(items, now): Item[]` lives in `src/<domain>/` and takes the current time as an argument rather than reading it, so it stays testable.
- **One card at a time**, not a table: the current item, 1–2 actions, advanced by swipe or keyboard.
- **A progress indicator** (`3 of 12`), plus **explicit empty and done states** — "nothing needs review" on an empty selection, and a distinct "you cleared the queue" after the last card.

A screen shape alongside list/detail/form, reading the same entities through a different selector.

## Adding an entity (touch these, in order)

1. **`src/<x>/`** — types, `summary.ts`, `rules.ts`, `index.ts` barrel.
2. **`src/db/`** — the table in `BASE_SCHEMA` (parent-before-child), a migration if the DB already ships, typed query fns (`listX`, `requireX`, `createX`, `updateX`, `deleteX`, batched `countYByX`).
3. **`lib/schemas/<x>.ts`** — the one zod schema (`z.coerce.*` on non-strings).
4. **`lib/<x>.ts`** — list loader (+counts), detail loader (+aggregate), row types, the `toX` mapper.
5. **`app/<x>/`** — `page` / `new` / `[id]` / `[id]/edit` / `actions.ts` / `not-found` / `error`.
6. **`components/`** — `<X>Form` reusing `<FormScreen>`, plus per-entity `<X>List` / `<X>Detail`.
7. **Wire relationships** — `<RelatedList>` on the parent's detail, a back-link on the child, FK-prefill on `+ New`.

Deliberately not hidden behind a factory: the duplication is mechanical but explicit, and each entity stays independently editable. If steps 2 and 4 chafe across many entities, that's where a typed-store helper earns its keep.

## Shared derived state for multi-step flows

When several tabs or a wizard need the *same* computed data, hoist it into a **context provider above the tabs** that owns the raw inputs and the derived analysis (it calls core helpers; no logic lives in it).

The hard requirement: **selections and computed results survive navigating Next/Back across steps.** A "stale selection" guard fires when an upstream change invalidates a downstream choice.

## Component consolidation

The UI converges on a few shared primitives — reuse them instead of bespoke variants:

- a `<RelatedList>` for every parent→child section, with a **1:N mode** (rows link out, `+ New` prefills the FK) and an **N:N mode** (attach/detach) — one component, one mode prop,
- a controlled grouped-columns table (parent owns which column groups show),
- a chart renderer with a built-in bar/line toggle,
- multi-select filter pills, and a filtered-section render-prop handing selected groups to its children.

Parent owns filter state; children are dumb. One pill selection filters a table and its chart together.

## Background jobs (long-running sync)

Optional machinery — skip it for pure manual-entry CRUD, reach for it once an action would leave the user on a spinner for more than a couple of seconds. Model the work as a **job row**, not a blocking action.

- **A job table** — `id, kind, status (queued/running/done/error), phase, total, done, error, created_at, finished_at`. The UI polls this row, never the raw operation.
- **Kick off from a detached promise held in a module-level `Set`**, so the work survives the response:

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

- **Client polls the job row** every ~2s while `status === "running"` and renders progress from `done`/`total`. A small `useJob(jobId)` hook is enough; no websocket for a single-user app.
- **Boot-time reconciliation** marks any still-`running` job from a previous process as `error`, so the UI never shows a permanently-stuck spinner.
- **Gate auto-run behind a `last_run` timestamp**, not "always on mount" — HMR and navigation shouldn't fire duplicate syncs.

## External APIs, caching, and dedup

Isolate each third-party API behind its own `lib/sources/<name>.ts` — one function per operation, its own throttle, no cross-source coupling.

- **Throttle per source, not globally** — a rate-limited API shouldn't stall a fast one. A `sleep(THROTTLE_MS)` between calls, tuned per source, covers a single-user app's volume.
- **Cache-first, including negative results.** Cache a confirmed miss (a `null` sentinel) so an item with no match isn't re-queried every sync; only an explicit "retry" clears it.
- **Per-item failure isolation.** Catch per item, record the error alongside successes, and return a partial-success summary (`{ succeeded: 12, failed: 2, errors: [...] }`) rather than aborting on the first failure.
- **Dedup by natural key on import.** A source's ID won't reliably match an existing row — normalize the title and match before inserting:

```ts
// src/import/normalize.ts — pure
export const normalizeTitle = (title: string) =>
  title.toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();
```

- **Secrets exception.** The "no server-side secrets" scope line assumes a hosted multi-user service; a local single-user app legitimately stores third-party API keys. Keep them in a `settings` table (or `.env` in dev), never echo them back to the client, never log them.

## Testing layout

Tests live in a **top-level `tests/` directory** mirroring the source tree.

```
tests/
  shims/
    next-cache.ts        revalidatePath / revalidateTag → no-ops
    next-navigation.ts   notFound / redirect → throwing sentinels the tests assert on
    node-sqlite.ts       createRequire redirect (Vite mangles the builtin specifier)
    server-only.ts       empty module — the real one throws outside a server context
  <domain>/summary.test.ts
  db/migrations.test.ts
  lib/loaders.test.ts
```

The **shims are the point**. Anything importing `src/db/` or a `'server-only'` module is unimportable under vitest without them, and each fails in its own confusing way: `server-only` throws at import time, `node:sqlite` resolves to nothing, `notFound()` has no route context. Wire them as aliases in `vitest.config.ts` alongside `@/*` → repo root.

## Agent access (MCP)

Expose the app's read surface over MCP via `mcp-handler` at `app/api/mcp/route.ts`. Close to free — the loaders already return plain serializable rows.

- **Read tools first** (`list_<entity>`, `get_<entity>`, a rollup tool), wrapping the same `lib/` loaders the UI uses so there's no second data path.
- **Writes are opt-in**, reusing the server actions' zod schemas as tool input schemas rather than accepting free-form arguments.
- **No auth layer** — same trust boundary as the app: one user, one machine, a local port.

## Your data is one file

- **Backup** = copy the file (plus its `-wal`/`-shm` siblings, or `PRAGMA wal_checkpoint(TRUNCATE)` first). The pre-migration snapshots give you a rotating set for free.
- **Export/import** for portability: a "download my data" that streams the file, or a per-table CSV/JSON dump. Name it as a feature — it's a core selling point of going local-first. Serialization is pure logic, so it belongs in `src/<domain>/` and is unit-tested against fixtures; the route then only streams what the core returned and needs no test of its own.
- **Reads load everything, filter in the browser** — fine into the low tens of thousands of rows. Past that, push filtering and pagination into the query (`LIMIT`/`OFFSET`, or keyset).
