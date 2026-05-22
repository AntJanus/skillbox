# Code Review — Worked REVIEW.md Example

Full output example for the `code-review` skill. SKILL.md keeps a compact skeleton inline; this is the long-form rendering, showing a promoted finding (with `Verifier note:`), an `[Unverified]` Stage-1 demotion, the `## What to fix first` distillation, and nits grouped by file. Header counts use placeholders (`N`/`M`/`X`…) because they depend on the actual run.

The report is written to `REVIEW.md` at the repo root, always — even when clean.

## Full report (findings present)

```markdown
# Code Review

**Generated:** YYYY-MM-DD HH:MM
**Scope:** N files (list)
**Agents:** basics, architecture, clarity, testing, repo-hygiene
**Verifier:** kept N of M; promoted P; demoted K; dropped J
**Total findings:** X Critical, Y Major, Z Minor, W Nit, P Pre-existing

---

## What to fix first

1. `src/services/user-service:12` — hardcoded Stripe live key in source; rotate and move to env before this ships
2. `src/services/user-service:87` — untested payment-retry path silently drops the charge on a 429
3. `src/services/user-service:42` — service imports a route handler; the layering break peers don't have
4. `internal/worker/queue:27` — downstream call has no retry siblings use; one blip drops the job

## Critical

### src/services/user-service

- **[architecture]** `line 42` — Layering violation
  - Existing pattern: files under `services/*` never import from `routes/*`; see sibling `services/billing-service`
  - This change: imports a route handler from inside a service
  - Fix: move the shared logic into `common/` or invert the dependency

- **[testing]** `line 87` — New error path has no test
  - Risk: if the downstream API returns 429, the retry loop silently exits
  - Fix: add a test case that simulates a 429 response and asserts the retry counter
  - Verifier note: promoted Major→Critical — this path guards payment retries; an untested silent exit loses the charge

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

### src/api/fetch-user

- **[architecture]** `line 58` — [Unverified] Possible duplicate of the validation helper in `src/api/create-user`
  - Existing pattern: `src/api/create-user` has a near-identical `validatePayload`
  - This change: adds a second validator that overlaps but isn't obviously the same
  - Fix: if truly duplicated, extract to `src/api/shared/validate`; otherwise ignore
  - Verifier note: demoted Major→Minor, tagged [Unverified] — the two helpers overlap but the cited line's branching differs enough that "duplicate abstraction" couldn't be confirmed against the code; surfaced at lower severity for the author to judge.

## Nit

Grouped by file, no cap — terse one-liners kept out of the way.

### src/utils/format

- **[basics]** `:14` — Stale TODO from 2024
- **[clarity]** `:42` — Variable `x` could be `formattedValue`
- **[basics]** `:88` — Unused import `lodash/get`

### src/api/handler

- **[clarity]** `:12` — Comment restates the code

### tests/format.test

- **[basics]** `:5` — Leftover `console.log`

## Pre-existing

Issues found outside the change scope. Listed for awareness; not blocking the current change.

- **[architecture]** `src/legacy/auth:200` — Layering violation predates this diff
- **[clarity]** `src/legacy/auth:88` — 200-line function predates this diff

---

**Agents that found nothing:** <list or "none">
```

## Clean report (still write REVIEW.md)

```markdown
# Code Review

**Generated:** YYYY-MM-DD HH:MM
**Scope:** N files
**Verifier:** kept 0 of 0; promoted 0; demoted 0; dropped 0
**Total findings:** 0

All five reviewers returned NO FINDINGS. Ship it.
```

## Chat-side one-liner after writing the file

```
REVIEW.md written — 0 Critical, 0 Major, 0 Minor, 0 Nit, 0 Pre-existing. Clean review.
```
