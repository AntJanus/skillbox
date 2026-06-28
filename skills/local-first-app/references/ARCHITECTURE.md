# Architecture — deep reference

Load when wiring up the data layer, migrations, or shared state. The three layers are: pure core (`src/<domain>/`), server-only store (`src/db/`), glue (`lib/`), routes (`app/`), UI (`components/`).

## The pure core (`src/<domain>/`)

The product's brain. Imports nothing from React, Next, or the DB. Works in plain data — domain entities, and plain numbers in major units where there's money — returns explicit typed result objects, and **throws on invalid input** rather than guessing. The logic is whatever the function needs: derived state and rollups for a tracker (status counts, filters, streaks), real math for a calculator. Same rules either way.

- Keep one file per concept — `summary.ts` / `filters.ts` for a tracker, `amortization.ts` / `inflation.ts` for a calculator — plus an `index.ts` barrel.
- Higher-level helpers (`analyzeX`, `summarizeX`) compose the primitives and return the per-row shapes the UI renders.
- Shared helpers (a status-grouping reducer, a period/loop iterator) avoid duplicating the same traversal across features.
- Because it's pure, it's trivially unit-tested and reusable by a future CLI.

## The store (`src/db/`, `server-only`)

`node:sqlite`'s `DatabaseSync` — no native addon, so the app compiles into one file.

```
src/db/
  schema.ts       BASE_SCHEMA exported as a TS string (NOT a .sql file read at runtime)
  migrations.ts   versioned migrations + runInTransaction wrapper
  index.ts        openDatabase() → typed query API; runs migrations on boot
```

- **Schema as a TS string export.** `readFileSync(join(process.cwd(), ...))` ENOENTs next to a shipped binary — inline it.
- **Versioned migrations** tracked by `PRAGMA user_version`: each has a monotonic `version` + idempotent `up()` (`CREATE IF NOT EXISTS`, guarded `ALTER TABLE ... ADD COLUMN`). A DB seeded at any earlier version upgrades cleanly. Run on boot.
- **`runInTransaction(db, fn)`** — node:sqlite has no `db.transaction()`:

```ts
export function runInTransaction<T>(db: DatabaseSync, fn: () => T): T {
  db.exec("BEGIN");
  try { const result = fn(); db.exec("COMMIT"); return result; }
  catch (error) { db.exec("ROLLBACK"); throw error; }
}
```

- Expose a **small typed query API** (`createX`, `addY`, `requireX`, batched aggregates to avoid N+1), not raw SQL at call sites.
- `getDb()` is cached and `server-only`. Resolve the data dir via one helper: an env override (e.g. `<APP>_DATA_DIR`, set by the desktop entrypoint) else `./data`; `mkdirSync(..., { recursive: true })`.
- Gitignore `data/`, `*.sqlite`, `.next/`.

## The glue (`lib/`)

- `'server-only'` loaders that the server pages call (e.g. `loadX()` = `getDb()` + query + map).
- **Pure view-models** over the plain row type — aggregations, summary stats, derived metrics. This is where roll-ups live, NOT in components.
- zod schemas, one per write boundary; formatters; the color module; config defaults.
- A **plain client-row type** + `toX(row, derived)` mapper: the single shape the overview, list, and detail screens all render.

## Routes & server actions (`app/`)

- Each data page is a server component with `export const dynamic = "force-dynamic"`; it loads via a `lib/` loader and passes plain rows to a `'use client'` child.
- Writes are `'use server'` actions: zod `.parse()` → typed DB call → `revalidatePath()` the affected routes. Validate at this boundary; never trust raw input.

## Shared derived state for multi-step / tabbed flows

When several tabs or a wizard need the *same* computed data, hoist it into a **context provider above the tabs** that owns the raw inputs AND the derived analysis (it calls the pure-core helpers; no logic lives in it).

The hard requirement: **the user's selections and computed results must survive navigating Next/Back across steps.** Don't recompute per tab or let state reset on step change. A "stale selection" guard should fire if an upstream change invalidates a downstream choice (e.g. the chosen term was deselected).

## Component consolidation

The UI converges on a few shared presentational primitives — reuse them instead of bespoke variants:

- a controlled grouped-columns table (parent owns which column groups show),
- a chart renderer with a built-in bar/line toggle,
- multi-select filter pills,
- a filtered-section render-prop that hands selected groups to its children.

Parent owns filter state; children are dumb. One pill selection filters a table and its chart together.
