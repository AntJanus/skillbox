# Track Session — Extended Troubleshooting

Additional troubleshooting beyond the common issues covered in SKILL.md.

## Problem: SESSION_PROGRESS.md getting too large (>1000 lines)

**Cause:** Usually one of two things — the plan is too granular (task-level, not phase-level), or multiple finished sessions have been stacked into one file. A session file should track **one** active session; the dashboard parses only the top frontmatter block, so anything below a second `---` is invisible to it.

**Solution:**
- Collapse finished phases to one-line entries under `## Completed Work` — the detail already lives in git history and commit messages, so it doesn't need to sit in the file.
- When a session is genuinely done, start the next one by **replacing** the file (see the Start-mode collision policy in SKILL.md), not by appending to it. Don't accrete `# (Previous session)` blocks.
- Only if you truly need the old context readable, move it to a topic-named `SESSION_ARCHIVE_<topic>.md` and keep `SESSION_PROGRESS.md` to the active session. In practice, replace-and-trust-git is simpler and is the default.

## Problem: Repeated failed attempts with same approach

**Cause:** Not reading or updating "Failed Attempts" section.

**Solution:**
Before trying new approach:
1. Check "Failed Attempts" section
2. Verify approach is different
3. Document why this attempt should work
4. Add failed attempt immediately when it fails

## Problem: Save mode stops work when you wanted to continue

**Cause:** Using `save` argument instead of no argument.

**Solution:**
- Use `/track-session save` ONLY when pausing work
- Use `/track-session` (no arg) to checkpoint and continue
- Default no-arg mode is for active work with checkpoints

## Problem: Verify reports work incomplete but all tasks are checked

**Cause:** Tasks were marked complete without actually finishing the work, or requirements changed.

**Solution:**
1. Review each flagged item in the verification report
2. Either:
   - Complete the missing work and re-verify, OR
   - Update SESSION_PROGRESS.md if requirements changed
3. Never skip verification - checked boxes don't mean work is actually done

## Problem: Verify mode takes too long

**Cause:** Too many completed tasks to verify at once.

**Solution:**
- Run verify incrementally after each major phase
- Don't wait until the end to verify everything
- Use `/track-session verify` after completing each group of related tasks
- Collapse already-verified phases to one-line `## Completed Work` entries to reduce scope (git holds the detail)

## Problem: Verify passes but work still has bugs

**Cause:** Verification wasn't thorough enough (didn't run tests, check edge cases, etc.)

**Solution:**
Verification should include:
- Running test suites (unit, integration, e2e)
- Manual testing of key user flows
- Checking error handling and edge cases
- Validating against original acceptance criteria
- Code review of critical changes
