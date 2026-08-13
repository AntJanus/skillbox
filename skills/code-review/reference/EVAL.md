# code-review — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 19 queries, 10 should-trigger / 9 should-not-trigger, split 10 train / 9 validation. Shuffled once 2026-07-28; keep the split fixed across iterations. V9 was appended 2026-08-13 (see Notes) rather than reshuffled, so earlier measurements stay comparable.

**Protocol:** run each query in a fresh Claude session ~3 times. Trigger rate = fraction of runs where code-review was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score.

## Train (10)

| # | Query | Expected |
|---|---|---|
| T1 | "review my code" | trigger |
| T2 | "review these changes before I commit" | trigger |
| T3 | "do a code review of the whole repo" | trigger |
| T4 | "review this in the background while I keep working" | trigger |
| T5 | "is this branch ready to ship?" | trigger (indirect — no "review") |
| N1 | "review PR #412" | no (/review) |
| N2 | "check this branch for security vulnerabilities" | no (/security-review) |
| N3 | "rate this skill" | no (rate-skill) |
| N4 | "clean up and simplify what I just wrote" | no (simplify) |
| N5 | "review this contract for me" | no (unrelated) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "can you look over my staged changes for bugs" | trigger |
| V2 | "check my changes before I commit" | trigger |
| V3 | "review src/billing against the local-first-app blueprint" | trigger |
| V4 | "did I break anything with this change?" | trigger (indirect — no "review") |
| V5 | "audit skills/track-qa/SKILL.md" | no (rate-skill) |
| V6 | "do a security review of the auth flow" | no (/security-review) |
| V7 | "write a PR description for this branch" | no (pr-description) |
| V8 | "refactor this component to be less repetitive" | no (simplify / ideal-react-component) |
| V9 | "I checked PR #412 out into a worktree — review it against main" | trigger (local diff, not a by-number fetch) |

## Results

**Measured 2026-07-28** (validation split, 3 fresh sonnet sessions per query, `--max-turns 3`, scratch project with full fleet installed): V1[T] 0.00 FAIL, V2[T] 0.67, V3[T] 0.00 FAIL, V5-V8[N] all 0.00 — 5/7 parsed (V4 row unparsed by harness). **Methodology bias, read before iterating:** ~48% of fleet runs truncated at max-turns while the agent explored the empty project first, so trigger rates are a lower bound; the official capable-alone caveat also applies (agents answer simple asks directly). Do not reword the description against these validation queries — iterate on train, and re-measure with a higher turn budget before treating any 0.00 as a description defect. Fleet measurement aborted at 146/264 runs by a usage limit.

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 2.1.0 (front-loaded "code review", coverage clause, 4-way negative scope) | 2026-07-28 | not yet run | not yet run | — |

## Notes

- T5 and V4 probe the coverage clause ("even if they never say 'review' and only ask whether the work is ready to ship or safe to commit"). Without it, an agent is likely to answer these conversationally instead of dispatching the lanes — they are the queries the clause exists for.
- N1/V6 and N3/V5 test the two negative-scope clauses that matter most, because `/review`, `/security-review`, and rate-skill all share the verbs "review", "audit", and "check". Each appears in both halves so a description edit can't be tuned against one and regress the other.
- N4 and V8 guard the newest boundary: simplify does quality-only cleanup with no bug hunt, so cleanup phrasing must stay below threshold even though it targets the same working diff.
- V3 is a positive that carries a flag (`--blueprint`) — it verifies the description still triggers when the ask is scoped to one directory rather than "my changes".
- N5 ("review this contract") is the domain-collision negative: the strongest trigger verb attached to a non-code object.
- **V9 vs N1 is the PR boundary, and the pair must be scored together.** They deliberately name the *same* PR number so the only variable is where the diff lives: N1 asks the agent to fetch #412 from GitHub (`/review`'s job), V9 already has it on disk in a worktree, which is an ordinary local review. Added 2026-08-13 after transcripts showed the worktree-per-PR workflow was the skill's most-used path while the description still disowned it. A description edit that wins V9 by dropping the by-number negative and regressing N1 has not passed.
