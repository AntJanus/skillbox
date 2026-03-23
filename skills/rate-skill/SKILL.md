---
name: rate-skill
description: |
  Evaluate skill quality against best practices. Use when asked to "rate this skill",
  "review skill quality", "check skill formatting", "is this skill good", "evaluate SKILL.md",
  "grade this skill", or when validating skill files before publishing.
license: MIT
argument-hint: "<path/to/SKILL.md>"
allowed-tools: Read, Glob, Grep
metadata:
  author: Antonin Januska
  version: "2.0.0"
---
# Rate Skill

## Overview

Audit SKILL.md files against quality standards from generate-skill best practices. Provides letter grade (A-F) and actionable recommendations.

**Core principle:** Measure skill quality objectively to improve activation reliability and context efficiency.

## When to Use

**Always use when:**
- Reviewing skills before publishing
- Validating skill structure and formatting
- Checking if skill meets quality standards
- User asks to "rate", "grade", or "review" a skill

**Useful for:**
- Skill authors validating their work
- Maintainers reviewing PRs with new skills
- Quality audits of skill repositories
- Before submitting skills to marketplaces

**Avoid when:**
- Evaluating non-skill documentation
- Reviewing code (not skill definitions)
- General code quality auditing

## How It Works

1. Read specified SKILL.md file
2. Detect skill type (methodology / technical / auditing / reference)
3. Evaluate against quality criteria
4. Validate frontmatter against spec (universal vs Claude Code extensions)
5. Calculate scores per category
6. Generate letter grade (A-F)
7. Output findings with positive framing and concrete fixes

## Quality Criteria

| Category | Weight | Strong Signals (A-grade) |
|----------|--------|--------------------------|
| **Length** | 20% | Under 500 lines, or progressive disclosure with well-structured reference/ |
| **Conciseness** | 20% | High info density, scannable, short paragraphs, no redundancy, imperative language |
| **Structure** | 15% | All required sections present and ordered, bonus for "When NOT to Use" and "Quality Signals" |
| **Triggers** | 15% | 5+ natural-language phrases, "when asked to X" format, multiple contexts covered |
| **Frontmatter** | 15% | All required fields valid, name matches directory, semver version, spec-compliant placement |
| **Examples** | 10% | 3+ Good/Bad comparisons, `<Good>` shown first, explanations after each, real scenarios |
| **Type Compliance** | 5% | Skill type correctly identified, type-specific patterns present |

### Length (20%)

**Strong signals:** Under 500 lines with all essential content. Progressive disclosure used well — SKILL.md stays focused, reference/ holds deep details with clear links.

**Scores:** A: <500 or progressive disclosure | B: 500-600 | C: 600-800 | D: 800-1000 | F: >1000

**Watch for:** Monolithic files without reference/ splits, empty reference/ dirs that don't reduce SKILL.md length

### Conciseness (20%)

**Strong signals:** Short paragraphs (2-3 sentences), each sentence adds unique information, imperative direct language, bullet points over prose, scannable at a glance.

**Scores:** A: High info density, scannable | B: Mostly concise | C: Some wordiness | D: Verbose | F: Excessive

**Watch for:** Paragraphs over 5 sentences, repeated concepts across sections, flowery or hedging language

### Structure (15%)

**Strong signals:** All required sections present and logically ordered. Includes "When NOT to Use" for clarity. Methodology skills have verification checklists. "Quality Signals" section present where applicable.

**Required sections:** Frontmatter, Overview, When to Use, Main content, Examples (Good/Bad), Troubleshooting, Integration

**Scores:** A: All required + bonus sections | B: All required, missing 1 optional | C: Missing 2-3 optional | D: Missing required sections | F: Severely lacking

**Watch for:** Missing "When to Use", examples without Good/Bad comparisons, no troubleshooting section

### Triggers (15%)

