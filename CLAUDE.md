# SkillBox - Claude Code Agent Guide

This file helps Claude Code understand how to work with the SkillBox project effectively.

## Project Description

SkillBox is a collection of utility skills for Claude Code and AI agents. Each skill is a specialized instruction set that teaches agents how to handle specific development workflows.

**Core purpose:** Provide reusable, battle-tested skills that enhance AI agent capabilities across multiple platforms.

**Compatible with:** Claude Code, Cursor, Cline, GitHub Copilot, and 40+ other AI agents via the [Vercel Skills](https://skills.sh) ecosystem.

**Installation:** `npx skills add antjanus/skillbox`

**This is NOT:** A code project with tests and builds. This is a documentation and skill repository.

## File Structure and Patterns

```
skillbox/
├── README.md              # User-facing documentation
├── CLAUDE.md             # This file - AI onboarding doc
├── AGENTS.md             # Agent workflow documentation
├── CHANGELOG.md          # Version history and release notes
├── reference/            # Extended documentation
│   └── VERSION-CONTROL.md # Complete versioning workflow
├── skills/               # All skills live here
│   ├── track-session/
│   │   └── SKILL.md      # Skill definition
│   ├── code-review/
│   │   └── SKILL.md
│   └── generate-skill/
│       └── SKILL.md
└── logo.png              # Project branding
```

### Skill Directory Pattern

Each skill MUST follow this structure:

```
skill-name/
├── SKILL.md              # Required: Core skill documentation
├── references/           # Optional: Extended docs loaded on demand (plural — canonical per Anthropic spec)
│   ├── STANDARDS.md
│   └── EXAMPLES.md
├── scripts/              # Optional: Automation scripts
└── assets/               # Optional: Templates / resources used in output
```

### SKILL.md Format

Every SKILL.md MUST have:

```yaml
---
name: kebab-case-name
description: |
  Trigger-rich description with 3-5 specific phrases.
  Use when [situation], when asked to "[phrase]", or when [context].
license: MIT
metadata:
  author: author-name
  version: "1.0.0"
  argument-hint: <optional-args>
tags: [relevant, tags]
---

# Skill Title

## Overview
[1-2 sentences + core principle]

## When to Use
[Specific situations]

[Main Content - Pattern Specific]

## Examples
[Good/Bad code comparisons]

## Troubleshooting
[Common issues and solutions]

## Integration
[How it works with other skills]
```

## Libraries and Deprecated Code

### Approved Patterns

**DO use these patterns:**

- Phase-based workflows with verification checkboxes
- "Quality Signals" sections listing what good looks like
- "Anti-Patterns" sections with paired ✅ alternative for every ❌ item (negation handling in LLMs is empirically weak — pair `do not X` with `do Y instead`)
- ✅ / ❌ markdown emoji for example comparisons (community convention per Anthropic skill-creator + docx)
- Progressive disclosure (SKILL.md < 300 lines preferred, hard cap 500; extended docs in `references/` — plural is canonical)
- Trigger-rich descriptions in directive third-person form ("Use this skill whenever the user wants to…")

### Forbidden Patterns

**DO NOT use these patterns:**

- Vague descriptions like "A skill for testing" or "Helps with React"
- Single-sentence descriptions without specific triggers
- Multiline `description: |` YAML block scalars — they silently break skill discovery (anthropics/skills #9817). Always single-line.
- First-person POV ("I'll help you…") — empirically degrades activation reliability
- Descriptions over 1024 chars (Anthropic spec hard cap; soft target ≤230 chars for listing-budget safety past ~15-25 installed skills)
- Skills over 500 lines without progressive disclosure (aim under 300)
- Examples without ✅ / ❌ comparisons
- `<Good>` / `<Bad>` XML tag wrappers — non-canonical (zero of 8 surveyed top community skills use them); recommend ✅ / ❌ instead
- ALL-CAPS "IRON LAW" / "NEVER" / "ALWAYS" framing without explained reasoning (Anthropic skill-creator: yellow flag)
- Top-level `version`, `author`, `tags`, `category`, `hooks` in frontmatter — produce "unexpected key" errors (anthropics/skills #37). They live under `metadata` (except `argument-hint`, which is top-level).
- Methodology skills without verification checklists

## Standards and Expectations

### DO: Creating and Editing Skills

- **DO** use the `generate-skill` skill when creating new skills
- **DO** include 3-5 specific trigger phrases in the description field
- **DO** target the `description` field at **≤230 characters** as a soft cap for listing-budget safety past ~15-25 installed skills. No penalty up to 500. Spec hard cap is 1024 (per agentskills.io). The historical 250-char display cap was a Claude Code v2.1.86 regression, removed in v2.1.105+. Always front-load the distinctive trigger noun in the first ~50 chars.
- **DO** use single-line `description:` strings — never `description: |` block scalars (silently breaks discovery per anthropics/skills #9817)
- **DO** write descriptions in third person ("Use this skill whenever the user wants to…", not "I help you…"). First-person POV empirically degrades activation.
- **DO** use directive register: "Use this skill whenever the user wants to…" with a "Do NOT use this skill for…" negative scope clause for collision-prone domains
- **DO** provide ✅ / ❌ example comparisons (community convention per Anthropic skill-creator + docx)
- **DO** include a `## Gotchas` section — Anthropic engineers cite it as the highest-signal section in a skill body
- **DO** keep SKILL.md under 300 lines (aim) / 500 (hard cap). Use `references/` (plural) for extended content. ETH Zurich arXiv 2602.11988 shows verbose context files reduce task success ~3% and inflate step count >20%.
- **DO** add verification checklists for methodology enforcement skills
- **DO** use clear, imperative language (short sentences, bullet points)
- **DO** fold "When to Use" content into the description, not a body section (Anthropic skill-creator guidance: "Include all when-to-use information in the description, not the body — the body only loads after triggering.")
- **DO** document integration points with other skills

### DO NOT: Anti-Patterns

- **DO NOT** create vague or generic skills without specific use cases
- **DO NOT** skip examples - always show ✅ / ❌ comparisons (✅ first; if room, also last — recency bias)
- **DO NOT** write skills without troubleshooting sections
- **DO NOT** create monolithic skills over 1000 lines
- **DO NOT** use abstract language - be concrete and specific
- **DO NOT** skip the frontmatter metadata
- **DO NOT** create skills that duplicate existing functionality
- **DO NOT** write skills without testing activation triggers

### File Operations

**DO:**
- Read existing SKILL.md files before modifying them
- Preserve the YAML frontmatter exactly
- Keep examples in ✅ / ❌ format with desired pattern shown first
- Update version numbers when making changes

**DO NOT:**
- Delete or modify other skills without explicit request
- Change skill names (breaks existing references)
- Remove troubleshooting or examples sections
- Break markdown formatting

### Documentation Style

**DO use this style:**
```markdown
## Phase 1: Setup

**Before proceeding:**
- [ ] Requirement 1
- [ ] Requirement 2

**Commands:**
```bash
# Clear comment
command-here
```

**Anti-Patterns:**
- ❌ Skipping verification "just this once" — defeats the purpose of phase gates
  ✅ Run the verification block; if it fails, return to setup
```

**DO NOT use this style:**
```markdown
## Setup

Maybe you should do these things:
- Thing 1
- Thing 2

Run some commands to set up.
```

## Version Control & Changelog

SkillBox uses:
- **Conventional commits**: `type(scope): description` format
- **Dual versioning**: Individual skills (in frontmatter) + SkillBox releases (git tags)
- **CHANGELOG.md**: Tracks all changes by release

### Essential Workflow

**Update a skill:**
```bash
# Edit SKILL.md, bump version in frontmatter
git commit -m "fix(skill-name): description"
```

**Create a release:**
```bash
# 1. Update CHANGELOG.md with version and date
# 2. Commit changelog
git commit -m "docs(changelog): prepare v1.2.0 release"

# 3. Create and push annotated tag
git tag -a v1.2.0 -m "Release v1.2.0 - summary"
git push && git push origin v1.2.0
```

**Semantic versioning (skills and releases):**
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes and typos

### Deep Reference

For complete workflow details:

**[📋 Version Control & Changelog Guide](./reference/VERSION-CONTROL.md)**

Includes:
- Commit message conventions and examples
- When to increment skill versions
- Step-by-step release process (4 phases)
- CHANGELOG.md structure and guidelines
- Release checklist
- Git commands for viewing history
- Troubleshooting version issues

**Load reference/ docs only when specifically needed to save context.**

## Workflow and Testing

### Creating a New Skill

1. **Use generate-skill**: `/generate-skill skill-name`
2. **Answer questions**: Skill purpose, triggers, enforcement level
3. **Review generated SKILL.md**: Verify all sections present
4. **Test activation**: Ensure trigger phrases work
5. **Document integration**: How it works with existing skills

### Editing Existing Skills

1. **Read the skill first**: `Read` the entire SKILL.md
2. **Understand the pattern**: Methodology? Technical? Auditing?
3. **Preserve structure**: Keep all existing sections
4. **Update version**: Increment metadata.version
5. **Test changes**: Verify triggers still work

### Validation Checklist

Before marking skill work complete:

- [ ] SKILL.md has valid YAML frontmatter
- [ ] Description is single-line (not `description: |` block scalar)
- [ ] Description in third-person directive form ("Use this skill whenever the user wants to…")
- [ ] Description includes 3-5 trigger phrases front-loaded in first ~50 chars
- [ ] Description ≤230 chars (soft target) / ≤500 chars (no penalty) / ≤1024 chars (spec hard cap)
- [ ] Negative scoping ("Do NOT use this skill for X — see Y") for collision-prone domains
- [ ] Examples show ✅ / ❌ comparisons (✅ first)
- [ ] Gotchas section present (highest-signal section per Anthropic engineer)
- [ ] Integration points documented (when concrete; drop if filler)
- [ ] SKILL.md aim under 300 lines, hard cap 500. Use `references/` (plural) for overflow.
- [ ] Verification checklist included (if methodology skill)
- [ ] Markdown formatting is correct
- [ ] Code blocks specify language
- [ ] No top-level `version`, `author`, `tags`, `category`, `hooks` (use `metadata.*` instead)

### Testing Skills

**Test activation by trying trigger phrases:**

```
user: I need to track progress on this long task
[Should activate track-session]

user: Review my changes before I commit
[Should activate code-review]

user: Create a skill for running database migrations
[Should activate generate-skill]
```

**If skill doesn't activate:**
1. Check description field has specific triggers
2. Verify frontmatter is valid YAML
3. Ensure triggers match user's natural language
4. Add more trigger variations

## Common Tasks

### Task: Add a new skill to SkillBox

```markdown
1. Read existing skills for patterns
2. Use `/generate-skill new-skill-name`
3. Answer the discovery questions
4. Review generated SKILL.md
5. Save to skills/new-skill-name/SKILL.md
6. Update README.md to list the new skill
7. Test activation with trigger phrases
```

### Task: Update an existing skill

```markdown
1. Read the current SKILL.md
2. Identify sections needing updates
3. Preserve all existing sections
4. Make targeted changes only
5. Increment version in metadata
6. Test activation still works
```

### Task: Debug skill activation

```markdown
1. Read the SKILL.md description field
2. Check if triggers are specific enough
3. Verify YAML frontmatter is valid
4. Test with exact trigger phrases from description
5. Add more trigger variations if needed
```

### Task: Convert long skill to use progressive disclosure

```markdown
1. Aim SKILL.md under 300 lines (essential content only); hard cap 500
2. Create `references/` directory (plural — canonical per Anthropic spec)
3. Move detailed rules to `references/STANDARDS.md`
4. Move extensive examples to `references/EXAMPLES.md`
5. Add "Deep Reference" section with links:
   - **[📋 Complete Standards](./references/STANDARDS.md)**
   - **[⚡ Code Examples](./references/EXAMPLES.md)**
6. Keep extracted files one level deep — Claude head -100s deeply nested files and misses content
7. Note: "Only load these when specifically needed to save context"
```

### Task: Create a SkillBox release

```markdown
1. Read reference/VERSION-CONTROL.md for complete process
2. Update CHANGELOG.md with new version section
3. Commit changelog
4. Create annotated git tag
5. Push tag to remote
6. Verify tag exists on remote

For detailed steps, see reference/VERSION-CONTROL.md
```

### Task: Update skill and document change

```markdown
1. Read the current SKILL.md
2. Make your changes
3. Increment metadata.version (PATCH/MINOR/MAJOR)
4. Commit with conventional format: type(skill-name): description
5. Add change to CHANGELOG.md [Unreleased] section

For versioning rules, see reference/VERSION-CONTROL.md
```

## Anti-Patterns

If you catch yourself doing any of these, reconsider — each has a paired ✅ alternative:

- ❌ Creating skill without reading existing skills first
  ✅ Read 2-3 existing SKILL.md files to learn the house patterns first
- ❌ Vague description ("A skill for testing")
  ✅ Directive third-person form with 3-5 concrete user-language triggers and a `Do NOT use for…` scope clause
- ❌ Multiline `description: |` block scalar
  ✅ Single-line `description:` string (multiline silently breaks discovery, anthropics/skills #9817)
- ❌ First-person POV in description ("I help you…")
  ✅ Third-person ("Use this skill whenever the user wants to…")
- ❌ Skipping examples section
  ✅ At least one ✅ / ❌ comparison, desired pattern shown first
- ❌ Changing skill names mid-release
  ✅ Names are stable references — only rename in a documented major version
- ❌ Over 500 lines without progressive disclosure
  ✅ Move overflow to `references/` (plural), one level deep
- ❌ No verification checklist in methodology skills
  ✅ Methodology requires measurable checkpoints
- ❌ Testing by reading code instead of trigger phrases
  ✅ Test activation by saying the actual trigger phrase in a fresh Claude session
- ❌ Creating git tag without updating CHANGELOG.md
  ✅ Update CHANGELOG first, commit, then tag
- ❌ Non-conventional commit messages
  ✅ `type(scope): description` (e.g., `fix(track-session): collapse multiline description`)
- ❌ Forgetting to increment `metadata.version`
  ✅ Every skill edit bumps the version (PATCH for fixes, MINOR for additions, MAJOR for breaks)
- ❌ Creating tag for individual skill update
  ✅ Tags mark SkillBox releases that bundle multiple skill bumps
- ❌ ALL-CAPS "IRON LAW" / "NEVER" / "ALWAYS" framing
  ✅ "Quality Signals" and "Anti-Patterns" with explained reasoning

## Troubleshooting

### Problem: Skill not activating

**Cause:** Description field too generic or missing trigger phrases

**Solution:**
1. Read the SKILL.md
2. Check description field
3. Add 3-5 specific trigger phrases
4. Include user's natural language ("when asked to X")
5. Test with exact phrases

### Problem: Generated skill is too long

**Cause:** Too much content in SKILL.md

**Solution:**
1. Aim SKILL.md under 300 lines (hard cap 500)
2. Move extensive content to `references/` (plural)
3. Use progressive disclosure pattern; keep references one level deep
4. Link with clear descriptions of when to load each file

### Problem: Skill activation conflicts

**Cause:** Multiple skills have overlapping triggers

**Solution:**
1. Make triggers more specific
2. Use mutually exclusive phrases
3. Document which skill handles which scenarios
4. Consider combining skills if overlap is high

## Integration with Other Skills

### generate-skill + existing skills

When creating new skills:
- Read existing skills for patterns
- Use similar structure for consistency
- Reference existing skills in "Integration" section
- Maintain consistent quality standards

## Skill Development Philosophy

**Activation over configuration:**
Skills should activate automatically when relevant context appears. The description field is the only signal Claude reads pre-trigger — tune it like a prompt.

**Quality Signals over Red Flags:**
Frame requirements as "what good looks like" first. LLMs follow positive directives more reliably than negations (negation handling is empirically weak — arXiv 2503.22395). Pair every `Do NOT X` with a paired `Do Y instead`.

**Examples over explanation:**
Show concrete ✅ / ❌ comparisons, not just abstract rules. ✅ shown first; if room, also last (recency bias).

**Progressive disclosure:**
Start with essentials in SKILL.md, reveal complexity in `references/` (plural) when needed. Aim under 300 lines (ETH Zurich arXiv 2602.11988 shows verbose context degrades task success).

**Verification at every phase:**
Methodology skills include checkboxes and completion criteria.

## Quick Reference

### Creating New Skill
```
/generate-skill skill-name → Answer questions → Review → Save → Test
```

### Updating Skill
```
Read SKILL.md → Make changes → Increment version → Commit → Update CHANGELOG
```

### Validating Skill
```
Check: Single-line desc | Triggers in first 50 chars | ✅/❌ examples | Gotchas | < 300 lines preferred
```

### Testing Activation
```
Try trigger phrases → Verify activation → Adjust description if needed
```

### Creating Release
```
Review changes → Update CHANGELOG → Commit → Tag → Push
```

### Commit Message
```
type(scope): description

# Examples:
feat(track-session): add new checkpoint feature
fix(code-review): correct synthesis severity collapsing
docs(readme): update installation instructions
```

## Meta

This CLAUDE.md follows its own advice:
- Short, imperative sentences
- Do/Don't lists clearly marked
- Concrete examples with code
- Verification checklists
- Anti-Patterns section with paired ✅ alternatives
- Troubleshooting with solutions

Treat every issue working with SkillBox as an opportunity to update this file.

## Learnings

- **Progressive disclosure via `references/` (plural) for 300-500 line limits** — When a SKILL.md approaches 300 lines, move troubleshooting (highest line count, lowest immediate-need) to `references/TROUBLESHOOTING.md`, keeping only 3-4 most common issues inline with a progressive disclosure link. The `references/` dir can also hold EXAMPLES.md and STANDARDS.md. _(captured 2026-03-21; updated 2026-05-14 to plural)_
- **Release commit ordering matters** — SkillBox releases follow specific ordering: (1) one commit per skill change with `type(skill-name): description`, (2) separate `docs(changelog): prepare vX.Y.Z release` commit, (3) annotated tag `git tag -a vX.Y.Z`, (4) push with `git push && git push origin vX.Y.Z`. Don't bundle skill changes and changelog into one commit. _(captured 2026-03-21)_
- **Multiline `description: |` is the #1 silent killer** — YAML parses fine, but skill discovery never sees it (anthropics/skills #9817). Always single-line. Found across 9 SkillBox skills in 2026-05-14 audit. _(captured 2026-05-14)_
- **Directive third-person descriptions activate ~20× more reliably** — Empirical study (Seleznov n=650, p<0.0001): "Use this skill whenever the user wants to…" form hits 94-100% activation vs passive "Use when X" at 37-87%. First-person POV ("I help you…") degrades further. _(captured 2026-05-14)_
- **`<Good>`/`<Bad>` XML tags are SkillBox-only** — Zero of 8 surveyed top community skills (Anthropic, Vercel, Superpowers) use them. Migrate to ✅ / ❌ markdown emoji. _(captured 2026-05-14)_

---

**Last Updated:** 2026-05-14
**Applies To:** Claude Code 2.1.105+
**Source:** https://antjanus.com/ai/claude-code-best-practices
