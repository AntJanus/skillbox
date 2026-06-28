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

## CRUD as screens (no modals)

Every operation on an entity is its own addressable route — never modal state. The URL is the source of truth, so every screen is deep-linkable, refresh-safe, and works with browser back/forward. Mirror this layout for *every* entity:

```
app/<entity>/
  page.tsx             list      server page → loadEntities()       → <ListScreen>
  new/page.tsx         create    server page → defaults             → <FormScreen>
  [id]/page.tsx        detail    server page → loadEntityDetail(id) → <DetailScreen>
  [id]/edit/page.tsx   edit      server page → loadEntityDetail(id) → <FormScreen mode="edit">
  actions.ts           'use server' createEntity / updateEntity / deleteEntity
```

**Edit is the create screen, prefilled.** One `<EntityForm>` component owns the field set; `new` mounts it empty, `edit` mounts it with the loaded row via a `mode` prop. Both submit to the same shape; the action branches on presence of an id. This guarantees the two screens never drift.

**Post / redirect / get.** A write action `.parse()`s, calls the typed store method, `revalidatePath()`s the list + detail, then `redirect('/<entity>/[id]')`. The user lands on the canonical detail URL — no resubmit-on-refresh, no modal to dismiss.

```ts
// app/projects/actions.ts
"use server";
import { ProjectInput } from "@/lib/schemas/project";           // the one schema, shared with the client form
export async function saveProject(form: FormData) {
  const input = ProjectInput.parse(Object.fromEntries(form));   // zod at the boundary (authority)
  const id = input.id ? (updateProject(getDb(), input), input.id) : createProject(getDb(), input);
  revalidatePath("/projects");
  revalidatePath(`/projects/${id}`);
  redirect(`/projects/${id}`);                                   // PRG
}
```

**Validation — one schema, two consumers.** The entity's zod schema lives once in `lib/schemas/<entity>.ts`. The client `<EntityForm>` validates with `zodResolver(EntityInput)` (Mantine `useForm`) for inline field errors; the server action `.parse()`s the *same* schema as the authority. No duplicated rules, no client/server drift. Surface a failed `.parse()` back to the form (`useActionState` for the errors, `useFormStatus` for pending) — never swallow it.

**Delete — the one modal exception.** Data entry is always a screen, but a destructive yes/no is the single allowed dialog: Mantine `openConfirmModal`, with children showing the **cascade blast radius** from the detail loader's counts (`also deletes 4 tasks`). On confirm it calls the `deleteEntity` action → `revalidatePath` → `redirect` to the list. Don't build a delete *screen*; don't delete without the count.

**Unified page shells — one container per screen type.** Don't hand-build each entity's pages. Build three shells once and reuse them across every entity, so projects and tasks share identical chrome:

- `<ListScreen>` — page header, "+ New" action, the grouped table / `<RelatedList>` of rows.
- `<DetailScreen>` — title, edit/delete action bar, a slot for the entity's fields, and a slot for its `<RelatedList>` sections.
- `<FormScreen>` — title ("New X" / "Edit X"), the `<EntityForm>`, cancel/save bar; identical for create and edit.

Only the inner field set and the loader differ per entity. The shells own layout, breadcrumbs, and action placement — that's what makes every entity feel like the same app.

## Relationships between entities

Entities reference each other with **real foreign keys**, joins are **assembled in loaders**, and the **pure core never follows a relation**. Worked example: `projects` 1→N `tasks`.

**Schema — FKs on, delete intent declared.** node:sqlite leaves foreign keys OFF per connection; enable them in `openDatabase()` once, before any query:

