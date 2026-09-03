# Session Verification Guide

## Overview

This guide provides detailed methodology for verifying session work using `/track-session verify`.

**Purpose:** Ensure completed tasks actually meet original requirements before declaring work done.

## Verification

**Goal:** every `[x]` task in SESSION_PROGRESS.md is backed by evidence gathered this run — a file you read, a test you ran, a behavior you exercised — and the report says which tasks are not.
**Constraints:** verify, don't fix. A task that fails verification is reported, unticked, and left for the session to act on. If the file is missing, stop and say so; `/track-session` creates one.
**Gates:** the report section is written only after every `[x]` task has an evidence line.

Read the whole file first: the Plan gives the requirements, Failed Attempts tells you what was already ruled out, and each task's acceptance criteria tell you what "done" means. Where a task has no criteria, add them to its description before verifying it — "ambiguous done" is the most common cause of a false `[x]`.

Dependencies are mechanical and worth checking exactly: a `[x]` task whose `dep:` target is unticked is an orphan, and a chain that loops is a cycle. Report both.

```markdown
- [x] <!-- id:t_a1b2c dep:none --> Phase 1: Setup ✅
- [x] <!-- id:t_d3e4f dep:t_a1b2c --> Phase 2: Implementation ✅
- [ ] <!-- id:t_g5h6i dep:t_d3e4f --> Phase 3: Testing ⚠️ Phase 2 done but Phase 3 pending
```

Scope gaps are the judgment call: tasks done but unticked, requirements that surfaced during the work and never became tasks, tests written but not run, code committed but not deployed.

## Report format

**Length:** one evidence line per verified task, one line per issue; omit any subsection with nothing in it. Keep Recommended Next Steps to the top five. The report is appended to a state record — no narrative and no restatement of the Plan.

Create structured verification report in SESSION_PROGRESS.md under "## Verification Results":

#### ✅ Successfully Verified

List completed items with evidence:
```markdown
- Phase 1: Setup authentication - Passport.js configured, middleware active
- Phase 2: User registration - Endpoint returns 201, user in DB
- Phase 4: Tests - Suite passes (23/23 tests green)
```

**Include:**
- Specific evidence (test counts, status codes, file paths)
- What was checked
- How it was verified

#### ⚠️ Minor Issues Found

Non-blocking issues that should be addressed:
```markdown
- Email template uses default styling (cosmetic, not blocking)
- No rate limiting on registration endpoint (should add for production)
- Missing JSDoc comments (code quality, not critical)
```

**Criteria for Minor:**
- Doesn't break functionality
- Nice-to-have improvements
- Code quality issues
- Performance optimizations
- Missing documentation

#### ❌ Blocking Issues

Critical problems that prevent delivery:
```markdown
- Phase 3: Email verification - SendGrid API key invalid, emails not sending
- Tests failing: 5/23 tests red, authentication flow broken
- Missing dependency: Redis not configured, sessions fail
```

**Criteria for Blocking:**
- Broken functionality
- Failed tests
- Missing critical features
- Security vulnerabilities
- Data loss risks
- Unhandled errors

#### 📋 Recommended Next Steps

Prioritized action items:
```markdown
1. Fix SendGrid API key configuration (BLOCKING)
2. Debug failing auth tests (BLOCKING)
3. Add rate limiting to registration (HIGH)
4. Customize email templates (MEDIUM)
5. Add JSDoc comments (LOW)
```

**Prioritization:**
1. Fix all blocking issues first
2. Address high-priority improvements
3. Plan medium/low items for future sprints

## Common Verification Scenarios

### Scenario: All Tasks Checked but Tests Not Run

**Problem:** Tasks marked complete but verification reveals tests never executed.

**Verification:**
```bash
# Run test suite
npm test
# Result: Tests fail or don't exist
```

**Report:**
```markdown
❌ BLOCKING: Phase 4 marked complete but tests failing (5/23 red)
📋 Fix failing tests before declaring work done
```

### Scenario: Feature Works But Missing Error Handling

**Problem:** Happy path works, edge cases crash.

**Verification:**
```javascript
// Try edge cases
- Empty input
- Null values
- Invalid formats
- Race conditions
```

**Report:**
```markdown
⚠️ MINOR: Feature works but crashes on empty input
📋 Add error handling for edge cases
```

### Scenario: Dependencies Incomplete

**Problem:** Phase 3 marked done but depends on incomplete Phase 2.

**Verification:**
```markdown
- [x] <!-- id:t_d3e4f dep:t_a1b2c --> Phase 2: API integration (missing API key)
- [x] <!-- id:t_g5h6i dep:t_d3e4f --> Phase 3: Frontend using API (fails due to Phase 2 issue)
```

**Report:**
```markdown
❌ BLOCKING: Phase 3 depends on Phase 2, but Phase 2 API not configured
📋 Complete Phase 2 configuration before Phase 3 can be verified
```

## Integration with Development Workflow

Verify incrementally, not only at the end: run `/track-session verify` after each major phase, again before final delivery (fix blocking issues and re-verify until the report is clean), and during code review to confirm the report's evidence holds up.

For verify-mode problems — verify reports incomplete work with all tasks checked, verify takes too long, verify passes but bugs remain — see [TROUBLESHOOTING.md](./TROUBLESHOOTING.md).

## References

- Main skill: [track-session SKILL.md](../SKILL.md)
