# Track Roadmap - Detailed Examples

Extended examples for the track-roadmap skill. See the main [SKILL.md](../SKILL.md) for usage modes, format, and rules.

---

## Example: Generating a Roadmap

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
- <!-- id:r_x9w1n status:planned --> **Due date reminders** - Notify users when tasks are approaching their due date.

## User Experience

<!-- category:ux -->

- <!-- id:r_j4t8v status:planned --> **Dark mode** - Support system-level dark/light theme preference.
- <!-- id:r_b2c6d status:planned --> **Keyboard shortcuts** - Power users can manage tasks without touching the mouse.
- <!-- id:r_q7r3f status:planned --> **Drag-and-drop reordering** - Reorder tasks within and across lists.

## Technical Infrastructure

<!-- category:infra -->

- <!-- id:r_w5e9h status:planned --> **Cloud sync** - Sync tasks across devices via a backend API.
- <!-- id:r_n1y6k status:planned --> **Offline support** - App works without internet, syncs when reconnected.

## Future Ideas

<!-- category:future -->

- <!-- id:r_p4s8a status:idea --> **Shared lists** - Collaborate on task lists with other users.
- <!-- id:r_v2g7c status:idea --> **Recurring tasks** - Tasks that repeat on a schedule.

## Completed

<!-- category:completed -->

- <!-- id:r_k8x2m status:done completed:2026-01-15 --> ~~**Task CRUD**~~ - Create, read, update, and delete tasks with title, description, and due date. *(Completed: 2026-01-15)*
```

**Why this is good:** Includes frontmatter with schema version, every item has a unique ID and status, categories have slug comments, completed items have strikethrough and date, Future Ideas uses `idea` status, human-readable AND machine-parseable.
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

---

## Example: Brainstorming Ideas

<Good>
```bash
user: "/track-roadmap brainstorm"
# Agent reads ROADMAP.md -> summarizes 3 planned features, 0 future ideas
# Agent asks divergent questions

assistant: "Your roadmap covers task management basics. Let's explore what else
this could become. What's the most tedious part of using task managers today?"

user: "I always forget to check them. The tasks just sit there."

assistant: "Interesting — so the core problem is engagement, not features. Let me
explore that. What if tasks could come to you instead of you going to them?"

# Agent deepens the idea:
# - User journey: tasks surface in Slack/email/calendar based on due date + priority
# - Inspirations: Todoist smart scheduling, Hey's "screener" pattern
# - Requirements: Integration APIs, notification system, priority algorithm
# - Open questions: Which channels matter most? Push vs. digest?

assistant: "I also want to explore the opposite angle — instead of more
notifications, what about radical simplification? A mode that hides everything
except today's 3 most important tasks."

user: "Oh I love that. The first idea is interesting but might be scope creep for
a personal task manager. The focus mode idea — yes, keep that."

# Agent captures:
# - Smart surfacing: REJECTED — scope creep, better suited for enterprise product
# - Focus mode: ACCEPTED → added to ROADMAP.md Future Ideas

# Agent adds to ROADMAP.md:
# ## Future Ideas
# <!-- category:future -->
# - <!-- id:r_w2j6q status:idea --> **Focus mode** - Hide everything except
#   today's 3 most important tasks. Inspired by: "one thing at a time" productivity
#   methods. Open question: how to auto-select the 3 tasks (due date? manual pin?).
```

**Why this is good:** Starts with user pain points (not a feature list), explores the "why" before the "what", deepens each idea with journey/inspirations/requirements/questions, presents multiple angles, user decides what stays, rejected ideas are noted with reasons, captured ideas use `status:idea` with cc-dash IDs and include open questions.
</Good>

<Bad>
```bash
user: "/track-roadmap brainstorm"
assistant: "Based on similar task managers, here are 15 features you should add:
1. Dark mode
2. Notifications
3. Calendar view
4. AI task suggestions
5. Recurring tasks
6. Tags and labels
7. Team collaboration
8. Mobile app
9. Integrations
10. Analytics dashboard
..."
# Then immediately adds all 15 to ROADMAP.md without asking
```

**Why this is bad:** Dumped a generic feature list without asking about user's pain points or vision, no exploration of ideas, no user filtering, added items to roadmap without confirmation, features are generic (could apply to any app), no inspirations or open questions captured.
</Bad>
