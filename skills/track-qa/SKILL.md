---
name: track-qa
description: DEPRECATED 2026-09-01 — QA.md manual-QA checklists were retired portfolio-wide on 2026-08-24 and this skill will be deleted in the next release. Do NOT use this skill for anything, including "create a QA list", "set up QA", "what should I QA", "track manual QA", "audit the QA list", or "what's left to check before release". Hands-on verification (playthroughs, parity gates, release sign-offs) is filed as ordinary ROADMAP.md items instead — use track-roadmap for that, and track-session for cross-session progress.
license: MIT
argument-hint: "[deprecated — do not run]"
metadata:
  author: Antonin Januska
  version: "1.4.0"
---

# Track QA

> **Deprecated 2026-09-01.** Every `QA.md` in the portfolio was deleted by decision on
> 2026-08-24, and the cc-dash `/qa` views read empty by design. Do not run any mode below: do
> not generate, update, audit, migrate, or resume a `QA.md`, and do not refile checklist items.
> A behavior that needs a human to exercise it is filed as one roadmap item (a playthrough, a
> parity gate, a release sign-off) with `track-roadmap`. This file is kept for one release so
> the `cc-dash/qa@1` schema stays documented, then it is removed.

## Overview

Maintain `QA.md` in the project root — the manual checklist of things a human must exercise (visual rendering, multi-step flows, race conditions, real integrations) before a release is ready. Tests prove correctness; QA proves shippability. Don't duplicate test coverage: if a unit or integration test can verify it, write the test instead.

The `cc-dash/qa@1` schema below is machine-parsed, so its markers are exact. Everything else here is guidance to adapt to the project in front of you.

## Workflow

Every mode runs the same three phases: **read** the current state → **propose** a concrete diff → **write** only after the user confirms. The confirm gate matters because a QA list the user didn't agree to is a list nobody runs.

| Mode | Command | What it does |
|------|---------|--------------|
| **Generate** | `/track-qa` or `generate` | Scan for QA-worthy surfaces, ask 4 discovery questions (incl. the Setup command), write QA.md |
| **Update** | `/track-qa update` | Ask what changed, add or remove items — new IDs for new items, existing statuses untouched |
| **Audit** | `/track-qa audit` | Re-evaluate each item against current code; flag stale, obsolete, and missing checks |
| **Migrate** | `/track-qa migrate` | Convert ad-hoc QA notes (CLAUDE.md, README, scratch, QA_BACKLOG.md) into a compliant QA.md |
| **Resume** | `/track-qa resume` | Report pending/passed/failed counts, surface the next pending item |

Bare `/track-qa` means generate. If a QA.md already exists, say so and treat the request as **update** unless the user confirms they want a fresh file — regenerating discards verified history.

Full per-mode procedures (discovery questions, audit signals, migrate steps): **[reference/MODES.md](./reference/MODES.md)**.

## QA.md format

```markdown
---
schema: cc-dash/qa@1
project: project-name-here
last_updated: YYYY-MM-DDTHH:MM:SS-TZ
---

# Manual QA — project-name-here

## Setup

Run: `cd project-name && npm run dev`
(Free-form — multiple commands, env vars, prerequisites all welcome.)

## Checklist

- <!-- id:q_XXXXX status:pending --> One observable behavior, stated as a verifiable claim.
- <!-- id:q_XXXXX status:passed at:YYYY-MM-DDTHH:MM:SS-TZ --> An item that was verified.
- <!-- id:q_XXXXX status:failed at:YYYY-MM-DDTHH:MM:SS-TZ ref:r_xxxxx --> An item that failed.
  > **Note (YYYY-MM-DD):** What was wrong. Filed as r_xxxxx in ROADMAP.md.
- <!-- id:q_XXXXX status:needs-decision at:... --> Blocked on a design conversation.
- <!-- id:q_XXXXX status:skipped at:... --> Intentionally bypassed (e.g., env-dependent).
```

**Format rules** — the dashboard parser reads these markers literally, so a malformed item is silently dropped:

