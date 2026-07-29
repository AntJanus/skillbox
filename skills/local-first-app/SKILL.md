---
name: local-first-app
description: Local-first CRUD blueprint — Next.js + node:sqlite, single-user, no backend. Use this skill whenever the user wants to "build a local app to track my X", "a tracker that saves to my machine", "an offline single-user app with no account", "add a persisted entity", or "package this as a desktop binary" — even if they never say local-first and only describe a personal tracker, catalog, or dashboard whose data stays on disk. Covers the pure-core/db/loader architecture, screen-based CRUD, migrations and backups, and the verification gates. Do NOT use this skill for choosing a palette (see color-system), layout and visual design (see frontend-design), font sizing (see typography), or any app needing multi-user auth, a hosted API, or server-side secrets.
license: MIT
metadata:
  author: Antonin Januska
  version: "3.1.0"
  tags: [nextjs, react, typescript, sqlite, local-first, desktop, architecture, charts]
---

# Local-First App

## Overview

A local-first, single-user CRUD app for one function — a game-backlog tracker, a workout log, a collection catalog, a personal dashboard. It runs in the browser, persists to a local SQLite file, and ships as a self-contained desktop binary. **No backend service, no auth, no network dependency for core function**: the "server" is Next.js server components and server actions talking to a local file.

**Core principle:** every derived value — rollups, filters, status counts, real computation — lives in a **pure, framework-free core** (`src/<domain>/`) importing nothing from React, Next, or the DB. `lib/` maps rows and *calls* the core; it never aggregates. Client components import the core directly and run it in the browser. That separation is what makes the logic testable and packageable.

*Scope: one user, one machine, local data. Not for multi-user auth, server-side secrets, a hosted API, or horizontal scale. An app with **no persisted entities** skips this machinery — a pure core plus a form, no `src/db`, migrations, loaders or screen shells.*

## Build scope

Build what was asked, at the scope asked. These are the failure modes this blueprint invites:

- **Ship the entities requested, not the data model you'd design.** No speculative tables, no configurability nobody asked for, no abstraction for a one-time operation.
- **The gates below are shipped artifacts**, written once and left in `tests/`. They are not a ritual to re-run or re-derive on every change.
- **Match document length to the task.** READMEs and `/docs` pages cover the substance without filler sections or redundant summaries.
- **Deferrable by default:** bulk edit, the review deck, `/docs`, and explainability surfaces. Each earns its place from a real need — their absence is a scheduling decision, not non-conformance.
- **When two designs are both valid** (two row shapes vs sibling props, immediate-apply vs staged save), pick one, state which, and commit. Don't build both.

## Navigation

| Load | When |
|---|---|
| **[references/ARCHITECTURE.md](./references/ARCHITECTURE.md)** | Data layer, migrations, backups, loaders, route topology, shared state |
| **[references/CHROME.md](./references/CHROME.md)** | Shell dimensions, logo, icons, theming mechanism, type-scale values, shared-shell implementations |
| **[references/UI.md](./references/UI.md)** | Color/theme system, data-viz rules, explainability, legibility detail, bulk-edit rules |
| **[references/RELATIONSHIPS.md](./references/RELATIONSHIPS.md)** | Worked 1:N and N:N patterns |
| **[references/EXAMPLES.md](./references/EXAMPLES.md)** | ✅/❌ pairs for the rules below |
| **[references/PACKAGING.md](./references/PACKAGING.md)** | Compiling to a desktop binary |

## The stack (pin to these)

