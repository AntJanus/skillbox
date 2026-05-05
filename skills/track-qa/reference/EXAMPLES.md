# Track QA — Detailed Examples

Long-form Good/Bad comparisons for each mode of `/track-qa`. The main `SKILL.md` keeps a single quick example; this file holds the full walk-throughs.

---

## Mode: Generate

### Example: A Web App QA.md

<Good>

```markdown
---
schema: cc-dash/qa@1
project: blog-2024
last_updated: 2026-05-04T10:00:00-06:00
---

# Manual QA — blog-2024

## Setup

Run: `cd blog-2024 && npm run dev` → open http://localhost:5173

## Checklist

- <!-- id:q_a1b2c status:pending --> Homepage loads, featured articles render with images, no console errors.
- <!-- id:q_d3e4f status:pending --> Mobile menu (resize to <768px): simplified nav, hamburger toggle works smoothly.
- <!-- id:q_g5h6i status:pending --> Dark/light theme toggle: colors flip cleanly, no FOUC on reload, preference persists across navigation.
- <!-- id:q_j7k8l status:pending --> Reading progress bar + TOC: on a long article, progress tracks scroll, TOC sticks on xl+, collapses to accordion on mobile.
- <!-- id:q_m9n0o status:pending --> Full-text search returns results, no stale index issues after `npm run build`.
- <!-- id:q_p1q2r status:pending --> RSS feed validates in an RSS reader; latest 20 across collections, no broken URLs.
```

**Why this is good:**
- Setup is one line and runnable
- Each item is one observable behavior
- Items target what tests can't catch (visual rendering, responsive layout, theme persistence, real RSS validation)
- Items are specific to the project's domain (this isn't generic "test the website")
- A QAer can knock the whole list out in 15-30 minutes
</Good>

<Bad>

```markdown
---
schema: cc-dash/qa@1
project: blog-2024
last_updated: 2026-05-04T10:00:00-06:00
---

# Manual QA — blog-2024

## Setup

Refer to README.

## Checklist

- <!-- id:q_a1b2c status:pending --> Test the homepage.
- <!-- id:q_d3e4f status:pending --> Make sure mobile works.
- <!-- id:q_g5h6i status:pending --> Check dark mode.
- <!-- id:q_j7k8l status:pending --> Articles render correctly and TOC works and reading progress and search and RSS feed and theme switching.
```

**Why this is bad:**
- "Refer to README" forces every QAer to context-switch
- "Test the homepage" → test *what* exactly?
- "Make sure mobile works" → resize to what width? what feature on mobile?
- The fourth item is a composite — five behaviors crammed into one. If any single behavior breaks, the whole item gets marked failed and the note has to enumerate which sub-check failed.
</Bad>

---

### Example: A TUI/Game QA.md

<Good>

```markdown
---
schema: cc-dash/qa@1
project: fishing-game
last_updated: 2026-05-04T10:00:00-06:00
---

# Manual QA — fishing-game

## Setup

Run: `cd fishing-game && python3 -m http.server 8000` → open http://localhost:8000

## Checklist

- <!-- id:q_a1b2c status:pending --> Core loop playable: sail → cast → hook → tension minigame → reel in → sell at shop.
- <!-- id:q_d3e4f status:pending --> Save/load: play a session, earn gold, buy upgrades, catch fish — reload page → all state restored (gold, inventory, owned/equipped boats/rods/baits, fish stats).
- <!-- id:q_g5h6i status:pending --> Save versioning: corrupt the localStorage save (manually edit in DevTools), reload — game falls back gracefully, doesn't brick.
- <!-- id:q_j7k8l status:pending --> First major upgrade reachable in 10-15 min of play (validate the 2026-04-07 tuning pass held).
- <!-- id:q_m9n0o status:pending --> Edge-case lockups: try to fish while shop is open, try to sail while hooked, try to open shop mid-reel — state guards prevent soft-locks.
- <!-- id:q_p1q2r status:pending --> Pixel art renders crisply at 800x600 (no blur); 60 FPS steady on Chrome + Firefox.
- <!-- id:q_s3t4u status:pending --> Canvas on slower machines: run for 10 min continuous, no memory leak / FPS drop (DevTools Performance tab).
- <!-- id:q_v5w6x status:pending --> Clear localStorage entirely → first-run experience works (no null-ref errors).
```

