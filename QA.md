---
schema: cc-dash/qa@1
project: skillbox
last_updated: 2026-05-06T11:45:00-06:00
---

# Manual QA — skillbox

## Setup

Run: `cd skillbox && bash scripts/test-skills.sh` (or trigger the GitHub Actions workflow on a scratch PR)

## Checklist

- <!-- id:q_sk001 status:pending --> CI validation workflow runs clean on a fresh PR (no frontmatter errors, no missing sections).
- <!-- id:q_sk002 status:pending --> All 10+ skills pass the 500-line progressive-disclosure limit (spot-check `track-roadmap` — was at 517 lines).
- <!-- id:q_sk003 status:pending --> AGENTS.md "Last Updated" date is current and pattern examples (track-session, rate-skill, setup-semantic-release) match actual skill content.
- <!-- id:q_sk004 status:pending --> `npx skills add antjanus/skillbox` install still works end-to-end from a scratch directory.
- <!-- id:q_sk005 status:pending --> Trigger-phrase activation spot-check: invoke 3 skills by their natural-language triggers (e.g. "let's start a work session", "rate this skill", "set up semantic release") and confirm they activate in a fresh Claude Code session.
- <!-- id:q_sk006 status:pending --> Intentionally break one SKILL.md (remove frontmatter field, exceed 500 lines) and confirm CI fails with a useful error.
- <!-- id:q_sk007 status:pending --> `reference/` deep-link files load correctly when referenced from their parent SKILL.md.