| Layer | Choice | Why |
|---|---|---|
| Framework | **Next.js (App Router)**, `output: "standalone"` | Server components for the data boundary; standalone build compiles to a binary. |
| UI | **React + TypeScript (strict)** | `noUncheckedIndexedAccess: true`, `moduleResolution: "Bundler"` |
| Component lib | **Mantine** (`@mantine/core`, `/hooks`, `/dates`, `/charts`, `/form`, `/notifications`) | AppShell, tables, inputs, dark mode, charts, `useForm`+zodResolver. **Not `@mantine/modals`** — the one modal here is hand-rolled, so no `<ModalsProvider>`. **Known weakness, not a reason to switch:** Table, NavLink, Tooltip, Menu, Badge and Input labels default to sub-16px sizes even unstyled, and a headless stack costs a rebuild of everything this blueprint leans on. Override the **entire** `fontSizes` scale in the shared theme; the floor is the rule (≥1rem, line-height ≥1.5, weight ≥400, contrast ≥4.5:1). |
| Persistence | **`node:sqlite`** (`DatabaseSync`) | **No native addon** — `better-sqlite3` needs per-platform rebuilds, killing the single-binary goal. Unflagged from **v22.13.0 / v23.4.0**; the `ExperimentalWarning` on import is expected. Load-bearing; don't swap it. |
| Validation | **zod** at every server boundary | One schema per write path; parse before touching the DB |
| Data fetching | **none** — no TanStack Query / SWR / Redux | Reads are server components; derive in the browser. |
| Math/diagrams | **KaTeX**, **Mermaid** (lazy client render) | Only when the app computes non-obvious numbers. |
| Test | **vitest** | Pure-core unit tests, test-first |

## Architecture — one hard rule, five directories

`src/<domain>/` may not import React, Next, or the DB. That single constraint is what makes the core testable and packageable; the directories are how it's expressed on disk.

```
src/<domain>/   PURE logic core   — no I/O, no React, no next, no db. The product's brain.
src/db/         server-only store — node:sqlite, typed query API, versioned migrations
lib/            server/client glue — 'server-only' loaders + row mappers (call the core), zod schemas, formatters, colors, config
app/            routes            — server pages load data → pass plain rows to 'use client' children
components/     UI                — 'use client'; import the pure core directly
```

- **Reads:** server component (`export const dynamic = "force-dynamic"`) → `'server-only'` loader → map rows to a plain client-row type → pass to a `'use client'` child.
- **Writes:** `'use server'` action → zod parse → rule guard (load → check → throw) → typed DB call → `revalidatePath()`.
- **Two row shapes, not one:** a lightweight **list row** (scalars + cheap counts) and a **detail aggregate** (row + children + a core summary). A `toX(row, derived)` mapper builds each. A third shape covers a calculator bolted onto a CRUD app — see ARCHITECTURE.md.

## CRUD as screens — never modals

Every list/view/create/edit is an addressable route. One screen per operation, identical across entities:

```
app/<entity>/
  page.tsx             list      → loadEntities()         → <EntityList>   (per-entity)
  new/page.tsx         create    → <FormScreen>           → createEntity action
  [id]/page.tsx        detail    → loadEntityDetail(id)   → <EntityDetail> (per-entity)
  [id]/edit/page.tsx   edit      → <FormScreen mode=edit> → updateEntity action
  not-found.tsx        requireX → notFound()  (bad [id] → 404, not 500)
  error.tsx            catches throws   ·   loading.tsx (optional)
```

- **The URL is the state** — deep-linkable, refresh-safe, back/forward works. Use plain screens for data entry rather than App Router's intercepting-route modal pattern; for one user on one machine the clarity is the point.
- **The one modal is a destructive-delete confirm:** a hand-rolled controlled `<Modal>` (`<ConfirmDeleteButton>`) covering both a plain yes/no and a confirm carrying options. It shows the cascade blast radius (`also deletes 4 tasks`) from the detail loader's counts. Don't build a delete *screen*; don't delete without the count.
- **Edit is the new screen, prefilled.** One `<EntityForm>` (a `mode` prop) owns the fields and validates against **one zod schema** (`lib/schemas/<entity>.ts`, `z.coerce.*` on non-strings): `zodResolver` on the client for inline errors, the *same* schema `safeParse`d in the action as the authority. Submit through `useForm.onSubmit` with the **typed values object, not FormData**, inside `startTransition`. Worked code in ARCHITECTURE.md.
- **Shared form shell; per-entity list/detail.** The reuse that pays is the form/editor shell every entity's new+edit screens share. Promote list/detail only once duplication bites.
- **Bulk edit is a selection *mode*, not a route.** Make rows selectable and let a non-empty selection take over the app chrome — the sidebar nav becomes a batch bar. The one place "the URL is the state" doesn't apply: a selection is ephemeral. Four safety rules and the state-hoisting trap: **[references/UI.md](./references/UI.md)**.
- **Review-deck triage** for entity sets needing recurring re-verification (items due for follow-up, records gone stale). A pure core selector (`itemsDueForReview(items, now)`) picks the working set; the screen shows one item at a time — top card, 1–2 actions, a progress bar, explicit empty/done states.

