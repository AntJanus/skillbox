# Skill Body Templates

Full body templates for the five skill types used in the generate-skill workflow (Phase 4). Use the type chosen in Phase 1; each template below expands the compact summary in SKILL.md into a complete skeleton.

## Template Selection Guide

| Type | Use When | Enforcement | Key Sections |
|------|----------|-------------|--------------|
| methodology | Enforces a multi-step workflow (code review, TDD, session tracking) | Phased workflow + verification checklist | Phased Workflow, Examples, Gotchas, Verification |
| technical | Wraps an API, format, or tool (docx, semantic-release, build setup) | Step-by-step guidance | Quick Start, How It Works, Quick Reference, Gotchas |
| auditing | Grades or inspects an artifact (rate-skill, security review) | Rule-based checking | Scoring Rubric, Output Format, Examples, Gotchas |
| reference | Domain schemas, conventions, lookup tables (bigquery, style guides) | Information on demand | Overview + navigation, per-domain references/ files |
| automation | Wraps a script or external command (screenshots, recordings) | Workflow automation | Command Surface, Sample Invocation, Failure Modes, Gotchas |

---

## methodology — Workflow Enforcement

**Use when:** the skill enforces a multi-step process — code review, debugging protocol, quality gates, session tracking.

**Structure:**

````markdown
# Skill Title

## Overview
[Core principle statement — one or two sentences.]

## Core principles
- [Principle 1 with the reasoning behind it]
- [Principle 2]

## Workflow

### Phase 1: [Step Name]
**Before proceeding:**
- [ ] Requirement 1
- [ ] Requirement 2

[Instructions for this phase.]

### Phase 2: [Step Name]
[...]

## Examples

### Example: [one-line task]

✅ Desired

[short code or transcript]

Why it works: [one sentence].

### Counter-example

❌ Anti-pattern

[short code or transcript]

Why it fails: [one sentence].

## Anti-patterns
- ❌ [Shortcut authors are tempted by] — [why it backfires]
  ✅ [What to do instead]

## Gotchas
- **Symptom:** [observable failure]. **Cause:** [root cause]. **Fix:** [action].

## Verification Checklist
- [ ] Requirement 1
- [ ] Requirement 2
````

**Key characteristics:**
- Phase-based workflow with checkboxes at phase boundaries
- Every ❌ anti-pattern paired with a ✅ alternative (negation handling in LLMs is empirically weak)
- Explained reasoning instead of all-caps mandates — state *why* a rule exists
- Verification checklist at the end so completion is measurable

---

## technical — Tool/API Implementation

**Use when:** project setup, build automation, deployment, wrapping a file format or API.

**Structure:**

````markdown
# Skill Title

## Overview
[What it does and the tech stack — one or two sentences.]

## Quick Start

### Step 1: Setup
```bash
command-here
```

### Step 2: Configure
[Instructions]

### Step 3: Execute
```bash
command-here
```

## How It Works
[The non-obvious mechanics an agent can't infer.]

## Quick Reference
| Option | Effect | Default |
|--------|--------|---------|

## Examples

✅ Desired

[minimal working invocation]

❌ Anti-pattern

[common misconfiguration]

## Gotchas
- **Symptom:** [failure]. **Cause:** [cause]. **Fix:** [action].

## Troubleshooting
**Problem:** [Issue]
**Solution:** [Fix]
````

**Key characteristics:**
- Quick Start with one minimal, runnable path before any options
- Quick-reference tables for configuration surface
- Long API surface moves to `references/API.md` — SKILL.md keeps only the common 80%
- Gotchas capture version floors, environment traps, and silent failure modes

---

## auditing — Rule-Based Grading

**Use when:** code quality, performance, accessibility, or artifact grading.

**Structure:**

````markdown
# Skill Title

## Overview
[What gets audited and what the output is.]

## Scoring Rubric

| Signal | Weight | Check |
|--------|--------|-------|
| [Signal 1] | 25 | [How to measure it] |

## How It Works
1. Read specified files
2. Check against the rubric
3. Output findings in priority order

## Output Format
```
CRITICAL: Issue description (file.js:123)
- Impact: [explanation]
- Fix: [solution]
```

## Examples

✅ High-quality artifact

[what a passing artifact looks like, briefly]

❌ Low-quality artifact

[what a failing artifact looks like, briefly]

## Gotchas
- **Symptom:** [scoring edge case]. **Cause:** [cause]. **Fix:** [action].
````

**Key characteristics:**
- Explicit rubric with weights — grades are reproducible, not vibes
- Standardized output format with severity, impact, and fix per finding
- Paired examples of high- and low-quality artifacts anchor the rubric
- Severity levels (CRITICAL/HIGH/MEDIUM/LOW) ordered most-severe first

---

## reference — Domain Knowledge Router

**Use when:** library usage, architecture patterns, schemas, conventions, lookup tables.

**Structure:**

````markdown
# Skill Title

## Overview
[When to reach for this knowledge — one or two sentences.]

## Navigation

| Topic | Load When | File |
|-------|-----------|------|
| [Domain 1] | [trigger situation] | [references/domain-1.md](references/domain-1.md) |
| [Domain 2] | [trigger situation] | [references/domain-2.md](references/domain-2.md) |

## Core Concepts
[Only the ideas needed to pick the right reference file — keep short.]

## Examples

✅ Desired

[correct application of the domain knowledge]

❌ Anti-pattern

[common misapplication]

## Gotchas
- **Symptom:** [misuse]. **Cause:** [cause]. **Fix:** [action].
````

**Key characteristics:**
- SKILL.md stays a router — the data lives in one `references/<domain>.md` per domain
- Every reference file gets a "load when…" pointer so the agent knows what's inside without opening it
- Reference files exactly one level deep — deeper nesting gets truncated by preview reads
- Core Concepts covers only what's needed to navigate, not a tutorial

---

## automation — Script/Command Wrapper

**Use when:** browser testing, screenshots, recordings, API integration, CI/CD helpers.

**Structure:**

````markdown
# Skill Title

## Overview
[What the automation does, end to end.]

## Command Surface

| Command | Purpose |
|---------|---------|
| `command --flag` | [what it does] |

## Sample Invocation
```bash
# The one command that covers the common case
command --input file --output result
```

## Workflow
1. Auto-detect environment
2. Generate configuration
3. Execute with parameters
4. Present results

## Failure Modes

✅ Desired

[healthy run — what success output looks like]

❌ Anti-pattern

[running blind: no detection step, hardcoded paths]

## Gotchas
- **Symptom:** [failure]. **Cause:** [cause]. **Fix:** [action].

## Troubleshooting
[Common issues and recovery steps]
````

**Key characteristics:**
- Auto-detection of environment and tools before execution
- The actual script lives in `scripts/` — SKILL.md documents the surface, not the implementation
- Failure modes documented with recovery steps, not just the happy path
- Pre-built invocations for the common tasks

---

## Combining Types

Some skills benefit from combining elements of multiple templates:

| Combination | Example Use Case |
|-------------|------------------|
| methodology + automation | Enforced workflow with helper scripts |
| technical + reference | Tool setup plus domain knowledge files |
| auditing + automation | Automated grading with tool integration |
| methodology + auditing | Process enforcement with rule-based checks |

When combining, choose a **primary type** for the overall structure and incorporate specific sections from the secondary type.
