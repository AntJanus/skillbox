---
name: rate-skill
description: Use this skill to grade a SKILL.md whenever the user wants to rate, audit, or score one. Triggers include "rate this skill", "grade this skill", "audit my SKILL.md", "score this skill against best practices", or "is this SKILL.md up to spec", even if they don't use the word "rate". Returns a letter grade A-F, weighted category scores, and prioritized paste-ready patches. Do NOT use this skill for code review (see code-review) or for authoring a new skill (see generate-skill).
license: MIT
argument-hint: "<path/to/SKILL.md>"
allowed-tools: Read, Glob, Grep
metadata:
  author: Antonin Januska
  version: "4.0.0"
---

# Rate Skill

## Overview

Audits a single `SKILL.md` against current activation-driven authoring practice and returns a letter grade, weighted category scores, prioritized findings with concrete patches, named strengths, and a projected grade after fixes. Grade against the rubric text below, not memory — every rule's source lives in `## References`.

## Workflow

1. Resolve the input path. If the user passes a directory, look for `SKILL.md` inside it. If nothing is passed, ask once: "Which SKILL.md should I rate?"
2. Read the whole file. Parse frontmatter and body separately. Count body lines (exclude frontmatter) and estimate body tokens (`chars / 4` is close enough).
3. Detect the skill type — the same five `generate-skill` uses, so a generated skill can be graded against the profile it was built from: **methodology** (enforces a multi-step workflow), **technical** (wraps an API, format, or tool), **auditing** (grades or inspects an artifact), **reference** (schemas, conventions, lookup tables), or **automation** (wraps a script or external command). State it in the report.
4. Check for an eval set (`references/EVAL.md` or `evals/evals.json`) and grade it against the **Eval set check** below. Missing eval set is a standing P1 finding.
5. Score each category 0–100 against the rubric below, weight, sum, map to a letter.
6. Emit the report in the shape under **Output Format**.
7. Estimate the post-fix grade assuming the P0 and P1 findings are applied.

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

Letter mapping: A 90–100, B 80–89, C 70–79, D 60–69, F <60.

**Deduction scale.** Magnitudes are anchored so one violation is recoverable and repeated ones are not: −15 (frontmatter) means four errors floor the category; −20 (missing required section, §7 occurrence) means three floor it; −10 marks soft/style issues a skill can absorb several of before dropping a letter overall. Caps (40 / 50 / 70) express "this defect alone determines the ceiling regardless of what else is right."

### 1. Description quality (25)

Full marks require all five:

- Imperative third person, addressed to the agent — official form "Use this skill when…"; the house variant "Use this skill whenever the user wants to…" is equivalent. First-person ("I'll help you…") caps the score at 40.
- Directive register, not passive. Bare "Use when X" caps at 70. Don't reward ALL-CAPS escalation ("ALWAYS invoke when…") as stronger; §7 deducts for that framing, and the directive form already carries the activation benefit.
- Distinctive trigger token in the first ~50 chars (listing-budget truncation kicks in past ~15–25 installed skills; eviction is least-invoked-first).
- ≥3 concrete user-language triggers, either quoted phrases or an enumerated verb list. A coverage clause for indirect asks — "even if they don't explicitly mention X" — is an officially recommended pattern; credit it when present.
- Negative scoping ("Do NOT use this skill for…") when adjacent skills exist. Required only for collision-prone domains.

Length and style:

- Official conciseness guidance is "a few sentences to a short paragraph" — no numeric target. Note verbosity in the report; don't deduct by character count below the cap.
- >1024 chars: cap at 50 (spec hard cap per agentskills.io).
- Vague triggers ("helps with documents", "use for tasks"): cap at 50.
- YAML scalar style (`|`, `>`, single-line) is **not scored** (see Retired rules in references/EXAMPLES.md).

### 2. Frontmatter validity (20)

Accepted top-level fields: `name`, `description`, `license`, `compatibility`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `model`, `effort`, `agent`, `hooks`, `paths`, `shell`, `allowed-tools`, `metadata`.

Deduct 15 per occurrence:

