# generate-skill — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where generate-skill was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "create a skill for running database migrations" | trigger |
| T2 | "generate a skill from this workflow" | trigger |
| T3 | "scaffold a SKILL.md for screenshot automation" | trigger |
| T4 | "turn this workflow into a skill" | trigger |
| T5 | "I want a new Claude Code skill that formats SQL" | trigger |
| N1 | "rate this skill" | no (rate-skill) |
| N2 | "review my code" | no (code-review) |
| N3 | "create a roadmap for this project" | no (track-roadmap) |
| N4 | "generate screenshots for docs" | no (screenshot-local) |
| N5 | "set up semantic release for this repo" | no (setup-semantic-release) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "write a SKILL.md for our deploy process" | trigger |
| V2 | "help me make a skill for tracking TODOs" | trigger |
| V3 | "build a skill that wraps the ffmpeg CLI" | trigger |
| V4 | "make this checklist into a reusable skill" | trigger |
| V5 | "grade my SKILL.md" | no (rate-skill) |
| V6 | "create a QA list for this app" | no (track-qa) |
| V7 | "audit my SKILL.md for problems" | no (rate-skill) |
| V8 | "write a PR description for this branch" | no (pr-description) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 4.0.0 (near-neighbor scope: +track-roadmap, +track-qa) | 2026-07-28 | not yet run | 7/8 | ✓ |

Measured rates 2026-07-28 (3 fresh sonnet sessions per query, scratch project with all 14 skills installed): V1 1.00, V2 1.00, V3 1.00, V4 0.00 **FAIL**, V5–V8 all 0.00 (all four should-nots correctly silent, including "create a QA list"). V4 ("make this checklist into a reusable skill") is the known cost of dropping "checklist" from the coverage clause to avoid the track-qa collision — a deliberate precision-over-recall trade. If a future variant re-adds checklist coverage, it must keep V6 at 0.00; iterate on train, not against this query.

## Notes

- N1/V5/V7 test the `Do NOT use for grading existing skills — see rate-skill` clause; N3/N4/V6 test "create/generate X" verbs that belong to other skills.
- T5/V2/V4 are indirect asks (no "generate/scaffold" verb) — they test the description's "even if they don't say 'skill'" coverage clause.
