# Session Verification Guide

## Overview

This guide provides detailed methodology for verifying session work using `/track-session verify`.

**Purpose:** Ensure completed tasks actually meet original requirements before declaring work done.

## Verification Process

### Step 1: Check Existence

Verify SESSION_PROGRESS.md exists. If missing, return error: "No session to verify. Use `/track-session` to create session first."

### Step 2: Read Original Plan

Read the entire SESSION_PROGRESS.md to understand:
- Original requirements in Plan section
- Dependencies between tasks
- Acceptance criteria for each task
- Context from "Failed Attempts" section

### Step 3: Verify Each Completed Task

For each task marked with `[x]`:

**Check actual completion:**
- Read files mentioned in task
- Run tests if applicable
- Validate output/behavior
- Confirm code exists and works

**Confirm requirements met:**
- Does work match task description?
- Are quality standards satisfied?
- No broken tests or console errors?
- Edge cases handled?

**Evidence collection:**
- Test results (counts, pass/fail)
- File modifications (which files changed)
- Behavior validation (API responses, UI updates)
- Performance metrics if applicable

### Step 4: Verify Dependencies

**Check dependency tree:**
- Tasks marked complete should have dependencies also complete
- No orphaned dependencies (B depends on A, but A not done)
- No circular dependencies
- Proper sequencing maintained

**Validation:**
```markdown
- [x] Phase 1: Setup [dependency: none] ✅
- [x] Phase 2: Implementation [dependency: Phase 1] ✅
- [ ] Phase 3: Testing [dependency: Phase 2] ⚠️ Phase 2 done but Phase 3 pending
```

### Step 5: Check for Scope Gaps

**Requirements coverage:**
- Are there implied requirements not captured as tasks?
- Were tasks completed but not marked `[x]`?
- Did requirements evolve during work?
- Any technical debt introduced?

**Common gaps:**
- Tests written but not run
- Code committed but not deployed
- Documentation updated but not reviewed
- Error handling added but not tested

### Step 6: Generate Report

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

## Verification Checklists

### For Feature Implementation

- [ ] All planned features implemented
- [ ] Tests written and passing
- [ ] Edge cases handled
- [ ] Error handling complete
- [ ] Documentation updated
- [ ] No console errors or warnings
- [ ] Performance acceptable
- [ ] Security vulnerabilities addressed
- [ ] Dependencies properly managed
- [ ] Code reviewed (if applicable)

### For Bug Fixes

- [ ] Bug reproducible before fix
- [ ] Root cause identified
- [ ] Fix implemented and tested
- [ ] Bug no longer reproducible
- [ ] No regressions introduced
- [ ] Related edge cases checked
- [ ] Tests added to prevent recurrence
- [ ] Documentation updated if needed

### For Refactoring

- [ ] Original functionality preserved
- [ ] All tests still passing
- [ ] No behavior changes
- [ ] Code quality improved
- [ ] Technical debt reduced
- [ ] Performance maintained or improved
- [ ] No new bugs introduced
- [ ] Documentation reflects new structure

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
- [x] Phase 2: API integration [missing API key]
- [x] Phase 3: Frontend using API [fails due to Phase 2 issue]
```

**Report:**
```markdown
❌ BLOCKING: Phase 3 depends on Phase 2, but Phase 2 API not configured
📋 Complete Phase 2 configuration before Phase 3 can be verified
```

## Troubleshooting Verification

### Problem: Too Many Tasks to Verify

**Solution:**
- Verify incrementally after each major phase
- Don't wait until end to verify everything
- Archive verified phases to reduce scope
- Focus on critical path first

### Problem: Unclear What "Done" Means

**Solution:**
- Define acceptance criteria in task description
- Include "Definition of Done" in Plan section
- Specify test requirements
- Document expected behavior

### Problem: Verification Takes Too Long

**Solution:**
- Automate verification where possible (test suites, linters)
- Create verification scripts
- Use CI/CD for continuous verification
- Sample test critical paths, not everything

### Problem: Work Verified But User Unhappy

**Solution:**
- Verify against user requirements, not assumptions
- Confirm acceptance criteria with user before starting
- Include user testing in verification
- Document any deviations from original plan

## Best Practices

1. **Verify early and often** - Don't wait until the end
2. **Collect evidence** - Document what you checked and how
3. **Be specific** - "Tests pass (23/23)" vs. "tests work"
4. **Separate critical from nice-to-have** - Use ⚠️ vs. ❌ appropriately
5. **Provide actionable next steps** - Tell what to do, not just what's wrong
6. **Test edge cases** - Don't just verify happy path
7. **Check dependencies** - Ensure prerequisite work is solid
8. **Run actual tests** - Don't assume code works without running it
9. **Validate against requirements** - Check original plan, not current state
10. **Document deviations** - Note any changes from original plan

## Integration with Development Workflow

**After each phase:**
```bash
# Complete phase work
[make changes]

# Update session
/track-session

# Verify phase before moving on
/track-session verify
```

**Before final delivery:**
```bash
# All tasks appear complete
/track-session verify

# Fix any blocking issues
[make fixes]

# Re-verify
/track-session verify

# When clean, deliver
```

**During code review:**
```bash
# Reviewer runs verification
/track-session verify

# Checks verification report
# Confirms evidence provided
# Validates requirements met
```

## References

- Main skill: [track-session SKILL.md](../SKILL.md)
- Related: Systematic debugging, TDD, code review workflows
