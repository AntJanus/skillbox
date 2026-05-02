---
schema: cc-dash/roadmap@1
project: skillbox
description: Curated collection of reusable utility skills for Claude Code and AI agents.
last_updated: 2026-05-02T17:00:00-06:00
---

# Roadmap

> Curated collection of reusable utility skills for Claude Code and AI agents.

## Core

<!-- category:core -->

- <!-- id:r_si6j5 status:done completed:2026-04-15 --> ~~**AGENTS.md Refresh**~~ - AGENTS.md refreshed with rate-skill v2.0.0 rubric; workflow sections aligned to current skill set. *(Completed: 2026-04-15)*
- <!-- id:r_oulw2 status:done completed:2026-04-15 --> ~~**Progressive Disclosure Fixes**~~ - track-roadmap trimmed from 512 → 426 lines via inline-example extraction; TROUBLESHOOTING expanded in reference/. Similar patterns applied to record-tui, ideal-react-component, screenshot-local. *(Completed: 2026-04-15)*

## Infra

<!-- category:infra -->

- <!-- id:r_xd69x status:done completed:2026-04-15 --> ~~**CI/CD Pipeline**~~ - GitHub Actions workflow shipped in `.github/workflows/` with `test-skills.sh` validation: frontmatter, required sections, 500-line ceiling, markdown lint. *(Completed: 2026-04-15)*

## UX

<!-- category:ux -->

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
