# ui-ux-design — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 20 queries, 10 should-trigger / 10 should-not-trigger, split 12 train / 8 validation (60/40) with a proportional 1:1 mix in each half. Shuffled once 2026-08-04; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where ui-ux-design was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one (overfitting).

## Train (12)

| # | Query | Expected |
|---|---|---|
| T1 | "what states does this button need?" | trigger |
| T2 | "design the settings screen for this app" | trigger |
| T3 | "how should I structure the navigation for a site this size?" | trigger |
| T4 | "set up design tokens for this project" | trigger |
| T5 | "users keep dropping off at step three of the signup — why?" | trigger |
| T6 | "review my UX before I ship this" | trigger |
| N1 | "what font size should the body text be?" | no (typography) |
| N2 | "pick a palette for this dashboard" | no (color-system) |
| N3 | "which chart type fits this data?" | no (dataviz) |
| N4 | "my useEffect is firing in a loop" | no (ideal-react-component) |
| N5 | "write the copy for the pricing page headline" | no (content, not design) |
| N6 | "set up semantic-release for this repo" | no (unrelated) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "this screen feels cluttered and I can't tell what's important" | trigger |
| V2 | "the card breaks when the title is long" | trigger |
| V3 | "wireframe the onboarding flow" | trigger |
| V4 | "is this interface any good?" | trigger |
| V5 | "does #6b7280 pass contrast on white?" | no (color-system) |
| V6 | "split this component into a custom hook" | no (ideal-react-component) |
| V7 | "add a bar chart to the analytics page" | no (dataviz) |
| V8 | "run the test suite and fix what fails" | no (unrelated) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.0.0 (initial) | 2026-08-04 | not yet run | not yet run | — |
| 1.0.1 (routing clause names the query shape — "only about a type scale, a line-height, or a palette") | 2026-08-04 | not yet run | not yet run | — |

## Notes

- **T5, V1, and V2 carry no design vocabulary at all** — they are symptom descriptions ("dropping off", "feels cluttered", "breaks when the title is long"). They probe the coverage clause in the description, which is the half most likely to fail. V2 in particular is the state-matrix case stated as a bug report; if it doesn't trigger, the description's real-data language needs strengthening.
- **N1, N2, and V5 are the hardest negatives** because the user chose comprehensive scope: this skill genuinely contains typography and color content, so the description has to route narrow type-and-color questions away while still winning broad interface questions. Watch these closely — a regression here means the "load typography and color-system for depth" clause is not doing its job.
- **V4 ("is this interface any good?") is the widest positive.** It has no noun this skill uniquely owns, which makes it the best test of whether the distinctive trigger sits early enough in the description to survive listing truncation.
- N6 and V8 are unrelated-work controls; a trigger on either means the description is over-broad.
