---
name: track-roadmap
description: Plan, audit, and resume project roadmaps. Use when asked to "create a roadmap", "generate a roadmap", "what should we build next", "brainstorm features", or "audit the roadmap".
license: MIT
argument-hint: "[generate|update|audit|brainstorm|resume]"
metadata:
  author: Antonin Januska
  version: "2.5.2"
---

# Track Roadmap

Maintain `ROADMAP.md` in the project root as a living, high-level feature plan, so decisions about what to build next are intentional, not reactive. Keep it to **features (user-visible capabilities), not tasks** — use `track-session` for task-level work. A healthy roadmap is 5-15 committed features readable in under 2 minutes.

## Modes

| Mode | Command | Essence |
|------|---------|---------|
| **Generate** | `/track-roadmap` or `generate` | Offer a codebase scan, ask 4 discovery questions, propose a feature list, then write ROADMAP.md after the user confirms |
| **Update** | `/track-roadmap update` | Read current file, ask what changed (add/remove/complete/reword), apply after confirmation |
| **Audit** | `/track-roadmap audit` | Scan code to mark each feature Done/In-Progress/Not-Started/Unclear, review relevance with the user, update |
| **Brainstorm** | `/track-roadmap brainstorm` | Divergent ideation — explore directions before committing; viable ideas land in "Future Ideas" as `status:idea` |
| **Resume** | `/track-roadmap resume` | Check session state, present remaining features, user picks one, hand off to `/track-session` |

Full per-mode procedures (discovery questions, brainstorm question banks, audit steps): **[reference/MODES.md](./reference/MODES.md)**.

## ROADMAP.md format

```markdown
---
schema: cc-dash/roadmap@1
project: project-name-here
description: One-line project purpose
last_updated: YYYY-MM-DDTHH:MM:SS-TZ
---

# Roadmap

> Project purpose in one sentence.

## Core Features

<!-- category:core -->

- <!-- id:r_XXXXX status:planned --> **Feature Name** - What it does and why it matters.
- <!-- id:r_XXXXX status:in-progress started:YYYY-MM-DD --> **Feature Name** - Short description.

## Future Ideas

<!-- category:future -->

- <!-- id:r_XXXXX status:idea --> **Feature Name** - Short description.

## Completed

<!-- category:completed -->

- <!-- id:r_XXXXX status:done completed:YYYY-MM-DD --> ~~**Feature Name**~~ - Short description. *(Completed: YYYY-MM-DD)*
```

**Format rules** (the cc-dash schema is parsed by the dashboard — don't omit the markers):

- Frontmatter requires `schema`, `project`, `description`, `last_updated`.
- Every item: an `id` (`r_` + 5 random `[a-z0-9]`, **permanent — never change**) and a `status` (`planned` / `in-progress` / `done` / `idea`).
- Every category heading gets `<!-- category:slug -->` on the next line. Categories are flexible.
- One line per feature: bold title + 1-2 sentence description.

## Rules

- **User drives the roadmap** — never add or change features without confirmation.
- **High-level only** — "User authentication", not "Add bcrypt to hash passwords".
- **ROADMAP.md is the source of truth** — if it's not in the file, it's not on the roadmap.
- **Completed features stay** — move to the Completed section, don't delete. History matters.
- **Audit regularly** — roadmaps drift; audit catches it. 30+ days with no progress warrants review.

## Example

✅ **Good** — frontmatter, unique IDs, statuses, category slugs, strikethrough + date on completed items:

```markdown
## Core Features

<!-- category:core -->

- <!-- id:r_k8x2m status:done completed:2026-01-15 --> ~~**Task CRUD**~~ - Create/read/update/delete tasks with title, description, due date. *(Completed: 2026-01-15)*
- <!-- id:r_m3p7q status:in-progress started:2026-02-01 --> **Task lists** - Organize tasks into named lists (Work, Personal, Shopping).
```

❌ **Bad** — `- tasks` / `- lists` / `- make it look good` / `- fix bugs`: no descriptions, no groupings, mixes features with tasks, no IDs or purpose.

Full ✅/❌ comparisons for generate, audit, update, and resume modes: **[reference/EXAMPLES.md](./reference/EXAMPLES.md)**.

## Integration

- **track-session** — after picking a feature, use `track-session` to plan and track the implementation; SESSION_PROGRESS.md references the ROADMAP item ID.
- **track-qa** — pair every roadmap item that ships UI/integration with a QA.md entry; failed QA files back as an `r_xxxxx` roadmap issue.

```
generate    → pick a feature  → /track-session → build
brainstorm  → explore ideas   → update         → commit to plan
resume      → check session   → pick feature   → /track-session → build
audit       → review progress → update         → adjust plan
```

## Troubleshooting

- **Roadmap doesn't match what's actually being built** — run `/track-roadmap audit` to reconcile plan vs. reality; make auditing a habit after every major feature completion.
- **Roadmap has ballooned to 30+ features** — audit and move speculative items to "Future Ideas"; delete items that no longer fit (git preserves history, don't archive in-file).
- **Resume can't find ROADMAP.md** — run `/track-roadmap generate` first, then resume.

Extended edge cases (codebase-scan noise, brainstorm dead ends, audit ambiguity, renaming/merging features, priority paralysis): **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.
