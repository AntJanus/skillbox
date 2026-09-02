---
name: track-roadmap
description: Use this skill to maintain ROADMAP.md whenever the user wants to "add an item to the roadmap", "mark a feature done", "log the work I shipped", "create a roadmap", "what should we build next", "brainstorm features", or "audit the roadmap" — even if they don't mention the roadmap file by name. Covers the generate, update, audit, brainstorm, and resume modes. Do NOT use this skill for session-level task progress (see track-session) or free-form idea backlogs that aren't landing in a roadmap file.
license: MIT
argument-hint: "[generate|update|audit|brainstorm|resume]"
metadata:
  author: Antonin Januska
  version: "2.6.2"
---

# Track Roadmap

## Overview

Maintain `ROADMAP.md` in the project root as a living, high-level feature plan, so decisions about what to build next are intentional, not reactive. Keep it to **features (user-visible capabilities), not tasks** — task-level work belongs in `track-session`. A healthy roadmap is 5-15 committed features readable in under 2 minutes.

## Workflow

Every mode runs the same four beats — **read** the current state, **propose** a change, **confirm** with the user, **write** the file. Only the middle two differ:

| Mode | Command | Propose / confirm |
|------|---------|-------------------|
| **Generate** | `/track-roadmap` or `generate` | Offer a codebase scan, ask 4 discovery questions, propose a feature list, write after the user confirms |
| **Update** | `/track-roadmap update` | Ask what changed (add/remove/complete/reword), apply after confirmation |
| **Audit** | `/track-roadmap audit` | Scan code to mark each feature Done/In-Progress/Not-Started/Unclear, review relevance with the user, update |
| **Brainstorm** | `/track-roadmap brainstorm` | Divergent ideation — explore directions before committing; viable ideas land in "Future Ideas" as `status:idea` |
| **Resume** | `/track-roadmap resume` | Check session state, present remaining features, user picks one, hand off to `/track-session` |

Update is the common case: adding an item, marking one done, or logging shipped work all land there. There is no `save` mode — treat `/track-roadmap save` as Update. In Update and Audit, edit the affected items in place rather than regenerating the file — ids, ordering, and untouched text survive, and a whole-file rewrite costs more tokens for the same result. Generate is the only mode that writes the file from scratch.

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

**Format rules.** The cc-dash dashboard parses this file, so a dropped marker silently removes the item from the board:

- Frontmatter requires `schema`, `project`, `description`, `last_updated`.
- Every item: an `id` (`r_` + 5 random `[a-z0-9]`, **permanent — never change**) and a `status` (`planned` / `in-progress` / `done` / `idea`).
- Every category heading gets `<!-- category:slug -->` on the next line. Categories themselves are flexible — invent whatever groups fit the project.
- One line per feature: bold title + 1-2 sentence description.

## Rules

- **The user drives the roadmap** — propose changes and wait for confirmation rather than adding, rewording, or removing features on your own judgment.
- **High-level only** — "User authentication", not "Add bcrypt to hash passwords".
- **`ROADMAP.md` is the source of truth** — if it's not in the file, it's not on the roadmap.
- **Completed features move, they don't disappear** — relocate them to the Completed section with a `completed:` date instead of deleting, because audits use that history as evidence.

## Examples

✅ **Good** — frontmatter, unique IDs, statuses, category slugs, strikethrough + date on completed items:

```markdown
## Core Features

<!-- category:core -->

- <!-- id:r_m3p7q status:in-progress started:2026-02-01 --> **Task lists** - Organize tasks into named lists (Work, Personal, Shopping).

## Completed

<!-- category:completed -->

- <!-- id:r_k8x2m status:done completed:2026-01-15 --> ~~**Task CRUD**~~ - Create/read/update/delete tasks with title, description, due date. *(Completed: 2026-01-15)*
```

❌ **Bad** — `- tasks` / `- lists` / `- make it look good` / `- fix bugs`: no descriptions, no groupings, mixes features with tasks, no IDs or purpose.

✅ **Good** — update mode, user says *"dark mode shipped yesterday"*: keep the id, flip the status, add the date, move the line to Completed:

```markdown
- <!-- id:r_j4t8v status:done completed:2026-03-14 --> ~~**Dark mode**~~ - System-level dark/light theme preference. *(Completed: 2026-03-14)*
```

Full ✅/❌ comparisons for generate, audit, update, brainstorm, and resume modes: **[reference/EXAMPLES.md](./reference/EXAMPLES.md)**.

## Integration

- **track-session** — after picking a feature, use `track-session` to plan and track the implementation; SESSION_PROGRESS.md references the ROADMAP item ID.
- Hands-on verification (a playthrough, a parity gate, a release sign-off) is filed as an ordinary roadmap item here — `QA.md` and the `track-qa` skill are deprecated (2026-09-01), so nothing files back from a separate checklist.

```
generate    → pick a feature  → /track-session → build
brainstorm  → explore ideas   → update         → commit to plan
resume      → check session   → pick feature   → /track-session → build
audit       → review progress → update         → adjust plan
```

## Gotchas

- **Renaming a feature keeps its id.** Edit the title text but leave `<!-- id:r_XXXXX -->` alone — SESSION_PROGRESS.md `roadmap_ref` values and cc-dash history both point at it. On a merge, keep the surviving id; on a split, keep the original on one half and generate a new id for the other.
- **`roadmap_ref` can be a list.** One session advancing several features writes `roadmap_ref: r_abc12,r_def34` — read it as comma-separated, don't assume a single id.
- **Resume overwrites an active session plan.** If SESSION_PROGRESS.md has uncompleted tasks, ask whether to continue it before presenting the roadmap; switching features replaces that file.
- **Ambiguous audit evidence is `Unclear`, not a guess.** Partial or experimental code (a `src/auth/` with no tests) gets surfaced to the user for a ruling rather than being scored Done.
- **A 30+ item roadmap is a signal, not a state to preserve.** Audit it, move speculative entries to "Future Ideas" as `status:idea`, and delete what no longer fits — git holds the history, so in-file archiving just adds noise.
- **Roadmap drift is expected.** When the file stops matching what's being built, run audit to reconcile rather than patching individual lines from memory.

Extended edge cases (codebase-scan noise, brainstorm dead ends, priority paralysis, tightening vague feature descriptions): **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.
