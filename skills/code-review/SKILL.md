---
name: code-review
description: Multi-agent code review over local changes. Use when asked to "review my code", "review these changes", "do a code review", "check my changes before I commit", or "give me a thorough review". Writes REVIEW.md.
license: MIT
argument-hint: "[path | --staged | --branch <base>]"
allowed-tools: Read, Write, Glob, Grep, Bash, Task
metadata:
  author: Antonin Januska
  version: "1.4.1"
---

# Code Review - Multi-Agent Local Review

## Overview

Runs five specialized review agents in parallel, each focused on exactly one concern, then runs a verifier pass that keeps only the evidence-backed findings, then merges them into a single report sorted by severity. Keeps each reviewer in its lane so nothing drifts into generic "looks fine" commentary.

**Core principle:** Narrow-scope reviewers find more real issues than one broad reviewer trying to cover everything.

**Model tier:** Designed for Opus or Sonnet-tier models. Haiku may need more guidance — prefer Sonnet+ for the reviewer agents.

## The Five Reviewers

1. **basics** — surface-level hygiene (unused imports, dead code, stale comments, debug statements, orphaned symbols)
2. **architecture** — pattern fit with siblings (must read 3-5 sibling files first; flags structural holes peers would have filled)
3. **clarity** — readability, naming, function length, nesting (focus on what changed; same-scope pre-existing issues surface as `[Pre-existing]`)
4. **testing** — coverage of the change and assertion strength (membership checks, weak truthiness, missing error-path tests)
5. **repo-hygiene** — secrets, env var documentation drift, manifest/lockfile alignment, README/CLAUDE.md/AGENTS.md drift

