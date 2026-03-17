---
schema: cc-dash/roadmap@1
project: skillbox
description: Curated collection of reusable utility skills for Claude Code and AI agents.
last_updated: 2026-03-13T10:00:00-07:00
---

# Roadmap

> Curated collection of reusable utility skills for Claude Code and AI agents.

## Core

<!-- category:core -->

- <!-- id:r_si6j5 status:planned --> **AGENTS.md Refresh** - Update stale "Last Updated" date (2025-01-29), add real pattern examples from existing skills (Pattern A: track-session, Pattern C: rate-skill, Pattern D: setup-semantic-release), review all workflow sections for accuracy against current 10-skill set.
- <!-- id:r_oulw2 status:planned --> **Progressive Disclosure Fixes** - Add reference/ directory to track-roadmap (currently 517 lines, exceeds 500-line threshold). Audit setup-semantic-release and remember for progressive disclosure need. Ensure all skills at or near 500 lines use the reference/ pattern.
- <!-- id:r_6ctoj status:planned --> **Contribution Infrastructure** - Create .github/ISSUE_TEMPLATE/skill-proposal.md, .github/PULL_REQUEST_TEMPLATE.md, and CONTRIBUTING.md with contributor guidelines (skill creation process, quality standards, PR workflow).

## Infra

<!-- category:infra -->

- <!-- id:r_xd69x status:planned --> **CI/CD Pipeline** - Create .github/workflows/validate-skills.yml that runs test-skills.sh on PRs. Validate SKILL.md YAML frontmatter structure, section presence (Overview, When to Use, Examples, Troubleshooting, Integration), enforce 500-line limit, and lint markdown formatting.
- <!-- id:r_gb7ss status:planned --> **Documentation Polish** - Add usage examples and screenshots/GIFs to README for each skill. Document cross-skill integration patterns (remember + track-session + track-roadmap).

## UX

<!-- category:ux -->

- <!-- id:r_1ksmi status:planned --> **New Skills (v2.0.0)** - testing-workflow (run/manage test suites), code-review (structured review with severity levels), debug-systematic (bisection/isolation/hypothesis-driven debugging), database-migration (safe schema migrations), docker-workflow (containers and Compose management). Each must pass rate-skill with grade B+, use progressive disclosure if over 300 lines, and have 3+ trigger phrase variations tested. Deadline: 2026-06-06.
- <!-- id:r_5idsf status:idea --> **Community Contributions** - Accept community skill submissions via PR with automated quality checks. Publish SkillBox to Vercel Skills registry. Create submission template using generate-skill's validation checklist. Add CONTRIBUTORS.md.
- <!-- id:r_agpsg status:idea --> **Skill Marketplace** - Curate featured skills section on README. Add skill categories/tags for browsable discovery. Support skill dependencies. Skill ratings and download metrics via Vercel Skills CLI integration. Searchable skill index page.
- <!-- id:r_e1itv status:idea --> **Platform Expansion** - Test and document compatibility with Cursor, Cline, and GitHub Copilot agents. Platform-specific installation guides. Adapter layer for agents that do not support the full skills specification.

## Future

<!-- category:future -->

- <!-- id:r_tv3x6 status:idea --> **Skill Composition and Orchestration** - Composite skills chaining multiple skills together. Skill pipelines with conditional branching. Shared state between skills within a session.
- <!-- id:r_xsfpe status:idea --> **Intelligent Activation** - Context-aware skill selection using project metadata. Skill recommendation engine based on codebase analysis. Conflict resolution when multiple skills match the same trigger.
- <!-- id:r_n8sei status:idea --> **Ecosystem and Standards** - Propose enhancements to Agent Skills Specification. Open-source rate-skill as standalone linter/validator. SkillBox SDK for programmatic skill creation, testing, and publishing. Skill versioning and update notifications via CLI.
- <!-- id:r_6elz3 status:idea --> **Analytics and Feedback** - Opt-in usage telemetry. Feedback loop for skill improvement. Automated skill regression testing against new Claude Code releases.

## Completed

<!-- category:completed -->

- <!-- id:r_e2mzg status:done completed:2026-03-02 --> ~~**v1.6.0**~~ - Added remember skill for session context restoration. *(Completed: 2026-03-02)*
- <!-- id:r_gvb0t status:done completed:2026-03-01 --> ~~**v1.5.0**~~ - Added resume mode to track-roadmap for roadmap-to-session workflow. *(Completed: 2026-03-01)*
- <!-- id:r_cwxdt status:done completed:2026-02-23 --> ~~**v1.4.0**~~ - Added record-tui and screenshot-local for visual documentation. *(Completed: 2026-02-23)*
- <!-- id:r_skz5h status:done completed:2026-02-16 --> ~~**v1.3.0**~~ - Added track-roadmap for project planning and tracking. *(Completed: 2026-02-16)*
- <!-- id:r_l4eqy status:done completed:2026-02-16 --> ~~**v1.2.0**~~ - Added setup-semantic-release; quality refinements across existing skills. *(Completed: 2026-02-16)*
- <!-- id:r_thmj8 status:done completed:2026-02-10 --> ~~**v1.1.0**~~ - Quality review and progressive disclosure refactor across all skills. *(Completed: 2026-02-10)*
- <!-- id:r_ngxyx status:done completed:2026-02-04 --> ~~**v1.0.0**~~ - Initial stable release with 5 core skills (track-session, git-worktree, generate-skill, ideal-react-component, rate-skill), documentation, and Vercel Skills CLI support. *(Completed: 2026-02-04)*
- <!-- id:r_b2guu status:done completed:2026-03-02 --> ~~**remember**~~ - Rebuild context from previous Claude Code sessions. v1.0.0. *(Completed: 2026-03-02)*
- <!-- id:r_noi5p status:done completed:2026-02-23 --> ~~**screenshot-local**~~ - Capture screenshots of local dev projects using shot-scraper. v1.0.0. *(Completed: 2026-02-23)*
- <!-- id:r_vwujm status:done completed:2026-02-23 --> ~~**record-tui**~~ - Record polished terminal demos using Charmbracelet VHS. v1.0.0. *(Completed: 2026-02-23)*
- <!-- id:r_dffmu status:done completed:2026-02-16 --> ~~**track-roadmap**~~ - Plan, update, and audit a high-level project roadmap. v1.1.0. *(Completed: 2026-02-16)*
- <!-- id:r_zp7wj status:done completed:2026-02-16 --> ~~**setup-semantic-release**~~ - Automated versioning pipeline with conventional commits and husky. v1.0.0. *(Completed: 2026-02-16)*
- <!-- id:r_bybun status:done completed:2026-02-04 --> ~~**rate-skill**~~ - Evaluate skill quality against best practices with letter grades. v1.0.2. *(Completed: 2026-02-04)*
- <!-- id:r_embi8 status:done completed:2026-02-04 --> ~~**ideal-react-component**~~ - Battle-tested React component structure pattern. v1.3.0. *(Completed: 2026-02-04)*
- <!-- id:r_6bgrf status:done completed:2026-02-04 --> ~~**generate-skill**~~ - Interactive skill builder that generates high-quality SKILL.md files. v1.2.1. *(Completed: 2026-02-04)*
- <!-- id:r_tdnjs status:done completed:2026-02-04 --> ~~**git-worktree**~~ - Manage multiple branches simultaneously using git worktrees. v2.0.2. *(Completed: 2026-02-04)*
- <!-- id:r_nhs6j status:done completed:2026-02-04 --> ~~**track-session**~~ - Track, stop, resume, and save progress on long-running sessions. v3.3.2. *(Completed: 2026-02-04)*
