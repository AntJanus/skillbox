# Track Session - Migration from v1

Guide for upgrading legacy SESSION_PROGRESS.md files (without frontmatter or IDs) to the v2 format (`cc-dash/session@1`).

---

## Steps

If you encounter a SESSION_PROGRESS.md without frontmatter:

1. **Add the frontmatter block** with `schema: cc-dash/session@1`
2. **Infer `project`** from the directory name or ROADMAP.md
3. **Add IDs to each plan item** using the `t_` prefix + 5 random `[a-z0-9]` characters
4. **Add `dep:none`** to items without clear dependencies
5. **Set `started` and `last_updated`** from timestamps in the file
6. **Set `status`** based on content (all checked = completed, etc.)

## Example

**Before (v1):**

```markdown
# Session Progress

## Plan
- [x] Phase 1: Set up project [dependency: none]
- [ ] Phase 2: Implement feature [dependency: Phase 1]

## Current Status
Working on: Phase 2

## Failed Attempts
- Tried approach A: Failed because of X
```

**After (v2):**

```markdown
---
schema: cc-dash/session@1
project: my-project
session_id: s_2026-03-10_feature-work
started: 2026-03-10T09:00:00-07:00
last_updated: 2026-03-10T14:00:00-07:00
status: in-progress
---

# Session Progress

## Plan

- [x] <!-- id:t_a1b2c dep:none --> Phase 1: Set up project
- [ ] <!-- id:t_d3e4f dep:t_a1b2c --> Phase 2: Implement feature

## Current Status

Working on: Phase 2

## Failed Attempts

- <!-- id:f_g5h6i task:t_d3e4f --> Tried approach A: Failed because of X
```
