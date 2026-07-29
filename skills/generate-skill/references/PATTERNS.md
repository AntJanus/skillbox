# Skill Body Templates

Load during Phase 4, after the type is chosen. The section lists live in SKILL.md's Phase 4 table — this file adds the *shape* each type needs beyond its section names, and is not a second copy of the spec.

## Calibrating control

Match specificity to **fragility, per section** — not per skill (agentskills.io best-practices):

- **Give the agent freedom** where multiple approaches are valid and the task tolerates variation. State the goal and constraints, not the steps.
- **Be prescriptive** where operations are fragile, consistency matters, or a specific sequence must hold. "Run exactly this sequence…" is legitimate there.
- **Explain the why either way** — "Do X because Y tends to cause Z" outperforms a bare mandate, and an agent that understands the purpose makes better context-dependent calls.

The instructions to *omit* from every template — self-re-check steps, reasoning-echo, don't-think rules, uncapped delegation, unbounded deliverables and scope — are listed under Phase 4's "Agentic calibration" in SKILL.md. They apply to all five templates below.

---

## methodology — workflow enforcement

**Use when:** the skill enforces a multi-step process — code review, a debugging protocol, quality gates, session tracking.

````markdown
# Skill Title

## Overview
[Core principle, one or two sentences.]

## Core principles
- [Principle with the reasoning behind it]

## Workflow

### Phase 1: [Step Name]
**Before proceeding:**
- [ ] [Condition checkable against external state]

[Instructions for this phase.]

### Phase 2: [Step Name]

## Examples
[✅ desired / ❌ counter-example pairs — see Phase 5]

## Anti-patterns
- ❌ [Shortcut authors are tempted by] — [why it backfires]
  ✅ [What to do instead]

## Gotchas
- **Symptom:** [observable failure]. **Cause:** [root cause]. **Fix:** [action].
````

- Phase boundaries carry checkboxes, and each one gates on **external state** — a test run, a file that exists, a command that exits 0. Never on the agent re-reading its own output; there is no closing verification section.
- Every ❌ pairs with a ✅ alternative — negation handling in LLMs is empirically weak.
- Explained reasoning in place of all-caps mandates.

---

## technical — tool / API implementation

**Use when:** project setup, build automation, deployment, wrapping a file format or API.

````markdown
# Skill Title

## Overview
[What it does and the stack, one or two sentences.]

## Quick Start
### Step 1: Setup
```bash
command-here
```
### Step 2: Configure
### Step 3: Execute

## How It Works
[The non-obvious mechanics an agent can't infer.]

## Quick Reference
| Option | Effect | Default |
|--------|--------|---------|

## Examples
## Gotchas
## Troubleshooting
**Problem:** [Issue] · **Solution:** [Fix]
````

- Quick Start is one minimal runnable path, shown before any options.
- Configuration surface goes in a table, not prose.
- Long API surface moves to `references/API.md`; SKILL.md keeps the common 80%.
- Gotchas capture version floors, environment traps and silent failure modes — the things that cost an hour.

---

## auditing — rule-based grading

**Use when:** grading code quality, performance, accessibility, or any artifact.

````markdown
# Skill Title

## Overview
[What gets audited and what the output is.]

## Rubric
| Signal | Weight | Check |
|--------|--------|-------|

## Workflow
1. Read the specified files
2. Check against the rubric
3. Output findings in priority order

## Output Format
```
CRITICAL: [description] (file.js:123)
- Impact: [explanation]
- Fix: [solution]
```

## Examples
## Gotchas
````

- Weights make grades reproducible rather than vibes, and every weight names how to measure it.
- The output format is a literal template — agents pattern-match a concrete structure better than a prose description of one.
- Paired high- and low-quality artifacts anchor the rubric; without them the scale drifts toward "better than the last one I saw."
- Severity ordered most-severe first, and the template bounds its own length.

---

## reference — domain knowledge router

**Use when:** library usage, architecture patterns, schemas, conventions, lookup tables.

````markdown
# Skill Title

## Overview
[When to reach for this knowledge.]

## Navigation
| Topic | Load When | File |
|-------|-----------|------|
| [Domain] | [trigger situation] | [references/domain.md](references/domain.md) |

## Core Concepts
[Only what's needed to pick the right file — keep short.]

## Examples
## Gotchas
````

- SKILL.md stays a router; the data lives in one `references/<domain>.md` per domain.
- Every reference file gets a "load when…" pointer so the agent knows what's inside without opening it.
- Files exactly one level deep — deeper nesting gets truncated by preview reads.
- Core Concepts covers navigation only, never a tutorial.

---

## automation — script / command wrapper

**Use when:** browser testing, screenshots, recordings, API integration, CI/CD helpers.

````markdown
# Skill Title

## Overview
[What the automation does, end to end.]

## Command Surface
| Command | Purpose |
|---------|---------|

## Sample Invocation
```bash
command --input file --output result
```

## Workflow
1. Auto-detect environment
2. Generate configuration
3. Execute
4. Present results

## Failure Modes
## Gotchas
## Troubleshooting
````

- Environment and tool detection runs before execution, so the skill fails with a diagnosis instead of a stack trace.
- The script lives in `scripts/`; SKILL.md documents the surface, not the implementation.
- Failure modes carry recovery steps — the happy path alone is the common gap.
- Pre-built invocations for the common tasks beat a flag reference.

---

## Combining types

| Combination | Use case |
|---|---|
| methodology + automation | Enforced workflow with helper scripts |
| technical + reference | Tool setup plus domain knowledge files |
| auditing + automation | Automated grading with tool integration |
| methodology + auditing | Process enforcement with rule-based checks |

Choose a **primary type** for the overall structure and borrow specific sections from the secondary. Don't merge two full templates — that is how a skill ends up bundling unrelated jobs.
