---
name: code-review
description: Use this skill whenever the user wants a multi-agent review of local changes — triggers include "review my code", "review these changes", "do a code review", "check my changes before I commit", "review the whole repo", or "review this in the background". Prioritizes correctness over nitpicks; writes REVIEW.md. Do NOT use for an open PR by number (use /review) or a security-specific pass (use /security-review).
license: MIT
argument-hint: "[path | --staged | --branch <base> | --repo [--blueprint <skill>]] [--background] [--nits]"
allowed-tools: Read, Write, Glob, Grep, Bash, Agent
metadata:
  author: Antonin Januska
  version: "2.0.0"
---

# Code Review — Multi-Agent Local Review

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
| **architecture** | structural soundness *for the code's purpose*: wrong persistence/idempotency semantics, missing resilience the op needs, broken invariants, dropped load-bearing context. Not "peer differs" | yes |
| **testing** | coverage of the change + assertion strength (membership vs exact, weak truthiness, mocked oracles) | yes |
| **ui-ux** | readability/a11y vs the typography + color-system floors (prose below 16px, contrast <4.5:1, color-as-only-signal, missing focus/label). **Dispatched only when the scope touches UI** | yes (conditional) |
| **hygiene** | one non-blocking sweep: secrets, dead code, typos, doc/dep drift, readability nits | no — suppressed unless `--nits`; a real `[Secret]` always surfaces |

## Phase 1: Scope detection

Parse flags first. Resolve files to review, in priority order: `--repo` (all source under the repo, minus the excludes below) → explicit path arg → `--staged` (`git diff --cached`) → `--branch <base>` (`git diff <base>...HEAD`) → default (staged + unstaged, `git status --porcelain` + `git diff HEAD`) → fallback (feature branch, nothing dirty: `git diff main...HEAD`).

**Filter out** binary/image assets, generated files, build/dependency/venv output. **Do NOT filter** lockfiles, package manifests, env templates, or project docs — `hygiene` needs them. **Detect UI scope:** if the file list includes components/templates/styles/design-token files, include the **ui-ux** lane; otherwise skip it.

Before dispatching, you MUST have a concrete file list + the diff text (for `--repo`, the "diff" is the full current content of the in-scope files), and report scope to the user ("Reviewing N files: …"). If scope is empty in a diff mode, stop — don't invent work. (`--repo` is never empty; that's its purpose.)

## Phase 2: Parallel dispatch

**Send the reviewer Agent calls in a single message** so they run concurrently; `subagent_type: Explore` for all (read-only). Always dispatch **correctness, architecture, testing, hygiene**; add **ui-ux** only if UI scope was detected. Each prompt includes the file list + diff, the lane and what to ignore, the output format, and demands `file:line` specificity. Use the exact skeletons in [reference/AGENTS.md](./reference/AGENTS.md). When `--blueprint <skill>` is set, load that skill and pass its name/rules into the architecture and ui-ux prompts.

## Phase 2.5: Verification + impact floor

