---
name: local-first-app
description: Local-first CRUD blueprint — Next.js + node:sqlite, single-user, no backend. Use this skill whenever the user wants to "build a local app to track my X", "a tracker that saves to my machine", "an offline single-user app with no account", "add a persisted entity", or "package this as a desktop binary" — even if they never say local-first and only describe a personal tracker, catalog, or dashboard whose data stays on disk. Covers the pure-core/db/loader architecture, screen-based CRUD, migrations and backups, and the verification gates. Do NOT use this skill for choosing a palette (see color-system), layout and visual design (see frontend-design), font sizing (see typography), or any app needing multi-user auth, a hosted API, or server-side secrets.
license: MIT
metadata:
  author: Antonin Januska
  version: "2.2.1"
  tags: [nextjs, react, typescript, sqlite, local-first, desktop, architecture, charts]
---

# Local-First App

## Overview

A blueprint for a **local-first, single-user CRUD app for one specific function** — a game-backlog tracker, a workout log, a collection catalog, a personal dashboard. One purpose, one user, one machine: it runs in the browser, persists to a local SQLite file, and ships as a self-contained desktop binary. **No backend service, no auth, no network dependency for core function** — the "server" is Next.js server components and server actions talking to a local file. This skill is the *architecture*; the function is yours. A computation-only tool with **no persisted entities** skips this machinery entirely — a pure core plus a form, no `src/db`, migrations, loaders or screen shells.

**Core principle:** every **derived value** — rollups, filters, status counts, and any real computation — lives in a **pure, framework-free core** (`src/<domain>/`) importing nothing from React, Next, or the DB. `lib/` never aggregates; it maps rows and *calls* the core. Client components import the core directly and run it in the browser. That separation is what makes the logic testable, reusable and packageable.

*Scope: one-user, one-machine, local-data CRUD. Not for multi-user auth, server-side secrets, a hosted API, or horizontal scale.*

## Navigation

| Load | When |
|---|---|
| **[references/ARCHITECTURE.md](./references/ARCHITECTURE.md)** | Data layer, migrations, backups, loaders, route topology, shared state |
| **[references/CHROME.md](./references/CHROME.md)** | Shell dimensions, logo, icons, theming mechanism, type-scale values, shared-shell implementations (`PageShell`, `EditorShell`, `StatTile`, `EmptyState`, `ConfirmDeleteButton`) |
| **[references/RELATIONSHIPS.md](./references/RELATIONSHIPS.md)** | Worked 1:N and N:N relationship patterns |
| **[references/UI.md](./references/UI.md)** | Color/theme system, data-viz rules, explainability, legibility detail, bulk-edit rules and anatomy |
| **[references/PACKAGING.md](./references/PACKAGING.md)** | Compiling to a desktop binary (`deno compile` / `deno desktop`) |
| **[references/EXAMPLES.md](./references/EXAMPLES.md)** | Worked ✅/❌ pairs for the rules below |

## The stack (pin to these)

| Layer | Choice | Why |
|---|---|---|
| Framework | **Next.js (App Router)**, `output: "standalone"` | Server components for the data boundary; standalone build compiles to a binary. Start in React from day one. |
| UI | **React + TypeScript (strict)** | `noUncheckedIndexedAccess: true`, `moduleResolution: "Bundler"` |
| Component lib | **Mantine** (`@mantine/core`, `/hooks`, `/dates`, `/charts`, `/form`, `/notifications`) | Batteries-included: AppShell, tables, inputs, dark mode, charts, `useForm`+zodResolver. **Not `@mantine/modals`** — the one modal here is hand-rolled, so no `<ModalsProvider>`. **Known weakness, not a reason to switch:** Table, NavLink, Tooltip, Menu, Badge and Input labels default to sub-16px sizes even unstyled; a headless stack avoids it but costs a rebuild of everything this blueprint leans on. Neutralize it — override the **entire** `fontSizes` scale in the shared theme (**the floor is the rule**: smallest token ≥1rem, line-height ≥1.5, weight ≥400, contrast ≥4.5:1). Bare `size="xs"`/`"sm"`/`c="dimmed"` needs a justification, not a default reach. |
| Persistence | **`node:sqlite`** (built-in `DatabaseSync`) | **No native addon** — `better-sqlite3` needs per-platform rebuilds, which kills the single-binary goal. Same driver on Node 24 and Deno. Unflagged from **v22.13.0 / v23.4.0**, so a 22.13 floor needs no flag; it still prints an `ExperimentalWarning` on import, which is expected. Load-bearing; don't swap it. |
| Validation | **zod** at every server boundary | One schema per write path; parse before touching the DB |
| Data fetching | **none** — no TanStack Query / SWR / Redux | Reads are server components; derive/compute in the browser. No client cache layer to add. |
| Math/diagrams | **KaTeX** (formulas), **Mermaid** (lazy client render) | *Only if the app computes non-obvious numbers.* A pure CRUD tracker skips these. |
| Test | **vitest** | Pure-core unit tests, test-first |

