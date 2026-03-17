---
name: track-session
description: |
  Track, stop, resume, verify, and save progress on long-running work. Use when asked to "start a work session", "track this work", "save progress", "stop session", "resume work", "continue where we left off", "verify work", "check if we're done", "validate progress", "let's get to work on something big", or when planning multi-phase implementations, complex refactoring, or tasks spanning multiple sessions.
license: MIT
metadata:
  author: Antonin Januska
  version: "4.0.0"
  argument-hint: "[save|resume|verify]"
hooks:
  post_tool_use:
    - Update SESSION_PROGRESS.md after Write/Edit operations
  stop:
    - Verify all plan items are completed before ending
---
# Session Progress

> **🔄 Session tracking activated** - I'll use SESSION_PROGRESS.md to track our work so we can pause and resume anytime.

## Overview

Use SESSION_PROGRESS.md in the project root to track plans and progress. All planned work should be saved to SESSION_PROGRESS.md and updated over time. If the plan changes, update SESSION_PROGRESS.

**Core principle:** Maintain recoverable state so work can pause and resume without losing context.

## Usage Modes

This skill supports four modes via optional arguments:

| Mode | Command | What it does | Use when |
|------|---------|-------------|----------|
| **Default** | `/track-session` | Save progress, then continue working | Checkpoint during active work |
| **Save** | `/track-session save` | Save progress and stop | Pausing work or taking a break |
| **Resume** | `/track-session resume` | Load SESSION_PROGRESS.md and continue | Starting new session after break |
| **Verify** | `/track-session verify` | Validate completed work against requirements | Before declaring done or delivery |

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

## When to Verify

Run verification:
- Before declaring work complete
- After all planned tasks are checked off
- Before final delivery or handoff
- When returning to work after a long break (verify nothing regressed)
- After major refactoring (verify functionality preserved)
- When user asks "are we done?" or "did we finish everything?"

## Format

```markdown
---
schema: cc-dash/session@1
project: project-name-here
session_id: s_YYYY-MM-DD_topic-slug
roadmap_ref: r_XXXXX
started: YYYY-MM-DDTHH:MM:SS-TZ
last_updated: YYYY-MM-DDTHH:MM:SS-TZ
status: in-progress
---

# Session Progress

## Plan

- [ ] <!-- id:t_XXXXX dep:none --> Task 1: Description
- [x] <!-- id:t_XXXXX dep:t_XXXXX --> Task 2: Description
- [ ] <!-- id:t_XXXXX dep:t_XXXXX --> Task 3: Description

## Current Status

Last updated: [timestamp]
Working on: [current task]
Next: [immediate next step]

## Decisions

- [decision description]

## Failed Attempts

- <!-- id:f_XXXXX task:t_XXXXX --> Tried [approach]: Failed because [reason], trying [alternative] instead

## Completed Work

- <!-- ref:t_XXXXX at:YYYY-MM-DDTHH:MM:SS-TZ --> Task 2: [brief summary of what was done]

## Verification Results

(Added by /track-session verify command)

### Successfully Verified

- Task/Phase: Evidence of completion and correctness

### Minor Issues Found

- Issue: Description and impact

### Blocking Issues

- Critical problem: What's broken and why it blocks delivery
```

### Format Rules

1. **Frontmatter is required** - Must include `schema`, `project`, `session_id`, `started`, `last_updated`, `status`
2. **Every plan item gets an ID** - Format: `t_` + 5 random alphanumeric characters
3. **Every plan item declares dependencies** - `dep:t_XXXXX` or `dep:none`
4. **`roadmap_ref` links to the roadmap** - Set when session implements a specific roadmap feature
5. **Checkboxes are the primary status** - `[ ]` = not done, `[x]` = done
6. **Failed attempts reference tasks** - `task:t_XXXXX` links the failure to what was being attempted
7. **Completed work references tasks** - `ref:t_XXXXX at:timestamp` for traceability
8. **Session status in frontmatter** - `in-progress`, `paused`, `completed`, or `blocked`

### ID Generation

Generate IDs using 5 random characters from `[a-z0-9]`. Prefixes:

- `t_` = task (plan items)
- `f_` = failed attempt
- `s_` = session (in session_id, uses date + slug instead of random)

### Migration from v1

If you encounter a SESSION_PROGRESS.md without frontmatter or IDs, see the [Migration Guide](./reference/MIGRATION.md) for step-by-step instructions on upgrading to v2 format.

## Verification

**Command:** `/track-session verify`

Validates completed tasks against original requirements. Checks that work is actually done, requirements met, dependencies satisfied, no scope gaps. Generates report with verified items, minor issues, blockers, and next steps.

**See:** [Detailed Verification Guide](./reference/VERIFICATION.md) for full methodology.

## Rules

