---
name: save-session
description: When running long-running work, progress should be saved. Triggers on tasks where Claude and the user get to work together, need to plan something out, or want to save progress along the way. Allows for work to pause, stop, and resume from a checkpoint of a working session.
license: MIT
metadata:
  author: Antonin Januska
  version: "2.0.0"
hooks:
  post_tool_use:
    - Update SESSION_PROGRESS.md after Write/Edit operations
  stop:
    - Verify all plan items are completed before ending
---
# Session Progress

## Overview

Use SESSION_PROGRESS.md in the project root to track plans and progress. All planned work should be saved to SESSION_PROGRESS.md and updated over time. If the plan changes, update SESSION_PROGRESS.

**Core principle:** Maintain recoverable state so work can pause and resume without losing context.

## When to Use

**Always use when:**
- Working on multi-phase implementations
- Planning complex refactoring across multiple files
- Pairing with user on design decisions
- Tasks that might span multiple sessions or context resets
- Long-running debugging sessions with multiple approaches

**Useful for:**
- Feature development with dependencies between tasks
- Large refactoring projects
- Learning new codebases with exploration notes
- Collaborative work sessions with progress tracking

**Avoid when:**
- Quick 1-2 file changes
- Simple bug fixes with obvious solutions
- Read-only exploration without planned changes
- Tasks that complete in under 5 minutes

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

## Examples

### Example 1: Complex Feature Implementation

<Good>
```markdown
# Session Progress

## Plan
- [x] Phase 1: Research authentication libraries [dependency: none]
  - Evaluated OAuth.js, Passport.js, Auth0
  - Chose Passport.js for flexibility
- [x] Phase 2: Set up OAuth flow [dependency: Phase 1]
  - Configured Google OAuth provider
  - Added callback routes
- [ ] Phase 3: Add user session management [dependency: Phase 2]
  - Implement Redis session store
  - Add session cleanup job
- [ ] Phase 4: Test authentication flows [dependency: Phase 3]
  - Test login/logout
  - Test session persistence

## Current Status
Last updated: 2025-01-29 14:30
Working on: Phase 3 - Implementing Redis session storage
Next: Add Redis client configuration, then implement session middleware

## Failed Attempts
- Tried in-memory sessions: Failed because sessions not persistent across server restarts, switching to Redis instead
- Attempted express-session default store: Performance issues with concurrent users, Redis solves this

## Completed Work
- 2025-01-29 14:00: Phase 2 completed - OAuth flow working with Google provider
- 2025-01-29 13:30: Phase 1 completed - Selected Passport.js after comparing 3 libraries
```

**Why this is good:** Specific tasks with clear dependencies, documented decisions, failed attempts recorded with reasons, concrete next steps.
</Good>

<Bad>
```markdown
# Session Progress

## Plan
- [ ] Do auth stuff
- [ ] Fix sessions
- [ ] Test it

Working on auth. Tried some things that didn't work.
```

**Why this is bad:** Too vague, no dependencies tracked, no details on what failed or why, impossible to resume without starting over.
</Bad>

### Example 2: Debugging Session

<Good>
```markdown
# Session Progress

## Plan
- [x] Phase 1: Reproduce bug [dependency: none]
- [x] Phase 2: Identify root cause [dependency: Phase 1]
- [ ] Phase 3: Implement fix [dependency: Phase 2]
- [ ] Phase 4: Verify fix with tests [dependency: Phase 3]

## Current Status
Last updated: 2025-01-29 15:00
Working on: Phase 3 - Implementing race condition fix
Next: Add mutex lock around shared resource access in payment processor

## Failed Attempts
- Checked payment API logs: No errors found, bug is client-side
- Added try-catch around payment call: Still crashes, race condition suspected
- Increased timeout values: Made it worse, confirms race condition hypothesis

## Completed Work
- 2025-01-29 14:45: Phase 2 - Root cause identified: race condition in payment state management
- 2025-01-29 14:15: Phase 1 - Bug reproduced consistently with concurrent payment attempts
```

**Why this is good:** Clear progression through debugging phases, failed attempts inform next steps, root cause documented.
</Good>

<Bad>
```markdown
# Session Progress

Debugging payment bug. Tried a few things. Need to fix it.
```

**Why this is bad:** No systematic approach, no record of what was tried, no hypothesis tracking.
</Bad>

## Troubleshooting

### Problem: SESSION_PROGRESS.md getting too large (>1000 lines)

**Cause:** Not archiving completed work periodically.

**Solution:**
```bash
# Archive completed phases to separate file
cat SESSION_PROGRESS.md >> SESSION_ARCHIVE_2025-01.md
# Keep only active phases in SESSION_PROGRESS.md
```

Move completed work to archive file monthly or after major milestones.

### Problem: Lost track of what was being worked on

**Cause:** Didn't update "Current Status" before pausing session.

**Solution:**
- Update SESSION_PROGRESS.md before asking user questions
- Update before context resets
- Update every 2-3 file modifications
- Set reminder: "Last updated" timestamp should be recent

### Problem: Can't resume work after long break

**Cause:** Not enough detail in "Next" field.

**Solution:**
Include specific next action with file and function names:
```markdown
Next: Add mutex lock in src/payment/processor.ts:handlePayment()
around lines 45-60 where paymentState is accessed
```

Not just: "Next: Fix the bug"

### Problem: Repeated failed attempts with same approach

**Cause:** Not reading or updating "Failed Attempts" section.

**Solution:**
Before trying new approach:
1. Check "Failed Attempts" section
2. Verify approach is different
3. Document why this attempt should work
4. Add failed attempt immediately when it fails

## Integration

**This skill works with:**
- **git-worktree** - Each worktree should have its own SESSION_PROGRESS.md for parallel work tracking
- **All methodology skills** - Track phase completion for TDD, debugging, code review workflows
- **generate-skill** - Use SESSION_PROGRESS.md to track multi-phase skill creation
- **Long-running tasks** - Any task requiring >15 minutes or multiple context resets

**Integration pattern with git-worktree:**
```bash
# Create worktree for feature
git worktree add ../project-feature feature-branch
cd ../project-feature

# Create separate progress tracking
echo "# Session Progress - Feature Branch" > SESSION_PROGRESS.md
# Work on feature with independent progress tracking
```

**Pairs with:**
- Commit workflows - Track progress between commits
- Testing workflows - Track test implementation phases
- Refactoring - Track refactoring phases and rollback points