## Architecture — one hard rule, five directories

**The rule is import purity, not a directory count.** `src/<domain>/` may not import React, Next, or the DB — that single constraint is what makes the core testable, reusable and packageable. The five directories are how it's expressed on disk.

```
src/<domain>/   PURE logic core   — no I/O, no React, no next, no db. The product's brain.
src/db/         server-only store — node:sqlite, typed query API, versioned migrations
lib/            server/client glue — 'server-only' loaders + row mappers (call the core; no aggregation here), zod schemas, formatters, colors, config
app/            routes            — server pages load data → pass plain rows to 'use client' children
components/     UI                — 'use client'; import the pure core directly and compute in the browser
```

**Data flow:**
- **Reads:** server component (`export const dynamic = "force-dynamic"`) calls a `'server-only'` loader → maps DB rows to a plain client-row type → passes to a `'use client'` child. Mantine compound components (`Table.*`, `Accordion.*`) are client references — never render them from a server component.
- **Writes:** `'use server'` action → zod parse → rule guard (load → check → throw) → typed DB call → `revalidatePath()`.

Two row shapes, not one: a lightweight **list row** (scalars + cheap counts) and a **detail aggregate** (row + children + a core summary, a superset). A `toX(row, derived)` mapper builds each — the two loaders return different shapes by design. A third shape exists for bolt-on computation (a calculator/report mixed into an otherwise-CRUD app) — see references/ARCHITECTURE.md.

## CRUD as screens — never modals

Every list/view/create/edit is an **addressable route**, not modal state. One screen per operation, identical layout across every entity:

```
app/<entity>/
  page.tsx             list      → loadEntities()         → <EntityList>   (per-entity)
  new/page.tsx         create    → <FormScreen>           → createEntity action
  [id]/page.tsx        detail    → loadEntityDetail(id)   → <EntityDetail> (per-entity)
  [id]/edit/page.tsx   edit      → <FormScreen mode=edit> → updateEntity action
  not-found.tsx        requireX → notFound()  (bad [id] → 404, not 500)
  error.tsx            catches throws   ·   loading.tsx (optional)
```

