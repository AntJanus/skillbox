# Track QA — Detailed Examples

Long-form ✅/❌ comparisons for each mode of `/track-qa`. The main `SKILL.md` keeps a single quick example; this file holds the full walk-throughs.

---

## Mode: Generate

### Example: A Web App QA.md

✅ **Good:**

```markdown
---
schema: cc-dash/qa@1
project: my-notes-app
last_updated: 2026-01-10T10:00:00-06:00
---

# Manual QA — my-notes-app

## Setup

Run: `cd my-notes-app && npm run dev` → open http://localhost:5173

## Checklist

- <!-- id:q_a1b2c status:pending --> Sign-in flow: enter valid credentials, land on dashboard, no console errors.
- <!-- id:q_d3e4f status:pending --> Note CRUD: create, edit, delete a note; refresh the page; all changes persist.
- <!-- id:q_g5h6i status:pending --> Mobile breakpoint (<768px): nav collapses to hamburger, modals don't overflow viewport.
- <!-- id:q_j7k8l status:pending --> Dark/light theme toggle: colors flip cleanly, no FOUC on reload, preference persists across navigation.
- <!-- id:q_m9n0o status:pending --> Search: type a query that matches notes, results filter live, clearing the query restores the full list.
- <!-- id:q_p1q2r status:pending --> Offline mode: drop the network in DevTools, open a cached note, edits queue and replay when reconnected.
```

**Why this is good:**
- Setup is one line and runnable
- Each item is one observable behavior
- Items target what tests can't catch (visual rendering, responsive layout, theme persistence, real network behavior)
- Items are specific to the project's domain (not generic "test the website")
- A QAer can knock the whole list out in 15-30 minutes
❌ **Bad:**

```markdown
---
schema: cc-dash/qa@1
project: my-notes-app
last_updated: 2026-01-10T10:00:00-06:00
---

# Manual QA — my-notes-app

## Setup

Refer to README.

## Checklist

- <!-- id:q_a1b2c status:pending --> Test the homepage.
- <!-- id:q_d3e4f status:pending --> Make sure mobile works.
- <!-- id:q_g5h6i status:pending --> Check dark mode.
- <!-- id:q_j7k8l status:pending --> Notes render correctly and search works and theme switching and offline and the mobile menu.
```

**Why this is bad:**
- "Refer to README" forces every QAer to context-switch
- "Test the homepage" → test *what* exactly?
- "Make sure mobile works" → resize to what width? what feature on mobile?
- The fourth item is a composite — five behaviors crammed into one. If any single behavior breaks, the whole item gets marked failed and the note has to enumerate which sub-check failed.
---

### Example: A TUI/Game QA.md

✅ **Good:**

```markdown
---
schema: cc-dash/qa@1
project: my-roguelike
last_updated: 2026-01-10T10:00:00-06:00
---

# Manual QA — my-roguelike

## Setup

Run: `cd my-roguelike && cargo run --release`

## Checklist

- <!-- id:q_a1b2c status:pending --> Core loop playable: explore → encounter enemy → combat → loot → descend stairs to next floor.
- <!-- id:q_d3e4f status:pending --> Save/load: play a session, gain levels, collect items — quit and relaunch → all state restored (XP, inventory, equipped items, current floor).
- <!-- id:q_g5h6i status:pending --> Save versioning: corrupt the save file with an unknown field, relaunch — game falls back gracefully, doesn't crash.
- <!-- id:q_j7k8l status:pending --> First boss reachable in 15-20 min of play (calibrated against the most recent difficulty pass).
- <!-- id:q_m9n0o status:pending --> Edge-case lockups: open inventory mid-combat, try to descend while stunned, swap weapon during animation — state guards prevent soft-locks.
- <!-- id:q_p1q2r status:pending --> Terminal resize mid-session: layout reflows, no visual artifacts or panic.
- <!-- id:q_s3t4u status:pending --> Long-session stability: run for 15 min continuous, no memory growth, no rendering glitches.
- <!-- id:q_v5w6x status:pending --> Wipe save data → first-run experience works (no null-ref errors, intro plays).
```

**Why this is good:**
- Domain-specific (game-state persistence, save corruption recovery, difficulty pacing, terminal-resize behavior, soft-locks)
- "First boss reachable in 15-20 min" is calibrated against a specific past tuning decision — anchors the check to history
- Edge-case lockups are exactly the kind of thing tests can't catch easily — they require human curiosity
- The long-session check explicitly says "15 min continuous" so the time investment is upfront
---

## Mode: Update

### Example: Adding new items after a feature ships

**Scenario:** A new "achievement system" feature shipped. The existing QA.md from above already has 8 items.

✅ **Good:**

