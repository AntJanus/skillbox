# track-session — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 19 queries, 9 should-trigger / 10 should-not-trigger, split 10 train / 9 validation (~53/47) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where track-session was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one, since tuning against train overfits.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "resume work" | trigger |
| T2 | "pick up where I left off" | trigger |
| T3 | "what was I doing?" | trigger |
| T4 | "save progress before I run out of context" | trigger |
| T5 | "I lost my SESSION_PROGRESS.md — can you rebuild it?" | trigger |
| N1 | "add an item to the roadmap" | no (track-roadmap) |
| N2 | "create a handoff doc for my teammate" | no (work-summary) |
| N3 | "review my changes before I commit" | no (code-review) |
| N4 | "save this file" | no (literal file write) |
| N5 | "rate this skill" | no (rate-skill) |

## Validation (9)

| # | Query | Expected |
|---|---|---|
| V1 | "write down where things stand before I close this out" | trigger |
| V2 | "I'm back on the auth refactor from yesterday — where were we?" | trigger |
| V3 | "are we actually done with everything we planned?" | trigger |
| V4 | "checkpoint this and keep going" | trigger |
| V5 | "what should I work on next on the roadmap?" | no (track-roadmap) |
| V6 | "mark the export feature as done" | no (track-roadmap) |
| V7 | "resume the paused deployment" | no (unrelated sense of "resume") |
| V8 | "summarize this conversation for me" | no (unrelated) |
| V9 | "summarize what we've done so far" | no (work-summary) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 6.0.0 (front-loaded SESSION_PROGRESS.md, coverage clause, track-roadmap/track-qa negative scope) | — | not run | not run | superseded |
| 6.2.1 (work-summary added to negative scope; N2 and V9 retargeted after track-qa's 2026-09-01 deprecation) | 2026-09-02 | not run | PENDING | pending validation run |

## Notes

- **V1 and V2 probe the coverage clause** ("even if the user never says 'session'"). Neither contains a mode word or the filename, so they measure whether the description reaches indirect returns-to-work — the phrasing real usage actually produces.
- **V3 probes verify-mode reach.** "Are we done" is the documented trigger, but verify saw 0 uses across 49 measured invocations, so a low rate here reflects real demand rather than a description defect — don't tune the description toward it.
- **N4 and V7 are over-trigger probes** on the polysemous verbs in the description. "Save this file" and "resume the paused deployment" both borrow a trigger word in an unrelated sense; firing on either means the triggers are matching keywords instead of intent.
- **N1, N5, V5, V6 are the near-neighbor set** — track-roadmap shares the `track-` prefix, cc-dash schema vocabulary, and checkbox file format, which makes it the most likely collision. V5 is the sharpest: "what should I work on next" sits one paraphrase away from T3's "what was I doing".
- **N2 and V9 probe work-summary**, the closest live neighbor: a one-off handoff or summary that doesn't live in SESSION_PROGRESS.md. work-summary's own description scopes against track-session; these two check the reciprocal boundary. (N2 targeted track-qa until its 2026-09-01 deprecation.)
- track-session is predominantly slash-invoked in practice (49 real invocations over 30 days, mostly user-typed). Cold-start trigger rates on the barest phrasings fall under the official caveat about simple queries and are not automatically description defects.