1. **Never repeat failures** - Log every failed approach with reason
2. **Resume from checkpoint** - Check for existing SESSION_PROGRESS.md at session start
3. **Keep current** - File should always reflect actual state
4. **Be specific** - Include enough detail to resume work after context loss
5. **Verify before declaring done** - Always run `/track-session verify` before claiming work is complete
6. **Verification is not optional** - Checked boxes don't mean work meets requirements; verification does

## Examples

### Example: Mode Selection

<Good>
```bash
# Scenario 1: Starting a big feature
user: "Let's implement user authentication"
assistant: "/track-session"
# Creates SESSION_PROGRESS.md with plan, then starts working immediately

# Scenario 2: Taking a lunch break
user: "Save my progress, I'll be back in an hour"
assistant: "/track-session save"
# Saves current state and stops

# Scenario 3: Coming back from break
user: "I'm back, let's continue"
assistant: "/track-session resume"
# Reads SESSION_PROGRESS.md and continues from checkpoint

# Scenario 4: Creating checkpoint mid-work
assistant: "Completed Phase 2, creating checkpoint before Phase 3"
assistant: "/track-session"
# Updates SESSION_PROGRESS.md with Phase 2 completion, continues to Phase 3

# Scenario 5: Verifying work is complete
user: "Are we done? Did we complete everything?"
assistant: "/track-session verify"
# Reads SESSION_PROGRESS.md, checks all completed tasks against requirements
# Reports: "✅ Phases 1-3 verified. ⚠️ Phase 4 tests not run. Recommend: Run test suite"

# Scenario 6: End of work session verification
assistant: "All tasks appear complete. Let me verify before we finish."
assistant: "/track-session verify"
# Validates all work, generates verification report
```

**Why this is good:** Clear separation of concerns - save for pausing, resume for continuing, no-arg for checkpointing during active work, verify for validation before delivery.
</Good>

<Bad>
```bash
# Always using save even when you want to continue
user: "Let's build authentication"
assistant: "/track-session save"
# Saves and STOPS, now user has to manually ask to resume

# Using resume without a saved session
user: "Start working on the feature"
assistant: "/track-session resume"
# ERROR: No SESSION_PROGRESS.md exists yet

# Marking tasks complete without verification
assistant: "All tasks are checked off, we're done!"
# Never ran verify to confirm work actually meets requirements
```

**Why this is bad:** Using save when you want to continue wastes time. Using resume without prior save fails. Skipping verify means potentially incomplete or incorrect work. Use no-arg mode to save+continue, and always verify before declaring completion.
</Bad>

### Example 1: Complex Feature Implementation

<Good>
```markdown
---
schema: cc-dash/session@1
project: my-web-app
session_id: s_2026-03-10_user-auth
roadmap_ref: r_k8x2m
started: 2026-03-10T09:00:00-07:00
last_updated: 2026-03-10T14:30:00-07:00
status: in-progress
---

# Session Progress

## Plan

- [x] <!-- id:t_a1b2c dep:none --> Phase 1: Research authentication libraries
  - Evaluated OAuth.js, Passport.js, Auth0
  - Chose Passport.js for flexibility
- [x] <!-- id:t_d3e4f dep:t_a1b2c --> Phase 2: Set up OAuth flow
  - Configured Google OAuth provider
  - Added callback routes
- [ ] <!-- id:t_g5h6i dep:t_d3e4f --> Phase 3: Add user session management
  - Implement Redis session store
  - Add session cleanup job
- [ ] <!-- id:t_j7k8l dep:t_g5h6i --> Phase 4: Test authentication flows
  - Test login/logout
  - Test session persistence

## Current Status

Working on: Phase 3 - Implementing Redis session storage
Next: Add Redis client configuration, then implement session middleware

## Failed Attempts

- <!-- id:f_m9n0p task:t_g5h6i --> Tried in-memory sessions: Failed because sessions not persistent across server restarts, switching to Redis instead
- <!-- id:f_q1r2s task:t_g5h6i --> Attempted express-session default store: Performance issues with concurrent users, Redis solves this

## Completed Work

- <!-- ref:t_d3e4f at:2026-03-10T13:00:00-07:00 --> Phase 2 completed - OAuth flow working with Google provider
- <!-- ref:t_a1b2c at:2026-03-10T11:00:00-07:00 --> Phase 1 completed - Selected Passport.js after comparing 3 libraries
```

**Why this is good:** Frontmatter with schema and session metadata, specific tasks with IDs and explicit dependencies, failed attempts linked to tasks, completed work with timestamps and task references, concrete next steps.
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
---
schema: cc-dash/session@1
project: payment-service
session_id: s_2026-03-12_payment-race-condition
started: 2026-03-12T10:00:00-07:00
last_updated: 2026-03-12T15:00:00-07:00
status: in-progress
---

# Session Progress

## Plan

