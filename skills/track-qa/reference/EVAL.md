# track-qa — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where track-qa was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "create a QA list" | trigger |
| T2 | "set up QA for this project" | trigger |
| T3 | "what's left to check by hand before I release this?" | trigger |
| T4 | "audit the QA list" | trigger |
| T5 | "turn these scratch QA notes into a proper QA.md" | trigger |
| N1 | "write unit tests for this module" | no (automated tests) |
| N2 | "add an item to the roadmap" | no (track-roadmap) |
| N3 | "pick up where I left off" | no (track-session) |
| N4 | "review my changes before I commit" | no (code-review) |
| N5 | "audit my SKILL.md" | no (rate-skill) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "what should I QA" | trigger |
| V2 | "track manual QA" | trigger |
| V3 | "start manual QA" | trigger |
| V4 | "what manual checks still need a human before we ship?" | trigger |
| V5 | "run the test suite" | no (automated tests) |
| V6 | "what should we build next" | no (track-roadmap) |
| V7 | "save my progress on this task" | no (track-session) |
| V8 | "why is this test failing?" | no (debugging) |

## Results

**Measurement attempt 2026-07-28:** fleet run aborted by a usage limit at 146/264 sessions before this skill's queries executed. Table pending a re-run with a higher turn budget (~48% of completed fleet runs truncated at `--max-turns 3` while exploring, undercounting trigger rates).

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.3.0 (coverage clause + three-way negative scoping) | 2026-07-28 | not yet run | not yet run | — |

## Notes

- **T3 and V4 probe the coverage clause** ("even if the user never says QA"). Both describe manual pre-release verification without using the token "QA", so they fail if the description leans entirely on the literal word.
- **N1, N4, N5, V5, and V8 probe the negative-scope clause.** N1/V5/V8 sit on the automated-testing boundary, which is the most likely false-positive source — "test" and "QA" are near-synonyms in casual usage but this skill covers only what tests cannot verify.
- **N5 deliberately reuses the word "audit"** from T4's phrasing to check that the trigger is bound to the QA-list object, not the verb.
- **N2/V6 (track-roadmap) and N3/V7 (track-session)** are the sibling cc-dash schema skills. They share the tracking vocabulary and file-in-project-root shape, so they are the strongest near-neighbor distractors in the SkillBox set.
- **T5 probes migrate mode**, which users reach for without naming a mode — the phrasing describes the input artifact rather than the operation.
