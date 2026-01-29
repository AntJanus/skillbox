---
name: save-session
description: When running long-running work, progress should be saved. Triggers on tasks where Claude and the user get to work together, need to plan something out, or want to save progress along the way. Allows for work to pause, stop, and resume from a checkpoint of a working session
metadata:
  author: Antonin Januska
  version: "1.0.0"
hooks:
  post_tool_use:
    - Update SESSION_PROGRESS.md after Write/Edit operations
  stop:
    - Verify all plan items are completed before ending
---
# Session Progress

Use SESSION_PROGRESS.md in the project root to track plans and progress. All planned work should be saved to SESSION_PROGRESS.md and updated over time. If the plan changes, update SESSION_PROGRESS

## When to Update

Update after:
- Completing any checklist item
- Any change in plan
- Any error or failed attempt
- Every 2-3 file modifications
- Before asking user questions

## Format

```markdown
# Session Progress

## Plan
- [ ] Task 1: Description [dependency: none]
- [x] Task 2: Description [dependency: Task 1]
- [ ] Task 3: Description [dependency: Task 2]

## Current Status
Last updated: [timestamp]
Working on: [current task]
Next: [immediate next step]

## Failed Attempts
- Tried [approach]: Failed because [reason], trying [alternative] instead

## Completed Work
- [timestamp] Task 2: [brief summary of what was done]
```

## Rules

1. **Never repeat failures** - Log every failed approach with reason
2. **Resume from checkpoint** - Check for existing SESSION_PROGRESS.md at session start
3. **Keep current** - File should always reflect actual state
4. **Be specific** - Include enough detail to resume work after context loss