## Relationships — FKs, assembled in loaders

Entities reference each other with real foreign keys. Loaders assemble the joins; the pure core never follows one.

- **Schema:** turn FKs on (`PRAGMA foreign_keys = ON` — node:sqlite defaults them OFF) and declare delete intent (`ON DELETE CASCADE` for ownership, `RESTRICT`/`SET NULL` otherwise). Let the constraint reject orphans and surface the violation.
- **Store:** per-relation queries (`listTasksByProject(id)`) plus a *batched* count (one `GROUP BY`, no N+1). Two loaders per parent: list rows + cheap counts, and the `{ project, tasks }` aggregate.
- **Pure core stays relationship-agnostic** — hand it the assembled aggregate (`summarizeProject(project, tasks)`).
- **Cross-link both ways:** parent detail renders a `<RelatedList>` (children link to `/<child>/[id]`; `+ New` prefills the FK via `/<child>/new?projectId=<id>`); child detail links back.

## Conventions

- **All derivation in the core.** `lib/` maps rows and calls it. DB-context business rules run as a guard step in the server action (load → check → throw); extract to pure predicates (`rules.ts`) once they grow or need tests.
- **Exact quantities** *(when a value must be precise)*: store **integer base units** (grams, seconds, scaled fixed-point) at the DB/zod boundary; the core works in **major units as floats**. Convert at the boundary, nowhere else — iterative summation of floats drifts.
- **The pure core throws on invalid input**; the UI guards before calling it. A fallback that masks a missing row is a bug.
- **Empty state is the default state.** A fresh local-first DB has zero rows and no seed data, so every list screen needs a real empty state (message + primary "add" CTA) designed before the first entity exists.
- **Wire `next/font` variables to `<html>`, not `<body>`.** Mantine injects `fontFamily` into a `:root`-scoped block, so a `.variable` class on `<body>` leaves the property invisible at `:root` — properties don't inherit upward — and the app silently renders in the fallback serif with nothing wrong in source. **Three roles, three variables:** `--font-body`, `--font-display` (headings + logo), `--font-mono` (figures, IDs). Keep the names when swapping faces; the theme base references them by name.
- **Tests live in a top-level `tests/` directory** with a shared `tests/shims/` set (`next-cache`, `next-navigation`, `node-sqlite`, `server-only`). The shims are the non-obvious part: anything touching the DB or a `server-only` module is unimportable under vitest without them.

## The four gates a green test suite does not give you

**A gate asserts the positive thing it cares about, never the absence of a loud failure.** "Did not 5xx", "did not throw", "file exists" and "reported no issues" all pass whenever the failure is quiet. State the property positively: *the rows come back out of the copy*, *the page contains the element*, *the page rendered text at all*, *the newest snapshot is on disk*. Test any gate you add by describing the failure it catches, then asking whether that failure could occur quietly — if it could, the gate is checking for noise.

Restore and route smoke are dependency-free and ship in the app's test suite (measured: 15 tests, ~1.1s). Hydration and legibility need a real browser; run them from a shared tool against a running app rather than making every repo carry a browser toolchain.

1. **Route smoke — assert each route returns a *page*.** A 200 is not proof it rendered: a server component passing a function across the client boundary (`<Button component={Link}>`) makes React drop that element and serialise the error into the flight payload, status still 200. Assert the body contains what the route is for and carries no boundary-error string.
   **Discover routes, don't list them** — walk `app/` for `page.tsx`. Recurse into `(groups)` leaving the URL prefix unchanged, since a group is organisational and its children are real routes; skipping the subtree found *zero* routes in an app keeping all 67 pages under `(app)`/`(auth)`. Skip `[dynamic]` and anything under it, and `api`. Resolve a `page.tsx` directly inside a top-level group to `/`. Assert the discovery found something, and print a visible SKIPPED notice when no server is up.
