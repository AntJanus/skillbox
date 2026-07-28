# rate-skill — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 60/40 train/validation with a proportional mix in each half. Shuffled once 2026-07-27; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where rate-skill was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (11)

| # | Query | Expected |
|---|---|---|
| T1 | "rate this skill" | trigger |
| T2 | "grade the SKILL.md in skills/track-qa" | trigger |
| T3 | "audit my SKILL.md" | trigger |
| T4 | "score this skill against current best practices" | trigger |
| T5 | "how good is this skill file?" | trigger |
| T6 | "is this SKILL.md up to spec?" | trigger |
| N1 | "create a skill for running database migrations" | no (generate-skill) |
| N2 | "review my code before I commit" | no (code-review) |
| N3 | "write a SKILL.md for our deploy workflow" | no (generate-skill) |
| N4 | "grade this essay for me" | no (unrelated) |
| N5 | "audit the roadmap" | no (track-roadmap) |

## Validation (7)

| # | Query | Expected |
|---|---|---|
| V1 | "can you evaluate skills/deep-research/SKILL.md and tell me what to fix" | trigger |
| V2 | "give my new skill a letter grade" | trigger |
| V3 | "check the quality of skills/color-system/SKILL.md" | trigger |
| V4 | "turn this workflow into a skill" | no (generate-skill) |
| V5 | "review PR #123" | no (/review) |
| V6 | "rate my resume" | no (unrelated) |
| V7 | "score this pull request before merge" | no (code-review) |

## Notes

- V3 deliberately borders code-review vocabulary ("check the quality") — it tests the negative-scope clause both ways.
- rate-skill is a named tool in practice (mostly slash-invoked); low cold trigger rates on the vaguest phrasings (T5) fall under the official caveat about simple queries and are not automatically a description defect.
