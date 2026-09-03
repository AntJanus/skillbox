# deep-research — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where deep-research was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "research the current state of WebGPU browser support" | trigger |
| T2 | "deep dive on Rust async runtimes" | trigger |
| T3 | "compare Bun and Node for a production API" | trigger |
| T4 | "pros and cons of event sourcing" | trigger |
| T5 | "survey the landscape of open-source vector databases" | trigger |
| N1 | "what's the current Node LTS version?" | no (single WebSearch fact) |
| N2 | "review my changes before I commit" | no (code-review) |
| N3 | "where is the auth middleware in this repo?" | no (Explore) |
| N4 | "how do I center a div?" | no (trivial lookup) |
| N5 | "what does this function do?" | no (repo-internal read) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "investigate why teams are moving off Docker Desktop" | trigger |
| V2 | "what are the real tradeoffs between Postgres and SQLite for a small SaaS?" | trigger |
| V3 | "I need to understand the OAuth device flow well enough to pick a library — dig in" | trigger |
| V4 | "give me a deep read on the WASM component model" | trigger |
| V5 | "look up the weekly npm download count for lodash" | no (single WebSearch fact) |
| V6 | "find every place we call the payments API in this codebase" | no (Explore) |
| V7 | "audit my SKILL.md" | no (rate-skill) |
| V8 | "summarize the PDF I dropped in docs/" | no (no web research involved) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1[T] 1.00, V2[T] 0.00 FAIL, V3[T] 0.00 FAIL, V4[T] 1.00, V5-V8[N] all 0.00 — 6/8. **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 2.3.0 (imperative register, coverage clause, negative scoping) | 2026-07-28 | not run | 6/8 (V2, V3 0.00 under max-turns bias; lower bound) | — (baseline) |
| 2.4.0–2.4.1 (description unchanged since 2.3.0) | — | not run | not run — re-measure at `--max-turns 8` from an empty directory before iterating | — |

## Notes

- V2 and V3 carry no "research"/"deep dive" token at all — they probe the "even if they never say research" coverage clause. If they under-fire, iterate on the clause using the train positives, not on these queries directly.
- N1 and V5 are the sharpest negatives: both are legitimate web lookups that a single WebSearch answers. They test the first negative-scope clause, which is the one most likely to over-fire because "look up" and "research" sit close together in user language.
- N3, N5, and V6 probe the repo-internal boundary against Explore; V6 uses "find every place", which is the phrasing most likely to be mistaken for landscape mode.
- V7 borders rate-skill's vocabulary ("audit") — deep-research should stay silent even though auditing involves gathering evidence.
- Trigger rates on the vaguest positives fall under the official caveat that agents skip skills for tasks they handle alone; a low rate there is not automatically a description defect.
