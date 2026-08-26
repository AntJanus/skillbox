---
name: code-review
description: Use this skill to run a multi-agent code review of local changes whenever the user asks to "review my code", "review these changes", "do a code review", "check my changes before I commit", "review the whole repo", "review this in the background", or "review this PR I checked out locally" — even if they never say "review" and only ask whether the work is ready to ship or safe to commit. Reviews any local diff, including a pull request checked out into a worktree (`--branch origin/dev`). Prioritizes correctness over nitpicks and writes REVIEW.md. Do NOT use this skill to fetch and review an open PR by number from GitHub (use /review), for a security-specific pass (use /security-review), for grading a SKILL.md file (see rate-skill), or for a quality-only cleanup that does not hunt for bugs (see simplify).
license: MIT
argument-hint: "[path | --staged | --branch <base> | --repo [--blueprint <skill>]] [--background] [--nits]"
allowed-tools: Read, Write, Glob, Grep, Bash, Agent
metadata:
  author: Antonin Januska
  version: "2.4.0"
---

# Code Review — Multi-Agent Local Review

## Overview

Runs narrow-lane reviewer agents in parallel, then a verifier that keeps only findings with real impact, distills the "fix first" shortlist, and suppresses the nit tail — merged into `REVIEW.md` at the repo root. **Core principle:** a review is worth reading when it finds *wrong answers*, not style. The lanes are aimed at correctness and structural soundness; the verifier defaults low-impact findings to DROP so the signal isn't buried. The skill scopes, dispatches, and renders — the reviewers and verifier judge.

**Model tier:** Opus or Sonnet for the agents; Haiku needs more guidance. **Not for:** security passes (`/security-review`), open PRs by number (`/review`), or trivial one-line/doc changes.

## Modes & flags