- [x] <!-- id:t_p1a2b dep:none --> Phase 1: Reproduce bug
- [x] <!-- id:t_c3d4e dep:t_p1a2b --> Phase 2: Identify root cause
- [ ] <!-- id:t_f5g6h dep:t_c3d4e --> Phase 3: Implement fix
- [ ] <!-- id:t_i7j8k dep:t_f5g6h --> Phase 4: Verify fix with tests

## Current Status

Working on: Phase 3 - Implementing race condition fix
Next: Add mutex lock around shared resource access in payment processor

## Failed Attempts

- <!-- id:f_l9m0n task:t_c3d4e --> Checked payment API logs: No errors found, bug is client-side
- <!-- id:f_o1p2q task:t_c3d4e --> Added try-catch around payment call: Still crashes, race condition suspected
- <!-- id:f_r3s4t task:t_c3d4e --> Increased timeout values: Made it worse, confirms race condition hypothesis

## Completed Work

- <!-- ref:t_c3d4e at:2026-03-12T14:00:00-07:00 --> Phase 2 - Root cause identified: race condition in payment state management
- <!-- ref:t_p1a2b at:2026-03-12T12:00:00-07:00 --> Phase 1 - Bug reproduced consistently with concurrent payment attempts
```

**Why this is good:** Clear progression through debugging phases, failed attempts linked to tasks with IDs, root cause documented, frontmatter tracks session metadata.
</Good>

<Bad>
```markdown
# Session Progress

Debugging payment bug. Tried a few things. Need to fix it.
```

**Why this is bad:** No systematic approach, no record of what was tried, no hypothesis tracking.
</Bad>

### Example 3: Verification Workflow

<Good>
```markdown
---
schema: cc-dash/session@1
project: my-web-app
session_id: s_2026-03-08_auth-system
started: 2026-03-08T09:00:00-07:00
last_updated: 2026-03-09T16:00:00-07:00
status: completed
---

# Session Progress

## Plan

- [x] <!-- id:t_v1w2x dep:none --> Phase 1: Set up authentication system
- [x] <!-- id:t_y3z4a dep:t_v1w2x --> Phase 2: Implement user registration
- [x] <!-- id:t_b5c6d dep:t_y3z4a --> Phase 3: Add email verification
- [x] <!-- id:t_e7f8g dep:t_b5c6d --> Phase 4: Write tests

## Verification Results

### Successfully Verified

- All phases verified with passing tests (23/23)

### Minor Issues Found

- Email template styling needs polish, no rate limiting on registration endpoint

### Blocking Issues

- None
```

**Why this is good:** Verification report uses plain headings (no emojis), shows evidence (test counts, specific issues), separates critical vs. nice-to-have, frontmatter shows session is completed.
</Good>

<Bad>
```markdown
## Plan
- [x] Phase 1: Authentication
- [x] Phase 2: Registration
- [x] Phase 3: Email stuff
- [x] Phase 4: Tests

Everything is done! ✨
```

**Why this is bad:** No verification performed, no evidence work meets requirements, potentially incomplete work.
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

### Problem: Resume fails with "No SESSION_PROGRESS.md found"

**Cause:** Trying to resume without first saving a session.

**Solution:**
- Use `/track-session` (no argument) to create initial session
- Or use `/track-session save` to create SESSION_PROGRESS.md first
- Resume only works when SESSION_PROGRESS.md already exists

### Problem: Save mode stops work when you wanted to continue

**Cause:** Using `save` argument instead of no argument.

**Solution:**
- Use `/track-session save` ONLY when pausing work
- Use `/track-session` (no arg) to checkpoint and continue
- Default no-arg mode is for active work with checkpoints

### Problem: Unclear which mode to use

**Cause:** Not understanding the difference between modes.

**Solution:**
Quick decision guide:
- **Continuing work?** Use no argument (default)
- **Stopping for a break?** Use `save`
- **Coming back to work?** Use `resume`
- **Think you're done?** Use `verify`

### Problem: Verify reports work incomplete but all tasks are checked

**Cause:** Tasks were marked complete without actually finishing the work, or requirements changed.

**Solution:**
1. Review each flagged item in the verification report
2. Either:
   - Complete the missing work and re-verify, OR
   - Update SESSION_PROGRESS.md if requirements changed
3. Never skip verification - checked boxes don't mean work is actually done

### Problem: Verify mode takes too long

**Cause:** Too many completed tasks to verify at once.

**Solution:**
- Run verify incrementally after each major phase
- Don't wait until the end to verify everything
- Use `/track-session verify` after completing each group of related tasks
- Archive verified phases to SESSION_ARCHIVE.md to reduce scope

### Problem: Verify passes but work still has bugs

**Cause:** Verification wasn't thorough enough (didn't run tests, check edge cases, etc.)

**Solution:**
Verification should include:
- Running test suites (unit, integration, e2e)
- Manual testing of key user flows
- Checking error handling and edge cases
- Validating against original acceptance criteria
- Code review of critical changes

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