- Top-level `version`, `author`, or `tags` (belong inside `metadata`).
- `category` (not a real field).
- `argument-hint` nested under `metadata` (must be top-level).
- `name` with uppercase, consecutive hyphens, or reserved words (`anthropic`, `claude`).

Deduct 10: `compatibility` over its 500-char spec cap.

### 3. Length & progressive disclosure (15)

- Body ≤300 lines: full marks.
- 301–500 lines: −10 per 50 lines over 300 (so 500 lines floors at 60, not 20).
- \>500 lines: −30 on top of the above, and an **additional** −20 if there's no `references/` directory (crossing the hard cap with no progressive disclosure is the worst case, so it must score *below* every case under it — never a cap that rescues it).
- Body over ~5,000 tokens (≈20k chars): treat as over-cap even when under 500 lines. The official constraint is joint — "under 500 lines **and** 5,000 tokens" — and a dense, code-heavy body can breach tokens while passing the line count.
- Singular `reference/` instead of plural `references/`: style note only, no deduction (plural is the spec-documented name, but nothing validates directory names — prefer plural for new dirs, don't force renames).
- References nested more than one level deep from `SKILL.md`: −15 (Claude head -100s files and misses content).

### 4. Structure fit for type (15)

This table is the **shared section spec**, identical to the one `generate-skill` emits.

| Type | Required sections | Optional |
|---|---|---|
| methodology | Overview, Workflow (phased), Examples, Gotchas | Verification Checklist, Quality Signals / Anti-Patterns |
| technical | Overview, Quick Start / Setup, Quick Reference or API surface, Examples, Gotchas | Troubleshooting |
| auditing | Overview, Workflow, Rubric, Output Format, Examples, Gotchas | — |
| reference | Overview, Navigation (load-when table), Gotchas | Core Concepts |
| automation | Overview, Command Surface, Sample Invocation, Failure Modes, Gotchas | Troubleshooting |

- Missing a required section: −20 each. Gotchas is required for every type — agentskills.io: "the highest-value content in many skills is a list of gotchas."
- An `## Integration` section containing nothing concrete: −10 (rare in surveyed top skills).
- **Instruction-pattern fit:** the six official patterns are gotchas sections, output-format templates, checklists, validation loops, plan-validate-execute, and bundled scripts. Reward *fit*, not presence: −10 for a pattern the skill's job clearly calls for and omits (e.g., a batch-destructive workflow with no plan-validate-execute step), −10 for a pattern bolted on where it doesn't fit.
- A **Verification Checklist** is recommended for *enforcement*-style methodology skills but is **not** required — note its absence, don't deduct.

### 5. Examples (10)

- ≥1 concrete pair (desired vs. anti-pattern): baseline 70.
- Desired shown FIRST (and ideally last too — recency bias): +15.
- ✅/❌ emoji or prose `## Anti-Pattern:` headers: +15.
- Non-canonical `<Good>`/`<Bad>` XML tags: −10 (zero of 8 surveyed top skills use them).
- All examples abstract / no concrete code: cap at 40.

### 6. Conciseness / context economy (10)

Apply the official cut test to every instruction: **"Would the agent get this wrong without this instruction?"** If no, the line is bloat.

Deduct 10 per distinct occurrence, floor 40:

- Paragraphs restating general programming knowledge.
- "Why this matters" prose longer than the rule it precedes.
- A verbose intro before the workflow.
- Inconsistent terminology for the same thing (e.g., swapping "skill" / "command").
- Menus of alternatives where a default should be picked ("provide defaults, not menus").
- Instance-specific outputs prescribed where a procedure would generalize ("favor procedures over declarations").
- Payload duplicated between `SKILL.md` and a `references/` file.

### 7. Anti-patterns & calibration (5)

Deduct 20 per occurrence:

- ALL-CAPS "IRON LAW" framing without reasoning — officially discouraged: "Reasoning-based instructions ('Do X because Y tends to cause Z') work better than rigid directives ('ALWAYS do X, NEVER do Y')" (agentskills.io).
- **Miscalibrated control.** The official rule is "match specificity to fragility": freedom where multiple approaches are valid, prescription where operations are fragile or a sequence must be followed. Deduct for rigid mandates on variation-tolerant tasks *and* for vague hand-waving over fragile operations. Prescription itself is not a defect — calibrate per section.
- **Reasoning-echo instructions** ("show your thinking", "explain your reasoning in the response", "transcribe your analysis"). These can trigger the `reasoning_extraction` refusal category on Claude Fable 5. Always **also** emit a P0 finding — this is a hard failure mode, not a style issue.
- Mega-skill scope bundling unrelated jobs ("one skill, one job"; SkillsBench found focused skills of ≤3 modules outperform larger bundles).
- Extraneous docs in the skill dir (`README.md`, `INSTALLATION.md`, `QUICK_REFERENCE.md`, `CHANGELOG.md`).
- Windows-style backslash paths.
- Voodoo constants — magic numbers with no documented rationale.
- Time-bound notes that will rot (`"if before August 2025…"`) without being scoped to an "old patterns" section.

## Eval set check

Every rated skill should ship an eval set. **Missing → standing P1 finding** (include a starter set in the patch), not a score deduction or bonus.

When present, verify it matches the official loop (agentskills.io optimizing-descriptions):

- ~20 queries: 8–10 should-trigger, 8–10 should-not-trigger (near-neighbor skills make the best should-nots).
- A ~60/40 train/validation split, with a proportional mix of positives and negatives in **both** halves, fixed across iterations.
- A documented measurement protocol: each query run ~3 times in fresh sessions; trigger rate = fraction of runs that invoked the skill; should-trigger passes above the threshold, should-not-trigger passes below it (0.5 is the official default).
- Selection rule stated: pick the description with the best *validation* score — an earlier iteration can beat the last (overfitting).

Grading caveat (official): agents consult skills for tasks beyond what they handle alone — a simple one-step query ("read this PDF") may not trigger a matching skill. A low trigger rate on trivially simple queries is not automatically a description defect.

## Output Format

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
...

### P2 — <title>
...

## Estimated grade after P0+P1: <letter> (<projected score>/100)

<one-line commit-ready summary>
```

Every report includes at least one strength (even on F-tier skills — users abandon purely negative reports). Every finding ships a **concrete patch the user can paste**, not "improve the description".

## Examples

✅ Directive third person, distinctive token front-loaded, enumerated triggers, negative scope:

```yaml
description: Use this skill whenever the user wants to review a React component for hook misuse, infinite-loop risk, or dependency-array bugs. Triggers include "review this component", "check my hooks", or "audit this React file". Do NOT use this skill for general code review.
```

❌ Passive and trigger-free — caps Category 1 at 70:

```yaml
description: Use when reviewing React components for hook issues.
```

Further worked examples — frontmatter cleanup, a full sample report, and retired rules: **[references/EXAMPLES.md](./references/EXAMPLES.md)**.

## Gotchas

- **The listing cap is separate from the spec cap.** Claude Code caps `description` + `when_to_use` at a combined 1,536 chars for the listing (configurable via `skillListingMaxDescChars`); `skillListingBudgetFraction` defaults to ~1% of context. Neither is the 1024-char spec cap in §1.
- **`tags` does nothing functionally at top level.** No discovery system consumes it. Demote to `metadata.tags` rather than deleting — preserves user intent.
- **Claude Code extension keys vs the packaging validator.** `argument-hint`, `hooks`, `paths`, and `when_to_use` are valid Claude Code runtime keys but are rejected by Anthropic's repo packaging validator (`quick_validate.py`) and absent from the universal spec. Don't penalize them — raise the portability caveat only if the skill targets submission to anthropics/skills.
- **Recommend `skills-ref validate <path>`** (agentskills/agentskills) as the structural validator. Do not recommend `npx skills lint` or `npx skills validate` — vercel-labs/skills ships no validation command.
- **Negation is poorly handled by LLMs** (arXiv 2503.22395). When a bare "DO NOT X" appears in a graded skill's body, recommend pairing it with a positive directive — "Do Y instead of X."
- **B is production ready, not a near-failure.** Anchor every category to the rubric text, never to "most skills are worse than this one."

## References

Full source list with URLs: **[references/SOURCES.md](./references/SOURCES.md)** — load only when a user disputes a rule and you need to cite the spec.
