# setup-semantic-release — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 18 queries, 9 should-trigger / 9 should-not-trigger, split 10 train / 8 validation (~55/45) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where setup-semantic-release was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "set up semantic release" | trigger |
| T2 | "add conventional commits to this repo" | trigger |
| T3 | "set up commitlint" | trigger |
| T4 | "can we stop hand-bumping the version in package.json?" | trigger |
| T5 | "I want our changelog and GitHub releases generated automatically" | trigger |
| N1 | "update CHANGELOG.md and tag v1.2.0" | no (manual release flow) |
| N2 | "set up a GitHub Actions workflow to run our tests" | no (CI generally) |
| N3 | "write a commit message for these changes" | no (authoring, not setup) |
| N4 | "review my changes before I commit" | no (code-review) |
| N5 | "publish this package to npm" | no (publishing, not release automation) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "configure automated versioning for this project" | trigger |
| V2 | "add husky hooks so bad commit messages get rejected" | trigger |
| V3 | "automate releases from our commit history" | trigger |
| V4 | "enforce a commit message format on this repo" | trigger |
| V5 | "bump the version to 2.0.0 and push a tag" | no (manual release flow) |
| V6 | "set up husky to run prettier on staged files" | no (git hooks, no release pipeline) |
| V7 | "what does BREAKING CHANGE mean in a commit?" | no (knowledge question) |
| V8 | "add a deploy workflow for staging" | no (CI generally) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1[T] 1.00, V2[T] 0.00 FAIL; V3-V8 unmeasured (limit abort) — 1/2 partial. **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 1.4.0 (imperative register, coverage clause, manual-flow negative scope) | 2026-07-28 | not run | partial: V1 1.00, V2 0.00, V3–V8 unmeasured (limit abort) | — (re-measure with higher turn budget first) |

## Notes

- T4 and T5 carry no product name at all — they exercise the "even if they never name semantic-release" coverage clause, which is the main thing the 1.4.0 description added over 1.3.0.
- N1 and V5 are the sharpest negatives: they describe a release, but a hand-maintained one (SkillBox's own CHANGELOG + `git tag` flow is exactly this). If either fires, the negative-scope clause is too weak.
- V6 shares the husky trigger token with V2 but wants lint-staged, not a release pipeline. It tests that "husky" alone doesn't carry activation.
- N2 and V8 probe the CI-in-general boundary; the description must not claim workflow authoring broadly.
- This skill is normally invoked deliberately (a user sets up releases once per repo), so cold trigger rates on the vaguest phrasings fall under the official caveat about simple queries and are not automatically a description defect.
