---
name: rate-skill
description: Grades a SKILL.md A-F with prioritized, paste-ready fixes. Use whenever the user asks to "rate this skill", "grade this skill", "audit my SKILL.md", or "score this skill". Do NOT use for code review or for new skills (see generate-skill).
license: MIT
argument-hint: <path/to/SKILL.md>
allowed-tools: Read, Glob, Grep
metadata:
  author: Antonin Januska
  version: "3.1.1"
---

# Rate Skill

Audits a single `SKILL.md` against current activation-driven authoring practice and returns a letter grade, weighted category scores, prioritized findings with concrete patches, named strengths, and a projected grade after fixes.

The rubric is anchored to (a) the agentskills.io / Claude Code frontmatter spec, (b) Anthropic's `skill-creator` guidance, and (c) Seleznov's activation study (n=650, p<0.0001) showing directive third-person descriptions carry ~20× higher activation odds (CMH OR 20.6) than passive prose.

## Workflow

1. Resolve the input path. If the user passes a directory, look for `SKILL.md` inside it. If nothing is passed, ask once: "Which SKILL.md should I rate?"
2. Read the whole file. Parse frontmatter and body separately. Count body lines (exclude frontmatter).
3. Detect the skill type — **methodology** (phases + checklists), **reference** (schemas + tables), **generator** (produces an artifact), or **auditor** (reviews an artifact). State it in the report.
4. Score each category 0–100 against the rubric below, weight, sum, map to a letter.
5. Emit the report in the shape under **Output Format**.
6. Estimate the post-fix grade assuming the P0 and P1 findings are applied.

## Rubric (weights sum to 100)

| # | Category | Weight |
|---|---|---|
| 1 | Description quality | 25 |
| 2 | Frontmatter validity | 20 |
| 3 | Length & progressive disclosure | 15 |
| 4 | Structure fit for type | 15 |
| 5 | Examples | 10 |
| 6 | Conciseness / token economy | 10 |
| 7 | Anti-pattern avoidance | 5 |

Letter mapping: A 90–100, B 80–89, C 70–79, D 60–69, F <60.

### 1. Description quality (25)

Full marks require all five:

- Third person ("Skill X does Y…" or "Use this skill whenever…"). First-person ("I'll help you…") caps the score at 40.
- Directive register — Anthropic's middle-ground "Use this skill whenever the user wants to…" or a stronger "ALWAYS invoke when…". Passive bare "Use when X" caps at 70.
- Distinctive trigger token in the first ~50 chars (listing-budget truncation kicks in past ~15–25 installed skills).
- ≥3 concrete user-language triggers, either quoted phrases or an enumerated verb list.
- Negative scoping ("Do NOT use this skill for…") when adjacent skills exist. Required only for collision-prone domains.

Length scoring:

