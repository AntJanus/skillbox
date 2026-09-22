# track-roadmap — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 22 queries, 13 should-trigger / 9 should-not-trigger, split 13 train / 9 validation with positives slightly outnumbering negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where track-roadmap was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (13)

| # | Query | Expected |
|---|---|---|
| T1 | "add an item to the roadmap" | trigger |
| T2 | "mark the dark mode feature done" | trigger |
| T3 | "create a roadmap for this project" | trigger |
| T4 | "audit the roadmap" | trigger |
| T5 | "we finished cloud sync — update the plan" | trigger |
| T6 | "add the release sign-off checks to the roadmap" | trigger |
| T7 | "let's put a few things in the roadmap" | trigger |
| T8 | "commit this and update the roadmap" | trigger |
| N1 | "resume work, pick up where I left off" | no (track-session) |
| N2 | "summarize what we've done so far for a handoff doc" | no (work-summary) |
| N3 | "save my progress before I stop" | no (track-session) |
| N4 | "review my changes before I commit" | no (code-review) |
| N5 | "add this idea to PROJECT_IDEAS.md" | no (backlog file, no roadmap) |

## Validation (9)

| # | Query | Expected |
|---|---|---|
| V1 | "log the work I shipped today" | trigger |
| V2 | "what should we build next?" | trigger |
| V3 | "brainstorm features for this app" | trigger |
| V4 | "what's left to build here?" | trigger |
| V9 | "keep going until the whole roadmap is done" | trigger |
| V5 | "add a task to my session file" | no (track-session) |
| V6 | "turn this bug into a Jira ticket" | no (ticket-description) |
| V7 | "rate this skill" | no (rate-skill) |
| V8 | "what's on my calendar next week" | no (unrelated) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 2.6.0 (front-loaded ROADMAP.md, update triggers first, negative scope vs track-session/track-qa) | 2026-07-28 | not yet run | not yet run | — |
| 2.6.3 (N2/V6 re-targeted after track-qa deprecation; T6 added; sign-off trigger added) | 2026-09-02 | not yet run | not yet run | — |
| 2.7.0 ("put these in", "update the roadmap", "work through the roadmap" added after a usage audit found 11 of 16 roadmap-edit asks missed; T7, T8, V9 added) | 2026-09-22 | not yet run | not yet run | — |

## Notes

- T1/T2/T5 and V1 probe update mode, which is roughly 80% of real invocations — they carry the most weight, and the description front-loads their phrasings for that reason.
- N1 and N3 are the sharpest collision test: `/track-roadmap resume` is a real mode, but bare "resume work" and "save my progress" belong to track-session. A trigger here means the negative-scope clause is too weak.
- V1 ("log the work I shipped") deliberately straddles track-session — shipped *work* is session vocabulary, shipped *features* are roadmap vocabulary. Either outcome is informative; treat a low rate as a candidate for a train-side rewording, not a direct edit against this query.
- V4 uses no roadmap noun at all, testing the "even if they don't mention the roadmap file by name" coverage clause.
- N5 tests that a bare idea-capture request against a non-roadmap backlog file stays out.
- N2 and V6 originally targeted track-qa. It was deprecated 2026-09-01 and its asks now route here, so those queries became should-triggers; they were swapped for work-summary and ticket-description near-neighbors, and T6 covers the routed ask.

**Measured 2026-09-02, 2.6.3** (3 fresh sonnet sessions per query, `--max-turns 3`, empty working directory, Skill call parsed from stream-json): T1 1.00, T2 1.00, T3 0.67, T4 1.00, T5 0.00 **FAIL**, T6 1.00, N1–N5 all 0.00; V1 1.00, V2 1.00, V3 0.00 **FAIL**, V4 0.00 **FAIL**, V5–V8 all 0.00 — train 10/11, validation 6/8. Every miss below is a query that points at something absent from the empty directory ("this app", "this SKILL.md", "the card"); the model asked what to look at instead of invoking. All should-nots were silent. Treat trigger rates as lower bounds and give deictic queries a fixture before iterating the description against them. T5, V3 and V4 all assume an app and a plan exist ("we finished cloud sync", "this app", "here"); T6, the new sign-off trigger, passed 1.00.
