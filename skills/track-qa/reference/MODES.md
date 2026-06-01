# Track QA — Mode Procedures

Detailed per-mode workflows. SKILL.md has the one-line essence; load this for the full process.

## Generate

Create a new QA.md interactively.

1. **Discovery** — Scan the project for QA-worthy surfaces: frontend/UI → visual checks, breakpoints, theme switching; TUI/CLI → layout, terminal-resize, ANSI rendering; game → core-loop playability, save/load, edge-case lockups; network/integration → real-API smoke tests, auth flows, error paths; filesystem/data → migrations, save-corruption recovery. Summarize, then ask: (1) how do you run this locally? (the Setup command) (2) what does "ready to ship" look like? (3) what bugs have bitten you that tests don't catch? (4) any integrations/external services needing a real-environment check?
2. **Organize & write** — Propose a draft checklist; user confirms/adds/removes. Verify before writing: the Setup command actually runs, each item is a *single* observable behavior, items focus on what tests can't verify (no `expect X === Y`), no duplicates.

## Update

1. Read current QA.md.
2. Ask what changed: new features needing QA? items to remove (obsolete / now test-covered)? Setup command changed?
3. Apply, present a diff for confirmation, write.

Rules: generate new IDs for added items (`q_` + 5 random); never reuse an ID even after deletion; don't reset existing items' status when adding new ones — only modify what the user asked.

## Audit

Review QA.md against current project state.

1. Read QA.md.
2. For each pending item: does it still apply? does the surface still exist?
3. For each passed item: checked in the last 30 days? re-verify after recent changes?
4. Report items to remove / revisit / add. Apply only after confirmation.

Signals: items referencing deleted files → propose removal; "passed" older than the last release → propose reset to pending; features merged since last QA → propose new items; items matching a test-suite name → propose converting to an automated test + removal.

## Migrate

Convert ad-hoc QA notes into a compliant QA.md.

1. Look for QA-shaped content in CLAUDE.md, README.md, ROADMAP.md, scratch files, or a portfolio-level `QA_BACKLOG.md`.
2. Extract each manual-check item; group by repo if pulling from a portfolio file.
3. Generate IDs and statuses (default `pending` unless context says otherwise).
4. Identify the Setup command from existing run instructions.
5. Present the proposed QA.md for review before writing.

## Resume

1. Read QA.md.
2. Report totals: pending / passed / failed / needs-decision counts.
3. Surface the next pending item with its description.
4. Ask "Want to start QA on this item?"
5. If yes, link to dashboard focus mode (`/project/<slug>/qa?focus=<id>`) or print the item's full text for in-terminal QA.
