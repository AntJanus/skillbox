# Changelog

All notable changes to SkillBox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### New Skills
- TBD

### Enhancements
- TBD

### Fixes
- TBD

### Documentation
- Added comprehensive version control and changelog workflow to CLAUDE.md
- Established conventional commit message format
- Created CHANGELOG.md with proper structure

---

## [1.0.0] - 2026-02-04

Initial stable release of SkillBox with 5 core skills.

### New Skills

- **track-session** (v3.3.0): Track, stop, resume, verify, and save progress on long-running work sessions
- **git-worktree** (v2.0.0): Manage multiple branches simultaneously using git worktrees for parallel development
- **generate-skill** (v2.0.0): Interactive skill builder that generates high-quality SKILL.md files
- **ideal-react-component** (v1.0.0): Battle-tested React component structure pattern
- **rate-skill** (v1.0.0): Evaluate skill quality against best practices

### Documentation

- Complete README.md with installation instructions
- CLAUDE.md with AI agent onboarding and development guidelines
- AGENTS.md with agent workflow patterns
- Installation support for Vercel Skills CLI
- Manual and project-specific installation methods

### Infrastructure

- Established file structure and patterns
- SKILL.md format specification
- Progressive disclosure pattern for long skills
- Trigger-rich description system

---

## Version History Notes

This is the first tagged release of SkillBox. Previous development history:

- 2026-01: Core skills developed (track-session, git-worktree, generate-skill)
- 2026-01: Added ideal-react-component and rate-skill
- 2026-01: Established documentation structure
- 2026-02: Stabilized for v1.0.0 release with version control workflow

---

## How to Use This Changelog

### For Skill Users

Check this file to see:
- What skills are available and their versions
- What changed between releases
- Breaking changes that affect your workflows

### For Contributors

When making changes:
1. Add your changes to the [Unreleased] section
2. Use the appropriate category (New Skills, Enhancements, Fixes, Documentation, Breaking Changes)
3. Include skill version numbers in parentheses
4. Follow the format: `**skill-name** (vX.Y.Z): Description of change`

### For Release Managers

When creating a release:
1. Rename [Unreleased] to the new version with date
2. Create a new empty [Unreleased] section
3. Review all changes for accuracy
4. Update skill version references
5. Create git tag matching the version
6. Push tag to remote

---

[Unreleased]: https://github.com/antjanus/skillbox/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/antjanus/skillbox/releases/tag/v1.0.0
