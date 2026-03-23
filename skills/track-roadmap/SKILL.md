---
name: track-roadmap
description: |
  Plan, update, audit, brainstorm, and resume work from a high-level project roadmap. Use when asked to "create a roadmap",
  "plan features", "what should we build next", "update the roadmap", "audit the roadmap",
  "review project direction", "prioritize features", "resume from roadmap", "pick up where I left off",
  "what should I work on next", "brainstorm features", "brainstorm ideas", "let's brainstorm",
  "what could we build", "explore ideas", or when starting a new project and needing to map out future work.
license: MIT
argument-hint: "[generate|update|audit|brainstorm|resume]"
metadata:
  author: Antonin Januska
  version: "2.1.0"
---

# Track Roadmap

> **Roadmap tracking activated** - I'll use ROADMAP.md to capture and manage the high-level feature plan for this project.

## Overview

Use ROADMAP.md in the project root to plan and track high-level project features. Think through what to build, keep the plan current, and periodically audit whether the roadmap still reflects reality.

**Core principle:** Maintain a living document of what the project should become, so decisions about what to build next are intentional, not reactive.

## Usage Modes

This skill supports five modes via optional arguments:

| Mode | Command | What it does | Use when |
|------|---------|-------------|----------|
| **Generate** | `/track-roadmap` or `/track-roadmap generate` | Interactive feature discovery and ROADMAP.md creation | Starting a project or first-time roadmap |
| **Update** | `/track-roadmap update` | Add, remove, or modify features in existing roadmap | Scope changes, new ideas, completed work |
| **Audit** | `/track-roadmap audit` | Check progress against codebase and re-evaluate relevance | Periodic review, before planning next sprint |
| **Brainstorm** | `/track-roadmap brainstorm` | Exploratory ideation to discover what a project could become | Exploring directions, expanding scope, "what if" sessions |
| **Resume** | `/track-roadmap resume` | Check session state, pick next roadmap item, start working | Returning to a project, deciding what to build next |

## When to Use

**Always use when:**
- Starting a new project and need to plan features
- User asks "what should we build?" or "what's the plan?"
- User returns to a project and wants to pick up the next feature
- Project has grown organically and needs direction
- Before a major planning session or milestone

**Useful for:**
- Capturing feature ideas before they're lost
- Communicating project scope to collaborators
- Deciding what to work on next
- Tracking what's been built vs. what's planned

**Avoid when:**
- Tracking granular task-level work (use `track-session` instead)
- Single-feature implementation (just build it)
- Project is a one-off script or throwaway prototype

---

## Mode: Generate

**Command:** `/track-roadmap` or `/track-roadmap generate`

Creates a new ROADMAP.md through an interactive process.

### Phase 1: Discovery

**Step 1 - Optional codebase scan:**

Ask the user if they want a codebase scan. If yes, examine: project description files, directory structure, TODO/FIXME comments, package dependencies, existing issues. Summarize findings before proceeding.

**Step 2 - Interactive questioning:**

Adapt questions based on codebase scan results. Core questions:

1. **"What is the core purpose of this project?"**
2. **"What are the must-have features you already know about?"**
3. **"Who is the target user and what workflows should it support?"**
4. **"Are there any technical capabilities you know you'll need?"** (integrations, platforms, etc.)

Propose a draft feature list and ask the user to confirm, add, or remove items before writing ROADMAP.md.

### Phase 2: Organize and Write

Group features into logical categories. Write ROADMAP.md using the format below.

**Verification before writing:**
- [ ] User confirmed the feature list
- [ ] Features are grouped logically
- [ ] Each feature has a clear description (see Format Rules)
- [ ] No duplicate or overlapping features

---

## Mode: Update

**Command:** `/track-roadmap update`

Modifies an existing ROADMAP.md.

### Process

1. **Read** the current ROADMAP.md
2. **Ask the user** what changed:
   - New features to add?
   - Features to remove or deprioritize?
   - Features that are now complete?
   - Features that need rewording?
3. **Apply changes** and present the updated roadmap for confirmation
4. **Write** the updated ROADMAP.md

### Update Rules

- When marking features complete, move them to the "Completed" section
- When adding features, ask which category they belong to
- All rules in the Rules section apply (especially: user confirms all changes)

---

## Mode: Audit

**Command:** `/track-roadmap audit`

Performs a combined progress check and relevance review.

### Part 1: Progress Check