| Flag | Effect |
|------|--------|
| *(none)* / `path` / `--staged` / `--branch <base>` | Diff-scoped review (default fast path) |
| `--repo` | Whole-repo review — every source file, not just the diff (conformance pass) |
| `--blueprint <skill>` | Judge architecture + ui-ux against a named blueprint skill (e.g. `local-first-app`), not the nearest sibling. Implies `--repo` unless a diff scope is also given |
| `--background` | Run detached in a git worktree; keep working while it reviews (see [Background mode](#background-mode)) |
| `--nits` | Also surface the suppressed hygiene/nit bucket. Off by default |

## Pipeline

```
detect scope → dispatch reviewers (parallel Agent) → verifier (1 Agent) → synthesize → REVIEW.md
```

The lanes (full prompts in **[reference/AGENTS.md](./reference/AGENTS.md)** — load when dispatching):

| Lane | Owns | Blocking? |
|------|------|-----------|
| **correctness** | wrong answers: boundary/off-by-one (dates, DST, month-end), tz/locale bucketing, money/rate math, swallowed errors, non-atomic writes, unterminated loops, discarded async results, null/degenerate inputs | yes — top priority |
| **architecture** | structural soundness *for the code's purpose*: wrong persistence/idempotency semantics, missing resilience the op needs, broken invariants, dropped load-bearing context, egregious complexity (4+ nesting levels, ~cyclomatic >10) that conceals behavior. Not "peer differs" | yes |
| **testing** | coverage of the change + assertion strength (membership vs exact, weak truthiness, mocked oracles) | yes |
| **ui-ux** | readability/a11y vs the typography + color-system floors (prose below 16px, contrast <4.5:1, color-as-only-signal, missing focus/label). **Dispatched only when the scope touches UI** | yes (conditional) |
| **hygiene** | one non-blocking sweep: secrets, dead code, typos, doc/dep drift, readability + moderate-complexity nits | no — suppressed unless `--nits`; a real `[Secret]` always surfaces |

## Phase 1: Scope detection

Parse flags first. Resolve files to review, in priority order: `--repo` (all source under the repo, minus the excludes below) → explicit path arg → `--staged` (`git diff --cached`) → `--branch <base>` (`git diff <base>...HEAD`) → default (staged + unstaged, `git status --porcelain` + `git diff HEAD`) → fallback (feature branch, nothing dirty: `git diff main...HEAD`).

**Filter out** binary/image assets, generated files, build/dependency/venv output. **Do NOT filter** lockfiles, package manifests, env templates, or project docs — `hygiene` needs them. **Detect UI scope:** if the file list includes components/templates/styles/design-token files, include the **ui-ux** lane; otherwise skip it.

Dispatch only once you hold a concrete file list **and** the diff text (for `--repo`, the "diff" is the full current content of the in-scope files), because reviewer subagents start with no conversation context and can read nothing you didn't pass them. Report scope to the user first ("Reviewing N files: …"). If scope is empty in a diff mode, stop rather than inventing work. (`--repo` is never empty; that's its purpose.)

## Phase 2: Parallel dispatch

**Send the reviewer Agent calls in a single message** so they run concurrently; `subagent_type: Explore` for all (read-only). Always dispatch **correctness, architecture, testing, hygiene**; add **ui-ux** only if UI scope was detected. Each prompt includes the file list + diff, the lane and what to ignore, the output format, and demands `file:line` specificity. Use the exact skeletons in [reference/AGENTS.md](./reference/AGENTS.md). When `--blueprint <skill>` is set, load that skill and pass its name/rules into the architecture and ui-ux prompts.

## Phase 2.5: Verification + impact floor

Dispatch **one verifier** (single Agent, `Explore`) with the file list, diff, and merged candidates. Full prompt: [reference/AGENTS.md#verifier](./reference/AGENTS.md). It is a **signal filter**, not just a false-positive filter:

- **Evidence:** re-read each finding's cited `file:line`; if the citation is wrong, DROP.
- **Impact floor:** a surviving finding must name a *concrete bad outcome* it prevents (wrong result, data loss, security, real regression, genuine reader-trap). If the worst realistic outcome is cosmetic/stylistic/doc-only/"inconsistent but nothing breaks", it FAILS the floor → routed to the nit bucket (if tagged `[Nit]`) or DROPPED. **When in doubt about impact, DROP.**
- **Severity** by blast radius is authoritative (replaces the lane's).
- **STRENGTHS:** the verifier lists 2-4 things the code does right that it *confirmed by reading*, each tied to the file or line where it checked — grounded praise flips the felt tone from nitpicking to reviewing; ungrounded praise reads as filler.

The verifier returns: STRENGTHS, the "what to fix first" distillation (3-6 items), the kept blocking findings at re-rated severities, a NITS section (only if `--nits`), and `Verifier summary: kept N blocking of M; dropped J (W wrong-evidence, L low-impact); H nits held.`

## Phase 3: Synthesis

The verifier already judged evidence, impact, and priority — synthesis only formats:

1. Render **`## What the repo does well`** (the STRENGTHS block) first, if present.
2. Render **`## What to fix first`** next, each the verifier's one-line `path:line — why it matters`, in order. If it returned `Nothing blocking — only polish remains.`, render that single line.
3. Group kept findings by **re-rated** severity (Critical → Major → Minor), then by file. Apply the verifier's severity as-is; keep any `Verifier note:`. A `[Secret]` finding always appears (Critical).
4. **Nits:** only if `--nits` was passed, render a `## Nit` block grouped by file, terse one-liners. Otherwise omit entirely — the summary line still reports how many were held.
5. Dedupe: if multiple lanes flag the same line, keep the most severe and note the lanes.
6. **Write to `REVIEW.md` at the repo root** (`git rev-parse --show-toplevel`) with Write, overwriting. Print one chat line: `REVIEW.md written — X Critical, Y Major, Z Minor; H nits held (--nits to show)`.

Always write REVIEW.md even when clean (zeroed header + the STRENGTHS block + `Nothing blocking — only polish remains.`). **Synthesizer scope is structural** — no fresh findings, no re-judging, no dumping the report into chat.

## Background mode

`--background` runs the review detached so the user keeps working. Orchestrate it from the thread that owns the review — usually the main thread, but a delegated agent works too, since subagents spawn subagents up to three levels deep.

1. The orchestrator resolves scope + captures the diff text (Phase 1), prints `Reviewing N files in the background — keep working; REVIEW.md will appear when done.`
2. Dispatch each reviewer with `run_in_background: true`, `isolation: "worktree"`, and **no `name`** — a clean pinned checkout so the user's concurrent edits don't move `file:line` under the reviewers. Reviewers stay read-only, so the worktree auto-cleans.
3. The orchestrator returns control; the harness re-invokes it as each reviewer completes.
4. When all reviewers are in, dispatch the verifier (background).
5. On completion, write REVIEW.md to the **real repo root** (`git rev-parse --show-toplevel` of the working tree the review was scoped to — reviewer worktrees are torn down), which is the "done" signal.

Reviewers read the diff **from the prompt**, never by re-running `git diff` in the worktree (it shares HEAD with a clean tree — no unstaged changes to see). `--repo --background` is the sweet spot: a multi-minute whole-repo conformance pass that doesn't block you.

## Output format

`REVIEW.md` at repo root, section order: **header** (`Generated` / `Scope` / `Lanes` / `Verifier: kept N blocking of M; dropped …; H nits held` / `Total`) → **`## What the repo does well`** → **`## What to fix first`** → **`## Critical` → `## Major` → `## Minor`** (blocks: `[lane]` `line` — issue, risk/evidence + fix; re-rated findings carry a `Verifier note:`) → **`## Nit`** (only with `--nits`). Full worked report: **[reference/EXAMPLE-REVIEW.md](./reference/EXAMPLE-REVIEW.md)**.

## Examples

✅ **Good:** reviewer Agent calls in one message → wait → verifier Agent → write REVIEW.md → chat shows only `REVIEW.md written — 1 Critical, 2 Major, 0 Minor; 5 nits held (--nits to show)`. A good correctness finding is specific: `[correctness] src/allowance.ts:42 — detail page shows $10/wk but accrual pays $5/wk forever (rate-row shadowing); trigger: any item with a weekly rate; fix: read the rate from the accrual row, not the display row`.

❌ **Bad:** reviewers dispatched sequentially; the full report dumped into chat instead of REVIEW.md; a kept finding like "consider renaming this variable" (no concrete bad outcome — should have failed the impact floor); the nit tail shown by default and drowning the two findings that matter.

✅ **Scope detection, backend-only diff:** no components, styles or token files in the list → ui-ux lane skipped, four lanes dispatched. Empty diff scope → stop and say so rather than widening to `--repo`.

❌ **Bad:** ui-ux dispatched on a CLI-only diff, then its findings kept because they were technically true.

✅ **A verifier DROP working correctly:** `[architecture] src/db.ts:88 — differs from the pattern in src/cache.ts`. No stated consequence → fails the impact floor → DROPPED, counted in `dropped J (L low-impact)`.

## Quality signals

- Reviewer Agent calls in one turn, then one verifier Agent before synthesis.
- The report leads with `## What the repo does well` + `## What to fix first`; the nit tail is hidden unless `--nits`.
- Every kept finding names a concrete bad outcome; correctness findings name a triggering input.
- Architecture findings argue from the code's *purpose* (a real consequence), not "a sibling differs."
- Severities reflect the verifier's impact judgment; low-impact truths are dropped, not demoted-and-kept.
- REVIEW.md is the deliverable (chat gets one line), overwritten in place.

## Gotchas

- **Never pass `name` on a lane dispatch.** Naming an agent makes it a teammate, and a teammate cannot spawn teammates — inside a delegated review the whole batch is rejected with `Teammates cannot spawn other teammates`. It retries and recovers, but it costs a round-trip per lane. The lanes are never addressed by name, so leave the parameter off.
- **A worktree reviewer sees a clean tree.** The `isolation: "worktree"` checkout shares HEAD, so `git diff` inside it returns nothing. Reviewers read the diff from their prompt; never let a lane re-derive it.
- **`--repo` mode has no diff.** What the lanes receive is full file content, so a lane hunting `+` lines returns NO FINDINGS on real problems. Pass the mode into the prompt so lanes review whole files.
- **Dropped findings are the product, not a bug.** The verifier deletes true-but-trivial findings on purpose; `--nits` is the recovery path, and there is no demote-and-keep tier to fall back on.
- **The ui-ux lane is conditional.** If it fires on a backend/CLI diff, Phase-1 UI detection matched a non-UI file — fix detection rather than accepting the lane's noise.
- **Complexity is two-tier by design.** Egregious complexity (4+ nesting levels, ~cyclomatic >10) that conceals behavior blocks via the architecture lane and must name the trap — which path a future editor misses and what breaks. Moderate complexity is hygiene's `[Nit]`. A complexity finding with no named trap failing the impact floor is the floor working, not a lost finding.
- **Architecture findings drift back to "a peer differs."** That bar was removed in 2.0; a finding without a stated consequence should have been dropped, so re-dispatch the lane with its exact prompt.
- **REVIEW.md is overwritten every run** and written at the true repo root (`git rev-parse --show-toplevel`, not a worktree). The prior review is gone — add it to `.gitignore`.

## Troubleshooting

- **Still too nitpicky** — the verifier isn't enforcing the impact floor. Re-dispatch it with the [reference/AGENTS.md#verifier](./reference/AGENTS.md) prompt verbatim and "default to DROP; every kept finding must name a concrete bad outcome."

Empty scope, huge diffs, blueprint not found, worktree cleanup: **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.

## Integration

Pairs with `/security-review` (security), `/review` (fetching an open PR by number), `track-session` (track fixes), `typography` + `color-system` (the ui-ux lane's standard), and blueprint skills like `local-first-app` via `--blueprint`. Typical loop: edit → `/code-review` → read REVIEW.md, fix what's first → re-run (overwrites) → commit when clean. For a big pass, `/code-review --repo --blueprint <skill> --background` and keep working. **Reviewing incoming PRs:** check each PR out into its own worktree and run `--branch <base>` there, one delegated agent per PR — REVIEW.md lands in that worktree's root, so several PRs review concurrently without colliding. Add `REVIEW.md` to `.gitignore`. Not a replacement for CI linting or human PR review — a pre-commit pass that catches wrong answers linters miss. **Maintainers:** activation triggers are measured in **[reference/EVAL.md](./reference/EVAL.md)**; lane quality is measured against representative diffs (clean / real correctness bug / tempting nitpick). Re-run both after every prompt edit.
