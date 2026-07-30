# Worked examples

Load when you need the concrete shape of a rule in SKILL.md — the pure core, the API-route
boundary, binary-safe schema, exact quantities, and loader-assembled relationships.

✅ **Derived state in the pure core — a tracker with no math**

```ts
// src/backlog/summary.ts — pure: rollups/counts, throws on bad input.
export function summarize(games: Game[]): BacklogSummary {
  const byStatus = { backlog: 0, playing: 0, beaten: 0 };
  for (const game of games) byStatus[game.status]++;
  return {
    total: games.length,
    byStatus,
    pctBeaten: games.length ? byStatus.beaten / games.length : 0,
  };
}
```

✅ **The identical pattern carries real computation, called straight from the client**

```ts
// src/measure/bmi.ts — no React, no db, throws on bad input
export function bmi(weightKg: number, heightM: number): number {
  if (weightKg <= 0 || heightM <= 0) throw new Error("invalid measurements");
  return weightKg / (heightM * heightM);
}
// components/BmiPanel.tsx — 'use client', imports the core directly: bmi(weightKg, heightM)
```

❌ **Your own cheap math hidden behind an API route**

```ts
// app/api/calculate/route.ts — pointless network hop; the math has no secrets and is cheap
export async function POST(req) {
  /* ...the bmi math inline... */
}
```

Mutations → server actions; reads → server components. **API route handlers are for external/integration endpoints only** (an SSRF-guarded image proxy, scraping, third-party quotes), never for wrapping your own domain logic.

✅ **Schema as a TS string export (binary-safe)**

```ts
// src/db/schema.ts
export const BASE_SCHEMA = `CREATE TABLE IF NOT EXISTS items (...);`;
```

❌ **Schema read from disk at runtime (ENOENTs next to a shipped binary)**

```ts
const schema = readFileSync(join(process.cwd(), "src/db/schema.sql"), "utf8"); // breaks in the packaged app
```

❌ **Exact quantity stored as a float**

```ts
createItem({ weight: 1.37 }); // float drift; store exact quantities as scaled integers
```

✅ **Exact quantities: base units at the boundary, major units in the core**

```ts
createItem({ weightGrams: Math.round(kilograms * 1000) }); // store
const kilograms = row.weight_grams / 1000; // read, then hand to the core
```

❌ **Core follows the relation into the DB (and N+1s)**

```ts
// src/project/summary.ts — pure core must not import the db or query per-row
function summarize(project: Project) {
  const tasks = getDb()
    .prepare("SELECT * FROM tasks WHERE project_id = ?")
    .all(project.id); // wrong layer + N+1
}
```

✅ **Relationship assembled in the loader, core stays pure**

```ts
// lib/projects.ts — loader composes the aggregate; one batched count, no N+1
export async function loadProjectDetail(id: number): Promise<ProjectDetail> {
  const db = getDb();
  const project = requireProject(db, id);
  const tasks = listTasksByProject(db, id); // single scoped query
  return { project, tasks, summary: summarizeProject(project, tasks) }; // core gets the assembled shape
}
```
