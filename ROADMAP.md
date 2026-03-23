---
schema: cc-dash/roadmap@1
project: skillbox
description: Curated collection of reusable utility skills for Claude Code and AI agents.
last_updated: 2026-03-23T16:00:00-07:00
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

- <!-- id:r_q3m7x status:done completed:2026-03-23 --> ~~**rate-skill v2.0.0**~~ - New rubric: replaced Repetitiveness/Troubleshooting with Frontmatter (15%) and Type Compliance (5%). Positive framing throughout (Strong signals, Watch for). Output adds Detected Type, Spec Compliance, concrete fix examples. *(Completed: 2026-03-23)*
- <!-- id:r_w8k4p status:done completed:2026-03-23 --> ~~**Batch Frontmatter Fix**~~ - Moved argument-hint to top-level across 7 skills (Claude Code autocomplete). Removed tags (7 skills) and hooks (2 skills) from frontmatter. Updated generate-skill template. *(Completed: 2026-03-23)*
- <!-- id:r_j2v9n status:done completed:2026-03-23 --> ~~**Full Collection Audit**~~ - Audited all 11 skills against CLAUDE.md standards. Overall grade: A (89/100). Identified frontmatter spec gaps, positive framing opportunities, progressive disclosure patterns. Saved to SKILL_AUDIT_2026-03-23.md. *(Completed: 2026-03-23)*
- <!-- id:r_f5t1r status:done completed:2026-03-21 --> ~~**reflect v1.0.0**~~ - Added reflect skill for extracting learnings from conversations into CLAUDE.md or auto-memory. *(Completed: 2026-03-21)*
