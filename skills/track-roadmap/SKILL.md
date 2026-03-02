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
  version: "1.1.0"
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
# Roadmap

> Project purpose in one sentence.

## Core Features
- **Feature Name** - Short description of what it does and why it matters.
- **Feature Name** - Short description.

## User Experience
- **Feature Name** - Short description.
- **Feature Name** - Short description.

## Technical Infrastructure
- **Feature Name** - Short description.

## Future Ideas
- **Feature Name** - Short description. (Not committed, just captured.)

## Completed
- ~~**Feature Name**~~ - Short description. *(Completed: YYYY-MM-DD)*
```

### Format Rules

1. **Categories are flexible** - Use whatever groupings make sense for the project (the above are suggestions)
2. **One line per feature** - Title in bold + 1-2 sentence description
3. **Future Ideas** section is a parking lot for uncommitted ideas
4. **Completed** section preserves history of what's been built
5. **Keep it scannable** - The whole file should be readable in under 2 minutes

---

## Rules

1. **User drives the roadmap** - Never add features without user confirmation
2. **Keep it high-level** - Features, not tasks. "User authentication" not "Add bcrypt to hash passwords"
3. **ROADMAP.md is the source of truth** - If it's not in the file, it's not on the roadmap
4. **Audit regularly** - Roadmaps drift. Audit catches the drift.
5. **Don't over-plan** - 5-15 features is a healthy roadmap. 50 features means the project needs splitting.
6. **Completed features stay** - Move to Completed section, don't delete. History matters.

## Examples

### Example: Generating a Roadmap

<Good>
```markdown
# Roadmap

> A personal task manager that syncs across devices.

## Core Features
- **Task CRUD** - Create, read, update, and delete tasks with title, description, and due date.
- **Task lists** - Organize tasks into named lists (e.g., Work, Personal, Shopping).
- **Due date reminders** - Notify users when tasks are approaching their due date.

## User Experience
- **Dark mode** - Support system-level dark/light theme preference.
- **Keyboard shortcuts** - Power users can manage tasks without touching the mouse.
- **Drag-and-drop reordering** - Reorder tasks within and across lists.

## Technical Infrastructure
- **Cloud sync** - Sync tasks across devices via a backend API.
- **Offline support** - App works without internet, syncs when reconnected.

## Future Ideas
- **Shared lists** - Collaborate on task lists with other users.
- **Recurring tasks** - Tasks that repeat on a schedule.

## Completed
```

**Why this is good:** Clear project purpose, logical groupings, each feature is one line with a concise description, Future Ideas captures uncommitted work, Completed section ready for use.
</Good>

<Bad>
```markdown
# Roadmap

- tasks
- lists
- dark mode
- sync
- make it look good
- fix bugs
- add tests
- deploy somewhere
- maybe sharing?
```

**Why this is bad:** No descriptions, no groupings, mixes features with tasks ("fix bugs", "add tests"), vague items ("make it look good"), no project purpose, no structure.
</Bad>

### Example: Auditing a Roadmap

<Good>
```markdown
## Audit Results

### Progress
| Feature | Status | Evidence |
|---------|--------|----------|
| Task CRUD | Done | src/components/TaskForm, TaskList, API routes |
| Task lists | Done | src/models/List.ts, list management UI |
| Due date reminders | Not Started | No notification system found |
| Dark mode | In Progress | Theme context exists but only light theme defined |
| Cloud sync | Not Started | No backend API or sync logic |

### Recommendations
- Move "Task CRUD" and "Task lists" to Completed
- "Dark mode" is close - just needs dark theme CSS variables
- Consider deprioritizing "Cloud sync" until core UX is solid
- New: "Search/filter tasks" came up in TODO comments (src/App.tsx:42)
```

**Why this is good:** Every feature checked, evidence cited with file paths, actionable recommendations, surfaced a new feature from codebase discovery.
</Good>

<Bad>
```markdown
## Audit
Looks like some stuff is done. Maybe we should build more things.
```

**Why this is bad:** No specifics, no evidence, no per-feature assessment, no actionable recommendations.
</Bad>

### Example: Updating a Roadmap

User says: *"We decided not to do offline support, and I want to add calendar integration."*

<Good>
```markdown
# Before:
## Technical Infrastructure
- **Cloud sync** - Sync tasks across devices via a backend API.
- **Offline support** - App works without internet, syncs when reconnected.

## User Experience
- **Dark mode** - Support system-level dark/light theme preference.

# After (confirmed with user):
## Technical Infrastructure
- **Cloud sync** - Sync tasks across devices via a backend API.

## User Experience
- **Dark mode** - Support system-level dark/light theme preference.
- **Calendar integration** - Show tasks with due dates in a calendar view.
```

**Why this is good:** Confirms removal before acting, places new feature in appropriate category with description, only changes what the user asked for.
</Good>

<Bad>
```markdown
# User asked to remove offline support.
# Agent removes offline support AND cloud sync AND dark mode
# because it decided they weren't important either.
```

**Why this is bad:** Removed features the user didn't ask about. Never make unilateral roadmap decisions.
</Bad>

### Example: Resuming from Roadmap

<Good>
```bash
# User returns to project after a break
user: "/track-roadmap resume"

# Agent checks for SESSION_PROGRESS.md → not found
# Agent reads ROADMAP.md → presents features

assistant: "No active session found. Here are the features from your roadmap:"
# Uses AskUserQuestion with roadmap features:
# - Due date reminders (Core Features)
# - Dark mode (User Experience)
# - Cloud sync (Technical Infrastructure)

user: selects "Due date reminders"

assistant: "Great - Due date reminders: Notify users when tasks are approaching
their due date. Before we start, a couple of questions:
- Should reminders be push notifications, email, or in-app?
- How far in advance should reminders trigger?"

user: "In-app only, 1 hour and 1 day before"

# Agent creates SESSION_PROGRESS.md:
# ## Plan
# Feature: Due date reminders (from ROADMAP.md → Core Features)
# - [ ] Phase 1: Add due date reminder model/schema
# - [ ] Phase 2: Implement reminder check logic (1hr and 1day thresholds)
# - [ ] Phase 3: Build in-app notification UI
# - [ ] Phase 4: Test reminder flows

# Agent starts working on Phase 1
```

**Why this is good:** Checks session state first, presents roadmap features for user to choose, asks clarifying questions before starting, creates a session plan that references the roadmap feature, then starts working.
</Good>

<Bad>
```bash
# Agent skips session check, auto-picks feature
user: "/track-roadmap resume"
assistant: "I'll start working on Cloud sync since it's the most important feature."
# Never checked for active session
# Never asked user which feature
# Picked feature unilaterally
```

**Why this is bad:** Skipped session check (might have overwritten active work), auto-selected a feature without asking the user, violated the "user drives the roadmap" rule.
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
