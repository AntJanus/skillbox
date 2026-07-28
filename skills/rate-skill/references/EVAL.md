# rate-skill — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where rate-skill was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "rate this skill" | trigger |
| T2 | "grade the SKILL.md in skills/track-qa" | trigger |
| T3 | "audit my SKILL.md" | trigger |
| T4 | "score this skill against current best practices" | trigger |
| T5 | "how good is this skill file?" | trigger |
| N1 | "create a skill for running database migrations" | no (generate-skill) |
| N2 | "review my code before I commit" | no (code-review) |
| N3 | "write a SKILL.md for our deploy workflow" | no (generate-skill) |
| N4 | "grade this essay for me" | no (unrelated) |
| N5 | "audit the roadmap" | no (track-roadmap) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "can you evaluate skills/deep-research/SKILL.md and tell me what to fix" | trigger |
| V2 | "give my new skill a letter grade" | trigger |
| V3 | "check the quality of skills/color-system/SKILL.md" | trigger |
| V4 | "is this SKILL.md up to spec?" | trigger |
| V5 | "turn this workflow into a skill" | no (generate-skill) |
| V6 | "review PR #123" | no (/review) |
| V7 | "rate my resume" | no (unrelated) |
| V8 | "score this pull request before merge" | no (code-review) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 4.0.0 (imperative register) | | | | |

## Notes

- V3 deliberately borders code-review vocabulary ("check the quality") — it tests the negative-scope clause both ways.
- rate-skill is a named tool in practice (mostly slash-invoked); low cold trigger rates on the vaguest phrasings (T5) fall under the official caveat about simple queries and are not automatically a description defect.
