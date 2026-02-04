# Version Control & Changelog - Extended Guide

This document contains the complete version control and changelog workflow for SkillBox.

**Load this only when:** Creating releases, debugging versioning issues, or setting up the workflow for the first time.

---

## Overview

SkillBox follows a dual-versioning system:
- **Individual skills** have their own semantic versions in SKILL.md frontmatter
- **SkillBox releases** track collections of skill changes via git tags and CHANGELOG.md

---

## Commit Message Conventions

**Use conventional commit format:**

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

- `feat`: New skill or major feature addition
- `fix`: Bug fix in skill or documentation
- `docs`: Documentation-only changes
- `refactor`: Skill restructure without behavior change
- `chore`: Maintenance tasks (dependencies, cleanup)
- `test`: Adding or updating tests

### Scopes

- Skill names: `track-session`, `git-worktree`, `generate-skill`, `ideal-react-component`, `rate-skill`
- Repository areas: `docs`, `workflow`, `meta`

### Examples

```bash
# New skill
feat(git-worktree): add parallel development workflow skill

# Bug fix
fix(track-session): correct checkpoint recovery logic

# Documentation update
docs(readme): add installation troubleshooting section

# Skill version bump
refactor(ideal-react-component): split into progressive disclosure format

BREAKING CHANGE: moved detailed rules to reference/STANDARDS.md

# Multiple skills
feat(track-session,git-worktree): add integration guidelines
```

---

## Versioning Individual Skills

### When to Increment Versions

Follow semantic versioning (MAJOR.MINOR.PATCH):

**MAJOR (x.0.0)**: Breaking changes to skill structure or behavior
- Removed sections, changed triggers, restructured workflow
- Update CHANGELOG.md with migration guide

**MINOR (0.x.0)**: New features, additional triggers, new sections
- Added examples, new workflow phases, enhanced troubleshooting
- Backward compatible additions

**PATCH (0.0.x)**: Bug fixes, typos, clarifications
- Fixed examples, corrected commands, improved wording
- No structural changes

### Process

1. Edit the SKILL.md file
2. Update metadata.version in frontmatter
3. Commit with conventional format: `fix(skill-name): description`
4. Do NOT create git tag for individual skill updates
5. Skill changes accumulate for next SkillBox release

### Example

```yaml
# Before
metadata:
  version: "3.2.0"

# After patch fix
metadata:
  version: "3.2.1"

# Commit
git add skills/track-session/SKILL.md
git commit -m "fix(track-session): correct checkpoint file path"
```

---

## Creating SkillBox Releases

### When to Create a Release

- Multiple skill updates have accumulated
- Significant new skill added
- Breaking changes to any skill
- Approximately monthly cadence (not strict)

### Release Process

#### Phase 1: Prepare Release

**Before proceeding, you MUST:**
- [ ] All skills are tested and working
- [ ] No uncommitted changes (git status clean)
- [ ] On main branch
- [ ] Local branch up to date with remote

#### Phase 2: Update CHANGELOG

**1. Determine version number:**
- Check current version: `git describe --tags --abbrev=0`
- Decide increment based on changes:
  - MAJOR: Breaking changes to any skill
  - MINOR: New skills or significant features
  - PATCH: Bug fixes and documentation only

**2. Update CHANGELOG.md:**
- Add new version section at top
- Use format: `## [X.Y.Z] - YYYY-MM-DD`
- Categorize changes:
  - **New Skills**: Newly added skills
  - **Enhancements**: Feature additions to existing skills
  - **Fixes**: Bug fixes and corrections
  - **Documentation**: Docs-only changes
  - **Breaking Changes**: Incompatible changes (if any)
- Include skill versions in parentheses
- Link to commits or PRs where relevant

**3. Update version references:**
- Update README.md footer if needed
- Update CLAUDE.md "Last Updated" date
- Update AGENTS.md if workflow changed

#### Phase 3: Create Git Tag

```bash
# Set version (e.g., v1.2.0)
VERSION="v1.2.0"

# Create annotated tag with changelog excerpt
git tag -a $VERSION -m "Release $VERSION

New Skills:
- rate-skill: Evaluate skill quality against best practices

Enhancements:
- track-session (v3.3.0): Add work summary generation
- git-worktree (v2.1.0): Add parallel session coordination

See CHANGELOG.md for full details."

# Verify tag
git tag -l -n9 $VERSION

# Push tag to remote
git push origin $VERSION
```

