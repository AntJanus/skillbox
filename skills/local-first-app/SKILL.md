---
name: local-first-app
description: Local-first single-user web-app blueprint for a single-purpose CRUD app — Next.js App Router + React + TypeScript, Mantine, node:sqlite, a pure domain core, zod boundaries, colorblind-safe charts. Use this skill whenever the user wants to scaffold a tracker/calculator/dashboard app, add a persisted entity + server action, wire a node:sqlite store, or package a web app as a desktop binary. Do NOT use for palette/contrast choices (see color-system) or pure visual layout (see frontend-design).
license: MIT
metadata:
  author: Antonin Januska
  version: "1.0.0"
  tags: [nextjs, react, typescript, sqlite, local-first, desktop, architecture, charts]
---

# Local-First App

## Overview

A blueprint for building a **local-first, single-user web app for one specific function** — a game-backlog tracker, an expense log, a book/collection catalog, a habit tracker, a mortgage calculator, a personal dashboard. One purpose, one user, one machine: it runs entirely in the browser, persists to a local SQLite file, and can ship as a single self-contained desktop binary. **No backend service, no auth, no network dependency for core function.** The "server" is just Next.js server components and server actions talking to a local file. This skill is the *architecture*; the specific function is yours.

**Core principle:** keep all real domain logic — CRUD-derived state (rollups, filters, status counts) *and* any computation — in a **pure, framework-free core** (`src/<domain>/`) that imports nothing from React, Next, or the DB. Client components import it directly and run it in the browser. Persistence is a thin `server-only` SQLite layer. This separation makes the logic testable, reusable (a future CLI), and packageable.

*Scope: one-user, one-machine, local-data apps. Not for apps needing real multi-user auth, server-side secrets, a hosted API, or horizontal scale — that's a different architecture.*

## The stack (pin to these)

| Layer | Choice | Why |
|---|---|---|
| Framework | **Next.js (App Router)**, `output: "standalone"` | Server components for the data boundary; standalone build compiles to a binary. Start in React from day one. |
| UI | **React + TypeScript (strict)** | `noUncheckedIndexedAccess: true`, `moduleResolution: "Bundler"` |
| Component lib | **Mantine** (`@mantine/core`, `/hooks`, `/dates`, `/charts`) | Mature, batteries-included: AppShell, tables, inputs, dark mode, charts. Don't roll your own or use an immature/personal component lib. |
| Persistence | **`node:sqlite`** (built-in `DatabaseSync`) | **No native addon** — `better-sqlite3` needs per-platform native rebuilds, which kills the single-binary goal. `node:sqlite` is the same driver on Node 24 and Deno. Load-bearing; don't swap it. |
| Validation | **zod** at every server boundary | One schema per write path; parse before touching the DB |
| Data fetching | **none** — no TanStack Query / SWR / Redux | Reads are server components; derive/compute in the browser. No client cache layer to add. |
| Math/diagrams | **KaTeX** (formulas), **Mermaid** (lazy client render) | *Only if the app computes non-obvious numbers.* A pure CRUD tracker can skip these. |
| Test | **vitest** | Pure-core unit tests, test-first |

## Architecture — three hard layers

```
src/<domain>/   PURE logic core   — no I/O, no React, no next, no db. The product's brain.
src/db/         server-only store — node:sqlite, typed query API, versioned migrations
lib/            server/client glue — 'server-only' loaders, pure view-models, zod schemas, formatters, colors, config
app/            routes            — server pages load data → pass plain rows to 'use client' children
components/     UI                — 'use client'; import the pure core directly and compute in the browser
```

**Data flow:**
- **Reads:** server component (`export const dynamic = "force-dynamic"`) calls a `'server-only'` loader → maps DB rows to a plain client-row type → passes to a `'use client'` child. Mantine compound components (`Table.*`, `Accordion.*`) are client references — never render them from a server component.
- **Writes:** `'use server'` action → zod `.parse()` the input → typed DB call → `revalidatePath()`.
- **Derive/compute:** roll-ups, filters, summaries, and any math live in the pure core, called from client components and `lib/` view-models.

Keep a **plain row type** + a `toX(row, derived)` mapper as the single shape every screen renders, and put **pure view-model logic** (aggregations, summaries, derived metrics) in `lib/<domain>.ts` — not in components.

→ Full data-layer, migrations, and shared-state detail: **[references/ARCHITECTURE.md](./references/ARCHITECTURE.md)**

## Conventions (carry these verbatim)

- **Money** *(only finance domains)*: integer **cents** at the DB/zod boundary; the pure core works in **major units (dollars) as floats**. Convert at the boundary, nowhere else. Never store money as a float.
- **Rates** *(only finance domains)*: decimals in code — 7% is `0.07`. The UI takes percents and `/100` before calling the core.
- **Imports:** extensionless relative imports (`./amortization`). Bundler resolves TS directly.
- **No silent fallbacks:** the pure core *throws* on invalid input; the UI guards inputs before calling it. A fallback that masks a missing row is a bug.
- **Types:** explicit interfaces for every input/result. `noUncheckedIndexedAccess` is on — handle `undefined` from index access.

## UI & data-viz quality signals

