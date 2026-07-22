---
name: code-review
description: Use this skill whenever the user wants a multi-agent review of local changes — triggers include "review my code", "review these changes", "do a code review", or "check my changes before I commit". Writes REVIEW.md. Do NOT use for an open PR by number (use /review) or a security-specific pass (use /security-review).
license: MIT
argument-hint: "[path | --staged | --branch <base>]"
allowed-tools: Read, Write, Glob, Grep, Bash, Agent
metadata:
  author: Antonin Januska
  version: "1.6.1"
---

# Code Review — Multi-Agent Local Review

Runs five narrow-lane reviewer agents in parallel, then a verifier pass that keeps only evidence-backed findings, re-rates each by real impact, and distills the "fix first" shortlist — merged into `REVIEW.md` at the repo root, sorted by severity. **Core principle:** narrow-scope reviewers find more real issues than one broad reviewer covering everything. The skill only scopes, dispatches, and renders — the reviewers and verifier do all the judging.

**Model tier:** Opus or Sonnet for the agents; Haiku needs more guidance. **Not for:** security passes (`/security-review`), open PRs by number (`/review`), or trivial one-line/doc changes.

## Pipeline

```
detect scope → dispatch 5 reviewers (parallel Agent) → verifier (1 Agent) → synthesize → REVIEW.md
```

The five reviewers, each in a tight lane (full prompts in **[reference/AGENTS.md](./reference/AGENTS.md)** — load when dispatching):

| Lane | Owns | Out of scope |
|------|------|--------------|
| **basics** | unused/dead code, stale comments, leftover debug stmts, typos, orphaned new symbols (declared + used in-file but no external call site) | architecture, naming, tests, readability |
| **architecture** | pattern fit with siblings (**must read 3-5 sibling files first**) + structural holes: swallowed errors, missing retry/timeout, context not threaded | hygiene, naming, tests, design-health (`/simplify`) |
| **clarity** | readability, naming, function length, nesting; same-scope pre-existing issues → `[Pre-existing]` | unused code, arch, tests, design-health |
| **testing** | coverage of the change + assertion strength (membership vs exact, weak truthiness, mocked oracles) | test-file organization, prod code quality |
| **repo-hygiene** | secrets, env-var doc drift, manifest/lockfile alignment, README/CLAUDE.md/AGENTS.md drift (**reads manifests, lockfiles, .env.example, docs**) | code-level cleanups, arch, tests, readability |

## Phase 1: Scope detection

Resolve files to review, in priority order: explicit path arg → `--staged` (`git diff --cached`) → `--branch <base>` (`git diff <base>...HEAD`) → default (staged + unstaged, `git status --porcelain` + `git diff HEAD`) → fallback (on a feature branch with nothing dirty, `git diff main...HEAD`).

**Filter out** binary/image assets, generated files, build/dependency/venv output. **Do NOT filter** lockfiles, package manifests, env templates, or project docs — `repo-hygiene` needs them (the other lanes skip them by definition; pass the full list to all five).

Before dispatching, you MUST have a concrete file list + the diff text, and report the scope to the user ("Reviewing N files: …"). If scope is empty, stop — don't invent work.

## Phase 2: Parallel dispatch

**Send all five Agent calls in a single message** so they run concurrently; use `subagent_type: Explore` for all (read-only traversal). Each prompt includes the file list + diff, states the lane and what to ignore, specifies the output format, and demands `file:line` specificity. Use the exact skeletons in [reference/AGENTS.md](./reference/AGENTS.md) — each agent returns findings as `[SEVERITY] path:line` blocks or `NO FINDINGS`.

## Phase 2.5: Verification + impact re-rating

