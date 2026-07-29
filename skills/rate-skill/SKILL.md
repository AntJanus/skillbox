---
name: rate-skill
description: Use this skill to grade a SKILL.md whenever the user wants to rate, audit, or score one. Triggers include "rate this skill", "grade this skill", "audit my SKILL.md", "score this skill against best practices", or "is this SKILL.md up to spec", even if they don't use the word "rate". Returns a letter grade A-F, weighted category scores, and prioritized paste-ready patches. Do NOT use this skill for code review (see code-review) or for authoring a new skill (see generate-skill).
license: MIT
argument-hint: "<path/to/SKILL.md>"
allowed-tools: Read, Glob, Grep
metadata:
  author: Antonin Januska
  version: "5.0.0"
---

# Rate Skill

## Overview

Grades one `SKILL.md` and returns a letter, weighted category scores, named strengths, prioritized findings with paste-ready patches, and a projected grade after fixes. Score against the rubric text below, not memory — sources in `references/SOURCES.md`.

## Navigation

| Load | When |
|---|---|
| **[references/EXAMPLES.md](./references/EXAMPLES.md)** | ✅/❌ pairs for descriptions, frontmatter and verification scaffolding; a full sample report; retired rules |
| **[references/SOURCES.md](./references/SOURCES.md)** | A user disputes a rule and you need to cite the spec |

## Workflow

1. Resolve the path. A directory means the `SKILL.md` inside it. Nothing passed — ask once: "Which SKILL.md should I rate?"
2. Read the whole file. Parse frontmatter and body separately; count body lines excluding frontmatter; estimate body tokens as `chars / 4`.
3. Detect the type — the same five `generate-skill` uses, so a generated skill is graded against the profile it was built from. State it in the report.
4. Check for an eval set (`EVAL.md` in `references/` or legacy `reference/`, or `evals/evals.json`) against **Eval set check**. Missing is a standing P1.
5. Score each category 0–100, weight, sum, map to a letter.
6. Emit the report in the **Output Format** shape.
7. Project the grade with P0 and P1 applied.

## Rubric (weights sum to 100)

| # | Category | Weight |
|---|---|---|
| 1 | Description quality | 25 |
| 2 | Frontmatter validity | 20 |
| 3 | Length & progressive disclosure | 15 |
| 4 | Structure fit for type | 15 |
| 5 | Examples | 10 |
| 6 | Conciseness / context economy | 10 |
| 7 | Anti-patterns & calibration | 5 |

A 90–100, B 80–89, C 70–79, D 60–69, F <60. **B is production ready, not a near-failure.**

Magnitudes are anchored so one violation is recoverable and repeated ones aren't: −15 floors a category at four occurrences, −20 at three, −10 marks soft issues a skill can absorb several of. A cap (40/50/70/80) means that defect alone sets the ceiling.

### 1. Description quality (25)

Full marks require all five:

- **Imperative third person addressed to the agent** — official "Use this skill when…"; the house "Use this skill whenever the user wants to…" is equivalent. First person ("I'll help you…") caps at 40.
- **Directive, not passive.** Bare "Use when X" caps at 70. Don't read ALL-CAPS escalation as stronger — §7 deducts for it and the directive form already carries the benefit.
- **Distinctive trigger token in the first ~50 chars**, since listing truncation starts past ~15–25 installed skills.
- **≥3 concrete user-language triggers**, quoted phrases or an enumerated verb list. Credit a coverage clause for indirect asks ("even if they don't explicitly mention X") — officially recommended.
- **Negative scoping** ("Do NOT use this skill for…") when adjacent skills exist. Required only for collision-prone domains.

Caps: >1024 chars → 50 (spec hard cap). Vague triggers ("helps with documents", "use for tasks") → 50. Official sizing is "a few sentences to a short paragraph" — note verbosity, never deduct by character count below the cap. YAML scalar style is **not scored** (see Retired rules).

### 2. Frontmatter validity (20)

Accepted top-level: `name`, `description`, `license`, `compatibility`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `model`, `effort`, `agent`, `hooks`, `paths`, `shell`, `allowed-tools`, `metadata`.

−15 each: top-level `version`/`author`/`tags` (belong in `metadata`); `category` (not a field); `argument-hint` nested under `metadata` (must be top-level); `name` with uppercase, consecutive hyphens, or the reserved words `anthropic`/`claude`. −10: `compatibility` over its 500-char cap.

### 3. Length & progressive disclosure (15)

