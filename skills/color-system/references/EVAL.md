# color-system — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 24 queries, 12 should-trigger / 12 should-not-trigger, split 14 train / 10 validation with a proportional 1:1 positive/negative mix in each half. Shuffled once 2026-07-28; keep the split fixed across iterations. T6, T7, N6, N7, V9 and V10 were added 2026-09-22 for the 1.6.0 coverage clause — the three positives are verbatim in-app complaints that failed to fire in real use.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where color-system was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on **train** failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one.

## Train (14)

| # | Query | Expected |
|---|---|---|
| T1 | "what color palette should I use for this dashboard?" | trigger |
| T2 | "set up dark mode colors for my app" | trigger |
| T3 | "does #64748b on #ffffff pass WCAG AA?" | trigger |
| T4 | "I need colorblind-safe colors for these chart series" | trigger |
| T5 | "pick brand colors for my landing page" | trigger |
| N1 | "what font pairing should I use for this site?" | no (typography) |
| N2 | "our body text is 12px — what size should it be?" | no (typography) |
| N3 | "fix the layout spacing on this page" | no (frontend-design) |
| N4 | "should this be a bar chart or a line chart?" | no (dataviz — chart form, not color) |
| N5 | "build a React component for this form" | no (frontend-design) |
| T6 | "make sure the text changes into a legible color" | trigger |
| T7 | "the whole page goes dark -- can't read anything" | trigger |
| N6 | "I can't tell the heading levels apart, the sizes are too close" | no (typography — indistinguishable by size, not color) |
| N7 | "the body text is too small to read on my phone" | no (typography) |

## Validation (10)

| # | Query | Expected |
|---|---|---|
| V1 | "build a color scale from this brand hex" | trigger |
| V2 | "give me a terminal theme with the 16 ANSI colors" | trigger |
| V3 | "our muted text is unreadable in dark mode — what hex should it be?" | trigger |
| V4 | "what hex should success, warning, and error be?" | trigger |
| V5 | "add axis labels and a tooltip to this chart" | no (dataviz) |
| V6 | "review my CSS changes before I commit" | no (code-review) |
| V7 | "make this heading bigger and bolder" | no (typography) |
| V8 | "optimize these images for the web" | no (out of scope) |
| V9 | "I can't tell anything apart" | trigger |
| V10 | "the sidebar collapses on mobile and hides the content" | no (frontend-design) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1[T] 0.67, V2-V4[T] 1.00, V5-V8[N] all 0.00 — 8/8. **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.4.0 (imperative register, quoted triggers, three-way negative scope) | 2026-07-28 | not run | 8/8 (lower bound — 48% max-turns truncation) | ✅ current |
| 1.5.1 (description unchanged; body-only revision) | 2026-09-02 | not yet run | not yet run — description text identical to 1.4.0 | — |
| 1.6.0 (coverage clause names the unreadable-on-background and can't-tell-apart class; typography negative now names too-small/too-thin text) | 2026-09-22 | not yet run | not yet run | — |

## Notes

- **Train has never been run.** Run T1–T5 and N1–N5 with `--max-turns 6` before the next description edit so there is a train baseline to iterate against.
- **This set measures routing correctness, not cold auto-activation.** color-system is a specialist-vocabulary skill: measured SkillBox activation data shows such skills are invoked by name or by explicit domain vocabulary, near-zero cold. The question worth answering here is "when color vocabulary *is* present, does the right skill answer and do the near-neighbors stay quiet" — not "what fraction of unprompted design work wakes it up." Do not tune the description chasing an auto-fire rate the vocabulary cannot deliver.
- **Near-neighbor coverage is the point of the negatives.** typography (N1, N2, V7), frontend-design (N3, N5), and dataviz (N4, V5) each get multiple probes because all three overlap color-system's surface — a user asking about "how this looks" could land in any of them. V6 and V8 are generic-adjacent controls.
- **N4 vs T4 is the sharpest pair.** Both are chart questions; only T4 is about color. If N4 fires, the negative-scope clause naming dataviz is not carrying.
- **V3 tests the "even if they don't say color" clause** — the user says "unreadable", never "color" or "contrast". T3 tests the same domain with explicit hex vocabulary, so the pair isolates whether coverage-clause phrasing is doing work.
- **V1 and V2 probe the two thinnest domains** (build-your-own recipe, TUI). They're the queries most likely to under-fire if the description gets trimmed, since neither "OKLCH" nor "ANSI" is common user vocabulary.
- **T6/T7/V9 vs N6/N7 is the 1.6.0 pair.** All five are terse complaints about reading or telling things apart; only the first three are about color. V9 is the hardest — it names neither text nor color — and N6 is its size-based twin. If N6 or N7 fires, the typography clause in the negative scope is not carrying.
