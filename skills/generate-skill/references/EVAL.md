# generate-skill — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 60/40 train/validation with a proportional mix in each half. Shuffled once 2026-07-27; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where generate-skill was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (11)

| # | Query | Expected |
|---|---|---|
| T1 | "create a skill for running database migrations" | trigger |
| T2 | "generate a skill from this workflow" | trigger |
| T3 | "scaffold a SKILL.md for screenshot automation" | trigger |
| T4 | "turn this workflow into a skill" | trigger |
| T5 | "I want a new Claude Code skill that formats SQL" | trigger |
| T6 | "make this checklist into a reusable skill" | trigger |
| N1 | "rate this skill" | no (rate-skill) |
| N2 | "review my code" | no (code-review) |
| N3 | "create a roadmap for this project" | no (track-roadmap) |
| N4 | "generate screenshots for docs" | no (screenshot-local) |
| N5 | "set up semantic release for this repo" | no (setup-semantic-release) |

## Validation (7)

| # | Query | Expected |
|---|---|---|
| V1 | "write a SKILL.md for our deploy process" | trigger |
| V2 | "help me make a skill for tracking TODOs" | trigger |
| V3 | "build a skill that wraps the ffmpeg CLI" | trigger |
| V4 | "grade my SKILL.md" | no (rate-skill) |
| V5 | "create a QA list for this app" | no (track-qa) |
| V6 | "audit my SKILL.md for problems" | no (rate-skill) |
| V7 | "write a PR description for this branch" | no (pr-description) |

## Notes

- N1/V4/V6 test the `Do NOT use for grading existing skills — see rate-skill` clause; N3/N4/V5 test "create/generate X" verbs that belong to other skills.
- T5/V2 are indirect asks (no "generate/scaffold" verb) — they test whether the description's coverage extends past the literal trigger phrases.
