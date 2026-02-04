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
│   ├── git-worktree/
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
├── reference/            # Optional: Extended docs (if SKILL.md > 500 lines)
│   ├── STANDARDS.md
│   └── EXAMPLES.md
├── scripts/              # Optional: Automation scripts
└── lib/                  # Optional: Helper libraries
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
- "Iron Laws" for mandatory requirements
- "Red Flags" sections for common mistakes
- Good/Bad code examples in `<Good>` and `<Bad>` tags
- Progressive disclosure (SKILL.md < 500 lines, extended docs in reference/)
- Trigger-rich descriptions with multiple activation phrases

### Forbidden Patterns

**DO NOT use these patterns:**

- Vague descriptions like "A skill for testing" or "Helps with React"
- Single-sentence descriptions without specific triggers
- Skills over 500 lines without progressive disclosure
- Examples without Good/Bad comparisons
- Missing troubleshooting sections
- Methodology skills without verification checklists

## Standards and Expectations

### DO: Creating and Editing Skills

- **DO** use the `generate-skill` skill when creating new skills
- **DO** include 3-5 specific trigger phrases in the description field
- **DO** provide Good/Bad code examples for clarity
- **DO** include troubleshooting sections addressing real issues
- **DO** keep SKILL.md under 500 lines (use reference/ for extended content)
- **DO** add verification checklists for methodology enforcement skills
- **DO** use clear, imperative language (short sentences, bullet points)
- **DO** include "When to Use" and "When NOT to Use" sections
- **DO** document integration points with other skills

### DO NOT: Anti-Patterns

- **DO NOT** create vague or generic skills without specific use cases
- **DO NOT** skip examples - always show Good/Bad comparisons
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
- Keep examples in `<Good>` and `<Bad>` tags for clarity
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

**Before proceeding, you MUST:**
- [ ] Requirement 1
- [ ] Requirement 2

**Commands:**
```bash
# Clear comment
command-here
```

**Red Flags:**
- "I'll skip this step just once..." - STOP
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
- [ ] Description includes 3-5 trigger phrases
- [ ] "When to Use" section is specific
- [ ] Examples show Good/Bad comparisons
- [ ] Troubleshooting section exists
- [ ] Integration points documented
- [ ] SKILL.md is under 500 lines OR uses progressive disclosure
- [ ] Verification checklist included (if methodology skill)
- [ ] Markdown formatting is correct
- [ ] Code blocks specify language

### Testing Skills

**Test activation by trying trigger phrases:**

```
user: I need to track progress on this long task
[Should activate track-session]

user: I want to work on multiple features in parallel
[Should activate git-worktree]

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
1. Keep SKILL.md under 500 lines (essential content only)
2. Create reference/ directory
3. Move detailed rules to reference/STANDARDS.md
4. Move extensive examples to reference/EXAMPLES.md
5. Add "Deep Reference" section with links:
   - **[📋 Complete Standards](./reference/STANDARDS.md)**
   - **[⚡ Code Examples](./reference/EXAMPLES.md)**
6. Note: "Only load these when specifically needed to save context"
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

## Red Flags - STOP

If you catch yourself doing any of these:

- **Creating skill without reading existing skills first** - Learn patterns first!
- **Writing vague description** - Add specific triggers
- **Skipping examples section** - Always include Good/Bad comparisons
- **No troubleshooting section** - Users will encounter issues
- **Changing skill names** - Breaks existing references
- **Over 500 lines without progressive disclosure** - Split content
- **No verification checklist in methodology skills** - Required for enforcement
- **Testing by reading code instead of trigger phrases** - Test activation properly
- **Creating git tag without updating CHANGELOG.md** - Document first!
- **Non-conventional commit messages** - Follow the format
- **Forgetting to increment skill version** - Update metadata.version
- **Creating tag for individual skill update** - Tags are for SkillBox releases only

**ALL of these mean: STOP. Read this CLAUDE.md again.**

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
1. Keep SKILL.md under 500 lines
2. Move extensive content to reference/
3. Use progressive disclosure pattern
4. Link with clear descriptions

### Problem: Skill activation conflicts

**Cause:** Multiple skills have overlapping triggers

**Solution:**
1. Make triggers more specific
2. Use mutually exclusive phrases
3. Document which skill handles which scenarios
4. Consider combining skills if overlap is high

## Integration with Other Skills

### git-worktree + track-session

When working with worktrees in parallel sessions:
- Each worktree should have its own SESSION_PROGRESS.md
- Use track-session to track progress in each worktree
- Name Claude sessions after worktree branches

### generate-skill + existing skills

When creating new skills:
- Read existing skills for patterns
- Use similar structure for consistency
- Reference existing skills in "Integration" section
- Maintain consistent quality standards

## Skill Development Philosophy

**Activation over configuration:**
Skills should activate automatically when relevant context appears.

**Enforcement over suggestion:**
Critical workflows use "Iron Laws" and mandatory phases.

**Examples over explanation:**
Show concrete Good/Bad code comparisons, not just abstract rules.

**Progressive disclosure:**
Start with essentials in SKILL.md, reveal complexity in reference/ when needed.

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
Check: Frontmatter | Triggers | Examples | Troubleshooting | < 500 lines
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
fix(git-worktree): correct branch switching logic
docs(readme): update installation instructions
```

## Meta

This CLAUDE.md follows its own advice:
- Short, imperative sentences
- Do/Don't lists clearly marked
- Concrete examples with code
- Verification checklists
- Red Flags section
- Troubleshooting with solutions

Treat every issue working with SkillBox as an opportunity to update this file.

---

**Last Updated:** 2026-02-04
**Applies To:** Claude Code 2025+
**Source:** https://antjanus.com/ai/claude-code-best-practices