Scan the codebase to assess each roadmap feature:

- **Read project files** to determine what's actually been built
- **Compare against ROADMAP.md** features
- **Categorize each feature:**
  - **Done** - Feature exists and works
  - **In Progress** - Partially implemented
  - **Not Started** - No evidence of implementation
  - **Unclear** - Can't determine status from code alone

### Part 2: Relevance Review

Present audit findings to the user and ask: Are any features no longer needed? Any new features to add? Any priority changes based on what we've learned?

### Part 3: Update

Apply changes from the review and write the updated ROADMAP.md. See the Audit example below for output format.

---

## Mode: Brainstorm

**Command:** `/track-roadmap brainstorm`

Exploratory ideation to discover what a project could become. Unlike Generate (which creates a structured plan), Brainstorm encourages divergent thinking before committing ideas to the roadmap.

### Phase 1: Context

1. **Read existing artifacts** — ROADMAP.md (if exists), README.md, CLAUDE.md, package manifests
2. **Summarize current state** — What exists, what's planned, what gaps might exist

### Phase 2: Divergent Exploration

Ask open-ended questions adapted to the project's maturity:

**For new/early projects:**
- "What problem does this solve, and for whom?"
- "What would make this 10x more useful than alternatives?"
- "What projects or products inspire you? What would you borrow from them?"

**For mature projects:**
- "What do users complain about or request most?"
- "What's the most tedious part of using this today?"
- "If you had unlimited time, what would you add?"

**For all projects:**
- "What technical capabilities could unlock new features?" (APIs, integrations, platforms)
- "What's one wild idea you've had but dismissed as too ambitious?"

### Phase 3: Deepen Each Idea

For each promising idea the user raises, explore:

| Dimension | Prompt |
|-----------|--------|
| **User journey** | Walk through one complete interaction with this feature |
| **Inspirations** | What existing tools or products do something similar? |
| **Requirements** | What technical capabilities does this need? |
| **Open questions** | What's unclear or needs research before building? |
| **Effort/impact** | Rough sense — weekend project or multi-month effort? |

### Phase 4: Capture

1. **Filter with user** — Which ideas are worth keeping? Which are scope creep or separate projects?
2. **Add to ROADMAP.md** — Viable ideas go to "Future Ideas" with `status:idea`
3. **Note rejected ideas** — Briefly state why in the conversation (prevents re-brainstorming the same thing)

### Brainstorm Rules

1. **Diverge before converging** — Don't filter ideas too early in Phase 2
2. **User drives selection** — Agent suggests and explores, user decides what stays
3. **Ideas are cheap, commitment is expensive** — Everything starts as `status:idea`
4. **Link inspirations** — Reference existing tools/projects when the user mentions them
5. **Open questions are valuable output** — Unanswered questions guide future research

---

## Mode: Resume

**Command:** `/track-roadmap resume`

Bridges the roadmap to active work by checking session state and helping the user pick the next roadmap item to work on.

### Process

1. **Check current session** — If SESSION_PROGRESS.md has uncompleted tasks, ask the user whether to continue that work or pick a new roadmap item. If continuing, delegate to `/track-session resume` and stop.
2. **Load and present roadmap** — Read ROADMAP.md, filter out completed features, present remaining features grouped by category. Ask the user which feature to work on next.
3. **Confirm and plan** — Summarize the selected feature, ask clarifying questions if too high-level, get user approval.
4. **Start session** — Invoke `/track-session` to create SESSION_PROGRESS.md, populate with tasks derived from the feature, reference the ROADMAP.md item's ID, begin working.

### Resume Rules

1. **Always check session state first** — Don't skip straight to the roadmap
2. **User picks the feature** — Never auto-select the next item
3. **One feature at a time** — Don't start multiple features in one session
4. **Link back to roadmap** — SESSION_PROGRESS.md must reference the ROADMAP.md feature ID
5. **No ROADMAP.md = no resume** — Tell the user to run `/track-roadmap generate` first

---

## ROADMAP.md Format

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

- <!-- id:r_XXXXX status:planned --> **Feature Name** - Short description of what it does and why it matters.
- <!-- id:r_XXXXX status:in-progress started:YYYY-MM-DD --> **Feature Name** - Short description.

## User Experience

<!-- category:ux -->

- <!-- id:r_XXXXX status:planned --> **Feature Name** - Short description.

## Technical Infrastructure

