# Track Roadmap - Detailed Examples

Extended examples for the track-roadmap skill. See the main [SKILL.md](../SKILL.md) for usage modes, format, and rules.

---

## Example: Generating a Roadmap

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

---

## Example: Auditing a Roadmap

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

---

## Example: Updating a Roadmap

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

---

## Example: Resuming from Roadmap

<Good>
```bash
# User returns to project after a break
user: "/track-roadmap resume"

# Agent checks for SESSION_PROGRESS.md -> not found
# Agent reads ROADMAP.md -> presents features

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
# Feature: Due date reminders (from ROADMAP.md -> Core Features)
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