These are the corrections that recur most — treat them as defaults:

- **Charts:** never plot different-unit quantities on one axis (a total over years next to a monthly figure misleads). Show the actual value at each bar end; give every chart a bar/line toggle and multiple scale-grouped views; don't force a $0 line baseline (auto-fit the y-domain); make hover/tooltips work.
- **Tables:** one grouped table with parent-owned filter pills that drive columns AND chart series together — not many split tables. Always include the diff/delta column for paired figures.
- **Color:** centralize all chart color in one module; color by **semantic role**, not hue; provide light + dark variants; ride meaning on **blue-vs-orange (warm/cool), never red-vs-green**, and add a `+/−` glyph so color is never the only signal.
- **Legibility (recurring failure):** set the floor at the theme/globals level — body ≥16px, weight ≥400, contrast ≥4.5:1, line-height ≥1.5. Cards/tables need a surface background distinct from the canvas; flat same-color containers read as illegible.
- **Explainability** *(when the app computes non-obvious numbers)*: show each formula once (KaTeX) with values plugged in + a JavaScript-form toggle; collapsible "underlying math" under dashboard stats; an in-app `/docs` area with Mermaid diagrams. A pure CRUD tracker skips formulas but still ships the `/docs` concept area.

→ Full color/theme system, data-viz rules, explainability, and legibility detail: **[references/UI.md](./references/UI.md)**
→ Packaging to a desktop binary (`deno compile` / `deno desktop`): **[references/PACKAGING.md](./references/PACKAGING.md)**

## Examples

✅ **Derived state in the pure core — a tracker with no math**
```ts
// src/backlog/summary.ts — pure: rollups/counts, throws on bad input. No arithmetic, same pattern.
export function summarize(games: Game[]): BacklogSummary {
  const byStatus = { backlog: 0, playing: 0, beaten: 0 };
  for (const game of games) byStatus[game.status]++;
  return { total: games.length, byStatus, pctBeaten: games.length ? byStatus.beaten / games.length : 0 };
}
```

The identical core pattern carries real computation when the domain has it:

✅ **Calculation in the pure core, called from the client**
```ts
// src/finance/amortization.ts — no React, no db, throws on bad input
export function monthlyPayment(principal: number, annualRate: number, months: number): number {
  if (principal < 0 || months < 1) throw new Error("invalid loan inputs");
  const r = annualRate / 12;
  return r === 0 ? principal / months : (principal * r) / (1 - (1 + r) ** -months);
}
```
```tsx
// components/Calculator.tsx — 'use client', imports the core directly, divides percent → decimal
const payment = monthlyPayment(costDollars, ratePercent / 100, months);
```

❌ **Calculation hidden behind an API / living in the component**
```ts
// app/api/calculate/route.ts — pointless network hop; the math has no secrets and is cheap
export async function POST(req) { /* ...amortization math inline... */ }
```

✅ **Schema as a TS string export (binary-safe)**
```ts
// src/db/schema.ts
export const BASE_SCHEMA = `CREATE TABLE IF NOT EXISTS purchases (...);`;
```

❌ **Schema read from disk at runtime (ENOENTs next to a shipped binary)**
```ts
const schema = readFileSync(join(process.cwd(), "src/db/schema.sql"), "utf8"); // breaks in the packaged app
```

✅ **Money: cents at the boundary, dollars in the core**
```ts
createPurchase({ priceCents: Math.round(dollars * 100) });   // store
const dollars = row.price_cents / 100;                       // read, then hand to the core
```

❌ **Money stored as a float**
```ts
createPurchase({ price: 19.99 });   // float drift; never store money as a float in SQLite
```

## Gotchas

- **`node:sqlite` breaks vitest/Vite** — it's a runtime builtin but NOT in `module.builtinModules`, so Vite mangles the specifier. Redirect `node:sqlite` to a tiny `createRequire` shim via a `pre` resolve plugin in `vitest.config.ts` (test-only; prod imports it directly). Also alias `@/*` → repo root there.
- **Schema must be an inlined TS string**, not a `.sql` file — `readFileSync(process.cwd()/...)` ENOENTs next to a packaged binary.
- **No `db.transaction()` in node:sqlite** — write a `runInTransaction(db, fn)` wrapper (`BEGIN`/`COMMIT`/`ROLLBACK`); better-sqlite3's helper doesn't exist here.
- **Migrations:** track `PRAGMA user_version`; each migration idempotent (`CREATE IF NOT EXISTS`, guarded `ALTER ... ADD COLUMN`) so any older DB upgrades cleanly. Run on boot.
- **Compound Mantine components are client-only** — rendering `Table.*` / `Accordion.*` from a server component throws. Fetch on the server, pass plain rows to a `'use client'` child.
- **Wizard/tab state resets mid-flow** unless you hoist shared derived state into a context provider *above* the steps — selections and computed results must survive Next/Back.
- **Derived aggregates silently undercount** — a roll-up (e.g. "total used") must account for *every* contributing source, not just one type. Build a fixture that would catch it, and expose the number via the collapsible math so it's auditable.
- **Forgetting `force-dynamic`** on a data route serves a stale snapshot — local-first reads should be dynamic.

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
