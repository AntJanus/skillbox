# Code Review — Worked REVIEW.md Example

Full output example for the `code-review` skill. SKILL.md keeps a compact skeleton inline; this is the long-form rendering, showing the STRENGTHS block, the `## What to fix first` distillation, a correctness finding leading the report, and the nit tail held back by default. Header counts use placeholders (`N`/`M`/`X`…) because they depend on the actual run.

The report is written to `REVIEW.md` at the repo root, always — even when clean.

## Full report (findings present)

```markdown
# Code Review

**Generated:** YYYY-MM-DD HH:MM
**Scope:** N files (list)
**Lanes:** correctness, architecture, testing, ui-ux, hygiene
**Verifier:** kept N blocking of M; dropped J (W wrong-evidence, L low-impact); H nits held
**Total:** X Critical, Y Major, Z Minor

---

## What the repo does well

- Pure calculation core has zero framework/db imports (verified: no `next`/`react`/`sqlite` in `src/core`)
- The new 429 branch is actually tested (saw the case in `tests/retry.test.ts:88`)
- Money is handled in integer cents throughout `src/billing`, not floats

## What to fix first

1. `src/allowance.ts:42` — detail page shows $10/wk but accrual pays $5/wk forever (rate-row shadowing)
2. `src/schedule.ts:71` — a 0-minute duration makes the render loop never terminate (page hangs)
3. `src/db/schema.ts:19` — `ON DELETE CASCADE` on a document child silently deletes vault records

## Critical

### src/allowance.ts

- **[correctness]** `line 42` — Detail page displays a different rate than what accrues
  - Trigger: any item whose weekly rate was edited after creation
  - Wrong result: UI shows $10/wk while the accrual job pays $5/wk indefinitely — the user is misled about what they'll receive
  - Fix: read the rate from the accrual row, not the (stale) display row

### src/schedule.ts

- **[correctness]** `line 71` — Render loop can never terminate
  - Trigger: `durationMinutes === 0` (a valid saved value)
  - Wrong result: `while (current < end)` with a zero step never advances; the request hangs and ties up the worker
  - Fix: guard `durationMinutes > 0`, or advance by at least one slot per iteration

## Major

### src/db/schema.ts

- **[architecture]** `line 19` — Wrong delete semantics for a document vault
  - Intent: a vault keeps documents even when a parent folder is removed (that's the point of a vault)
  - Consequence: `ON DELETE CASCADE` silently deletes the child documents when a folder row goes — data loss the user never asked for
  - Fix: `ON DELETE SET NULL` (orphan, don't destroy), matching the vault's purpose

### src/api/import.ts

- **[testing]** `line 58` — New timeout error path has no test
  - Risk: on a slow upstream the retry loop exits silently and the import is dropped with a success status
  - Fix: add a test that simulates the timeout and asserts the retry counter + surfaced error

## Minor

### src/ui/SummaryCard.tsx

- **[ui-ux]** `line 33` — Computed result rendered at `size="xs"` (~12px)
  - Standard: typography readability floor is 16px for prose the user must read
  - Who it harms: everyone, low-vision users most; this is the sentence stating the actual result
  - Fix: drop the `size` prop (inherit body 16px); keep small tokens for the caption only

---

**Lanes that found nothing:** <list or "none">
_H nits held — re-run with `--nits` to show dead code, typos, and doc drift._
```

## Clean report (still write REVIEW.md)

```markdown
# Code Review

**Generated:** YYYY-MM-DD HH:MM
**Scope:** N files
**Lanes:** correctness, architecture, testing, hygiene
**Verifier:** kept 0 blocking of M; dropped J (W wrong-evidence, L low-impact); H nits held

## What the repo does well

- <2-4 verified strengths, if any>

Nothing blocking — only polish remains.
```

## Chat-side one-liner after writing the file

```
REVIEW.md written — 2 Critical, 2 Major, 1 Minor; 5 nits held (--nits to show).
```