- ≤300 body lines: full marks. 301–500: −10 per 50 lines over 300, so 500 floors at 60.
- \>500 lines: −30, **plus another −20** with no `references/` dir. Crossing the cap with no disclosure is the worst case and must score *below* every case under it — never a cap that rescues it.
- Over ~5,000 body tokens (≈20k chars): over-cap even under 500 lines. The official constraint is joint, and a dense code-heavy body breaches tokens while passing lines.
- References nested more than one level deep: −15 — Claude `head -100`s files and misses content.
- Singular `reference/` vs plural: style note, no deduction. Plural is spec-documented but nothing validates directory names — prefer it for new dirs, never force a rename.

### 4. Structure fit for type (15)

The **shared section spec**, identical to the one `generate-skill` emits.

| Type | Job | Required sections | Optional |
|---|---|---|---|
| methodology | Enforces a multi-step workflow | Overview, Workflow (phased), Examples, Gotchas | Quality Signals / Anti-Patterns |
| technical | Wraps an API, format, or tool | Overview, Quick Start / Setup, Quick Reference or API surface, Examples, Gotchas | Troubleshooting |
| auditing | Grades or inspects an artifact | Overview, Workflow, Rubric, Output Format, Examples, Gotchas | — |
| reference | Schemas, conventions, lookup tables | Overview, Navigation (load-when table), Gotchas | Core Concepts |
| automation | Wraps a script or external command | Overview, Command Surface, Sample Invocation, Failure Modes, Gotchas | Troubleshooting |

- Missing a required section: −20 each. Gotchas is required for every type — "the highest-value content in many skills is a list of gotchas."
- An `## Integration` section containing nothing concrete: −10.
- **Instruction-pattern fit.** The six official patterns are gotchas, output-format templates, checklists, validation loops, plan-validate-execute, and bundled scripts. Reward *fit*: −10 for one the skill's job clearly calls for and omits (a batch-destructive workflow with no plan-validate-execute step), −10 for one bolted on where it doesn't fit.
- **Written-deliverable length: −10** when the skill's output is a file the agent writes and the template doesn't bound its length. Written deliverables run long by default; the template needs a line like "match length to the task, no filler sections or redundant summaries."
- **`## Verification Checklist` is not a spec section for any type.** Don't deduct its absence, don't credit its presence — judge its *content* under §7. Checklists remain an official pattern; only self-re-check content is penalized.

### 5. Examples (10)

- ≥1 concrete pair (desired vs. anti-pattern): baseline 70. Desired FIRST, ideally last too: +15. ✅/❌ emoji or prose `## Anti-Pattern:` headers: +15.
- **Examples in `references/EXAMPLES.md` behind a pointer count in full.** That is progressive disclosure, not an omission — read the file before scoring this category. §6 penalizes keeping them in both places.
- Fewer than 3, or 3+ all exercising the same situation: cap at 80. Official guidance is 3–5, relevant and diverse enough that the agent doesn't pattern-match an unintended regularity.
- `<Good>`/`<Bad>` XML tags: −10 — zero of 8 surveyed top skills use them. This targets the *labels*; `<example>`/`<examples>` as structural delimiters are officially recommended and score fine.
- All abstract, no concrete code: cap at 40.

### 6. Conciseness / context economy (10)

Apply the official cut test to every instruction: **"Would the agent get this wrong without this?"** If no, it's bloat.

−10 per distinct occurrence, floor 40: paragraphs restating general programming knowledge; "why this matters" prose longer than the rule it precedes; a verbose intro before the workflow; inconsistent terminology for one thing; menus where a default should be picked; instance-specific outputs where a procedure would generalize; payload duplicated between `SKILL.md` and a `references/` file.

### 7. Anti-patterns & calibration (5)

−20 each. The category is weight 5, so the score barely moves — **the finding is the deliverable.** Emit one per occurrence at P1 or higher.

**Authoring**

- ALL-CAPS "IRON LAW" framing without reasoning. Discouraged in both source families: "Do X because Y tends to cause Z" beats rigid directives (agentskills.io), and "dial back any aggressive language… use more normal prompting" (platform.claude.com).
- Mega-skill scope bundling unrelated jobs — one skill, one job; SkillsBench found ≤3-module skills outperform larger bundles.
- Extraneous docs in the skill dir (`README.md`, `INSTALLATION.md`, `QUICK_REFERENCE.md`, `CHANGELOG.md`).
- Windows-style backslash paths; voodoo constants with no documented rationale; time-bound notes that will rot (`"if before August 2025…"`) outside an "old patterns" section.
- **Miscalibrated control.** Match specificity to fragility: freedom where multiple approaches are valid, prescription where operations are fragile or a sequence must hold. Deduct for rigid mandates on variation-tolerant tasks *and* vague hand-waving over fragile ones. Prescription itself is not a defect — calibrate per section.

**Agentic over-prompting** — behavior the model already performs, so restating it compounds and costs tokens with no quality gain.