- ≤230 chars: full marks (soft target — listing-budget safe).
- 231–500 chars: no penalty, but note "above soft target" in the report.
- 501–1024 chars: −15 (over soft target, eats listing budget at high skill counts).
- >1024 chars: cap at 50 (spec hard cap violation per agentskills.io).
- Multiline `description:` (YAML `|` or `>` block scalar): **automatic 0**. Silently breaks discovery (anthropics/skills #9817).

Other hard penalties:

- Vague triggers ("helps with documents", "use for tasks"): cap at 50.

### 2. Frontmatter validity (20)

Accepted top-level fields: `name`, `description`, `license`, `compatibility`, `when_to_use`, `argument-hint`, `arguments`, `disable-model-invocation`, `user-invocable`, `model`, `effort`, `agent`, `hooks`, `paths`, `shell`, `allowed-tools`, `metadata`.

Deduct 15 per occurrence:

- Top-level `version`, `author`, or `tags` (belong inside `metadata`).
- `category` (not a real field).
- `argument-hint` nested under `metadata` (must be top-level).
- `name` with uppercase, consecutive hyphens, or reserved words (`anthropic`, `claude`).

### 3. Length & progressive disclosure (15)

- Body ≤300 lines: full marks.
- 301–500 lines: −20 per 50 lines over 300.
- >500 lines without a `references/` directory: cap at 40.
- Singular `reference/` instead of plural `references/`: style note only, no deduction (plural is the spec-documented name, but nothing validates directory names — prefer plural for new dirs, don't force renames).
- References nested more than one level deep from `SKILL.md`: −15 (Claude head -100s files and misses content).

### 4. Structure fit for type (15)

Expected sections by detected type:

- **Methodology**: Overview, Workflow/Phases, Quality Signals or Anti-Patterns, Examples, Verification Checklist.
- **Reference**: Overview, Quick Reference table, Detailed sections, Gotchas.
- **Generator**: Workflow, Inputs, Output Format, Examples.
- **Auditor**: Workflow, Rubric, Output Format, Examples.

Missing a section the detected type needs: −20 each. Penalize an `## Integration` section that contains nothing concrete (rare in surveyed top skills).

### 5. Examples (10)

- ≥1 concrete pair (desired vs. anti-pattern): baseline 70.
- Desired shown FIRST (and ideally last too — recency bias): +15.
- ✅/❌ emoji or prose `## Anti-Pattern:` headers: +15.
- Non-canonical `<Good>`/`<Bad>` XML tags: −10 (zero of 8 surveyed top skills use them).
- All examples abstract / no concrete code: cap at 40.

### 6. Conciseness (10)

Penalize: paragraphs restating general programming knowledge; "why this matters" prose longer than the rule it precedes; verbose intros before the workflow; inconsistent terminology (e.g., swapping "skill" / "command" for the same thing).

### 7. Anti-pattern avoidance (5)

Deduct 20 per occurrence:

- ALL-CAPS "IRON LAW" framing without reasoning (Anthropic `skill-creator` calls this a yellow flag).
- Mega-skill scope bundling unrelated jobs ("one skill, one job").
- Extraneous docs in the skill dir (`README.md`, `INSTALLATION.md`, `QUICK_REFERENCE.md`, `CHANGELOG.md`).
- Windows-style backslash paths.
- Voodoo constants — magic numbers with no documented rationale.
- Time-bound notes that will rot (`"if before August 2025…"`) without being scoped to an "old patterns" section.

## Output Format

```
# Skill Rating: <skill-name>

**Detected type:** <methodology | reference | generator | auditor>
**Overall grade:** <letter> (<weighted score>/100)

## Category scores

| Category | Score | Weight | Weighted |
|---|---|---|---|
| Description quality | nn | 25 | nn.n |
| Frontmatter validity | nn | 20 | nn.n |
| Length & disclosure  | nn | 15 | nn.n |
| Structure            | nn | 15 | nn.n |
| Examples             | nn | 10 | nn.n |
| Conciseness          | nn | 10 | nn.n |
| Anti-pattern avoid.  | nn |  5 | nn.n |

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

Worked examples — directive-description rewrite, frontmatter cleanup, and a desired report opener: **[references/EXAMPLES.md](./references/EXAMPLES.md)**.

## Gotchas

- **Multiline `description:` is a silent killer.** A `|` block scalar parses fine but discovery never sees it (anthropics/skills #9817). Always flag as P0 — automatic 0 on Category 1.
- **The 250-char display cap is gone (Claude Code v2.1.105+).** Listing-budget truncation is not. `skillListingBudgetFraction` defaults to ~1% of context — past ~15–25 installed skills, descriptions get silently dropped. Soft target ≤230; no penalty up to 500.
- **`tags` does nothing functionally at top level.** No discovery system consumes it. If found at top level, demote to `metadata.tags` rather than deleting — preserves user intent.
- **First-person POV breaks activation.** "I'll help you…" empirically under-activates even with identical body. Cap Category 1 at 40 on detection.
- **`<Good>`/`<Bad>` XML tags are a SkillBox-only convention.** Zero of 8 surveyed Anthropic/Vercel/Superpowers skills use them. Recommend ✅/❌ or prose `## Anti-Pattern:` headers.
- **Singular `reference/` vs plural `references/`.** The spec and `skill-creator` document plural, but no validator checks directory names and Anthropic's own examples are inconsistent. Style note only — recommend plural for new dirs, never a rename finding.
- **Claude Code extension keys vs the packaging validator.** `argument-hint`, `hooks`, `paths`, `when_to_use` are valid Claude Code runtime keys but are rejected by Anthropic's repo packaging validator (`quick_validate.py`) and absent from the universal spec. Don't penalize them — note the portability caveat only if the skill targets submission to anthropics/skills.
- **ALL-CAPS "IRON LAW" framing has no empirical support.** Anthropic `skill-creator` calls it a yellow flag: "if possible, reframe and explain the reasoning." Recommend "Quality Signals" + "Anti-Patterns".
- **Negation is poorly handled by LLMs** (arXiv 2503.22395). When you see a bare "DO NOT X" inside the body, recommend pairing with a positive directive — "Do Y instead of X."
- **Standards are calibrated for activation reliability, not curve-grading.** B grade is "production ready" — not a near-failure. Anchor every category to the rubric, not "most skills are worse than this one."
- **Eval-set bonus.** Anthropic's `skill-creator` (May 2026 update) ships a 60/40 train/test description optimizer. If the rated skill ships its own eval set under `eval/` or `references/EVAL.md`, add +5 to Category 1 (cap 100). Cite: https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills

## References

- agentskills.io spec: https://agentskills.io/specification
- Claude Code skills docs: https://code.claude.com/docs/en/skills
- Anthropic skill-creator: https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- Description activation study (Seleznov n=650): https://medium.com/@ivan.seleznov1/why-claude-code-skills-dont-activate-and-how-to-fix-it-86f679409af1
- Skill listing budget: https://claudefa.st/blog/guide/mechanics/skill-listing-budget
- anthropics/skills #9817 (multiline description bug): https://github.com/anthropics/claude-code/issues/9817