After all five return, dispatch **one verifier** (single Agent, `Explore`) with the file list, diff, and merged candidates. Full prompt: [reference/AGENTS.md#verifier](./reference/AGENTS.md). It runs two stages, then distills:

**Stage 1 — Evidence.** Re-read each finding's cited `file:line` against current code:
- **Holds** → carry into Stage 2.
- **Thin** → tag `[Unverified]`, demote one tier (Critical→Major→Minor→Nit→drop), add a `Verifier note:`. Skips Stage 2.
- **Drop** → citation doesn't hold; remove (count only).

**Stage 2 — Impact** (evidence-holds findings only). Re-rate by real blast radius on *this* change, independent of the lane reviewer's severity (each saw only its own lane): **promote** under-rated findings, **demote** over-rated ones. The re-rated severity is **authoritative** and replaces the lane reviewer's; a `Verifier note:` records the reasoning whenever severity moves; the original is not shown. `[Pre-existing]` findings keep their tag and are **never** promoted into the blocking buckets — they stay informational.

**Distillation — "what to fix first".** Select what to address before shipping (every Critical + highest-impact Majors; 3-6 items), returned as an ordered `path:line — why it matters` list. If only Minor/Nit survive: `Nothing blocking — only polish remains.`

The verifier returns the distillation block, the kept findings (agents' format, at re-rated severities), and a summary line: `Verifier summary: kept N of M; promoted P; demoted K; dropped J` (`demoted` = Stage-1 thin demotions + Stage-2 lowers, combined). The evidence stage mirrors Anthropic's two-stage filter; Datadog reports a 60%→13% false-positive reduction with it.

## Phase 3: Synthesis

The verifier already judged evidence, severity, and priority — synthesis only formats what it returned:

1. Render the distillation as `## What to fix first` at the **top** (above `## Critical`), each item the verifier's one-line `path:line — why it matters`, in order. If it returned `Nothing blocking — only polish remains.`, render that single line.
2. Parse each kept finding into a structured entry; group by the verifier's **re-rated** severity (Critical → Major → Minor → Nit), then a separate **Pre-existing** bucket at the bottom; within each, group by file path.
3. Annotate each finding with the lane that surfaced it; apply the verifier's final severity as-is; keep any `[Unverified]` tag + `Verifier note:`. Don't show the lane reviewer's original severity.
4. Dedupe: if multiple lanes flag the same line, keep the most severe and note all lanes.
5. **Group all nits under their file path** in one `## Nit` block, terse one-liners, no cap.
6. **Write to `REVIEW.md` at the repo root** (`git rev-parse --show-toplevel`) with the Write tool, overwriting any existing one. Then print a chat one-liner: `REVIEW.md written — X Critical, Y Major, Z Minor, W Nit, P Pre-existing`.

Always write REVIEW.md even when clean (zeroed header + `All five reviewers returned NO FINDINGS. Ship it.`). **Synthesizer scope is structural, not editorial** — no fresh findings, no re-judging severity, no rewordings, no dumping the report into chat. Anything beyond render/parse/group/dedupe/write belongs to the verifier.

## Output format

`REVIEW.md` at repo root, section order: **header** (`Generated` / `Scope` / `Agents` / `Verifier: kept N of M; promoted P; demoted K; dropped J` / `Total findings`) → **`## What to fix first`** → **`## Critical` → `## Major` → `## Minor`** (full blocks: `[lane]` `line` — issue, then risk/evidence + fix sub-bullets, grouped by file; re-rated and `[Unverified]` findings carry a `Verifier note:`) → **`## Nit`** (grouped by file, no cap) → **`## Pre-existing`** (informational) → **`Agents that found nothing:`** footer.

Full worked report (promoted finding, distillation, grouped nits, clean-report form): **[reference/EXAMPLE-REVIEW.md](./reference/EXAMPLE-REVIEW.md)**.

## Example

✅ **Good:** all five Agent calls in one message → wait for all → verifier Agent → write REVIEW.md → chat shows only `REVIEW.md written — 2 Critical, 1 Major, 4 Minor, 3 Nit`. A good finding is specific: `[Major] src/lib/fetch-user:42 — new timeout error path has no test; risk: silent retry-loop exit loses the request; fix: add "retries once on timeout" test asserting the retry counter`.

❌ **Bad:** agents dispatched sequentially (wastes time — they're independent); the full report dumped into chat instead of REVIEW.md; a finding like "could use more tests, consider error cases" (no file:line, no risk, no fix); lanes bleeding into each other (`basics` flagging naming, `clarity` flagging an unused import) — duplicates findings and dilutes attribution.

## Quality signals

- Five Agent calls in one turn, then one verifier Agent before synthesis.
- `## What to fix first` sits at the top; severities reflect the verifier's **impact** re-rating (moves carry a `Verifier note:`), not the lane.
- Every finding has `file:line`, a concrete fix, and evidence the verifier confirmed.
- Architecture findings cite siblings; repo-hygiene findings cite the actual manifest/`.env.example`/lockfile read.
- Nits grouped by file (no cap); pre-existing in its own bucket, never promoted; clean code gets "Ship it."
- REVIEW.md is the deliverable (chat gets one line), overwritten in place — one current review, no history.

## Troubleshooting

- **Agent returns vague findings** — prompt was paraphrased. Re-dispatch that one agent with the exact skeleton from `reference/AGENTS.md` + "no preamble, no summary — only findings in the specified format."
- **Architecture agent didn't read siblings** — no sibling refs in its output. Re-dispatch with "MANDATORY FIRST STEP" capitalized and first; list specific sibling candidates.

Lane overlap, env-var false positives, fixture vs real-secret, empty scope, huge diffs, verifier kept-everything, empty "what to fix first": **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.

## Integration

Pairs with `/security-review` (security concerns), `/review` (open PRs), `track-session` (track fixes), `ideal-react-component` (React findings). Typical loop: edit → `/code-review` → read REVIEW.md, fix Critical/Major → re-run (overwrites) → commit when clean or only nits remain. Add `REVIEW.md` to `.gitignore`. Not a replacement for CI linting, static analysis, or human PR review — it's a pre-commit pass that catches what linters and humans miss. **Maintainers:** keep an `evals/` dir with representative diffs (clean / real bug / tempting false positive); re-run after every prompt edit.