- **The URL is the state:** deep-linkable, refresh-safe, back/forward works, nothing to lose mid-flow. Don't reach for App Router's intercepting-route modal pattern for data entry — for one user on one machine, plain screens are simpler and the clarity is the point. **The one modal exception is a destructive-delete confirm**: a single hand-rolled controlled `<Modal>` (`<ConfirmDeleteButton>`), covering both a plain yes/no and a confirm carrying options, so there's no second pattern and no provider to mount. It shows the cascade blast radius (`also deletes 4 tasks`) from the detail loader's counts. Don't build a delete *screen*; don't delete without the count.
- **Edit is the new screen, prefilled.** One `<EntityForm>` (a `mode` prop) is the single source of truth for the fields, validating against **one zod schema** (`lib/schemas/<entity>.ts`, `z.coerce.*` on non-strings) — `zodResolver` on the client for inline errors, the *same* schema `safeParse`d in the action as the authority. Submit via `useForm.onSubmit` calling the action with the **typed values object, not FormData**, inside `startTransition`; the action returns `fieldErrors` → `form.setErrors`, else writes → `redirect('/<entity>/[id]')` (post/redirect/get) and `revalidatePath`s list + detail.
- **Shared form shell; per-entity list/detail.** The high-value reuse is the **form/editor shell** every entity's new+edit screens share — same chrome, only the inner fields differ. List and detail screens are usually per-entity components; promote them to shared shells only if the duplication actually bites.
- **Bulk edit — a selection *mode*, not a screen.** *(Deferrable: its absence is a scheduling decision, not non-conformance.)* Don't add per-row dropdowns and don't build a `/bulk-edit` route. Make rows selectable and let a non-empty selection **take over the app chrome** — the sidebar nav becomes a batch bar. This is the one place "the URL is the state" doesn't apply: a selection is ephemeral mode state. Decide **immediate-apply vs staged save** explicitly; it changes the whole component. Four safety rules and the state-hoisting trap: **[references/UI.md](./references/UI.md)**.
- **Review-deck triage — a fourth screen shape.** When an entity set needs recurring re-verification rather than one-off CRUD (items due for follow-up, records gone stale), don't bolt it onto the list as row actions. Model it as a deck: a pure core selector (`itemsDueForReview(items, now)`) picks the working set, and a dedicated screen shows one item at a time — top card, 1–2 actions, a progress bar, explicit empty/done states.

## Relationships — FKs, assembled in loaders, cross-linked

Entities reference each other with real foreign keys; joins are assembled in `lib/` loaders, never followed by the pure core.

- **Schema:** turn FKs on (`PRAGMA foreign_keys = ON` — node:sqlite defaults them OFF) and declare delete intent (`ON DELETE CASCADE` for ownership, `RESTRICT`/`SET NULL` otherwise). Let the DB constraint reject orphans; surface the violation, never swallow it.
- **Store:** per-relation queries (`listTasksByProject(id)`) plus a *batched* count (one `GROUP BY`, no N+1). **Loaders, two per parent:** a list loader returning rows + cheap counts, a detail loader returning the `{ project, tasks }` aggregate.
- **Pure core stays relationship-agnostic** — hand it the assembled aggregate (`summarizeProject(project, tasks)`); it never reads the DB to follow a relation.
- **Cross-link both ways:** parent detail renders a reusable `<RelatedList>` (child rows link to `/<child>/[id]`; a `+ New` link prefills the FK via `/<child>/new?projectId=<id>`); child detail links back. Relationship navigation is just links between detail routes.

## Conventions (carry these verbatim)

- **All derivation in the core:** rollups, summaries and math live in `src/<domain>/`; `lib/` only maps rows and calls the core. DB-context business rules run as a **guard step in the server action** (load → check → throw); extract them to pure predicates (`rules.ts`) only when they grow or need tests.
- **Exact quantities** *(when a value must be precise)*: store as **integer base units** (grams, seconds, scaled fixed-point) at the DB/zod boundary; the pure core works in **major units as floats**. Convert at the boundary, nowhere else. Floats are fine for display, but iterative summation drifts.
- **No silent fallbacks:** the pure core *throws* on invalid input; the UI guards inputs before calling it. A fallback that masks a missing row is a bug.
- **Types:** explicit interfaces for every input/result; `noUncheckedIndexedAccess` is on, so handle `undefined` from index access. Imports are extensionless and relative (`./summary`) — the bundler resolves TS directly.
- **Empty state is the default state:** a fresh local-first DB has zero rows on day one and there's no seed data. Every list screen needs a real empty state (a short message + the primary "add" CTA) designed *before* the first entity exists, not a bare table header.
- **Wire `next/font` variables to `<html>`, not `<body>`.** Mantine injects `fontFamily` into a `:root`-scoped block, so a `.variable` class applied only to `<body>` leaves the custom property invisible at `:root` — properties don't inherit upward — and the whole app silently renders in the browser's fallback serif with nothing wrong visible in source. **Three font roles, three variables:** `--font-body`, `--font-display` (headings + logo), `--font-mono` (figures, IDs). Keep the roles and variable names even when swapping faces, because the theme base references them by name.
- **Tests live in a top-level `tests/` directory**, not beside their sources, with a shared `tests/shims/` set (`next-cache`, `next-navigation`, `node-sqlite`, `server-only`). The shims are the non-obvious part: anything touching the DB or a `server-only` module can't be imported under vitest without them, and every app otherwise rediscovers that.

