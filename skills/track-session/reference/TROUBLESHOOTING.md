# Track Session — Extended Troubleshooting

Additional troubleshooting beyond the common issues covered in SKILL.md.

## Problem: SESSION_PROGRESS.md getting too large (>1000 lines)

**Cause:** Not archiving completed work periodically.

**Solution:**
```bash
# Archive completed phases to separate file
cat SESSION_PROGRESS.md >> SESSION_ARCHIVE_2025-01.md
# Keep only active phases in SESSION_PROGRESS.md
```

Move completed work to archive file monthly or after major milestones.

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
- Archive verified phases to SESSION_ARCHIVE.md to reduce scope

## Problem: Verify passes but work still has bugs

**Cause:** Verification wasn't thorough enough (didn't run tests, check edge cases, etc.)

**Solution:**
Verification should include:
- Running test suites (unit, integration, e2e)
- Manual testing of key user flows
- Checking error handling and edge cases
- Validating against original acceptance criteria
- Code review of critical changes
