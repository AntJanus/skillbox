# screenshot-local — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where screenshot-local was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "screenshot my app" | trigger |
| T2 | "take a screenshot of localhost:3000" | trigger |
| T3 | "generate screenshots for the README" | trigger |
| T4 | "set up shot-scraper for this project" | trigger |
| T5 | "I need an OG image for the landing page" | trigger |
| N1 | "record a demo of this CLI" | no (record-tui) |
| N2 | "start the dev server and check the change works" | no (run) |
| N3 | "crop and resize logo.png" | no (image editing) |
| N4 | "add a screenshot test that fails when the UI regresses" | no (visual regression tooling) |
| N5 | "capture a terminal session as a gif" | no (record-tui) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "batch screenshot all my pages at mobile and desktop widths" | trigger |
| V2 | "can you grab an image of the dashboard page for the docs" | trigger |
| V3 | "capture the hero section of the site running on port 5173" | trigger |
| V4 | "add screenshots to the README" | trigger |
| V5 | "why is my dev server crashing on startup" | no (run / debugging) |
| V6 | "make a terminal recording for the install instructions" | no (record-tui) |
| V7 | "convert these PNGs to WebP" | no (image processing) |
| V8 | "screenshot this Figma frame for me" | no (not a local dev server) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1[T] 1.00, V2[T] 0.00 FAIL, V3[T] 1.00, V4[T] 0.67, V5-V8[N] all 0.00 — 7/8. **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.4.0 (imperative register, coverage clause, negative scoping) | — | not yet run | not yet run | — |

## Notes

- T5 and V2 probe the coverage clause ("even if they never name shot-scraper") — neither says "screenshot" plus a tool name, and V2 says "grab an image" instead.
- V3 uses port 5173 rather than the 3000 that appears throughout the body, so a match there is coming from the description, not from memorized example text.
- N4 is the sharpest negative: it contains "screenshot" but wants a regression gate, which the Gotchas section explicitly routes to Percy/Chromatic/Playwright.
- N2 and V5 border the project-level `run` skill; N1, N5, and V6 border `record-tui`; N3 and V7 border generic image editing. Each near-neighbor named in the negative-scope clause is probed at least twice.
- V8 tests the "local dev server or HTML file" scoping — a remote design tool isn't in range even though the verb matches exactly.
