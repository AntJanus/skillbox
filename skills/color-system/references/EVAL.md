# color-system — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation with a proportional 1:1 positive/negative mix in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where color-system was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on **train** failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one.

## Train (10)

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

## Validation (8)

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

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.4.0 (imperative register, quoted triggers, three-way negative scope) | 2026-07-28 | not yet run | not yet run | — |

## Notes

- **This set measures routing correctness, not cold auto-activation.** color-system is a specialist-vocabulary skill: measured SkillBox activation data shows such skills are invoked by name or by explicit domain vocabulary, near-zero cold. The question worth answering here is "when color vocabulary *is* present, does the right skill answer and do the near-neighbors stay quiet" — not "what fraction of unprompted design work wakes it up." Do not tune the description chasing an auto-fire rate the vocabulary cannot deliver.
- **Near-neighbor coverage is the point of the negatives.** typography (N1, N2, V7), frontend-design (N3, N5), and dataviz (N4, V5) each get multiple probes because all three overlap color-system's surface — a user asking about "how this looks" could land in any of them. V6 and V8 are generic-adjacent controls.
- **N4 vs T4 is the sharpest pair.** Both are chart questions; only T4 is about color. If N4 fires, the negative-scope clause naming dataviz is not carrying.
- **V3 tests the "even if they don't say color" clause** — the user says "unreadable", never "color" or "contrast". T3 tests the same domain with explicit hex vocabulary, so the pair isolates whether coverage-clause phrasing is doing work.
- **V1 and V2 probe the two thinnest domains** (build-your-own recipe, TUI). They're the queries most likely to under-fire if the description gets trimmed, since neither "OKLCH" nor "ANSI" is common user vocabulary.