**Strong signals:** 5+ specific phrases in description field, "when asked to X" format, covers multiple user contexts, uses natural language users actually type.

**Scores:** A: 5+ specific | B: 3-4 good | C: 2 phrases | D: 1 vague | F: None

**Watch for:** Generic triggers ("helps with X"), duplicate phrases, missing user-language variations

### Frontmatter (15%)

**Strong signals:** All required fields present and valid. `name` matches directory name. Version follows semver. `argument-hint` at top level (not nested under metadata). Description is trigger-rich.

**Required universal fields (agentskills.io spec):** `name`, `description`, `license`, `metadata` (with `author`, `version`)

**Optional Claude Code extensions:** `argument-hint`, `allowed-tools`, `context`, `agent`, `model`, `effort`, `mode`, `user-invocable`

**Non-functional fields (flag if present):** `tags` (no discovery system consumes it), `hooks` (belongs in `.claude/hooks.json`)

**Scores:** A: All fields valid + spec-compliant | B: Minor placement issues | C: Missing optional fields | D: Missing required fields | F: Invalid or absent frontmatter

**Watch for:** `argument-hint` nested under `metadata` (Claude Code won't parse it), `tags` field adding no value, missing `name` or `version`

### Examples (10%)

**Strong signals:** 3+ Good/Bad comparisons using `<Good>` and `<Bad>` tags. `<Good>` shown first (LLMs anchor on first example). Each pair has explanation. Real-world scenarios, not toy examples.

**Scores:** A: 3+ with Good/Bad, Good first | B: 2 with comparisons | C: 1 comparison | D: No comparisons | F: None

**Watch for:** `<Bad>` shown before `<Good>`, examples without explanation, abstract/toy scenarios

### Type Compliance (5%)

**Skill types and their required patterns:**

| Type | Identifying signals | Required patterns |
|------|-------------------|-------------------|
| **Methodology** | Phases, workflows, process steps | Verification checklist, phase gates |
| **Technical** | Commands, tools, configuration | Command examples, setup instructions |
| **Auditing** | Evaluation, scoring, review | Output format, scoring criteria |
| **Reference** | Lookup, standards, conventions | Organized lookup structure, cross-references |

**Scores:** A: Type clear, all type patterns present | B: Type clear, minor pattern gap | C: Type ambiguous | D: Wrong patterns for type | F: No discernible type

**Watch for:** Methodology skills without verification checklists, auditing skills without defined output format

## Output Format

```markdown
# Skill Rating: [Letter Grade]

## Summary
- **File:** path/to/SKILL.md
- **Lines:** XXX lines
- **Detected Type:** [Methodology / Technical / Auditing / Reference]
- **Overall Grade:** [A/B/C/D/F] ([Score]/100)
- **Status:** [Production Ready / Needs Work / Not Ready]
- **Spec Compliance:** [Universal (portable) / Claude Code-only fields present]

## Category Scores

| Category | Score | Grade | Status |
|----------|-------|-------|--------|
| Length | XX/20 | [A-F] | [Pass/Warning/Fail] |
| Conciseness | XX/20 | [A-F] | [Pass/Warning/Fail] |
| Structure | XX/15 | [A-F] | [Pass/Warning/Fail] |
| Triggers | XX/15 | [A-F] | [Pass/Warning/Fail] |
| Frontmatter | XX/15 | [A-F] | [Pass/Warning/Fail] |
| Examples | XX/10 | [A-F] | [Pass/Warning/Fail] |
| Type Compliance | XX/5 | [A-F] | [Pass/Warning/Fail] |

## Findings by Priority

### Highest Impact Improvements
1. **[Category: Issue description]**
   - Impact: [Why this matters]
   - Fix: [Specific action with code example]
     ```yaml
     # concrete example of the fix
     ```

### Recommended Improvements
1. **[Issue description]**
   - Impact: [Why this matters]
   - Fix: [Specific action to take]

### Nice to Have
1. [Suggestion]
   - Benefit: [Why this helps]

## Strengths
- [What this skill does well]
- [Another strength]

## Priority Action Items
1. [Priority 1 action]
2. [Priority 2 action]
3. [Priority 3 action]

## Estimated Improvements
- Fix highest impact: +[X] points
- Address recommended: +[X] points
- Potential grade: [Current] -> [Target]
```

## Usage

**Basic rating:**
```bash
/rate-skill skills/example-skill/SKILL.md
```

**Rate after changes:**
```bash
# Make improvements
[edit SKILL.md]

# Re-rate
/rate-skill skills/example-skill/SKILL.md
```

**Compare before/after:**
```bash
# Rate original
/rate-skill skills/track-session/SKILL.md

# Make improvements
[condense, remove redundancy]

# Rate again to see improvement
/rate-skill skills/track-session/SKILL.md
```

## Grading Scale

| Grade | Score | Meaning |
|-------|-------|---------|
| A | 90-100 | Excellent - Production ready |
| B | 80-89 | Good - Minor improvements recommended |
| C | 70-79 | Acceptable - Needs work before publishing |
| D | 60-69 | Poor - Significant issues to address |
| F | 0-59 | Failing - Major overhaul needed |

**Status mapping:**
- A-B: Production Ready
- C: Needs Work
- D-F: Not Ready

## Examples

### Example 1: Rating a High-Quality Skill

**Input:** `/rate-skill skills/track-session/SKILL.md`

**Output:**
```markdown
# Skill Rating: A

## Summary
- **File:** skills/track-session/SKILL.md
- **Lines:** 489 lines
- **Detected Type:** Methodology
- **Overall Grade:** A (93/100)
- **Status:** Production Ready
- **Spec Compliance:** Claude Code-only fields present (argument-hint, allowed-tools)

## Category Scores

| Category | Score | Grade | Status |
|----------|-------|-------|--------|
| Length | 20/20 | A | Pass |
| Conciseness | 18/20 | A | Pass |
| Structure | 15/15 | A | Pass |
| Triggers | 15/15 | A | Pass |
| Frontmatter | 14/15 | A | Pass |
| Examples | 9/10 | A | Pass |
| Type Compliance | 5/5 | A | Pass |

## Strengths
- Excellent progressive disclosure with reference/VERIFICATION.md
- 10+ diverse trigger phrases in description
- Strong Good/Bad examples with explanations
- Verification checklist matches methodology type

## Recommended Improvements
1. **Frontmatter: `argument-hint` nested under metadata**
   - Impact: Claude Code won't parse for autocomplete
   - Fix: Move to top-level frontmatter field

## Priority Action Items
1. Move argument-hint to top level (optional, minor portability note)
```

**Note:** High-scoring skills get a short report focused on strengths and optional improvements.

### Example 2: Rating a Skill That Needs Work

**Input:** `/rate-skill skills/problematic-skill/SKILL.md`

**Output:**
```markdown
# Skill Rating: C

## Summary
- **File:** skills/problematic-skill/SKILL.md
- **Lines:** 742 lines
- **Detected Type:** Technical
- **Overall Grade:** C (71/100)
- **Status:** Needs Work
- **Spec Compliance:** Non-functional fields present (tags)

## Findings by Priority

### Highest Impact Improvements
1. **Length: 742 lines without progressive disclosure**
   - Impact: High context usage, harder to scan
   - Fix: Create reference/ directory, move detailed content:
     ```
     skill-name/
     ├── SKILL.md          # Keep under 500 lines
     └── reference/
         ├── EXAMPLES.md   # Move extensive examples here
         └── STANDARDS.md  # Move detailed rules here
     ```

2. **Triggers: Only 2 phrases in description**
   - Impact: Poor activation reliability
   - Fix: Add 5+ specific user phrases:
     ```yaml
     description: |
       Use when asked to "phrase 1", "phrase 2", "phrase 3",
       when [situation 1], or when [situation 2].
     ```

3. **Frontmatter: `argument-hint` nested under metadata**
   - Impact: Claude Code won't parse it for autocomplete
   - Fix: Move to top-level frontmatter field:
     ```yaml
     argument-hint: "<your-hint>"
     ```

### Recommended Improvements
1. **Conciseness: Verbose mode descriptions (30+ lines each)**
   - Fix: Condense to 2-3 lines per mode, move details to reference/
2. **Frontmatter: Remove `tags` field**
   - Fix: No discovery system consumes tags. Delete the field or move to `metadata.tags`

## Priority Action Items
1. Implement progressive disclosure (move 200+ lines to reference/)
2. Add 5+ trigger phrases to description
3. Move argument-hint to top level
4. Condense verbose sections

## Estimated Improvements
- Fix highest impact: +15 points -> 86 (B)
- Potential grade: C -> A
```

**Note:** Lower-scoring skills get detailed findings with concrete fixes and an improvement roadmap.

## Troubleshooting

### Problem: Can't find SKILL.md file

**Cause:** Path incorrect or file doesn't exist.

**Solution:**
```bash
# Verify file exists
ls skills/skill-name/SKILL.md

# Use correct path
/rate-skill skills/skill-name/SKILL.md
```

### Problem: Rating seems too harsh

**Cause:** Standards are calibrated for activation reliability. Each category has clear A-grade signals.

**Solution:**
- Review the "Strong signals" for each category to understand what A-grade looks like
- Compare your skill to high-rated skills (track-session, git-worktree)
- Focus on Highest Impact Improvements first
- Remember: B grade is "Production Ready"

### Problem: Grade improved but still low

**Cause:** Multiple categories need attention.

**Solution:**
- Focus on highest-weight categories first (Length 20%, Conciseness 20%)
- Fix Highest Impact Improvements before Recommended
- Re-rate after each major change
- Use "Estimated Improvements" as roadmap

### Problem: Don't know how to fix an issue

**Cause:** Fix recommendation unclear.

**Solution:**
- Check generate-skill examples for patterns
- Review high-rated skills for reference
- Ask for specific help on that issue
- Consult CLAUDE.md for SkillBox guidelines

### Problem: Unsure about spec compliance

**Cause:** Two-tier spec (universal vs Claude Code) can be confusing.

**Solution:**
- **Universal fields** (portable across all agents): `name`, `description`, `license`, `metadata`, `allowed-tools`, `compatibility`
- **Claude Code extensions** (only Claude Code reads these): `argument-hint`, `context`, `agent`, `model`, `effort`, `mode`, `user-invocable`
- **Non-functional** (remove): `tags` at top level, `hooks` in frontmatter
- Rate-skill flags non-portable fields so you can make informed decisions

## Integration

**This skill works with:**
- **generate-skill** - Use after generating to validate quality
- **Skill development workflow** - Rate before committing/publishing
- **Quality control** - Gate for accepting skills into repositories
- **Continuous improvement** - Track quality metrics over time

**Workflow:**
```bash
# Create skill
/generate-skill new-feature

# Rate it
/rate-skill skills/new-feature/SKILL.md

# Fix issues
[make improvements]

# Re-rate
/rate-skill skills/new-feature/SKILL.md

# When A or B grade, publish
git add skills/new-feature/
git commit -m "Add new-feature skill"
```

**Quality gates:**
- A-B: Merge to main
- C: Request changes
- D-F: Reject until improved

## References

**Based on:**
- generate-skill best practices
- SkillBox CLAUDE.md guidelines
- [agentskills.io](https://agentskills.io) universal skill spec
- Claude Code extensions documentation
- obra/superpowers patterns

**Related:**
- [generate-skill](../generate-skill/SKILL.md)
- [SkillBox CLAUDE.md](../../CLAUDE.md)
