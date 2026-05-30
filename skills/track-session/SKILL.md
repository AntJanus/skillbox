---
name: track-session
description: Resume work, track progress across sessions, verify completion. Use when asked to "resume work", "pick up where I left off", "what was I doing", "save progress", or "are we done". For multi-session tasks.
license: MIT
argument-hint: "[save|resume|verify]"
metadata:
  author: Antonin Januska
  version: "5.0.0"
---

# Session Progress

Track multi-session work in `SESSION_PROGRESS.md` at the project root so work can pause and resume without losing context. Keep the file current — it should always reflect actual state. At the start of any session, check for an existing `SESSION_PROGRESS.md` and resume from it.

## Modes

| Mode | Command | Behavior |
|------|---------|----------|
| **Default** | `/track-session` | Checkpoint progress, then keep working |
| **Save** | `/track-session save` | Checkpoint progress and stop |
| **Resume** | `/track-session resume` | Read `SESSION_PROGRESS.md`, continue from "Next" |
| **Verify** | `/track-session verify` | Validate completed work against requirements before declaring done |

## File format

cc-dash schema frontmatter (parsed by the dashboard) plus markdown checkboxes:

```markdown
---
schema: cc-dash/session@1
project: project-name
session_id: s_YYYY-MM-DD_topic-slug
roadmap_ref: r_XXXXX          # optional — links a roadmap feature
started: YYYY-MM-DDTHH:MM:SS-TZ
last_updated: YYYY-MM-DDTHH:MM:SS-TZ
status: in-progress           # in-progress | paused | completed | blocked
---

# Session Progress

## Plan

- [ ] <!-- id:t_a1b2c dep:none --> Task: description
- [x] <!-- id:t_d3e4f dep:t_a1b2c --> Task: description

## Current Status

Working on: <current task>
Next: <specific next action — name files and functions, not "fix the bug">

## Failed Attempts

- <!-- id:f_x1y2z task:t_d3e4f --> Tried X: failed because Y, trying Z instead

## Completed Work

- <!-- ref:t_d3e4f at:YYYY-MM-DDTHH:MM:SS-TZ --> What was done
```

**IDs:** 5 random `[a-z0-9]` chars — `t_` task, `f_` failed attempt; `session_id` uses date + slug. Every plan item gets an `id` and a `dep` (`dep:none` or `dep:t_XXXXX`). These markers are what the dashboard ingests — don't omit them.

**Log every failed approach with its reason**, so it's never retried.

**Update** after completing a task, changing the plan, hitting a failure, or before asking the user questions.

## Verify mode

`/track-session verify` confirms completed (`[x]`) tasks actually meet requirements — ticked boxes alone don't mean done. Read the relevant files, run tests, collect evidence, and ask the user about anything ambiguous. Append results:

```markdown
## Verification Results

### Successfully Verified
- Task: evidence (e.g. tests 23/23 passing)

### Minor Issues Found
- Issue: impact

### Blocking Issues
- None
```

See [reference/VERIFICATION.md](./reference/VERIFICATION.md) for the full methodology.

## Example

✅ Specific and resumable:

```markdown
## Plan
- [x] <!-- id:t_a1b2c dep:none --> Phase 1: choose session store (picked Redis)
- [ ] <!-- id:t_g5h6i dep:t_a1b2c --> Phase 2: add session middleware

## Current Status
Working on: Phase 2
Next: add Redis client in src/auth/session.ts, then wire middleware in app.ts
```

❌ Too vague to resume:

```markdown
## Plan
- [ ] Do auth stuff
- [ ] Fix sessions
Working on auth. Tried some things that didn't work.
```

The good version names the next action, files, and decisions; the bad one forces a context rebuild from scratch.

## When to use

For multi-phase work, cross-file refactors, long debugging sessions, or anything spanning multiple sessions / context resets. Skip quick 1–2 file changes and obvious fixes.

## Integration

- **track-roadmap** — pick a feature from the roadmap, then track its implementation here via `roadmap_ref`.
- Pairs with commit and testing workflows: checkpoint between commits and test phases.

See [reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) for resume failures, file-size management, and verify edge cases.
