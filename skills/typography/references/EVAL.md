# typography — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where typography was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score — an earlier iteration can beat the last one (overfitting).

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "what font size should I use for body text?" | trigger |
| T2 | "set up a type scale for this app" | trigger |
| T3 | "this text is too small and washed out — fix it" | trigger |
| T4 | "what line-height should paragraphs use?" | trigger |
| T5 | "pair a heading font with a body font" | trigger |
| N1 | "what color palette should I use for this dashboard?" | no (color-system) |
| N2 | "does #9ca3af pass WCAG contrast on white?" | no (color-system) |
| N3 | "lay out this page with a CSS grid" | no (frontend-design) |
| N4 | "build a React component for my signup form" | no (frontend-design) |
| N5 | "set up dark mode colors" | no (color-system) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "my headings and body text don't feel balanced" | trigger |
| V2 | "set up vertical rhythm for this page" | trigger |
| V3 | "make the hero headline fluid with clamp()" | trigger |
| V4 | "what's a good line length for an article?" | trigger |
| V5 | "write the copy for my landing page hero" | no (content, not type) |
| V6 | "pick chart colors for these five series" | no (color-system / dataviz) |
| V7 | "add a sticky header to this page" | no (frontend-design) |
| V8 | "the cards on this page need more spacing between them" | no (frontend-design — layout spacing, not type rhythm) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.4.0 (imperative register, quoted triggers, coverage clause) | 2026-07-28 | not yet run | not yet run | — |

## Notes

- **This set measures routing correctness, not cold-fire rate.** typography is a specialist-vocabulary skill, and measured SkillBox activation data shows such skills draw ~0 cold auto-activation — a user who never says "font", "text size", or "line-height" will not surface it, and that is expected rather than a description defect. What matters is that when type vocabulary *is* present the skill wins, and when adjacent-domain vocabulary is present it stays silent. Read a low rate on a positive query as a routing miss only if the query carries clear type vocabulary.
- T3 uses symptom language ("too small and washed out") with no type jargon — it probes the "even if the user never says typography" coverage clause in the description.
- N2 is the sharpest negative: it contains "WCAG contrast", which appears in this skill's own readability floor, but the *subject* is a color value, not text sizing. It tests the color-system half of the negative scope from the hardest direction.
- V6 borders both near-neighbors (color-system for the palette, dataviz for the chart) while sitting adjacent to this skill's chart-text gotcha — a correct silence here means the gotcha isn't over-claiming the chart domain.
- V8 probes the frontend-design boundary on the word "spacing", which this skill also uses for vertical rhythm. Layout spacing between components is not type rhythm; firing here would mean the description's layout exclusion is too weak.
- V5 is out of scope in a different direction (writing content vs. setting type) and guards against the skill grabbing anything that mentions text.
