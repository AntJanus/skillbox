# track-roadmap — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation with a 1:1 positive/negative mix in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where track-roadmap was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "add an item to the roadmap" | trigger |
| T2 | "mark the dark mode feature done" | trigger |
| T3 | "create a roadmap for this project" | trigger |
| T4 | "audit the roadmap" | trigger |
| T5 | "we finished cloud sync — update the plan" | trigger |
| N1 | "resume work, pick up where I left off" | no (track-session) |
| N2 | "create a QA list for this project" | no (track-qa) |
| N3 | "save my progress before I stop" | no (track-session) |
| N4 | "review my changes before I commit" | no (code-review) |
| N5 | "add this idea to PROJECT_IDEAS.md" | no (backlog file, no roadmap) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "log the work I shipped today" | trigger |
| V2 | "what should we build next?" | trigger |
| V3 | "brainstorm features for this app" | trigger |
| V4 | "what's left to build here?" | trigger |
| V5 | "add a task to my session file" | no (track-session) |
| V6 | "what should I QA before release?" | no (track-qa) |
| V7 | "rate this skill" | no (rate-skill) |
| V8 | "what's on my calendar next week" | no (unrelated) |

## Results

**Measurement attempt 2026-07-28:** fleet run aborted by a usage limit at 146/264 sessions before this skill's queries executed. Table pending a re-run with a higher turn budget (~48% of completed fleet runs truncated at `--max-turns 3` while exploring, undercounting trigger rates).

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 2.6.0 (front-loaded ROADMAP.md, update triggers first, negative scope vs track-session/track-qa) | 2026-07-28 | not yet run | not yet run | — |

## Notes

- T1/T2/T5 and V1 probe update mode, which is roughly 80% of real invocations — they carry the most weight, and the description front-loads their phrasings for that reason.
- N1 and N3 are the sharpest collision test: `/track-roadmap resume` is a real mode, but bare "resume work" and "save my progress" belong to track-session. A trigger here means the negative-scope clause is too weak.
- V1 ("log the work I shipped") deliberately straddles track-session — shipped *work* is session vocabulary, shipped *features* are roadmap vocabulary. Either outcome is informative; treat a low rate as a candidate for a train-side rewording, not a direct edit against this query.
- V4 uses no roadmap noun at all, testing the "even if they don't mention the roadmap file by name" coverage clause.
- N5 tests that a bare idea-capture request against a non-roadmap backlog file stays out.
