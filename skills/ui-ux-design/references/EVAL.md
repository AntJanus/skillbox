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

## Scope extension (8) — added 2026-08-06 for v2.0.0

The 20 above stay **fixed and unmodified** so variant scores remain comparable. v2.0.0 added two subject areas the original set cannot probe, so they get their own block, scored separately.

| # | Query | Expected |
|---|---|---|
| X1 | "what ARIA does this dropdown menu need?" | trigger |
| X2 | "make this data table accessible" | trigger |
| X3 | "should this be a tooltip or something else?" | trigger |
| X4 | "is a pre-ticked newsletter checkbox a dark pattern?" | trigger |
| X5 | "make this checkout convert better" | trigger |
| X6 | "add aria-label to every icon button in this file" | no — the mechanical edit, not the design question. A trigger here means the ARIA clause is over-broad |
| X7 | "write ad copy to increase signups" | no (copywriting, not interface design) |
| X8 | "set up an A/B test for the pricing page" | no (experimentation tooling, not design) |

## Copy boundary (2) — added 2026-09-22 for v2.2.0

N5 false-triggered in real use (not only in the harness), so 2.2.0 names writing the copy itself in the negative scope. X9 is the paired positive that proves pricing *presentation* stayed in scope; score these two with the extension block.

| # | Query | Expected |
|---|---|---|
| X9 | "how should the three pricing tiers be laid out so people can compare them?" | trigger |
| X10 | "write a tagline for the pricing page" | no (writing the copy itself) |

## Results

| Variant | Date | Train pass | Validation pass | Extension pass | Selected |
|---|---|---|---|---|---|
| 1.0.0 (initial) | 2026-08-04 | not yet run | not yet run | n/a | — |
| 1.0.1 (routing clause names the query shape — "only about a type scale, a line-height, or a palette") | 2026-08-04 | not yet run | not yet run | n/a | — |
| 2.0.0 (adds ARIA/accessibility triggers and a conversion clause; 893 → 948 chars) | 2026-08-06 | not yet run | not yet run | not yet run | superseded |
| 2.1.x (adds "accessibility contracts" to the lead, "make this accessible" and "review my UX" triggers, ARIA/dataviz/ideal-react-component negative scope; 948 → 980 chars) | 2026-08-25 | not yet run | not yet run | not yet run | superseded |
| 2.1.2 (frontend-design added to negative scope; two fragments trimmed; 1,000 chars) | 2026-09-02 | 10/12 (T2 0.33, T6 0.00) | 4/8 (V1 0.33, V2 0.00, V3 0.33, V4 0.00) | 4/8 (X2–X4 0.00, X5 0.33) | ✓ first measured variant — see the deictic note |
| 2.2.0 (negative scope names writing the copy itself — headlines, taglines, pricing text; three negative-scope phrases shortened to fit; 1,010 chars) | 2026-09-22 | not yet run | not yet run | not yet run (X1–X10) | — |

Measured 2026-09-02, 2.1.2 (3 fresh sonnet sessions per query, `--max-turns 3`, empty working directory, Skill call parsed from stream-json): T1 1.00, T2 0.33 **FAIL**, T3 1.00, T4 1.00, T5 1.00, T6 0.00 **FAIL**, N1–N6 all pass (N5 0.33 — the conversion clause brushed the pricing-copy negative once); V1 0.33, V2 0.00, V3 0.33, V4 0.00 — all four validation positives **FAIL**; V5–V8 all 0.00; X1 1.00, X2 0.00, X3 0.00, X4 0.00, X5 0.33, X6–X8 all 0.00. Every miss below is a query that points at something absent from the empty directory ("this app", "this SKILL.md", "the card"); the model asked what to look at instead of invoking. All should-nots were silent. Treat trigger rates as lower bounds and give deictic queries a fixture before iterating the description against them. Every validation positive here is a symptom description of a screen that does not exist in the harness ("this screen", "the card", "the onboarding flow", "this interface"), which is the case the Notes below already predicted; X4 is a pure knowledge question the model answers alone. The negatives — the hard part of this description — all held. Next iteration: give the harness a small Next.js fixture with one route and one card component, then re-run.

## Notes

- **T5, V1, and V2 carry no design vocabulary at all** — they are symptom descriptions ("dropping off", "feels cluttered", "breaks when the title is long"). They probe the coverage clause in the description, which is the half most likely to fail. V2 in particular is the state-matrix case stated as a bug report; if it doesn't trigger, the description's real-data language needs strengthening.
- **N1, N2, and V5 are the hardest negatives** because the user chose comprehensive scope: this skill genuinely contains typography and color content, so the description has to route narrow type-and-color questions away while still winning broad interface questions. Watch these closely — a regression here means the "load typography and color-system for depth" clause is not doing its job.
- **V4 ("is this interface any good?") is the widest positive.** It has no noun this skill uniquely owns, which makes it the best test of whether the distinctive trigger sits early enough in the description to survive listing truncation.
- N6 and V8 are unrelated-work controls; a trigger on either means the description is over-broad.
- **N5 is the specific regression risk since 2.0.0.** "Write the copy for the pricing page headline" is a should-not-trigger, and the description says "route signups, conversion, retention, and pricing-presentation asks here." Those two are close enough that N5 may flip. If it does, narrow the clause to the pattern question rather than conversion work generally — X7 exists as the paired control for the same boundary. **It did flip in real use** (a live session, 2026-09), so 2.2.0 took the other route: it keeps the conversion clause and names copywriting explicitly in the negative scope. If N5 or X10 still fires, narrow the conversion clause next; if X9 stops firing, the new negative is over-broad.
- **X6 is the hardest new negative.** The description now names ARIA, but "add aria-label to every icon button" is a mechanical edit and, worse, is the specific thing `COMPONENTS.md` argues against. A trigger there is not a catastrophe — the skill would give correct advice — but it means the description is claiming implementation work it does not own.