```ts
// src/db/index.ts
db.exec("PRAGMA foreign_keys = ON");   // without this, ON DELETE CASCADE and orphan-rejection do nothing
```
```ts
// src/db/schema.ts
export const BASE_SCHEMA = `
CREATE TABLE IF NOT EXISTS projects (id INTEGER PRIMARY KEY, name TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS tasks (
  id INTEGER PRIMARY KEY,
  project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,  -- ownership: tasks die with the project
  title TEXT NOT NULL,
  done INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tasks_project ON tasks(project_id);        -- index every FK you query by
`;
```

Pick the delete rule per relationship: `CASCADE` for true ownership (a task can't exist without its project), `RESTRICT` to block deleting a parent that still has children, `SET NULL` for optional references. Let the DB reject orphans and surface the error — don't add a fallback that masks it.

**Store — scoped queries + batched aggregates (no N+1).**

```ts
// src/db/index.ts (typed query API)
export const listTasksByProject = (db, projectId) =>
  db.prepare("SELECT * FROM tasks WHERE project_id = ? ORDER BY id").all(projectId);

// one query for ALL parents' counts — never query per row in a list
export const countTasksByProject = (db) =>
  db.prepare("SELECT project_id, COUNT(*) total, SUM(done) done FROM tasks GROUP BY project_id").all();
```

**Loaders — two per parent.** A list loader returns cheap counts; a detail loader assembles the full aggregate.

```ts
// lib/projects.ts
export async function loadProjects(): Promise<ProjectListRow[]> {
  const db = getDb();
  const counts = new Map(countTasksByProject(db).map(r => [r.project_id, r]));   // O(1) lookup
  return listProjects(db).map(p => ({ ...p, taskCount: counts.get(p.id)?.total ?? 0 }));
}

export async function loadProjectDetail(id: number): Promise<ProjectDetail> {
  const db = getDb();
  const project = requireProject(db, id);
  const tasks = listTasksByProject(db, id);
  return { project, tasks, summary: summarizeProject(project, tasks) };          // pure core gets assembled data
}
```

**Pure core stays relationship-agnostic.** `summarizeProject(project, tasks)` takes both plain shapes as arguments and returns derived metrics — it never imports the db, never follows `project.id` into another table. That's what keeps it unit-testable and CLI-reusable.

**Display — cross-link via `<RelatedList>`.** The parent's `<DetailScreen>` renders one `<RelatedList>` per relationship; the child's detail links back. Navigation between related entities is just links between their detail routes.

```tsx
// components/RelatedList.tsx — reused for every parent→child section
<RelatedList
  title="Tasks"
  rows={project.tasks}
  href={t => `/tasks/${t.id}`}                       // each child links to its own detail screen
  newHref={`/tasks/new?projectId=${project.id}`}     // "+ New" prefills the FK
/>
// the task detail screen renders: <Link href={`/projects/${task.projectId}`}>← {project.name}</Link>
```

The `new/page.tsx` for the child reads `searchParams.projectId` and passes it as the form's default FK, so creating a task from a project lands back on that project. Keep the FK select in the form too (for the standalone `/tasks/new` entry point), defaulted from the query param.

### Many-to-many variant (join table)

When the relationship is N:N (e.g. `tasks` ↔ `tags`), only three things change from the 1:N pattern:

- **Schema — a join table, no FK column on either entity:**

```ts
CREATE TABLE IF NOT EXISTS task_tags (
  task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  tag_id  INTEGER NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,
  PRIMARY KEY (task_id, tag_id)        -- composite PK = dedupe + the lookup index
);
```

- **Actions — attach/detach, not create-with-FK.** The link is edited by `attachTag(taskId, tagId)` / `detachTag(taskId, tagId)` (INSERT / DELETE on the join row), not by setting a column when the child is created. The `<RelatedList>` for an N:N gets add/remove controls instead of a `+ New` that prefills an FK.
- **Loader — two-step batched assembly.** Fetch the join rows for the parent(s), collect the far-side ids, then batch-fetch those rows in one `WHERE id IN (...)` — never per-row. For a list, one `GROUP BY` over the join table gives per-parent counts (same N+1 rule as 1:N).

The pure core still receives the assembled aggregate (`{ task, tags }`); the join table never leaks past the loader.

## Shared derived state for multi-step / tabbed flows

When several tabs or a wizard need the *same* computed data, hoist it into a **context provider above the tabs** that owns the raw inputs AND the derived analysis (it calls the pure-core helpers; no logic lives in it).

The hard requirement: **the user's selections and computed results must survive navigating Next/Back across steps.** Don't recompute per tab or let state reset on step change. A "stale selection" guard should fire if an upstream change invalidates a downstream choice (e.g. the chosen term was deselected).

## Component consolidation

The UI converges on a few shared presentational primitives — reuse them instead of bespoke variants:

- the three **screen shells** (`<ListScreen>` / `<DetailScreen>` / `<FormScreen>`) every entity reuses,
- a `<RelatedList>` for every parent→child section (rows link out, `+ New` prefills the FK),
- a controlled grouped-columns table (parent owns which column groups show),
- a chart renderer with a built-in bar/line toggle,
- multi-select filter pills,
- a filtered-section render-prop that hands selected groups to its children.

Parent owns filter state; children are dumb. One pill selection filters a table and its chart together.