After running `/track-qa update`:

```
Read existing QA.md (8 items)
Asked: "What changed since the last QA pass?"
User: "I shipped achievements — there's an overlay UI that opens/closes, lists all 12 achievements with locked/unlocked states."

Proposed additions:
  - <!-- id:q_y7z8a status:pending --> Achievement overlay UI: opens, closes, shows locked/unlocked states, all 12 listed.
  - <!-- id:q_b9c0d status:pending --> All 12 achievements: trigger a few concretely (first kill, first rare drop, level threshold) — toast appears, achievement persists across reload.

Confirm?
User: yes

Wrote 2 new items to QA.md. Total: 10 items.
```

**Why this is good:**
- Asked the user before writing (rule: user drives the QA list)
- Each new item is one observable behavior
- Items reference the actual achievement count (12) — concrete, not generic
- Existing items were not touched (rule: don't reset existing status)
❌ **Bad:**

```
Auto-generated 12 new items based on the latest commits without asking.
Reset all existing "passed" items to "pending" because "the codebase changed."
```

**Why this is bad:**
- Bypassed the user-confirms rule
- Reset of existing items destroys QA history (someone already verified those)
- "Auto-generated from commits" produces generic items that don't match how QA actually works
---

## Mode: Audit

### Example: Quarterly QA audit

**Scenario:** QA.md hasn't been touched in 3 months. The project shipped two features and removed one.

✅ **Good:**

After running `/track-qa audit`:

```
Read QA.md: 12 items (8 pending, 3 passed, 1 failed).

Findings:
  • q_g5h6i references a "save versioning" feature — feature still exists in the code. Keep.
  • q_p1q2r ("layout renders correctly at 80x24") — codebase now defaults to 120x40. PROPOSE: update item or split into 80x24 + 120x40.
  • q_v5w6x ("first-run experience") — passed 3 months ago. PROPOSE: reset to pending; new code paths added since.
  • Two new features merged with no QA items: "weather system" and "merchant NPCs". PROPOSE: add items.
  • One feature removed: "boat customization UI" — q_old01 is obsolete. PROPOSE: remove.

Apply all proposals?
User: yes to all except weather system (defer)

Updated: 1 item edited, 1 reset to pending, 1 removed, 1 added. Total: 12 items.
```

**Why this is good:**
- Each finding has a specific reason and proposed action
- Doesn't auto-apply — user confirms
- Recognizes that "passed 3 months ago" is unverified-fact, not verified-fact
- Removes obsolete items rather than letting QA.md bloat
---

## Mode: Migrate

### Example: Converting a portfolio-level QA backlog

**Scenario:** A portfolio root has a `QA_BACKLOG.md` file with multiple repos' QA notes in a single ad-hoc document. The user wants per-repo `QA.md` files.

✅ **Good:**

After running `/track-qa migrate` from each repo:

```
Found portfolio file: ../QA_BACKLOG.md
Located my-repo's section: lines 27-45.

Extracted:
  Setup: "cd my-repo && bash scripts/test.sh"
  Items (7 total):
    - "CI validation workflow runs clean on a fresh PR"
    - "Docs file last_updated date is current"
    - ...

Generating IDs (q_xxxxx) for each item.
Defaulting status to "pending" for all.

Proposed QA.md:
  [shows full file]

Confirm?
User: yes

Wrote QA.md (7 items). Recommend deleting my-repo's section from ../QA_BACKLOG.md after all repos migrated.
```

**Why this is good:**
- Found the source automatically (didn't make the user re-type)
- Generated stable IDs once (rule: IDs are permanent)
- Defaulted to `pending` rather than guessing status
- Surfaced the cleanup follow-up (delete the consolidated file once migration is complete)
---

## Mode: Resume

### Example: Returning to a project after a break

✅ **Good:**

After running `/track-qa resume`:

```
QA.md status (last_updated: 2026-01-01, 19 days ago):
  • 8 items pending
  • 3 items passed (last passed 19 days ago — consider re-verifying)
  • 1 item failed (q_g5h6i, ref:r_xyz12 — has the roadmap issue been fixed?)
  • 0 items needs-decision

Next pending item:
  q_a1b2c — "Save versioning: corrupt the save file with an unknown field, relaunch — game falls back gracefully, doesn't crash."

Want to start QA on this item? (Or open focus mode in a compatible dashboard at
  /project/<slug>/qa?focus=q_a1b2c.)
```

**Why this is good:**
- Surfaces age (19 days) — the QAer knows whether passed items are still trustworthy
- Calls out the failed item with its roadmap ref so the QAer can check if the bug was fixed before re-running
- Offers both terminal-driven and dashboard-driven workflows