**Why this is good:**
- Domain-specific (game-state persistence, save corruption recovery, upgrade pacing, FPS, soft-locks)
- "First major upgrade reachable in 10-15 min" is calibrated against a specific past tuning decision — anchors the check to history
- Edge-case lockups are exactly the kind of thing tests can't catch easily — they require human curiosity
- Memory-leak check explicitly says "10 min continuous" so the time investment is upfront
</Good>

---

## Mode: Update

### Example: Adding new items after a feature ships

**Scenario:** A new "achievement journal UI" feature shipped. The existing QA.md from above already has 8 items.

<Good>

After running `/track-qa update`:

```
Read existing QA.md (8 items)
Asked: "What changed since the last QA pass?"
User: "I shipped the achievement journal — overlay opens/closes, lists all 17 achievements with locked/unlocked states."

Proposed additions:
  - <!-- id:q_y7z8a status:pending --> Achievement journal UI: overlay opens, closes, shows locked/unlocked states, all 17 listed.
  - <!-- id:q_b9c0d status:pending --> All 17 achievements: trigger a few concretely (first catch, first rare, gold threshold, full species set) — toast appears, achievement persists in journal across reload.

Confirm?
User: yes

Wrote 2 new items to QA.md. Total: 10 items.
```

**Why this is good:**
- Asked the user before writing (rule: user drives the QA list)
- Each new item is one observable behavior
- Items reference the actual achievement count (17) — concrete, not generic
- Existing items were not touched (rule: don't reset existing status)
</Good>

<Bad>

```
Auto-generated 12 new items based on the latest commits without asking.
Reset all existing "passed" items to "pending" because "the codebase changed."
```

**Why this is bad:**
- Bypassed the user-confirms rule
- Reset of existing items destroys QA history (someone already verified those)
- "Auto-generated from commits" produces generic items that don't match how QA actually works
</Bad>

---

## Mode: Audit

### Example: Quarterly QA audit

**Scenario:** QA.md hasn't been touched in 3 months. The project shipped two features and removed one.

<Good>

After running `/track-qa audit`:

```
Read QA.md: 12 items (8 pending, 3 passed, 1 failed).

Findings:
  • q_g5h6i references a "save versioning" feature — feature still exists in the code. Keep.
  • q_p1q2r ("Pixel art crisp at 800x600") — codebase now supports 1024x768 default. PROPOSE: update item or split into 800x600 + 1024x768.
  • q_v5w6x ("first-run experience") — passed 3 months ago. PROPOSE: reset to pending; new code paths added since.
  • Two new features merged with no QA items: "weather system" and "fish marketplace". PROPOSE: add items.
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
</Good>

---

## Mode: Migrate

### Example: Converting a portfolio-level QA_BACKLOG.md

**Scenario:** A portfolio root has a `QA_BACKLOG.md` file with 10 repos' worth of QA notes in a single ad-hoc document. The user wants per-repo `QA.md` files.

<Good>

After running `/track-qa migrate` from each repo:

```
Found portfolio file: ../QA_BACKLOG.md
Located my-repo's section: lines 27-45.

Extracted:
  Setup: "cd my-repo && bash scripts/test.sh"
  Items (7 total):
    - "CI validation workflow runs clean on a fresh PR"
    - "AGENTS.md Last Updated date is current"
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
</Good>

---

## Mode: Resume

### Example: Returning to a project after a break

<Good>

After running `/track-qa resume`:

```
QA.md status (last_updated: 2026-04-15, 19 days ago):
  • 8 items pending
  • 3 items passed (last passed 19 days ago — consider re-verifying)
  • 1 item failed (q_g5h6i, ref:r_xyz12 — has the roadmap issue been fixed?)
  • 0 items needs-decision

Next pending item:
  q_a1b2c — "Save versioning: corrupt the localStorage save (manually edit in DevTools), reload — game falls back gracefully, doesn't brick."

Want to start QA on this item? (Or open focus mode in cc-dash:
  http://localhost:3000/project/fishing-game/qa?focus=q_a1b2c)
```

**Why this is good:**
- Surfaces age (19 days) — the QAer knows whether passed items are still trustworthy
- Calls out the failed item with its roadmap ref so the QAer can check if the bug was fixed before re-running
- Offers both terminal-driven and dashboard-driven workflows
</Good>