## The four gates a green test suite does not give you

Unit tests over the pure core pass while the app is broken in the browser. These four gates close the gaps that a typecheck, a full suite, and a clean production build all miss.

**A gate asserts the positive thing it cares about, never the absence of a loud failure.** "Did not 5xx", "did not throw", "file exists" and "reported no issues" are all absence checks, and each passes whenever the failure is quiet. State the property positively: *the rows come back out of the copy*, *the page contains the element*, *the page rendered text at all*, *the newest snapshot is the one still on disk*. Cheap test for any gate you add — describe the failure it exists to catch, then ask whether that failure could occur *quietly*. If it could, the gate is checking for noise. The restore gate is already in this shape; it's the model for the rest.

The first two are dependency-free and belong in the app's own test suite (measured on a real app: 15 tests, ~1.1s). The last two need a real browser — run them from a shared tool against a running app rather than making every repo carry a browser toolchain for a check most CI runs have no environment for.

- **A route smoke gate — assert each route returns a *page*.** A 200 is not proof it rendered: a server component passing a function across the client boundary (`<Button component={Link}>`) makes React drop that element and serialise the error into the flight payload, status still 200 — so the button an empty state depends on is simply not there. Assert the body contains what the route is for and carries no boundary-error string. **Discover routes, don't list them** — walk `app/` for `page.tsx`, since a hand-maintained list drifts the moment someone adds a page. Recurse into `(groups)` leaving the URL prefix unchanged (a group is organisational and its children are real routes — skipping the subtree found *zero* routes in an app keeping all 67 pages under `(app)`/`(auth)`), skip `[dynamic]` and anything under it and `api`, and resolve a `page.tsx` directly inside a top-level group to `/`. **Assert the discovery found something**, or the gate passes by discovering nothing, and print a visible SKIPPED notice when no server is up.
- **A restore gate, not a backup gate.** Assert the rows come back out of the copy: write the backup, open it, read a row back. A routine calling a `.backup()` method that doesn't exist on `node:sqlite` throws on first real use — the safety net missing exactly when it's needed — while a test that only checks a file appeared stays green.
- **A hydration gate.** Server/client HTML mismatch is the most frequent runtime error class in this family, normally found by a user pasting a React error dump. *Cheapest form:* load each route headless, click the interactive controls, and assert the page rendered content **and** that no `error` or `unhandledrejection` fired.
- **A legibility gate.** The readability floor has four parts and **only two are visible in source**: size and weight are theme tokens, but line-height resolves against the *computed* font-size and contrast against the *painted* background — the nearest non-transparent ancestor, composited through alpha. So an app can override every size token exactly as instructed and still ship a wordmark at 1.00:1. *The gate:* load each route headless, **assert it found text nodes at all** (a page that rendered nothing otherwise scores a clean zero issues), then walk every one, resolve the effective background, and fail under 4.5:1 (3:1 for large text). Apply the 1.5 leading floor to **running text only** — button labels and display headings legitimately set tighter. The same walk measures line length.

**Fixture realism is the multiplier on all four.** A five-row fixture passes while a predicate missing from the SQL makes a 5,000-row library report zero results, because `LIMIT` truncated before the pure filter ran. At least one test must exceed the page size, and filesystem features must be tested against real files on disk.

**Prove each gate bites before trusting it** — break the thing it guards and watch it fail. A gate that cannot fail is not a gate.

## UI, chrome & identity

Architecture alone doesn't produce a coherent app — it still has to invent a shell, logo, fonts, theming, chart colors and screen shells. Those are specified in full in CHROME.md and UI.md so they stop being reinvented; four defaults are worth carrying inline because they recur as rework:

