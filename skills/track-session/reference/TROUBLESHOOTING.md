# Track Session — Extended Troubleshooting

Additional troubleshooting beyond the common issues covered in SKILL.md.

## Problem: SESSION_PROGRESS.md getting too large (>1000 lines)

**Cause:** Usually one of two things — the plan is too granular (task-level, not phase-level), or multiple finished sessions have been stacked into one file. A session file should track **one** active session; the dashboard parses only the top frontmatter block, so anything below a second `---` is invisible to it.

**Solution:**
- Collapse finished phases to one-line entries under `## Completed Work` — the detail already lives in git history and commit messages, so it doesn't need to sit in the file.
- When a session is genuinely done, start the next one from a clean file rather than appending to it — don't accrete `# (Previous session)` blocks.
- Before replacing anything, run the tracked check from Start mode in SKILL.md and archive first when it comes back non-zero.

## Problem: Repeated failed attempts with same approach

**Cause:** Not reading or updating "Failed Attempts" section.

**Solution:** Read `## Failed Attempts` before retrying anything, and log a new failure the moment it happens — with its reason, and marked env-scoped when the environment rather than the approach was at fault.

## Problem: Verify reports work incomplete but all tasks are checked

**Cause:** Tasks were marked complete without actually finishing the work, or requirements changed.

**Solution:** For each flagged item, either finish the work and re-verify, or update the task in SESSION_PROGRESS.md if the requirement changed. A ticked box is a claim; the verification report is the evidence.

## Problem: Verify mode takes too long

**Cause:** Too many completed tasks to verify at once.

**Solution:**
- Run verify incrementally after each major phase
- Don't wait until the end to verify everything
- Use `/track-session verify` after completing each group of related tasks
- Collapse already-verified phases to one-line `## Completed Work` entries to reduce scope (git holds the detail)

## Problem: Verify passes but work still has bugs

**Cause:** The report tied tasks to reading rather than to running — a test suite that exists but was not executed, a flow that was described but not exercised.

**Solution:** Each evidence line in the report names something that ran this session (a test command and its result, a request and its response). Where a task has no acceptance criteria to run against, add them to the task first — see the Verification goal in [VERIFICATION.md](./VERIFICATION.md).