2. **Restore, not backup.** Write the snapshot, open the copy, read a row back. A routine calling a `.backup()` method that doesn't exist on `node:sqlite` throws on first real use while a test checking only that a file appeared stays green.
3. **Hydration.** Server/client HTML mismatch is the most frequent runtime error class here, normally found by a user pasting a React error dump. Load each route headless, click the interactive controls, assert the page rendered content **and** that no `error` or `unhandledrejection` fired.
4. **Legibility.** The readability floor has four parts and **only two are visible in source**: size and weight are tokens, but line-height resolves against the *computed* font-size and contrast against the *painted* background — the nearest non-transparent ancestor, composited through alpha. Load each route headless, assert it found text nodes at all (a page that rendered nothing otherwise scores zero issues), then walk every one, resolve the effective background, and fail under 4.5:1 (3:1 for large text). The 1.5 leading floor applies to **running text only**. The same walk measures line length.

**Fixture realism multiplies all four.** A five-row fixture passes while a predicate missing from the SQL makes a 5,000-row library report zero results, because `LIMIT` truncated before the pure filter ran. At least one test must exceed the page size, and filesystem features must run against real files on disk.

**Prove each gate fails before trusting it** — break the thing it guards and watch it go red.

## UI, chrome & identity

Full specs in CHROME.md and UI.md. Four defaults recur as rework:

- **Never plot different-unit quantities on one axis**, don't force a $0 baseline, and show the actual value at each bar end. Centralize chart color in one module keyed by **semantic role** rather than hue, riding meaning on **blue-vs-orange, never red-vs-green**, with a `+/−` glyph so color is never the only signal.
- **Set the legibility floor at the theme level** — body ≥16px, weight ≥400, contrast ≥4.5:1, line-height ≥1.5 — and cap running text near 65–85 characters. The theme is necessary and insufficient: apps routinely override the size scale exactly as instructed and still ship text under 4.5:1. The legibility gate is what makes it real.
- **Anything whose whole job is to look different must be measurably different.** A theme picker whose swatches sit between 1.00:1 and 1.10:1 of each other renders as identical squares while the theme system underneath is correct. Assert the perceptual gap.
- **Theming is two axes, both server-side:** the named theme *and* the light/dark scheme persist in the settings table and render into `<html data-theme>` + `forceColorScheme`. No pre-paint script, no flash, no hydration mismatch, and the header toggle renders one icon instead of hiding one of two.

## Examples

✅/❌ pairs for the pure core, the API-route boundary, binary-safe schema, exact quantities, and loader-assembled relationships: **[references/EXAMPLES.md](./references/EXAMPLES.md)**.

## Gotchas