- **Verification scaffolding**: "include a final verification step for any non-trivial task", "double-check your answer", "re-verify before responding", "use a subagent to verify". The official fix is deletion, not rewording. **Domain verification is not this** — "run the test suite", "confirm the file parses", "validate against the schema" check external state and score fine.
- **Reasoning-echo** ("show your thinking", "explain your reasoning in the response"). Can trigger the `reasoning_extraction` refusal on Claude Fable 5 — always **also** emit a P0. A hard failure mode, not a style issue.
- **"Do not think" / "do not reason"** — increases leakage of internal XML tags into visible output. Delete; a rule naming the tags is less effective than saying nothing.
- **Uncapped delegation** — subagent instructions with no statement of which scenarios warrant one or how many. Open-ended delegation multiplies cost on small tasks.
- **Unbounded scope on a narrow job** — models add steps that weren't requested, so a one-job skill should say where it stops.

## Eval set check

Every rated skill should ship one. **Missing → standing P1** (include a starter set in the patch), never a deduction or bonus. When present, verify against the official loop:

- ~20 queries, 8–10 each direction. Near-neighbor skills make the best should-nots.
- ~60/40 train/validation, proportional mix in **both** halves, fixed across iterations.
- A stated protocol: each query run ~3 times in fresh sessions; trigger rate = fraction of runs that invoked the skill; should-trigger passes above the threshold, should-not below (0.5 default).
- A stated selection rule: best *validation* score wins — an earlier iteration can beat the last.

Caveat (official): agents consult skills for tasks beyond what they handle alone, so a low trigger rate on a trivially simple query ("read this PDF") is not automatically a description defect.

## Output Format

Match report length to what the skill needs — findings carry the value, so no filler sections and no closing summary of what the report just said.

```
# Skill Rating: <skill-name>

**Detected type:** <methodology | technical | auditing | reference | automation>
**Overall grade:** <letter> (<weighted score>/100)
**Eval set:** <present + conforms | present, gaps: … | missing (P1)>

## Category scores

| Category | Score | Weight | Weighted |
|---|---|---|---|
| Description quality | nn | 25 | nn.n |
| Frontmatter validity | nn | 20 | nn.n |
| Length & disclosure  | nn | 15 | nn.n |
| Structure            | nn | 15 | nn.n |
| Examples             | nn | 10 | nn.n |
| Conciseness          | nn | 10 | nn.n |
| Anti-patterns/calib. | nn |  5 | nn.n |

## Strengths
- <concrete bullet — what the skill does well>

## Findings (prioritized)

### P0 — <title>
**Why:** <one-line rationale, cite category>
**Fix:**
\`\`\`<lang>
<concrete replacement text, not a description of one>
\`\`\`

### P1 — <title>
### P2 — <title>

## Estimated grade after P0+P1: <letter> (<projected score>/100)

<one-line commit-ready summary>
```

Every report names at least one strength, even on F-tier skills — users abandon purely negative reports. Every finding ships a **patch the user can paste**, never "improve the description".

## Examples

✅/❌ pairs for description quality, frontmatter cleanup, and domain verification vs. self-re-check scaffolding, plus a full sample report and the retired rules: **[references/EXAMPLES.md](./references/EXAMPLES.md)**.

## Gotchas

- **The two source families disagree on description intensity.** agentskills.io says "err on the side of being pushy"; platform.claude.com says models "may now overtrigger" on skills and to "dial back any aggressive language." They reconcile as coverage vs. intensity — more triggers and a coverage clause raise recall, ALL-CAPS raises nothing. Grade coverage up, intensity down.
- **The listing cap is separate from the spec cap.** Claude Code caps `description` + `when_to_use` at a combined 1,536 chars for the listing (`skillListingMaxDescChars`), and `skillListingBudgetFraction` defaults to ~1% of context. Neither is the 1024-char spec cap in §1.
- **`tags` does nothing at top level** — no discovery system consumes it. Demote to `metadata.tags` rather than deleting; that preserves user intent.
- **Extension keys are valid, just not portable.** `argument-hint`, `hooks`, `paths`, `when_to_use` run fine in Claude Code but are rejected by Anthropic's packaging validator (`quick_validate.py`) and absent from the universal spec. Don't penalize — raise the caveat only if the skill targets anthropics/skills.
- **Recommend `skills-ref validate <path>`** as the structural validator. Never `npx skills lint` or `npx skills validate` — vercel-labs/skills ships no validation command.
- **Negation is poorly handled.** Official: "Tell Claude what to do instead of what not to do," corroborated by arXiv 2503.22395. When a bare "DO NOT X" appears in a graded body, recommend pairing it with "Do Y instead."
