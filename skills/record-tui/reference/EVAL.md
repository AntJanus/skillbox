# record-tui — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where record-tui was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "record a demo of this app" | trigger |
| T2 | "create a GIF of my CLI" | trigger |
| T3 | "write a VHS tape for this app" | trigger |
| T4 | "make a terminal recording" | trigger |
| T5 | "add a demo GIF to the README" | trigger |
| N1 | "screenshot my app on localhost:3000" | no (screenshot-local) |
| N2 | "take a screenshot of the dashboard page" | no (screenshot-local) |
| N3 | "record my screen for a Zoom presentation" | no (not a terminal) |
| N4 | "build a TUI for browsing my notes" | no (build-tui) |
| N5 | "convert this MP4 to a GIF" | no (plain ffmpeg, no tape involved) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "can you generate an animated demo of my TUI for the docs" | trigger |
| V2 | "my README needs a screencast of the CLI running" | trigger |
| V3 | "demo.tape is out of date, re-record it" | trigger |
| V4 | "how do I automate recording this terminal demo in CI" | trigger |
| V5 | "capture a video walkthrough of the web app" | no (not a terminal) |
| V6 | "record a shell session so I can replay my history later" | no (asciinema, not a scripted demo) |
| V7 | "add a screenshot of the settings page to the docs" | no (screenshot-local) |
| V8 | "make a video of the Godot game running" | no (not a terminal) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1[T] 0.67, V2[T] 1.00, V3[T] 0.67, V4[T] 1.00, V5-V8[N] all 0.00 — 8/8. **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.6.0 (imperative register, coverage clause, negative scope vs screenshot-local) | 2026-07-28 | not run (fleet measurement aborted at usage limit) | 8/8 — V1 0.67, V2 1.00, V3 0.67, V4 1.00, V5–V8 0.00 | ✓ baseline |

## Notes

- V1 and V2 carry no "VHS", "tape", or "record a demo" token — they are the direct test of the description's "even if they never say VHS" coverage clause. If either under-fires, that clause is the thing to iterate, not the quoted trigger list.
- N1/N2/V7 are the screenshot-local boundary; the negative-scope sentence is what has to hold them below threshold. V7 is the softest of the three ("add … to the docs" overlaps T5's README framing), so it is the most informative negative.
- N5 and V6 probe the two lookalikes the skill deliberately declines: raw ffmpeg format conversion, and asciinema-style session capture that the Overview hands off. Neither involves authoring a `.tape`.
- V3 tests recognition from an artifact name alone — a user pointing at an existing `demo.tape` never states the job.
- record-tui is a narrow workflow tool with no recorded activations across the 2026-05-14 → 2026-07-02 window. Low cold trigger rates on the vaguest positives fall under the official caveat about simple queries and are not automatically a description defect; treat the coverage-clause positives (V1, V2) as the real signal.

**Measured 2026-09-02, 1.6.1** (3 fresh sonnet sessions per query, `--max-turns 3`, empty working directory, Skill call parsed from stream-json): T1 0.00 **FAIL**, T2 1.00, T3 0.00 **FAIL**, T4 1.00, T5 1.00, N1–N5 all 0.00; V1 0.67, V2 1.00, V3 0.00 **FAIL**, V4 1.00, V5–V8 all 0.00 — train 8/10, validation 7/8. Every miss below is a query that points at something absent from the empty directory ("this app", "this SKILL.md", "the card"); the model asked what to look at instead of invoking. All should-nots were silent. Treat trigger rates as lower bounds and give deictic queries a fixture before iterating the description against them. 1.6.0's 8/8 was measured under the July harness (fleet scratch project, different turn budget), so the two are not comparable; the 1.6.1 change is negative-scope only (build-tui) and every should-not held. Re-measure 1.6.0 under this harness before treating V3 as a regression.