- **Foreign keys default OFF in node:sqlite.** A *per-connection* PRAGMA, not a schema property. Run `PRAGMA foreign_keys = ON` in `openDatabase()` before any query, or `ON DELETE CASCADE` silently does nothing.
- **A manual cascade delete alongside `ON DELETE CASCADE` isn't dead code.** It covers a future path opening a raw connection without the pragma. Keep the FK cascade primary; leave the redundant delete alone.
- **Open the DB hardened, once.** Set `journal_mode = WAL`, `busy_timeout = 5000`, `synchronous = NORMAL`, `foreign_keys = ON`, and cache the connection on `globalThis`. Without WAL + busy_timeout a read racing a write throws `SQLITE_BUSY`; without the guard, dev HMR reopens the file → "database is locked".
- **`node:sqlite` breaks vitest/Vite.** It's a runtime builtin but not in `module.builtinModules`, so Vite mangles the specifier. Redirect it to a `createRequire` shim via a `pre` resolve plugin in `vitest.config.ts` (test-only), and alias `@/*` → repo root there.
- **No `db.transaction()` in node:sqlite.** Write a `runInTransaction(db, fn)` wrapper (`BEGIN IMMEDIATE`/`COMMIT`/`ROLLBACK`).
- **`BASE_SCHEMA` is migration v1 — one construction path.** Every database replays the chain from its own `user_version`, so there's no second schema definition to keep in sync. A fresh-DB fast path (run `BASE_SCHEMA`, jump `user_version` to the max) forces two schemas into manual agreement forever, and the failure is asymmetric: dev machines replay and stay green while **every new install and every packaged binary** gets the other schema. Replaying N migrations against a local file costs milliseconds.
- **Migrations:** track `PRAGMA user_version`, run on boot. Run each `up()` and its bump in *one* transaction; keep each idempotent (`CREATE IF NOT EXISTS`, guarded `ALTER ... ADD COLUMN`).
- **Snapshot before any pending migration — a requirement, not a nicety.** No server copy exists, so a bad migration is unrecoverable user data. `VACUUM INTO` a `backups/` directory that is a **sibling** of the data dir (so `rm -rf data/` spares it); skip it for a fresh DB. Three traps: milliseconds alone don't prevent collisions (break ties with a counter); a lexical sort prunes the *newest* snapshot past v9 (sort by timestamp); and snapshot and rotation need opposite failure policies (two calls). Detail in ARCHITECTURE.md.
- **A new migration never applies while the dev server runs.** The `globalThis.__db` cache survives HMR, but migrations run inside `openDatabase()`, which the cache skips — so a migration added mid-session silently doesn't apply and queries on the new columns 500 while the suite and any fresh boot pass. Re-run `runMigrations(db)` once per **module** load; module state resets on HMR reload while the cache doesn't.
- **A `globalThis`-cached store *object* pins its methods across HMR.** Caching the bare handle is immune, since query functions are free functions taking `db`. Cache an object carrying the methods and HMR keeps the object built by the old code: add a method and the dev server throws `db.newMethod is not a function` from code that passes every test. Restart clears it; production can't hit it. The durable fix is the shape.
- **A checkbox inside a card-wide `<Link>` desyncs from its own state.** `preventDefault()` stops the anchor navigating and *also* cancels the checkbox's activation, reverting the DOM `checked` — but React's value-tracker already recorded the intermediate value, so the next render sees no diff and never writes `checked` back. The box renders unchecked while the row is genuinely selected, racily enough to survive a casual click-test. Interactive content inside an `<a>` is invalid HTML: link the **cover and the title** instead of the whole card, and leave the checkbox a controlled input with a real `onChange`.
- **`lightHidden`/`darkHidden` lose to an inline `display` style.** Mantine's visibility props work through a class with no `!important`, so `<Box lightHidden display="inline-flex">` renders anyway and a toggle shows both sun and moon. Put the layout in a CSS class, or render the correct icon from the server-persisted scheme and delete the hide-one-of-two pattern.
- **`params`/`searchParams` are async in Next 15.** `await` them in page components; sync access type-errors and breaks the FK-prefill pattern.
- **`requireX` calls `notFound()`** (`next/navigation`) rather than throwing a plain `Error`, or a bad `[id]` serves a 500 instead of a 404. Likewise **`force-dynamic`** on every data route; without it a local-first read serves a stale snapshot.
- **Compound Mantine components are client-only.** `Table.*` / `Accordion.*` throw when rendered from a server component. Fetch on the server, pass plain rows to a `'use client'` child.
- **Wizard/tab state resets mid-flow** unless shared derived state hoists into a context provider *above* the steps.
- **Derived aggregates silently undercount.** A roll-up must account for every contributing source, not just one type. Build a fixture that would catch it.

## Troubleshooting

- **Packaged binary is ~750MB** — you compiled the repo root. Compile the standalone `server.js` so only the slim node_modules embeds (~115MB).
- **`deno desktop` reuses a stale `.next`** — run `next build` first; compile needs `-A`, else Next throws `NotCapable` on `process.env`.
- **Hydration mismatch on theme/colors** — the color hook must follow Mantine's *computed* scheme and resolve after mount, not read OS `prefers-color-scheme` at SSR time.

## Integration

- **color-system** — role-mapped palettes + contrast verification for the chart/theme module.
- **typography** — the readability floor (size/weight/contrast/line-height).
- **ideal-react-component** — component structure for the `'use client'` layer.
- **frontend-design** — layout and visual design; this skill decides architecture and data flow.
- **track-roadmap / track-session** — drive the feature-by-feature build.