<!-- category:infra -->

- <!-- id:r_XXXXX status:planned --> **Feature Name** - Short description.

## Future Ideas

<!-- category:future -->

- <!-- id:r_XXXXX status:idea --> **Feature Name** - Short description.

## Completed

<!-- category:completed -->

- <!-- id:r_XXXXX status:done completed:YYYY-MM-DD --> ~~**Feature Name**~~ - Short description. *(Completed: YYYY-MM-DD)*
```

### Format Rules

1. **Frontmatter is required** - Must include `schema`, `project`, `description`, `last_updated`
2. **Every item gets an ID** - Format: `r_` + 5 random alphanumeric characters (e.g., `r_k8x2m`)
3. **Every item gets a status** - `planned`, `in-progress`, `done`, or `idea`
4. **Every category heading gets a comment** - `<!-- category:slug -->` on the line after the `##`
5. **Categories are flexible** - Use whatever groupings make sense for the project
6. **One line per feature** - Title in bold + 1-2 sentence description
7. **Keep it scannable** - The whole file should be readable in under 2 minutes
8. **IDs are permanent** - Once assigned, never change an item's ID

### ID Generation

Generate IDs using 5 random characters from `[a-z0-9]`. Example: `r_k8x2m`, `r_3pq7z`.

IDs are embedded in HTML comments so they're invisible when rendered but parseable by tools.

### Migration from v1

If you encounter a ROADMAP.md without frontmatter or IDs:

1. Add the frontmatter block with `schema: cc-dash/roadmap@1`
2. Add IDs to each existing item
3. Add category comments to each heading
4. Infer status from context (strikethrough = done, in Completed section = done, etc.)
5. Set `last_updated` to current timestamp

---

## Rules

1. **User drives the roadmap** - Never add features without user confirmation
2. **Keep it high-level** - Features, not tasks. "User authentication" not "Add bcrypt to hash passwords"
3. **ROADMAP.md is the source of truth** - If it's not in the file, it's not on the roadmap
4. **Audit regularly** - Roadmaps drift. Audit catches the drift.
5. **Don't over-plan** - 5-15 features is a healthy roadmap. 50 features means the project needs splitting.
6. **Completed features stay** - Move to Completed section, don't delete. History matters.

## Examples

Each mode has a Good/Bad comparison example. For the full set of detailed examples, see the reference docs.

**[Detailed Examples](./reference/EXAMPLES.md)** - Complete Good/Bad comparisons for generate, audit, update, and resume modes.

### Quick Example: Generating a Roadmap

<Good>
```markdown
---
schema: cc-dash/roadmap@1
project: my-task-manager
description: A personal task manager that syncs across devices.
last_updated: 2026-03-16T10:00:00-07:00
---

# Roadmap

> A personal task manager that syncs across devices.

## Core Features

<!-- category:core -->

- <!-- id:r_k8x2m status:done completed:2026-01-15 --> ~~**Task CRUD**~~ - Create, read, update, and delete tasks with title, description, and due date. *(Completed: 2026-01-15)*
- <!-- id:r_m3p7q status:in-progress started:2026-02-01 --> **Task lists** - Organize tasks into named lists (e.g., Work, Personal, Shopping).

## Completed

<!-- category:completed -->

- <!-- id:r_k8x2m status:done completed:2026-01-15 --> ~~**Task CRUD**~~ - Create, read, update, and delete tasks with title, description, and due date. *(Completed: 2026-01-15)*
```

**Why this is good:** Includes frontmatter with schema version, every item has a unique ID and status, categories have slug comments, completed items have strikethrough and date, human-readable AND machine-parseable.
</Good>

<Bad>
```markdown
- tasks
- lists
- make it look good
- fix bugs
```

**Why this is bad:** No descriptions, no groupings, mixes features with tasks, no project purpose.
</Bad>

### Quick Example: Auditing a Roadmap

<Good>
```markdown
# Roadmap Audit — 2026-03-20

## Progress Assessment

| Feature | ID | Status | Evidence |
|---------|-----|--------|----------|
| Task CRUD | r_k8x2m | Done | Full CRUD in src/tasks/, tests passing |
| Task lists | r_m3p7q | In Progress | Model exists, UI missing list picker |
| Due date reminders | r_9xw4n | Not Started | No scheduler or notification code found |
| Cloud sync | r_p2v8j | Not Started | No sync/API code |

## Recommendations

1. Mark r_k8x2m as `status:done completed:2026-03-20` in ROADMAP.md
2. r_m3p7q needs UI work — keep as `status:in-progress`
3. r_9xw4n and r_p2v8j still relevant per user confirmation
4. User wants to add: **Recurring tasks** — new item for Core Features
```