#### Phase 4: Document Release

- [ ] Verify CHANGELOG.md is committed
- [ ] Verify tag is pushed: `git ls-remote --tags origin`
- [ ] Update skills.sh registry if using Vercel Skills
- [ ] Announce in relevant channels (Discord, Twitter, etc.)

**Red Flags:**
- Creating tag before CHANGELOG.md is updated - STOP
- Version number doesn't match CHANGELOG.md - STOP
- Uncommitted changes present - STOP
- Not on main branch - STOP

---

## CHANGELOG.md Structure

### Required Format

```markdown
# Changelog

All notable changes to SkillBox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### New Skills
- Planned additions go here

### Enhancements
- In-progress improvements

## [X.Y.Z] - YYYY-MM-DD

### New Skills
- **skill-name** (vX.Y.Z): Brief description

### Enhancements
- **skill-name** (vX.Y.Z): What changed
- **skill-name** (vX.Y.Z): What changed

### Fixes
- **skill-name** (vX.Y.Z): What was fixed

### Documentation
- What docs were updated

### Breaking Changes
- What breaks compatibility (if any)
```

### Guidelines

- Maintain reverse chronological order (newest first)
- Always keep [Unreleased] section at top
- Include skill version numbers for context
- Use past tense ("Added", "Fixed", "Updated")
- Link to PRs/issues where relevant: `([#123](link))`
- Group related changes together
- Highlight breaking changes prominently

---

## Viewing Version History

### Commands

```bash
# List all releases
git tag -l

# View specific release notes
git tag -l -n9 v1.2.0

# Show changes since last release
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Show changes for specific skill
git log --oneline -- skills/track-session/

# Show changes between releases
git log v1.1.0..v1.2.0 --oneline

# View CHANGELOG for specific version
sed -n '/## \[1\.2\.0\]/,/## \[/p' CHANGELOG.md | head -n -1
```

---

## Release Checklist

Before creating a release, verify:

- [ ] All skill versions updated in their SKILL.md files
- [ ] CHANGELOG.md updated with all changes since last release
- [ ] Version number follows semantic versioning
- [ ] Git tag matches CHANGELOG.md version
- [ ] All commits follow conventional commit format
- [ ] No uncommitted changes
- [ ] On main branch and up to date
- [ ] Tag includes descriptive message
- [ ] Tag pushed to remote
- [ ] README.md reflects current state
- [ ] All skills tested and working

---

## Quick Command Reference

### Skill Version Bump

```bash
# Edit SKILL.md, increment version
git add skills/skill-name/SKILL.md
git commit -m "fix(skill-name): description"
git push
```

### SkillBox Release

```bash
# 1. Update CHANGELOG.md
# 2. Commit changelog
git add CHANGELOG.md
git commit -m "docs(changelog): prepare v1.2.0 release"

# 3. Create and push tag
git tag -a v1.2.0 -m "Release v1.2.0 - description"
git push && git push origin v1.2.0
```

### View History

```bash
# Recent changes
git log --oneline -10

# Changes since last release
git log $(git describe --tags --abbrev=0)..HEAD --oneline

# Skill-specific history
git log --oneline -- skills/track-session/
```

---

## Troubleshooting

### Version Mismatch

**Problem:** Tag version doesn't match CHANGELOG.md

**Solution:**
1. Delete the incorrect tag: `git tag -d vX.Y.Z`
2. Delete from remote: `git push origin :refs/tags/vX.Y.Z`
3. Fix CHANGELOG.md
4. Create new tag with correct version

### Missing Changes in Changelog

**Problem:** Forgot to document some commits

**Solution:**
1. Review git log since last release
2. Update CHANGELOG.md
3. Amend the "prepare release" commit or create new one
4. Recreate tag if already pushed (delete old tag first)

### Uncommitted Changes Blocking Release

**Problem:** `git status` shows uncommitted files

**Solution:**
1. Review changes: `git status`
2. Commit if they should be in release
3. Stash if they're work-in-progress: `git stash`
4. Never create a release with uncommitted changes

---

**Last Updated:** 2026-02-04