- **Never plot different-unit quantities on one axis**, don't force a $0 baseline, and show the actual value at each bar end. Centralize chart color in one module keyed by **semantic role** rather than hue, riding meaning on **blue-vs-orange, never red-vs-green**, with a `+/−` glyph so color is never the only signal.
- **Legibility is the recurring failure.** Set the floor at the theme level — body ≥16px, weight ≥400, contrast ≥4.5:1, line-height ≥1.5 — and cap running text near 65–85 characters. **Setting the floor in the theme does not achieve it:** apps routinely override the size scale exactly as instructed and still ship text under 4.5:1. The legibility gate above is what makes it real.
- **Anything whose whole job is to look different must be *measurably* different.** A theme picker whose swatches sit between 1.00:1 and 1.10:1 of each other renders as identical squares while the theme system underneath is perfectly correct. Assert the perceptual gap rather than eyeballing it.
- **Theming is two axes, both server-side:** the named theme *and* the light/dark scheme persist in the settings table and render into `<html data-theme>` + `forceColorScheme`. No pre-paint script, no flash, no hydration mismatch — and the header toggle renders one icon instead of hiding one of two.

Explainability surfaces (KaTeX formulas, collapsible math, a `/docs` concept area) apply only when the app computes non-obvious numbers, and `/docs` earns its place only when the app has a concept a new user would get wrong. A plain media library has none, and mandating a page there produces a stub nobody reads.

## Examples

Worked ✅/❌ pairs for the pure core, the API-route boundary, binary-safe schema, exact quantities, and loader-assembled relationships: **[references/EXAMPLES.md](./references/EXAMPLES.md)**.

## Gotchas

