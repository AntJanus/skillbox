# SkillBox Roadmap

A curated collection of utility skills for Claude Code and AI agents. SkillBox provides reusable, battle-tested skills that enhance agent capabilities for common development workflows. Compatible with Claude Code, Cursor, Cline, GitHub Copilot, and 40+ other AI agents via the [Vercel Skills](https://skills.sh) ecosystem.

**Install with:** `npx skills add antjanus/skillbox`

**Repository:** https://github.com/antjanus/skillbox

---

## Completed Skills

| Skill | Description | First Released | Current Version |
|-------|-------------|----------------|-----------------|
| ~~track-session~~ | Track, stop, resume, and save progress on long-running sessions | v1.0.0 (2026-02-04) | v3.3.2 |
| ~~git-worktree~~ | Manage multiple branches simultaneously using git worktrees | v1.0.0 (2026-02-04) | v2.0.2 |
| ~~generate-skill~~ | Interactive skill builder that generates high-quality SKILL.md files | v1.0.0 (2026-02-04) | v1.2.1 |
| ~~ideal-react-component~~ | Battle-tested React component structure pattern | v1.0.0 (2026-02-04) | v1.3.0 |
| ~~rate-skill~~ | Evaluate skill quality against best practices with letter grades | v1.0.0 (2026-02-04) | v1.0.2 |
| ~~setup-semantic-release~~ | Automated versioning pipeline with conventional commits and husky | v1.2.0 (2026-02-16) | v1.0.0 |
| ~~track-roadmap~~ | Plan, update, and audit a high-level project roadmap | v1.3.0 (2026-02-16) | v1.1.0 |
| ~~record-tui~~ | Record polished terminal demos using Charmbracelet VHS | v1.4.0 (2026-02-23) | v1.0.0 |
| ~~screenshot-local~~ | Capture screenshots of local dev projects using shot-scraper | v1.4.0 (2026-02-23) | v1.0.0 |
| ~~remember~~ | Rebuild context from previous Claude Code sessions | v1.6.0 (2026-03-02) | v1.0.0 |

### Completed Milestones

- ~~**v1.0.0** (2026-02-04): Initial stable release with 5 core skills, documentation, and Vercel Skills CLI support~~
- ~~**v1.1.0** (2026-02-10): Quality review and progressive disclosure refactor across all skills~~
- ~~**v1.2.0** (2026-02-16): Added setup-semantic-release; quality refinements across existing skills~~
- ~~**v1.3.0** (2026-02-16): Added track-roadmap for project planning and tracking~~
- ~~**v1.4.0** (2026-02-23): Added record-tui and screenshot-local for visual documentation~~
- ~~**v1.5.0** (2026-03-01): Added resume mode to track-roadmap for roadmap-to-session workflow~~
- ~~**v1.6.0** (2026-03-02): Added remember skill for session context restoration~~

---

## Short-term

### New Skills

- **testing-workflow**: Skill for running and managing test suites, interpreting failures, and iterating on fixes
- **code-review**: Skill for structured code review with severity levels, security checks, and actionable feedback
- **database-migration**: Skill for planning and executing database schema migrations safely
- **docker-workflow**: Skill for managing Docker containers, Compose files, and multi-service development environments
- **debug-systematic**: Skill for structured debugging using bisection, isolation, and hypothesis-driven investigation

### Quality Improvements

- Add progressive disclosure (reference/ directories) to skills that lack them: setup-semantic-release, track-roadmap, remember
- Add CI/CD pipeline for validating SKILL.md frontmatter and structure on PRs
- Create a `.github/ISSUE_TEMPLATE` for new skill proposals
- Create a `.github/PULL_REQUEST_TEMPLATE` for skill contributions
- Ensure all skills have reference/ docs where content approaches the 500-line limit

### Documentation Gaps

- AGENTS.md "Last Updated" date is stale (2025-01-29) -- needs refresh
- Pattern examples in AGENTS.md list "None currently" for Patterns A, C, and D -- update with real examples from existing skills
- Add a CONTRIBUTING.md with detailed contributor guidelines beyond what README covers
- Add usage examples and screenshots/GIFs to README for each skill
- Document cross-skill integration patterns (e.g., remember + track-session + track-roadmap)

---

## v2.0 Ideas

### Community Contributions

- Accept community skill submissions via PR with automated quality checks (rate-skill integration)
- Publish SkillBox to the [Vercel Skills](https://skills.sh) registry for discovery
- Create a skill submission template that runs generate-skill's validation checklist
- Add a `CONTRIBUTORS.md` to recognize community authors
- Establish skill ownership model so community authors can maintain their skills

### Skill Marketplace

- Curate a "featured skills" section on README highlighting community contributions
- Add skill categories/tags for browsable discovery (workflow, testing, documentation, devops, frontend, backend)
- Support skill dependencies -- allow one skill to declare and auto-load prerequisites
- Skill ratings and download metrics via Vercel Skills CLI integration
- Searchable skill index page (GitHub Pages or skills.sh integration)

### Platform Expansion

- Test and document compatibility with Cursor, Cline, and GitHub Copilot agents
- Platform-specific installation guides for each supported agent
- Adapter layer for agents that do not support the full skills specification

---

## v3.0 Ideas

### Skill Composition and Orchestration

- Composite skills that chain multiple skills together (e.g., "start project" = generate-skill + track-roadmap + setup-semantic-release)
- Skill pipelines with conditional branching based on project context
- Shared state between skills within a session

### Intelligent Activation

- Context-aware skill selection using project metadata (package.json, pyproject.toml, etc.)
- Skill recommendation engine -- suggest relevant skills based on codebase analysis
- Conflict resolution when multiple skills match the same trigger

### Ecosystem and Standards

- Propose enhancements to the [Agent Skills Specification](https://agentskills.io/specification) based on SkillBox learnings
- Open-source the skill quality framework (rate-skill) as a standalone linter/validator
- SkillBox SDK for programmatic skill creation, testing, and publishing
- Skill versioning and update notifications via CLI (`npx skills check` with changelogs)

### Analytics and Feedback

- Opt-in usage telemetry to understand which skills activate most and where they fail
- Feedback loop for skill improvement -- capture agent and user satisfaction signals
- Automated skill regression testing against new Claude Code releases

---

**Last Updated:** 2026-03-06
