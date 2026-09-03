# rate-skill — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 20 queries, 10 should-trigger / 10 should-not-trigger, split 12 train / 8 validation (60/40) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where rate-skill was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (12)

| # | Query | Expected |
|---|---|---|
| T1 | "rate this skill" | trigger |
| T2 | "grade the SKILL.md in skills/track-roadmap" | trigger |
| T6 | "what letter grade would you give skills/foo/SKILL.md" | trigger |
| T3 | "audit my SKILL.md" | trigger |
| T4 | "score this skill against current best practices" | trigger |
| T5 | "how good is this skill file?" | trigger |
| N1 | "create a skill for running database migrations" | no (generate-skill) |
| N2 | "review my code before I commit" | no (code-review) |
| N3 | "write a SKILL.md for our deploy workflow" | no (generate-skill) |
| N4 | "grade this essay for me" | no (unrelated) |
| N5 | "audit the roadmap" | no (track-roadmap) |
| N6 | "grade my pull request" | no (code-review) |

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
| 4.0.0 (imperative register, front-loaded noun) — description unchanged through 6.0.1 | 2026-07-28 | not run | 7/8 | superseded |
| 6.1.0 (adds "give my skill a letter grade"; T6/N6 added; T2 retargeted off deprecated track-qa) | 2026-09-02 | 9/12 (T3 0.00, T4 0.33, T5 0.00) | 7/8 (V4 0.00) | ✓ ties 4.0.0 on validation; V2 closed (0.33 → 1.00) |

Measured rates 2026-07-28 (3 fresh sonnet sessions per query, scratch project with all 14 skills installed): V1 1.00, V2 0.33 **FAIL**, V3 1.00, V4 1.00, V5–V8 all 0.00 (all four should-nots correctly silent). V2 ("give my new skill a letter grade") under-fires because the phrasing carries no "SKILL.md"/"rate"/"audit" token — the 6.1.0 trigger addition targets it from the train side (T6), not by rewording against this validation query.

Measured 2026-09-02, 6.1.0 (3 fresh sonnet sessions per query, `--max-turns 3`, empty working directory, Skill call parsed from stream-json): T1 1.00, T2 1.00, T6 1.00, T3 0.00 **FAIL**, T4 0.33 **FAIL**, T5 0.00 **FAIL**, N1–N6 all 0.00; V1 1.00, V2 1.00 (the letter-grade trigger closed the July miss), V3 1.00, V4 0.00 **FAIL**, V5–V8 all 0.00. Every miss below is a query that points at something absent from the empty directory ("this app", "this SKILL.md", "the card"); the model asked what to look at instead of invoking. All should-nots were silent. Treat trigger rates as lower bounds and give deictic queries a fixture before iterating the description against them. T3/T5/V4 all say "my/this SKILL.md" with no file present; T2 and T6, which name a path, passed 1.00.

## Notes

- V3 deliberately borders code-review vocabulary ("check the quality") — it tests the negative-scope clause both ways.
- rate-skill is a named tool in practice (mostly slash-invoked); low cold trigger rates on the vaguest phrasings (T5) fall under the official caveat about simple queries and are not automatically a description defect.
