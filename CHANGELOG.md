# Changelog

All notable changes to SkillBox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

---

## [1.4.0] - 2026-02-23

Two new skills for visual project documentation — terminal recordings and web UI screenshots.

### New Skills

- **record-tui** (v1.0.0): Record polished terminal demos using Charmbracelet VHS. Write `.tape` scripts that produce reproducible GIFs, MP4s, and WebMs. Covers tape authoring, smart generation, optimization, and CI/CD integration
- **screenshot-local** (v1.0.0): Capture screenshots of local development projects using shot-scraper via pipx. Supports single shots, batch YAML configs, element selectors, and CI/CD integration

### Documentation

- Added record-tui and screenshot-local to README.md Available Skills section
- Updated skill count from 7 to 9 in README.md

---

## [1.3.0] - 2026-02-16

New skill for high-level project roadmap planning and tracking.

### New Skills

- **track-roadmap** (v1.0.0): Plan, update, and audit a high-level project roadmap with interactive feature discovery, codebase scanning, and progress/relevance auditing

### Documentation

- Added track-roadmap to README.md Available Skills section
- Updated skill count from 6 to 7 in README.md

---

## [1.2.0] - 2026-02-16

New skill addition and quality refinements across existing skills.

### New Skills

- **setup-semantic-release** (v1.0.0): Set up automated versioning and release pipeline using conventional commits, commitlint, husky git hooks, and semantic-release

### Enhancements

- **ideal-react-component** (v1.3.0): Modernized styling section with Tailwind CSS and CSS Modules alternatives; added inline hooks antipatterns quick reference; added React Server Components note; removed redundant Best Practices Summary section
- **git-worktree** (v2.0.2): Added user-language trigger phrases to description; added References section

### Fixes

- **track-session** (v3.3.2): Deduplicated Usage Modes and Workflow by Mode into single concise table; extracted Verification as standalone section
- **generate-skill** (v1.2.1): Fixed phase numbering (3 jumped to 6); removed duplicate Quality Standards Checklist; updated meta section references
- **rate-skill** (v1.0.2): Reframed examples from misleading Good/Bad tags to descriptive headers; trimmed verbose example output

### Documentation

- Added setup-semantic-release to README.md Available Skills section
- Updated skill count from 5 to 6 in README.md

---

## [1.1.0] - 2026-02-10

Quality review and progressive disclosure refactor across all skills.

### Enhancements

- **ideal-react-component** (v1.2.0): Refactored from 1418 → 499 lines with progressive disclosure; moved hooks antipatterns and complete examples to reference/; consolidated TS/JS duplication
- **generate-skill** (v1.2.0): Refactored from 1043 → 393 lines with progressive disclosure; moved pattern templates and advanced topics to reference/; removed redundant content
- **rate-skill** (v1.0.1): Added Good/Bad tags to examples; removed redundant scoring algorithm section; fixed duplicate section naming

### Fixes

- **git-worktree** (v2.0.1): Fixed author metadata inconsistency; removed incorrect `git check-ignore` advice; added Git 2.45+ note for `useRelativePaths`; fixed formatting
- **track-session** (v3.3.1): Renamed "Example 0" to descriptive title; removed hardcoded timestamps from examples

### Documentation

- Added rate-skill to README.md Available Skills section
- Updated skill count from 4 to 5 in README.md

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

[Unreleased]: https://github.com/antjanus/skillbox/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/antjanus/skillbox/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/antjanus/skillbox/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/antjanus/skillbox/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/antjanus/skillbox/releases/tag/v1.0.0
