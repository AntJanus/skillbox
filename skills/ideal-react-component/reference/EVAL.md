# ideal-react-component — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where ideal-react-component was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "create a React component for the user profile card" | trigger |
| T2 | "structure this component properly" | trigger |
| T3 | "my useEffect isn't working — it never re-runs" | trigger |
| T4 | "this page is stuck in an infinite render loop" | trigger |
| T5 | "pull the state out of this .tsx file into a custom hook" | trigger |
| N1 | "review my code before I commit" | no (code-review) |
| N2 | "what hex colors should this dashboard use?" | no (color-system) |
| N3 | "refactor this Express route handler" | no (non-React JS) |
| N4 | "make this landing page look less generic" | no (frontend-design) |
| N5 | "write a Python dataclass for this payload" | no (unrelated) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "refactor this component — it's 400 lines" | trigger |
| V2 | "where should the handlers go in this file?" | trigger |
| V3 | "state doesn't update when the prop changes" | trigger |
| V4 | "why does this fetch fire twice on every render?" | trigger |
| V5 | "pick a type scale for this app" | no (typography) |
| V6 | "review PR #123" | no (/review) |
| V7 | "debug this Node CLI's argument parsing" | no (non-React JS) |
| V8 | "scaffold a local-first tracker app" | no (local-first-app) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1-V4[T] all 0.00 FAIL, V5-V8[N] all 0.00 (should-nots correctly routed to typography//review/local-first-app) — 4/8. **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.8.0 (coverage clause + negative scoping added) | — | not yet run | not yet run | — |

## Notes

- T3, T4, V3, and V4 never say "React" — they probe the "even if they don't mention React by name" coverage clause, which is the main reason this description was widened in 1.8.0.
- N1 and V6 are the code-review boundary; N3 and V7 are the plain-JavaScript boundary; N4 and V5 are the visual/design boundary. All three near-neighbors named in the negative-scope clause get two probes each.
- V2 ("where should the handlers go") tests whether the structural half of the skill activates on layout questions, not just bug questions — the seven-section order is the answer, but the phrasing carries no hook vocabulary.
- V8 borders local-first-app, which also generates React files; the distinguishing signal is app scaffolding vs. component structure.
