---
name: track-qa
description: |
  Manual QA tracking — things tests can't verify. Use when asked
  to "create a QA list", "set up QA for this project", "what
  should I QA", "track manual QA", "audit the QA list", or
  "start manual QA".
license: MIT
argument-hint: "[generate|update|audit|migrate|resume]"
metadata:
  author: Antonin Januska
  version: "1.1.0"
---

# Track QA

> **Manual QA tracking activated** — I'll use QA.md to capture and manage the hands-on verification checklist that tests can't cover.

## Overview

Use QA.md in the project root to maintain the manual QA checklist — the items a human has to exercise (visual rendering, multi-step flows, race conditions, integrations) before declaring a release ready. Tools that consume the `cc-dash/qa@1` schema can ingest the file: surface pending items in a portfolio queue, drive approve/fail/skip workflows with notes, and run focused review sessions across many items at once.

**Core principle:** Tests prove correctness; QA proves shippability. Maintain a living, executable checklist of everything tests can't catch, so "ready to ship" is a verifiable state, not a vibe.

## Usage Modes

This skill supports five modes via optional arguments:

| Mode | Command | What it does | Use when |
|------|---------|-------------|----------|
| **Generate** | `/track-qa` or `/track-qa generate` | Interactive QA discovery and QA.md creation | First time setting up manual QA for a project |
| **Update** | `/track-qa update` | Add, remove, or edit QA items in an existing QA.md | New features shipped, QA scope changed |
| **Audit** | `/track-qa audit` | Re-evaluate items against current state; identify stale or obsolete checks | Periodic review, before a release window |
| **Migrate** | `/track-qa migrate` | Convert ad-hoc QA notes (CLAUDE.md, README, scratch files) into a compliant QA.md | First time formalizing QA, or upgrading a v0 list |
| **Resume** | `/track-qa resume` | Read QA.md and report what's pending, what's blocked, what's next | Returning to a project, deciding what to QA next |

## When to Use

**Always use when:**
- A project is approaching a release and needs hands-on verification
- Tests cover the unit/integration layer but visual or end-to-end checks are missing
- An incident revealed a class of bugs that automated tests can't catch
- Multiple repos need a consistent manual-QA cadence (portfolio-level visibility)
- Returning to a project and asking "is this safe to ship?"

**Useful for:**
- TUI / CLI applications where layout, colors, and resize behavior matter
- Game projects where feel, pacing, and edge-case lockups need a play session
- Web apps where dark mode, mobile breakpoints, and progressive enhancement need eyes
- Systems with external integrations (auth, payments, AI APIs) that mock-tests can't fully exercise

**Avoid when:**
- The project has no human-visible surface (a pure library)
- Every check could plausibly be a unit or integration test (write the test instead)
- The project is a one-off script or throwaway prototype

## When to Update

Update QA.md after:
- Shipping a new feature that has a manual-verifiable surface
- Discovering an edge-case bug that tests didn't catch (turn it into a QA item to prevent regression)
- A QA pass identifies items that are now obsolete (remove them)
- The "Setup" command changes (new dev server port, new build step, etc.)

## When to Audit

Run an audit:
- Quarterly (or per release cadence)
- Before declaring a project "Maintenance" status
- After a major refactor (some QA items may be stale; some new ones needed)
- When the QA list has 20+ pending items (likely some are obsolete)

---

## Mode: Generate

**Command:** `/track-qa` or `/track-qa generate`

Creates a new QA.md through an interactive process.

### Phase 1: Discovery

**Step 1 — Codebase scan:**

Examine the project to identify QA-worthy surfaces:
- Frontend / UI code → visual checks, breakpoints, theme switching
- TUI / CLI code → layout, terminal-resize behavior, ANSI rendering
- Game code → core loop playability, save/load, edge-case lockups
- Network or integration code → real-API smoke tests, auth flows, error paths
- File-system or data code → migrations, save corruption recovery

Summarize findings before asking questions.

**Step 2 — Interactive questioning:**

1. **"How does someone run this project locally?"** (the Setup command)
2. **"What does 'ready to ship' look like for this project?"** (the goal QA validates)
3. **"What kinds of bugs have you been bitten by that tests don't catch?"** (history-informed coverage)
4. **"Are there integrations or external services that need a real-environment check?"** (RAWG_API_KEY, OAuth, etc.)

Propose a draft checklist and ask the user to confirm, add, or remove items before writing QA.md.

### Phase 2: Organize and Write