All five run concurrently as a single `Task` dispatch. A sixth **verifier** pass then filters the merged candidates down to the evidence-backed findings before they reach `REVIEW.md` at the repo root. Full per-lane prompts in [Phase 2](#phase-2-parallel-agent-dispatch); verifier prompt in [Phase 2.5](#phase-25-verification).

## When to Use

**Always use when:**
- User asks to "review my code", "review this diff", "do a code review"
- Before committing a meaningful change (not trivial typo fixes)
- Before opening a PR to flush issues the user would fix anyway
- After a large refactor to catch structural drift

**Useful for:**
- Pre-commit self-review on complex changes
- Catching stale comments and dead code after iteration
- Checking that a change matches surrounding patterns
- Verifying test coverage kept pace with implementation

**Avoid when:**
- Security-specific review is needed — use Claude Code's built-in `/security-review` instead
- Reviewing an open PR by number/URL — use Claude Code's built-in `/review`
- Trivial changes (one-line fixes, config bumps, doc typos) — overkill
- No changes exist yet — nothing to review

## How It Works

```
/code-review [scope]
       │
       ▼
 ┌─────────────────┐
 │ 1. Detect scope │  staged → unstaged → branch diff → explicit path
 └────────┬────────┘
          │
          ▼
 ┌──────────────────────────────────────────────────────┐
 │ 2. Dispatch 5 agents in parallel (Task tool)         │
 │   ├─ basics        (lint-level hygiene)              │
 │   ├─ architecture  (reads siblings first)            │
 │   ├─ clarity       (readability, naming)             │
 │   ├─ testing       (coverage of the change)          │
 │   └─ repo-hygiene  (secrets, env vars, deps, docs)   │
 └────────┬─────────────────────────────────────────────┘
          │
          ▼
 ┌──────────────────────────────────────────────────────┐
 │ 2.5. Verifier pass (single Task)                     │
 │      Re-checks each candidate against actual code,   │
 │      keeps the evidence-backed findings              │
 └────────┬─────────────────────────────────────────────┘
          │
          ▼
 ┌───────────────────────────────────┐
 │ 3. Synthesize → write REVIEW.md   │
 │    at the repo root               │
 └───────────────────────────────────┘
```

All five agents run concurrently. A verifier then keeps the substantiated findings before synthesis. The skill does no review reasoning itself — it only scopes, dispatches, verifies, and merges. The final report is written to `REVIEW.md` at the repo root (overwriting any previous review).

## Phase 1: Scope Detection

**Resolve what files to review, in this priority order:**

1. **Explicit path argument** — if the user passed a path, review that path
2. **`--staged`** — `git diff --cached --name-only` (and contents via `git diff --cached`)
3. **`--branch <base>`** — `git diff <base>...HEAD --name-only`
4. **Default** — staged + unstaged changes (`git status --porcelain` + `git diff HEAD`)
5. **Fallback** — if nothing dirty and on a feature branch, review `git diff main...HEAD`

**Commands used:**
```bash
git status --porcelain              # untracked + modified
git diff --cached --name-only       # staged files
git diff HEAD                       # all unstaged working-tree changes
git diff <base>...HEAD --name-only  # branch diff
```

**Filter out:**
- Binary files, images, and other non-text assets
- Generated files (marked with a generator header, or living under an output directory)
- Files in build output, dependency, or virtual-environment directories

**Do NOT filter out:**
- Dependency lockfiles (`*.lock`, `*-lock.*`, etc.) — `repo-hygiene` needs to see whether they moved with the manifest
- Package manifests (`package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, etc.)
- Env templates (`.env.example`, `.env.sample`) and project docs (`README.md`, `CLAUDE.md`, `AGENTS.md`)

The other four agents skip lockfiles by lane definition; only `repo-hygiene` reads them. Pass the full file list to all five and let each stay in its lane.

**Before proceeding, you MUST:**
- [ ] Have a concrete list of file paths
- [ ] Have the diff text or file contents available
- [ ] Report the scope to the user ("Reviewing N files: X, Y, Z") before dispatching agents

If the scope is empty, stop and tell the user — don't invent work.

## Phase 2: Parallel Agent Dispatch

**Send all five Task tool calls in a single message so they run concurrently.**

Use `subagent_type: Explore` for all five — they are read-only review tasks and Explore is tuned for fast codebase traversal.

Each agent prompt must:
- Include the explicit file list and diff (or instructions to read specific files)
- State the reviewer's lane and what to ignore
- Specify the output format below
- Tell the agent to be specific — file:line, not vague

Each agent has a tight lane. Full prompt skeletons (including the exact output format per agent) live in **[reference/AGENTS.md](./reference/AGENTS.md)** — load it when dispatching.

### Agent 1: basics

**Focus:** Surface-level hygiene. What a linter catches, plus what linters miss.

**Looks for:** unused imports/vars/params, dead code, commented-out blocks, stale comments that contradict the code, `TODO`/`FIXME` drift, leftover debug/trace statements added during development (inline prints, console calls, interactive-debugger hooks), typos in identifiers and strings, **orphaned new symbols** (newly-introduced imports, exported functions, types, or constants with no call site in the codebase — the inverse of "unused": something is referenced inside its file but nothing *outside* uses it, suggesting a dropped wire-up).

**Out of scope:** architecture, naming quality, test coverage, readability, design health.

### Agent 2: architecture

**Focus:** Does the change match existing patterns, AND are there structural holes the patterns would have filled?

**MANDATORY first step:** read 3-5 sibling or similar files before judging. Without that baseline, any architectural comment is just opinion.

**Looks for:** file organization deviations, error-handling style mismatches with siblings, layering violations, abstractions at the wrong level, duplicated abstractions under new names, import direction inconsistencies. **Also flag holes, not just inconsistencies:** swallowed exceptions, fire-and-forget tasks without logged handlers, retry/timeout/fallback missing where siblings have them, context not threaded through where peers thread it (request IDs, correlation IDs, user context).

**Out of scope:** linter-level hygiene, naming within a function, test coverage, design-health judgments (that's `/simplify`'s territory). Consistency with siblings is the bar — not "is this pattern good."

### Agent 3: clarity

**Focus:** Can a new reader understand this without asking questions?

**Looks for:** function length (~40+ lines warrants a look), deep nesting (>3 levels), misleading or too-generic names (`data`, `handle`, `process`), implicit side effects in getter-shaped functions, non-obvious logic with no comment, clever one-liners that would read better as three lines. Review ONLY what changed; don't flag pre-existing issues.

**Out of scope:** unused code, architectural fit, testing, **design health** (over-engineering, duplicate abstractions, unnecessary layers — `/simplify` handles that). Clarity is about a reader's comprehension of what's there, not whether "what's there" should exist.

### Agent 4: testing

**Focus:** Did test coverage keep pace with the change, AND are the existing assertions strong enough to catch regressions?

**Looks for:**
- **Coverage:** new branches/error paths/boundaries without tests, changed behavior where tests still pass but don't exercise the new path, new exported symbols with no direct test, files with no test at all, mocks that let tests pass even when real code is broken, every new error-raising construct the diff introduces (thrown exceptions, returned errors, panics, result/option error cases) without a corresponding test case.
- **Assertion strength:** membership checks (asserting a key or value is *present* rather than that the full structure matches) on parser/API/structured output, field-by-field assertions where asserting the whole structure at once would catch missing *and* extra fields, conditional logic inside assertions that hides unreachable branches (should be split into parametrized cases), generic truthiness/presence checks where a specific expected value is known.

For each changed non-test file, locate the corresponding test file using whatever convention the codebase follows (sibling file, dedicated test directory, or the test framework's naming convention) and read it.

**Out of scope:** test file architecture, test readability beyond assertion strength. If no test file exists for changed production code, that's at least a Major.

### Agent 5: repo-hygiene

**Focus:** The repo's hygiene around the change — secrets, env vars, dependencies, and documentation alignment. Things a linter doesn't catch and a code reviewer often forgets.

**Looks for:**
- **Secrets / credentials:** hardcoded API keys, tokens, passwords, private keys, signed JWTs, connection strings with embedded credentials, OAuth client secrets, real values in committed `.env` files. Run pattern checks for common provider key shapes (AWS, GitHub, Stripe, Slack, GCP service-account JSON, SSH/PGP private-key headers) and language-specific secret accessors (`process.env.X = "..."` rather than reading from env).
- **Env var documentation drift:** every env var the change reads (`process.env.X`, `os.getenv("X")`, `os.environ["X"]`, `ENV["X"]`, `Deno.env.get`, etc.) must appear in `.env.example` (or `.env.sample` / `.env.template`), and ideally be mentioned in `README.md` or `CLAUDE.md` if it's user-configurable. Reverse direction matters too — if a documented env var was removed from code, the docs should follow.
- **Dependencies / lockfiles:**
  - New imports/requires/uses with no entry in the package manifest (`package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, etc.)
  - Manifest changed but the lockfile (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `poetry.lock`, `uv.lock`, `Pipfile.lock`, `go.sum`, `Cargo.lock`, `Gemfile.lock`) wasn't updated in the same diff
  - Removed dependencies still imported somewhere
  - Pinned versions in code disagreeing with the manifest
- **Doc alignment:**
  - `README.md` references commands, flags, files, or features that no longer exist (or aren't yet implemented)
  - `CLAUDE.md` / `AGENTS.md` describes architecture, directories, or commands that the change has shifted
  - Doc-comments / docstrings in source files referring to renamed or removed functions, files, or modules
  - CHANGELOG entries that don't reflect the diff (when CHANGELOG is part of the scope)
  - Public API surface changed without corresponding docs update

**Read these (when present):** the package manifest(s), the matching lockfile(s), `.env.example`, `.env.sample`, `.env.template`, `README.md`, `CLAUDE.md`, `AGENTS.md`, `CHANGELOG.md`, and any `docs/` directory that would normally cover the changed area.

**Out of scope:** code-level cleanups (basics owns), architectural fit (architecture owns), test coverage (testing owns), readability (clarity owns). If a docstring is misleading because it's *unclear*, that's clarity; if it's misleading because the function it documents has moved or been renamed, that's repo-hygiene.

## Phase 2.5: Verification

**After all five agents return, dispatch one verifier agent (single Task, `subagent_type: Explore`) with the file list, the diff, and the merged candidate findings.** The verifier:

1. Re-reads each cited `file:line` against the current code
2. Keeps findings whose evidence holds up
3. Tags unsubstantiated findings as `[Unverified]` and demotes one severity tier (Critical→Major→Minor→Nit→drop) — preserves the paper trail rather than dropping silently
4. Returns kept findings in the agents' format plus a summary line (`Verified N of M; demoted K; dropped J`)

Full verifier prompt: [reference/AGENTS.md](./reference/AGENTS.md#verifier). Mirrors Anthropic's official two-stage filter pattern; Datadog reports a 60%→13% false-positive reduction with this approach.

## Phase 3: Synthesis

**After the verifier returns, merge its kept findings and write REVIEW.md:**

1. Parse each kept finding into a structured entry
2. Group by severity (Critical → Major → Minor → Nit), then add a separate **Pre-existing** bucket at the bottom for findings the agents flagged outside the diff scope
3. Within each severity, group by file path
4. Annotate each finding with which agent surfaced it; if the verifier demoted it, mark it `[Unverified]` and apply the demoted severity
5. Deduplicate: if multiple agents flag the same line, keep the most severe one and note all lanes
6. **Cap nits at 5.** If more than 5 Nits remain after verification, keep the top 5 (most actionable) and collapse the rest into a single closing line: `_…plus N similar nits across <file list>._` This is a primary rule, not a fallback — it keeps reviews actionable. Anthropic's official guidance recommends the same cap.
7. **Write the report to `REVIEW.md` at the repo root using the Write tool** — overwrite any existing REVIEW.md
8. Tell the user the report is at `REVIEW.md` and print a one-line summary to the conversation: `REVIEW.md written — X Critical, Y Major, Z Minor, W Nit, P Pre-existing`

**Always:**
- Write REVIEW.md even when the report is clean (so the user sees a clean report, not missing output)
- Put REVIEW.md at the **repo root** (use `git rev-parse --show-toplevel` to locate it)
- Overwrite in place — there is only ever one current review
- Keep agent findings in the agents' words — synthesis is structural, not editorial

**Synthesizer scope:** parse, group, dedupe, cap nits, write the file. Anything beyond that — fresh findings, rewordings, dropping things you disagree with, dumping the full report into the chat — belongs to a different role.

## Output Format

**Target file:** `REVIEW.md` at the repo root. Always written, even when clean.

```markdown
# Code Review

**Generated:** YYYY-MM-DD HH:MM
**Scope:** N files (list)
**Agents:** basics, architecture, clarity, testing, repo-hygiene
**Verifier:** kept N of M; demoted K; dropped J
**Total findings:** X Critical, Y Major, Z Minor, W Nit, P Pre-existing

---

## Critical

### src/services/user-service

- **[architecture]** `line 42` — Layering violation
  - Existing pattern: files under `services/*` never import from `routes/*`; see sibling `services/billing-service`
  - This change: imports a route handler from inside a service
  - Fix: move the shared logic into `common/` or invert the dependency

- **[testing]** `line 87` — New error path has no test
  - Risk: if the downstream API returns 429, the retry loop silently exits
  - Fix: add a test case that simulates a 429 response and asserts the retry counter

- **[repo-hygiene]** `line 12` — Hardcoded API key committed
  - Evidence: `STRIPE_KEY = "sk_live_..."` literal in source
  - Risk: secret enters git history; rotate immediately, then move to env
  - Fix: read from `process.env.STRIPE_KEY`, add `STRIPE_KEY=` to `.env.example`, document in README

## Major

### src/api/fetch-user

- **[clarity]** `line 103` — Function `handle` is 78 lines with 4-deep nesting
  - A reader can't follow the early-exit logic; the `else` at line 145 pairs with the `if` at line 105
  - Fix: extract the validation block (lines 110-135) into a named helper

### internal/worker/queue

- **[architecture]** `line 27` — Missing retry where peers have it
  - Existing pattern: `internal/worker/http-client` wraps external calls in the shared retry/backoff helper
  - This change: calls the downstream service once, propagates the error
  - Fix: wrap the call with the same retry/backoff helper siblings use

### package.json

- **[repo-hygiene]** — Manifest changed but lockfile not updated
  - `package.json` adds `pino@^9.0.0`; `package-lock.json` is unchanged in this diff
  - Risk: CI install will resolve a different version than developers; reproducible builds break
  - Fix: run the package manager's install/lock command and commit the lockfile

## Minor
...

## Nit

(Up to 5 most actionable shown.)

- **[basics]** `src/utils/format:14` — Stale TODO from 2024
- **[clarity]** `src/utils/format:42` — Variable `x` could be `formattedValue`
- **[basics]** `src/utils/format:88` — Unused import `lodash/get`
- **[clarity]** `src/api/handler:12` — Comment restates the code
- **[basics]** `tests/format.test:5` — Leftover `console.log`

_…plus 8 similar nits across `src/utils/`, `src/api/`, `tests/`._

## Pre-existing

Issues found outside the change scope. Listed for awareness; not blocking the current change.

- **[architecture]** `src/legacy/auth:200` — Layering violation predates this diff
- **[clarity]** `src/legacy/auth:88` — 200-line function predates this diff

---

**Agents that found nothing:** <list or "none">
```

**When everything is clean (still write REVIEW.md):**
```markdown
# Code Review

**Generated:** YYYY-MM-DD HH:MM
**Scope:** N files
**Verifier:** kept 0 of 0
**Total findings:** 0

All five reviewers returned NO FINDINGS. Ship it.
```

**Chat-side one-liner after writing the file:**
```
REVIEW.md written — 0 Critical, 0 Major, 0 Minor, 0 Nit, 0 Pre-existing. Clean review.
```

## Examples

### Example 1: A good dispatch

✅ **Good:**

```
User: /code-review

Scope: 3 files
  src/components/user-profile
  src/lib/auth
  tests/auth

[Dispatches 5 agents in parallel via Task]
[Waits for all 5 to complete]
[Writes REVIEW.md at repo root]
[Prints one-liner: "REVIEW.md written — 2 Critical, 1 Major, 4 Minor, 3 Nit"]
```

All five agents fire in one message, scope line shown before dispatch, full report lands in REVIEW.md, chat stays terse with a one-line summary.

❌ **Bad:**

```
User: /code-review

[Runs "basics" agent]
[Waits for it to finish]
[Runs "architecture" agent]
[Waits for it to finish]
...
[Dumps entire report into the chat instead of REVIEW.md]
```

Two problems: sequential dispatch wastes time, and dumping the report into the chat bypasses the REVIEW.md artifact. The five agents are independent — send them in a single message. The report belongs in REVIEW.md.

### Example 2: A good agent finding

✅ **Good:**

```
[Major] src/lib/fetch-user:42
Issue: new error path (network timeout) has no test
Risk: timeout → silent retry loop exit; production would lose the request
Fix: add a test case named "retries once on timeout" in the corresponding test file, simulate a timeout at the network layer, and assert the retry counter
```

Specific file:line, concrete risk, actionable fix with a test name.

❌ **Bad:**

```
Could use more tests. Consider adding coverage for error cases.
```

No file, no line, no specific risk, no actionable fix. Agents that produce output like this should be re-prompted with the output format.

### Example 3: Staying in lane

✅ **Good:**

```
[basics]        internal/auth/token:12  Unused import
[clarity]       internal/auth/token:45  Function is 60 lines and hard to follow
[arch]          internal/auth/token:8   Error-handling style doesn't match sibling modules — peers wrap errors with the shared error-chaining helper; this change returns raw errors
[repo-hygiene]  internal/auth/token:22  New env var AUTH_TOKEN_TTL referenced but not added to .env.example or documented in README
```

Four agents each found something distinct in the same file. No overlap, no "also this".

❌ **Bad:**

```
[basics] internal/auth/token:12 Unused import and the function name is also unclear
[clarity] internal/auth/token:45 The function is too long and has an unused import at line 12
```

Basics bleeding into clarity's lane and vice versa. Duplicates the finding and dilutes attribution.

## Quality Signals

A well-run code review has these properties:

- **All five agents dispatched in a single message** — visible as five Task calls in one turn
- **Verifier pass runs after the agents** — visible as one additional Task call before synthesis; its summary line appears in REVIEW.md
- **Scope reported before dispatch** — user sees which files are under review
- **Every finding has file:line** — no "consider reviewing the error handling"
- **Every finding has a concrete fix** — not just the problem
- **Findings are evidence-backed** — each cites concrete code; the verifier kept it because the citation matched
- **Severities are used meaningfully** — not everything is Major
- **Nits cap at 5** — anything beyond that collapses into a single "_…plus N similar nits_" line
- **Pre-existing issues sit in their own bucket** — agents may surface them; they appear at the bottom of REVIEW.md, not mixed with change-focused findings
- **Lane discipline** — each agent stays focused on what it owns; basics covers hygiene, architecture covers fit, clarity covers readability, testing covers coverage, repo-hygiene covers project health
- **Architecture agent actually reads siblings** — you can see the sibling references in its findings
- **repo-hygiene actually reads `.env.example`, manifests, and lockfiles** — you can see those filenames cited in its findings, not just guesses about what's documented
- **Clean code gets "Ship it."** — no manufactured findings to look thorough
- **REVIEW.md is the deliverable** — full report lives in the file at repo root, chat gets a one-line summary
- **REVIEW.md is overwritten in place** — there is only ever one current review, not a history

## Troubleshooting

The three most-common issues are inline. Full troubleshooting catalog in **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)** — load when you hit something not covered below.

### Problem: Agent returns vague findings

**Cause:** Agent drifted from the output format, usually because the prompt was paraphrased.

**Solution:** Re-dispatch that one agent with the exact output format skeleton from `reference/AGENTS.md`. Include the phrase "no preamble, no summary — only findings in the specified format."

### Problem: Architecture agent didn't read siblings

**Cause:** The mandatory-first-step instruction got dropped or softened.

**Solution:** Look at its output — if there are no sibling file references in the findings, re-dispatch with "MANDATORY FIRST STEP" capitalized and first in the prompt body. Consider listing specific sibling candidates in the prompt.

### Problem: Verifier kept everything (no demotions, no drops)

**Cause:** Verifier prompt was paraphrased and lost the substantiation requirement, or the agent findings were already strong enough.

**Solution:** Check the verifier's summary line — if it says `kept N of N; demoted 0; dropped 0` on a large finding set, re-dispatch with the exact verifier prompt from `reference/AGENTS.md#verifier`, emphasizing "re-read the cited line and confirm the issue is present in the current code."

For lane-overlap, env-var false positives, fixture vs real-secret distinction, empty scope, huge diffs, REVIEW.md location, and verifier-demoted findings see **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.

## Integration

**This skill pairs with:**
- Claude Code built-in `/security-review` — run separately for security-specific concerns
- Claude Code built-in `/review` — for reviewing an open PR by URL (this skill targets local changes)
- `track-session` — if review surfaces work to address, a session can track the fixes
- `ideal-react-component` — if React files are under review, findings may reference its patterns

**Recommended follow-up for skill maintainers:** create an `evals/` directory with 3+ representative diff scenarios (e.g., a clean diff, a diff with a real bug, a diff with a tempting false positive). Re-run after every prompt edit — catches regressions in agent or verifier behavior before they ship.

**Typical workflow:**
```bash
# Make changes
[edit files]

# Self-review before committing — writes REVIEW.md at repo root
/code-review

# Open REVIEW.md, read findings, fix critical and major
[edit files]

# Re-run — REVIEW.md is overwritten with the new pass
/code-review

# Commit when REVIEW.md is clean or only nits remain
git commit -m "..."
```

**Tip:** Add `REVIEW.md` to `.gitignore` so the artifact never gets committed.

**Not a replacement for:**
- CI linting (faster, runs on every push)
- Static analysis tools (deeper semantic checks)
- Human review on PRs (judgment calls and product context)

This skill is a pre-commit sanity pass and catches things linters and humans both miss.

## References

- [Claude Code Task tool docs](https://code.claude.com/docs/)
- [obra/superpowers](https://github.com/obra/superpowers) — multi-agent patterns
- SkillBox `generate-skill` — Pattern C (Auditing)
- SkillBox `rate-skill` — severity-based reporting patterns