- **Foreign keys default OFF in node:sqlite** — a *per-connection* PRAGMA, not a schema property. Run `PRAGMA foreign_keys = ON` in `openDatabase()` before any query, or `ON DELETE CASCADE` and orphan-rejection silently do nothing.
- **A manual cascade delete alongside `ON DELETE CASCADE` isn't dead code** — it protects against a future path opening a second raw connection without the pragma. Rely on the FK cascade as primary, but don't flag the redundant explicit delete as a smell to remove.
- **Open the DB hardened, once** — set `journal_mode = WAL`, `busy_timeout = 5000`, `synchronous = NORMAL`, `foreign_keys = ON`, and cache the connection on `globalThis`. Without WAL + busy_timeout a read racing a write throws `SQLITE_BUSY`; without the globalThis guard Next's dev HMR reopens the file → "database is locked".
- **`node:sqlite` breaks vitest/Vite** — it's a runtime builtin but NOT in `module.builtinModules`, so Vite mangles the specifier. Redirect it to a `createRequire` shim via a `pre` resolve plugin in `vitest.config.ts` (test-only; prod imports it directly), and alias `@/*` → repo root there.
- **No `db.transaction()` in node:sqlite** — write a `runInTransaction(db, fn)` wrapper (`BEGIN IMMEDIATE`/`COMMIT`/`ROLLBACK`); better-sqlite3's helper doesn't exist here.
- **`BASE_SCHEMA` is migration v1 — one construction path.** Every database, fresh or existing, replays the chain from its own `user_version`, so there is no second definition of the schema to keep in sync. A fresh-DB fast path (run `BASE_SCHEMA`, jump `user_version` to the max) forces two schemas into manual agreement forever, and the failure is asymmetric: dev machines replay and stay green while **every new install and every packaged binary** gets the other schema. Replaying N migrations against a local file costs milliseconds.
- **Migrations:** track `PRAGMA user_version`, run on boot. Run each `up()` and its `user_version` bump in *one* transaction (no half-applied state); keep each migration idempotent (`CREATE IF NOT EXISTS`, guarded `ALTER ... ADD COLUMN`).
- **Snapshot before any pending migration — a requirement, not a nicety.** Local-first means no server copy, so a bad migration is unrecoverable user data. `VACUUM INTO` a `backups/` directory that is a **sibling** of the data dir (so `rm -rf data/` spares it); skip it for a fresh DB. Three details the obvious version gets wrong: stamp to milliseconds **and** break ties with a counter (two calls really do land in one millisecond, and letting `VACUUM INTO` throw means either migrating with no backup or refusing to start); prune by **timestamp, not filename** (a lexical sort puts `v10-<old>` before `v2-<new>`, so an oldest-first prune deletes the *newer* snapshot past v9 — and "keep 20" means 20 backups, not 20 per version); and keep snapshot and rotation as **two calls**, since a failed snapshot is fatal and a failed rotation must not be.
- **A new migration never applies while the dev server is running.** The `globalThis.__db` cache correctly survives HMR, but migrations run *inside* `openDatabase()`, which the cache skips — so a migration added mid-session silently doesn't apply and every query on the new columns 500s while the suite and any fresh boot pass. Fix: re-run `runMigrations(db)` once per **module** load; module state resets on HMR reload while the `globalThis` cache doesn't, and that asymmetry is the hook.
- **A `globalThis`-cached store *object* pins its methods across HMR.** Caching the bare handle is immune, since the query functions are free functions taking `db`. Cache an *object carrying the methods* and dev HMR keeps the object built by the old code: add a method and the dev server throws `db.newMethod is not a function` from code that passes every test. It reads exactly like a real bug; restarting the dev server clears it, and it can't happen in production. The durable fix is the shape — cache the handle, keep the API free functions.
- **A checkbox nested inside a card-wide `<Link>` silently desyncs from its own state.** To stop the anchor navigating you call `preventDefault()`, which *also* cancels the checkbox's activation behavior and reverts the DOM `checked` — but React's value-tracker already recorded the intermediate value, so the next render sees no diff and never writes `checked` back. The box renders **unchecked while the row is genuinely selected**, racily enough to survive a casual click-test. Root cause is structural: interactive content inside an `<a>` is invalid HTML. Link the **cover and the title** instead of the whole card, and leave the checkbox a plain controlled input with a real `onChange`.
- **`lightHidden`/`darkHidden` lose to an inline `display` style.** Mantine's visibility props work through a class with no `!important`, so `<Box lightHidden display="inline-flex">` renders anyway and a dark/light toggle shows both sun and moon. Put the layout in a CSS class, never the `display` prop — or render the correct icon from the server-persisted scheme and delete the hide-one-of-two pattern.
- **`params`/`searchParams` are async in Next 15** — `await` them in page components; sync access type-errors and breaks the FK-prefill pattern.
- **`requireX` should call `notFound()`** (`next/navigation`), not throw a plain `Error` — otherwise a bad `[id]` serves a 500 instead of a 404. And **forgetting `force-dynamic`** on a data route serves a stale snapshot; local-first reads should be dynamic.
- **Compound Mantine components are client-only** — rendering `Table.*` / `Accordion.*` from a server component throws. Fetch on the server, pass plain rows to a `'use client'` child.
- **Wizard/tab state resets mid-flow** unless you hoist shared derived state into a context provider *above* the steps — selections and computed results must survive Next/Back.
- **Derived aggregates silently undercount** — a roll-up must account for *every* contributing source, not just one type. Build a fixture that would catch it, and expose the number via the collapsible math so it's auditable.

## Troubleshooting

- **Packaged binary is ~750MB** — you compiled the repo root; compile the **standalone `server.js`** instead so only the slim node_modules embeds (~115MB). See references/PACKAGING.md.
- **Hydration mismatch on theme/colors** — the color hook must follow Mantine's *computed* color scheme and resolve after mount, not read OS `prefers-color-scheme` at SSR time.
- **`deno desktop` reuses a stale `.next`** — always `next build` first; compile needs `-A` (else Next throws `NotCapable` on `process.env`).
- **Chart looks alarming/wrong** — you're probably comparing different units on one axis or forcing a $0 baseline; see references/UI.md.

## Integration

- **color-system** — supplies the role-mapped palettes + contrast verification for the chart/theme module here.
- **typography** — sets the readability floor (size/weight/contrast/line-height) referenced above.
- **ideal-react-component** — the component structure for the `'use client'` UI layer.
- **frontend-design** — builds the actual layout/visual design; this skill decides architecture + data flow.
- **track-roadmap / track-session** — drive the feature-by-feature build: plan features, discuss via questions, then implement and verify.