Dispatch **one verifier** (single Agent, `Explore`) with the file list, diff, and merged candidates. Full prompt: [reference/AGENTS.md#verifier](./reference/AGENTS.md). It is a **signal filter**, not just a false-positive filter:

- **Evidence:** re-read each finding's cited `file:line`; if the citation is wrong, DROP.
- **Impact floor:** a surviving finding must name a *concrete bad outcome* it prevents (wrong result, data loss, security, real regression, genuine reader-trap). If the worst realistic outcome is cosmetic/stylistic/doc-only/"inconsistent but nothing breaks", it FAILS the floor → routed to the nit bucket (if tagged `[Nit]`) or DROPPED. **When in doubt about impact, DROP.**
- **Severity** by blast radius is authoritative (replaces the lane's).
- **STRENGTHS:** the verifier lists 2-4 things the code does right that it *confirmed by reading* — this proves comprehension and flips the felt tone from nitpicking to reviewing.

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

`--background` runs the review detached so the user keeps working. **It must be orchestrated from the main thread, not by running the skill as one subagent — a subagent cannot spawn the reviewers.**

1. Main resolves scope + captures the diff text (Phase 1), prints `Reviewing N files in the background — keep working; REVIEW.md will appear when done.`
2. Dispatch each reviewer with `run_in_background: true` and `isolation: "worktree"` — a clean pinned checkout so the user's concurrent edits don't move `file:line` under the reviewers. Reviewers stay read-only, so the worktree auto-cleans.
3. Main returns control; the harness re-invokes it as each reviewer completes.
4. When all reviewers are in, dispatch the verifier (background).
5. On completion, main writes REVIEW.md to the **real repo root** (`git rev-parse --show-toplevel` of the main tree — worktrees are torn down), which is the "done" signal.

Reviewers read the diff **from the prompt**, never by re-running `git diff` in the worktree (it shares HEAD with a clean tree — no unstaged changes to see). `--repo --background` is the sweet spot: a multi-minute whole-repo conformance pass that doesn't block you.

## Output format

`REVIEW.md` at repo root, section order: **header** (`Generated` / `Scope` / `Lanes` / `Verifier: kept N blocking of M; dropped …; H nits held` / `Total`) → **`## What the repo does well`** → **`## What to fix first`** → **`## Critical` → `## Major` → `## Minor`** (blocks: `[lane]` `line` — issue, risk/evidence + fix; re-rated findings carry a `Verifier note:`) → **`## Nit`** (only with `--nits`). Full worked report: **[reference/EXAMPLE-REVIEW.md](./reference/EXAMPLE-REVIEW.md)**.

## Example

✅ **Good:** reviewer Agent calls in one message → wait → verifier Agent → write REVIEW.md → chat shows only `REVIEW.md written — 1 Critical, 2 Major, 0 Minor; 5 nits held (--nits to show)`. A good correctness finding is specific: `[correctness] src/allowance.ts:42 — detail page shows $10/wk but accrual pays $5/wk forever (rate-row shadowing); trigger: any item with a weekly rate; fix: read the rate from the accrual row, not the display row`.

❌ **Bad:** reviewers dispatched sequentially; the full report dumped into chat instead of REVIEW.md; a kept finding like "consider renaming this variable" (no concrete bad outcome — should have failed the impact floor); the nit tail shown by default and drowning the two findings that matter.

## Quality signals

- Reviewer Agent calls in one turn, then one verifier Agent before synthesis.
- The report leads with `## What the repo does well` + `## What to fix first`; the nit tail is hidden unless `--nits`.
- Every kept finding names a concrete bad outcome; correctness findings name a triggering input.
- Architecture findings argue from the code's *purpose* (a real consequence), not "a sibling differs."
- Severities reflect the verifier's impact judgment; low-impact truths are dropped, not demoted-and-kept.
- REVIEW.md is the deliverable (chat gets one line), overwritten in place.

## Troubleshooting

- **Still too nitpicky** — the verifier isn't enforcing the impact floor. Re-dispatch it with the [reference/AGENTS.md#verifier](./reference/AGENTS.md) prompt verbatim and "default to DROP; every kept finding must name a concrete bad outcome."
- **ui-ux lane fired on a backend diff** — scope detection matched a non-UI file as UI. It should dispatch only when components/templates/styles are in scope.
- **Architecture finding reads as "peer differs"** — the lane reverted to consistency-mode. Its finding must state a concrete consequence; if it can't, it should have dropped it.

Empty scope, huge diffs, blueprint not found, worktree cleanup: **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.

## Integration

Pairs with `/security-review` (security), `/review` (open PRs), `track-session` (track fixes), `typography` + `color-system` (the ui-ux lane's standard), and blueprint skills like `local-first-app` via `--blueprint`. Typical loop: edit → `/code-review` → read REVIEW.md, fix what's first → re-run (overwrites) → commit when clean. For a big pass, `/code-review --repo --blueprint <skill> --background` and keep working. Add `REVIEW.md` to `.gitignore`. Not a replacement for CI linting or human PR review — a pre-commit pass that catches wrong answers linters miss. **Maintainers:** keep an `evals/` dir with representative diffs (clean / real correctness bug / tempting nitpick); re-run after every prompt edit.
