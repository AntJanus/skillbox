# Relationships — deep reference

Load when wiring up foreign keys, join tables, or cross-entity views. Entities reference each other with **real foreign keys**, joins are **assembled in loaders**, and the **pure core never follows a relation**. Worked example: `projects` 1→N `tasks`.

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

Pick the delete rule per relationship: `CASCADE` for true ownership (a task can't exist without its project), `RESTRICT` to block deleting a parent that still has children, `SET NULL` for optional references (**the FK column must be nullable — no `NOT NULL`, or `SET NULL` errors when the parent is deleted**). Let the DB reject orphans and surface the error — don't add a fallback that masks it.

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

**Display — cross-link via `<RelatedList>`.** The parent's detail screen renders one `<RelatedList>` per relationship; the child's detail links back. Navigation between related entities is just links between their detail routes.

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

The `new/page.tsx` for the child reads the FK from `searchParams` (`const { projectId } = await searchParams` — async in Next 15) and passes it as the form's default FK, so creating a task from a project lands back on that project. Keep the FK select in the form too (for the standalone `/tasks/new` entry point), defaulted from the query param.

**Edit overfetches by default, and that's fine.** The edit page reuses `loadEntityDetail` (full aggregate) just to prefill the parent's own scalar fields — harmless at this scale. If a detail aggregate ever gets heavy, give edit a lighter parent-only loader; until then, one loader is simpler.

### Many-to-many variant (join table)

When the relationship is N:N (e.g. `tasks` ↔ `tags`), only three things change from the 1:N pattern:

- **Schema — a join table, no FK column on either entity:**

```ts
CREATE TABLE IF NOT EXISTS task_tags (
  task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  tag_id  INTEGER NOT NULL REFERENCES tags(id)  ON DELETE CASCADE,
  PRIMARY KEY (task_id, tag_id)        -- composite PK: dedupe + the task_id→tags lookup index
);
CREATE INDEX IF NOT EXISTS idx_task_tags_tag ON task_tags(tag_id);   -- reverse tag→tasks (the PK doesn't cover it)
```

- **Actions — attach/detach, not create-with-FK.** The link is edited by `attachTag(taskId, tagId)` / `detachTag(taskId, tagId)` (INSERT / DELETE on the join row), not by setting a column when the child is created. The `<RelatedList>` for an N:N gets add/remove controls instead of a `+ New` that prefills an FK.
- **Loader — two-step batched assembly.** Fetch the join rows for the parent(s), collect the far-side ids, then batch-fetch those rows in one `WHERE id IN (...)` — never per-row. (SQLite caps bound variables at ~999 on older builds / 32766 on 3.32+; chunk the `IN` list if a parent could exceed it.) For a list, one `GROUP BY` over the join table gives per-parent counts (same N+1 rule as 1:N).

The pure core still receives the assembled aggregate (`{ task, tags }`); the join table never leaks past the loader.

### At scale: keep the row shape stable across reads, sync writes through one path

Once a tags-style N:N relationship is real (not just a demo), two refinements pay off:

- **Reads — pre-aggregate the join into the row, not a separate query.** A `json_group_array` subquery keeps the row shape a plain string array — existing consumers that expect `task.tags: string[]` don't need to change when tags move from a denormalized column to a real join table:

```sql
-- one row per task, tags pre-aggregated — existing consumers see an unchanged shape
SELECT t.*,
  (SELECT json_group_array(tag.name)
     FROM task_tags jt JOIN tags tag ON tag.id = jt.tag_id
    WHERE jt.task_id = t.id ORDER BY jt.rowid) AS tags_json
FROM tasks t;
```

- **Writes — one `syncTags` path for both create and edit**, instead of separate attach/detach call sites. It diffs desired vs. current and applies the minimal set of inserts/deletes:

```ts
// lib/tags.ts — the one write path for "set the tags on this task"
export function syncTags(db: DatabaseSync, taskId: number, desiredTagIds: number[]) {
  const current = new Set(listTagIdsForTask(db, taskId));
  const desired = new Set(desiredTagIds);
  for (const id of desired) if (!current.has(id)) attachTag(db, taskId, id);
  for (const id of current) if (!desired.has(id)) detachTag(db, taskId, id);
}
```

Both refinements exist to avoid a migration from denormalized-column to join-table forcing changes at every call site — normalize the schema, keep the shape the rest of the app already relies on.