Group related checks into informal sections (categories aren't enforced — items are flat in v1, but you can group them with prose between them). Write QA.md using the format below.

**Verification before writing:**
- [ ] User confirmed the Setup command actually runs
- [ ] Each item is a *single* observable behavior (not multiple)
- [ ] Items focus on what tests can't verify (no "expect X === Y" items)
- [ ] No duplicate or trivially-covered checks

---

## Mode: Update

**Command:** `/track-qa update`

Modifies an existing QA.md.

### Process

1. **Read** the current QA.md
2. **Ask the user** what changed:
   - New features that need QA?
   - Items to remove (obsolete, covered by new tests, etc.)?
   - Setup command needs updating?
3. **Apply changes** and present diff for confirmation
4. **Write** the updated QA.md

### Update Rules

- Generate new IDs for added items (`q_` + 5 random alphanumerics)
- Never reuse an ID, even after deletion
- Don't reset existing items' status when adding new ones — only modify what the user asked

---

## Mode: Audit

**Command:** `/track-qa audit`

Reviews QA.md against the current state of the project.

### Process

1. Read QA.md
2. For each pending item, ask: does this still apply? Does the codebase still have this surface?
3. For each passed item, ask: was this checked in the last 30 days? Should it be re-verified after recent changes?
4. Report: items to remove, items to revisit, items missing from the list
5. Apply changes only after user confirmation

### Audit Signals

- Items referencing files that no longer exist → propose removal
- "Passed" items older than the last release → propose reset to pending
- New features merged since last QA → propose new items
- Items that match a name in the test suite → propose conversion to automated test + removal

---

## Mode: Migrate

**Command:** `/track-qa migrate`

Converts ad-hoc QA notes into a compliant QA.md.

### Process

1. Look for QA-shaped content in: CLAUDE.md, README.md, ROADMAP.md, scratch files, the consolidated `QA_BACKLOG.md` (portfolio-level)
2. Extract each manual-check item; group by repo if pulling from a portfolio file
3. Generate IDs and statuses (default `pending` unless context indicates otherwise)
4. Identify the Setup command from existing run instructions
5. Present the proposed QA.md for review before writing

---

## Mode: Resume

**Command:** `/track-qa resume`

Loads the existing QA.md and reports state.

### Process

1. Read QA.md
2. Report: total items, pending count, passed count, failed count, needs-decision count
3. Surface the next pending item with its description
4. Ask: "Want to start QA on this item?"
5. If yes, link the user to the dashboard focus mode (`/project/<slug>/qa?focus=<id>`) or print the item's full text for in-terminal QA

---

## QA.md Format

```markdown
---
schema: cc-dash/qa@1
project: project-name-here
last_updated: YYYY-MM-DDTHH:MM:SS-TZ
---

# Manual QA — project-name-here

## Setup

Run: `cd project-name && npm run dev`

(Free-form text — multiple commands, env vars, prerequisites all welcome.)

## Checklist

- <!-- id:q_XXXXX status:pending --> One observable behavior, stated as a verifiable claim.
- <!-- id:q_XXXXX status:passed at:YYYY-MM-DDTHH:MM:SS-TZ --> An item that was verified.
- <!-- id:q_XXXXX status:failed at:YYYY-MM-DDTHH:MM:SS-TZ ref:r_xxxxx --> An item that failed.
  > **Note (YYYY-MM-DD):** What was wrong. Filed as r_xxxxx in ROADMAP.md.
- <!-- id:q_XXXXX status:needs-decision at:YYYY-MM-DDTHH:MM:SS-TZ --> An item blocked on a design conversation.
  > **Note:** What needs to be discussed before this can be re-attempted.
- <!-- id:q_XXXXX status:skipped at:YYYY-MM-DDTHH:MM:SS-TZ --> An item intentionally bypassed (e.g., env-dependent).
```

### Format Rules

1. **Frontmatter is required** — `schema`, `project`, `last_updated`
2. **Every item gets an ID** — `q_` + 5 lowercase alphanumeric chars (e.g. `q_a1b2c`)
3. **Every item gets a status** — `pending | passed | failed | needs-decision | skipped`
4. **Non-pending items must record `at`** — ISO timestamp at the time of the transition
5. **Failed items should record `ref:r_xxxxx`** — the roadmap issue filed for the failure
6. **Notes are blockquotes immediately after the item** — `  > Note text`. Multi-paragraph notes use a blank `  >` line as separator.
7. **Two known sections only** — `## Setup` (free-form) and `## Checklist` (parsed). Other sections are preserved through round-trip but not interpreted by the dashboard.
8. **IDs are permanent** — Once assigned, never change an item's ID.

### ID Generation

5 random characters from `[a-z0-9]`. Example: `q_a1b2c`, `q_3xq7z`. IDs live in HTML comments so they don't render in GitHub but parse cleanly.

### Item Style

A good QA item is:
- **One observable behavior** — not "everything in the settings page works" but "the settings page persists changes across reload"
- **Verifiable in <2 minutes** — items that take longer should be split
- **Phrased as a claim** — "First major upgrade reachable in 10-15 min of play" beats "playtest"
- **Specific to this project** — generic items like "test all features" don't help anyone

---

## Rules

1. **User drives the QA list** — Never add items without user confirmation
2. **One observable behavior per item** — Composite items hide failures
3. **QA.md is the source of truth** — If it's not in the file, it's not on the QA list
4. **Audit regularly** — QA lists drift. Audit catches the drift.
5. **Don't duplicate test coverage** — If a unit or integration test can verify it, write the test instead
6. **Failed items need notes** — A "failed" without context is unactionable
7. **The Setup command must work** — Verify it before writing QA.md the first time

## Examples

A short Good/Bad example for a QA item. The full set of detailed examples lives in the reference docs.

**[Detailed Examples](./reference/EXAMPLES.md)** — Complete Good/Bad comparisons for generate, update, audit, migrate, and resume modes.

### Quick Example: A Single QA Item

<Good>
```markdown
- <!-- id:q_a1b2c status:pending --> Save a session, reload the page, confirm gold/inventory/equipped items all restore.
```

**Why this is good:** One observable behavior, runnable in under a minute, specific to the project's domain (game state persistence), verifiable as pass/fail without ambiguity.
</Good>

<Bad>
```markdown
- <!-- id:q_a1b2c status:pending --> Test save/load.
```

**Why this is bad:** Vague — what does "test save/load" mean? Test what? In what state? With what expected outcome? Two QAers will check different things.
</Bad>

See **[Detailed Examples](./reference/EXAMPLES.md)** for full mode walk-throughs.

## Quality Signals

A well-maintained QA.md has these properties:

- **5-30 items** — Below 5 is probably under-coverage; above 30 is probably bloat or unsplit composite items
- **Items target what tests can't catch** — Visual, multi-step, integration, race conditions, performance feel
- **Setup command is one line, copy-pasteable** — If it's complex, link to a runbook
- **Most items reviewed in the last 30 days** — Stale "passed" items are unverified facts
- **No "needs-decision" items older than two weeks** — Decisions block QA; surface them up

## Troubleshooting

### Problem: Items that look like unit tests

**Cause:** Mixing test-coverable assertions into the QA list.

**Solution:**
- If a unit test could verify it (no human eyes needed), write the unit test
- QA is for: visual rendering, multi-step flows, real-environment integrations, edge-case lockups
- Move test-coverable items out of QA.md and into the test suite

### Problem: Vague items like "test the UI"

**Cause:** Composite items that conflate many checks.

**Solution:**
- Split into specific observable behaviors
- Each item should be verifiable in under 2 minutes
- Use the phrase "I can confirm that…" — if you can't complete that sentence concretely, the item is too vague

### Problem: Failed items pile up without follow-through

**Cause:** Failing a QA item files a roadmap issue but the issue never gets worked.

**Solution:**
- A compatible dashboard's `/qa` portfolio queue surfaces stale failures
- Audit failed items quarterly; either fix the underlying bug or remove the QA item if obsolete
- Failures with no roadmap ref are a smell — every failure should have a tracked next-step

**[Extended Troubleshooting](./reference/TROUBLESHOOTING.md)** — Edge cases for migrate, audit, and dashboard integration.

## Integration

**This skill works with:**
- **track-roadmap** — Failed QA items can auto-file roadmap issues (in a "QA Issues" category) when the consuming tool supports cross-linking. After fixing, mark the roadmap item done and reset the QA item to pending.
- **track-session** — Use track-session to drive a focused QA pass when working through many items at once. Reference QA item IDs in the session plan.
- **`cc-dash/qa@1`-aware dashboards** — Any tool that ingests the schema can render a portfolio queue, an inline approve/fail/skip workflow, and a focus mode for keyboard-driven review. MCP servers built on the schema can expose tools like `list_qa_pending`, `approve_qa_item`, and `fail_qa_item` for agent-driven QA.

**Workflow pattern:**

```
/track-qa generate     →  Interview, write QA.md
/track-qa migrate      →  Convert ad-hoc notes to QA.md
/track-qa resume       →  Pick up where last QA pass left off
/track-qa audit        →  Periodic relevance review
/track-qa update       →  Add new items as features ship
```

**Pairs with:**
- Pre-release verification windows
- Maintenance-tier project transitions
- Portfolio-level "ready to ship" reviews