- Frontmatter requires `schema`, `project`, `last_updated`.
- Every item carries `q_` + 5 random `[a-z0-9]` (**permanent**) and a status: `pending | passed | failed | needs-decision | skipped`.
- Non-pending items record `at:` (ISO timestamp); failed items record `ref:r_xxxxx` (the roadmap issue filed).
- Notes are blockquotes immediately after the item (`  > Note text`).
- Two parsed sections only: `## Setup` (free-form) and `## Checklist`. Other sections round-trip but aren't interpreted.

## Writing QA items

- **One observable behavior** — "settings page persists changes across reload", not "everything in settings works". Composite items hide failures: one sub-check breaks and the note has to enumerate which.
- **Verifiable in under 2 minutes** — split anything longer, because long items get deferred and then skipped.
- **Phrased as a claim to confirm or refute** — "first major upgrade reachable in 10-15 min of play" beats "playtest".
- **Specific to this project** — "test all features" tells the next QAer nothing.
- **Failed items always carry a note** — a `failed` status with no explanation is unactionable a week later.
- **Verify the Setup command actually runs** before the first write; a list whose entry point is broken stalls at item one.
- **Keep the list finishable** — roughly 5–30 items. Past that a QAer can't complete a pass in one sitting, and a pass that never completes stops happening. Audit periodically; QA lists drift as features ship.

## Examples

✅ One observable behavior, under a minute, unambiguous pass/fail, specific to the domain:

```markdown
- <!-- id:q_a1b2c status:pending --> Save a session, reload the page, confirm gold/inventory/equipped items all restore.
```

❌ Unscoped — two QAers would check different things and both would call it done:

```markdown
- <!-- id:q_a1b2c status:pending --> Test save/load.
```

✅ Propose, then write once the user confirms:

```
Read QA.md (8 items). Asked what changed since the last pass.
Proposed 2 new items covering the achievement overlay. Confirm?
→ user: yes → wrote 2 items. Total: 10.
```

❌ Writing unasked, and destroying verification history in the process:

```
Auto-generated 12 items from recent commits.
Reset every passed item to pending because "the codebase changed."
```

✅ A failed item that carries its own evidence:

```markdown
- <!-- id:q_g5h6i status:failed at:2026-07-28T09:12:00-06:00 ref:r_x1y2z --> Theme preference persists across navigation.
  > **Note (2026-07-28):** Reverts to light on the settings route only. Filed as r_x1y2z.
```

Full ✅/❌ walkthroughs for every mode: **[reference/EXAMPLES.md](./reference/EXAMPLES.md)**.

## Gotchas

- **A malformed item vanishes silently.** The parser skips anything not matching `- <!-- id:q_xxxxx status:... --> Description`. When items don't show on a dashboard, check that shape first, then that `schema: cc-dash/qa@1` is exact and QA.md sits in the project root.
- **failed → pending is never automatic.** Completing the linked roadmap item does not flip the QA item back. Re-verify by hand with `/track-qa update`, because "the fix shipped" is not the same claim as "the behavior is right".
- **`q_` IDs are permanent and share no namespace** with `r_`, `t_`, or `i_`. Reusing a deleted item's ID reattaches old dashboard history to an unrelated check.
- **"Passed three months ago" is an unverified fact.** Audit treats a stale pass as a reset candidate — tune the 30-day default to the project's release cadence instead of applying it flat.
- **needs-decision items don't resolve on their own.** They block on a conversation, not on engineering. Surface any older than two weeks during audit and either schedule it, convert it to a concrete pending check, or delete it.
- **Migrate expects per-repo notes or `### project-name` headings.** Other layouts need manual splitting before the mode can do anything useful — ask the user which lines belong to which project rather than guessing.

Extended edge cases (ID collisions, dangling roadmap refs, dashboard discovery caching): **[reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md)**.

## Integration

- **track-roadmap** — a failed QA item files a roadmap issue under a "QA Issues" category; after the fix ships, mark the roadmap item done and reset the QA item to pending.
- **track-session** — drive a focused pass over many QA items at once, referencing item IDs in the session plan.
- **`cc-dash/qa@1` dashboards / MCP** — portfolio queue, inline approve/fail/skip, focus mode at `/project/<slug>/qa?focus=<id>`; tools include `list_qa_pending`, `approve_qa_item`, `fail_qa_item`.