**Why this is good:** References items by ID, provides codebase evidence, categorizes status clearly, ties back to cc-dash schema IDs for traceability, gets user confirmation before changes.
</Good>

<Bad>
```markdown
# Audit

Looks like tasks work. Lists are half done. Reminders and sync not started.
I'll update the roadmap now.
```

**Why this is bad:** No evidence, no IDs referenced, no user confirmation, applies changes without asking.
</Bad>

### Quick Example: Brainstorming Ideas

<Good>
```bash
user: "/track-roadmap brainstorm"
# Agent reads ROADMAP.md -> summarizes current state -> asks divergent questions
# "What's the most tedious part of using task managers today?"
# User: "I always forget to check them."
# Agent explores pain point: "What if tasks came to you?"
# Deepens: user journey, inspirations (Todoist scheduling), requirements, open questions
# User confirms 2 ideas, rejects 1 as scope creep
# Agent adds to ROADMAP.md Future Ideas with status:idea and cc-dash IDs
```

**Why this is good:** Starts with pain points, explores "why" before "what", deepens each idea, user filters, output uses `status:idea`.
</Good>

<Bad>
```bash
user: "/track-roadmap brainstorm"
assistant: "Here are 15 features: 1. Dark mode 2. Notifications 3. Calendar..."
# Generic list without questions, no exploration, no user filtering
```

**Why this is bad:** No divergent exploration, no pain points, skipped filtering.
</Bad>

### Quick Example: Resuming from Roadmap

<Good>
```bash
user: "/track-roadmap resume"
# Agent checks SESSION_PROGRESS.md -> not found
# Agent reads ROADMAP.md -> presents features to user
# User picks "Due date reminders"
# Agent asks clarifying questions, then creates SESSION_PROGRESS.md with plan
```

**Why this is good:** Checks session state first, user picks the feature, agent asks before starting.
</Good>

<Bad>
```bash
user: "/track-roadmap resume"
assistant: "I'll start working on Cloud sync since it's the most important."
# Never checked for active session, never asked user which feature
```

**Why this is bad:** Skipped session check, auto-selected a feature without asking the user.
</Bad>

## Troubleshooting

### Problem: ROADMAP.md has too many features (30+)

**Cause:** Roadmap has become a wish list instead of a plan.

**Solution:**
- Run `/track-roadmap audit` to review relevance
- Move speculative items to "Future Ideas"
- Consider splitting into multiple projects or milestones
- A healthy roadmap has 5-15 committed features

### Problem: Features are too granular

**Cause:** Mixing task-level work with feature-level planning.

**Solution:**
- Features should be user-visible capabilities, not implementation steps
- Bad: "Add bcrypt", "Create user table", "Build login form"
- Good: "User authentication"
- Use `track-session` for task-level tracking within a feature

### Problem: User can't decide on features

**Cause:** Too many options or unclear project direction.

**Solution:**
- Start with the core question: "What problem does this project solve?"
- Ask: "If you could only build 3 features, what would they be?"
- Use the "Future Ideas" section as a pressure valve for uncommitted items
- Try `/track-roadmap brainstorm` to explore ideas before committing

**[Extended Troubleshooting](./reference/TROUBLESHOOTING.md)** — Resume edge cases, codebase scan issues, and more.

## Integration

**This skill works with:**
- **track-session** - After choosing a feature from the roadmap, use `track-session` to plan and track the implementation work
- **generate-skill** - Use the roadmap to identify features that could become reusable skills
- **git-worktree** - Work on multiple roadmap features in parallel across worktrees

**Workflow pattern:**
```
/track-roadmap generate    →  Pick a feature  →  /track-session  →  Build it
/track-roadmap brainstorm  →  Explore ideas   →  /track-roadmap update  →  Commit to plan
/track-roadmap resume      →  Check session   →  Pick feature    →  /track-session  →  Build it
/track-roadmap audit       →  Review progress →  /track-roadmap update  →  Adjust plan
```

**Pairs with:**
- Sprint planning and milestone reviews
- Project kickoff and scope definition
- Periodic retrospectives
