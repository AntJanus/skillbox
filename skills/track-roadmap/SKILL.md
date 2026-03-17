---
name: track-roadmap
description: |
  Plan, update, audit, and resume work from a high-level project roadmap. Use when asked to "create a roadmap",
  "plan features", "what should we build next", "update the roadmap", "audit the roadmap",
  "review project direction", "prioritize features", "resume from roadmap", "pick up where I left off",
  "what should I work on next", or when starting a new project and needing to map out future work.
license: MIT
metadata:
  author: Antonin Januska
  version: "2.0.0"
  argument-hint: "[generate|update|audit|resume]"
tags: [planning, roadmap, features, project-management]
---

# Track Roadmap

> **Roadmap tracking activated** - I'll use ROADMAP.md to capture and manage the high-level feature plan for this project.

## Overview

Use ROADMAP.md in the project root to plan and track high-level project features. Think through what to build, keep the plan current, and periodically audit whether the roadmap still reflects reality.

**Core principle:** Maintain a living document of what the project should become, so decisions about what to build next are intentional, not reactive.

## Usage Modes

This skill supports three modes via optional arguments:

| Mode | Command | What it does | Use when |
|------|---------|-------------|----------|
| **Generate** | `/track-roadmap` or `/track-roadmap generate` | Interactive feature discovery and ROADMAP.md creation | Starting a project or first-time roadmap |
| **Update** | `/track-roadmap update` | Add, remove, or modify features in existing roadmap | Scope changes, new ideas, completed work |
| **Audit** | `/track-roadmap audit` | Check progress against codebase and re-evaluate relevance | Periodic review, before planning next sprint |
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

Ask the user if they want a codebase scan to inform the roadmap:

```
"Would you like me to scan the project to understand what exists before we plan features?"
```

If yes, examine:
- README.md, CLAUDE.md, or any project description files
- Directory structure and existing features
- TODO/FIXME comments in source files
- Package dependencies (package.json, requirements.txt, etc.)
- Existing issues or task lists

Summarize findings briefly to the user before proceeding.

**Step 2 - Interactive questioning:**

Ask the user about their vision using AskUserQuestion. Adapt questions to what you learned from the codebase scan (if performed). Core questions:

1. **"What is the core purpose of this project?"** - Understand the project's reason to exist.
2. **"What are the must-have features you already know about?"** - Capture what's already in the user's head.
3. **"Who is the target user and what workflows should the project support?"** - Uncover features the user hasn't thought of yet.
4. **"Are there any technical capabilities you know you'll need?"** - Infrastructure, integrations, platform support, etc.

After gathering answers, propose a draft feature list and ask the user to confirm, add, or remove items before writing ROADMAP.md.

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

For each feature, ask whether it's still relevant:

- Present the audit findings to the user
- Ask: "Are there features that are no longer needed?"
- Ask: "Are there new features that should be added?"
- Ask: "Should any priorities change based on what we've learned?"

### Part 3: Update

Apply any changes from the review and write the updated ROADMAP.md. See the Audit example below for output format.

---

## Mode: Resume

**Command:** `/track-roadmap resume`

Bridges the roadmap to active work by checking session state and helping the user pick the next roadmap item to work on.

### Process

**Step 1 - Check current session:**

Check for an existing SESSION_PROGRESS.md (invoke `/track-session resume` logic):

- **If an active session exists** (uncompleted tasks remain) → Ask the user: "You have an active session in progress. Would you like to continue that work, or pick a new item from the roadmap?"
  - If continue → delegate to `/track-session resume` and stop here
  - If new item → proceed to Step 2
- **If session is done, empty, or missing** → proceed to Step 2

**Step 2 - Load and present roadmap:**

1. **Read ROADMAP.md** from the project root
2. **Filter out** completed features (those in the "Completed" section)
3. **Present remaining features** to the user grouped by category, using AskUserQuestion
4. **Ask:** "Which feature would you like to work on next?"

**Step 3 - Confirm and plan:**

Once the user picks a feature:

1. **Confirm the selection** with a brief summary of what the feature involves
2. **Ask clarifying questions** if the feature description is too high-level to start working (e.g., "User authentication - do you want to start with OAuth, email/password, or both?")
3. **Get user approval** before proceeding

**Step 4 - Start session:**

After confirmation:

1. **Invoke `/track-session`** to create a new SESSION_PROGRESS.md
2. **Populate the session plan** with tasks derived from the selected roadmap feature
3. **Include context:** Reference the ROADMAP.md feature in the session so it's clear what roadmap item this work maps to
4. **Begin working** on the first task in the plan

### Resume Rules

1. **Always check session state first** - Don't skip straight to the roadmap
2. **User picks the feature** - Never auto-select the next item
3. **One feature at a time** - Don't let the user start multiple features in one session
4. **Link back to roadmap** - SESSION_PROGRESS.md should reference which ROADMAP.md feature is being worked on
5. **No ROADMAP.md, no resume** - If ROADMAP.md doesn't exist, tell the user to run `/track-roadmap generate` first

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

### Problem: Roadmap doesn't match what's actually being built

**Cause:** Roadmap wasn't updated as priorities shifted.

**Solution:**
- Run `/track-roadmap audit` to reconcile plan vs. reality
- Update the roadmap to reflect actual direction
- Set a habit: audit after every major feature completion

### Problem: Features are too granular

**Cause:** Mixing task-level work with feature-level planning.

**Solution:**
- Features should be user-visible capabilities, not implementation steps
- Bad: "Add bcrypt", "Create user table", "Build login form"
- Good: "User authentication"
- Use `track-session` for task-level tracking within a feature

### Problem: Codebase scan suggests irrelevant features

**Cause:** Discovery picked up on implementation details, not user features.

**Solution:**
- Treat scan results as suggestions, not requirements
- Always confirm with user before adding to roadmap
- Focus on user-facing capabilities, not internal architecture

### Problem: Resume can't find ROADMAP.md

**Cause:** No roadmap has been created for this project yet.

**Solution:**
- Run `/track-roadmap generate` to create a ROADMAP.md first
- Then use `/track-roadmap resume` to pick a feature and start working

### Problem: Resume finds an active session but user wants to switch features

**Cause:** User changed their mind about what to work on.

**Solution:**
- Resume will ask whether to continue the active session or pick a new item
- If switching: the current SESSION_PROGRESS.md will be overwritten with the new feature's plan
- Consider running `/track-session save` first to preserve progress if needed

### Problem: User can't decide on features

**Cause:** Too many options or unclear project direction.

**Solution:**
- Start with the core question: "What problem does this project solve?"
- Ask: "If you could only build 3 features, what would they be?"
- Use the "Future Ideas" section as a pressure valve for uncommitted items

## Integration

**This skill works with:**
- **track-session** - After choosing a feature from the roadmap, use `track-session` to plan and track the implementation work
- **generate-skill** - Use the roadmap to identify features that could become reusable skills
- **git-worktree** - Work on multiple roadmap features in parallel across worktrees

**Workflow pattern:**
```
/track-roadmap generate  →  Pick a feature  →  /track-session  →  Build it
/track-roadmap resume    →  Check session    →  Pick feature    →  /track-session  →  Build it
/track-roadmap audit     →  Review progress  →  /track-roadmap update  →  Adjust plan
```

**Pairs with:**
- Sprint planning and milestone reviews
- Project kickoff and scope definition
- Periodic retrospectives
