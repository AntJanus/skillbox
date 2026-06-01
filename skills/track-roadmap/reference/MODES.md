# Track Roadmap — Mode Procedures

Detailed per-mode workflows. SKILL.md has the one-line essence; load this for the full process.

## Generate

Create a new ROADMAP.md interactively.

1. **Discovery** — Offer a codebase scan (project files, structure, TODO/FIXME, dependencies, issues); summarize findings. Then ask: (1) core purpose of the project? (2) known must-have features? (3) target user and workflows? (4) technical capabilities needed (integrations, platforms)? Adapt questions to scan results.
2. **Organize & write** — Propose a draft feature list; user confirms/adds/removes. Group into logical categories, then write ROADMAP.md in the standard format. Verify before writing: user confirmed the list, features grouped logically, each has a clear description, no duplicates.

## Update

Modify an existing ROADMAP.md.

1. Read the current file.
2. Ask what changed: features to add / remove / deprioritize / mark complete / reword.
3. Apply, present for confirmation, write.

Rules: move completed features to the Completed section (don't delete); ask which category new features belong to; user confirms all changes.

## Audit

Combined progress check + relevance review.

1. **Progress check** — Scan the codebase and categorize each feature: **Done** (exists and works), **In Progress** (partial), **Not Started** (no evidence), **Unclear** (can't tell from code).
2. **Relevance review** — Present findings and ask: any features no longer needed? new ones to add? priority changes based on what was learned?
3. **Update** — Apply and write.

## Brainstorm

Divergent ideation before committing to the roadmap. Unlike Generate (structured plan), Brainstorm explores.

1. **Context** — Read ROADMAP.md (if any), README, CLAUDE.md, manifests; summarize current state and gaps.
2. **Diverge** — Open-ended questions by maturity:
   - *New/early:* "What problem does this solve, and for whom?" · "What would make this 10x more useful than alternatives?" · "What products inspire you — what would you borrow?"
   - *Mature:* "What do users complain about or request most?" · "What's the most tedious part of using this today?" · "Unlimited time — what would you add?"
   - *All:* "What technical capabilities could unlock new features?" · "One wild idea you dismissed as too ambitious?"
3. **Deepen** each promising idea across: user journey (one full interaction), inspirations (similar tools), requirements (technical needs), open questions (unknowns to research), effort/impact (weekend vs multi-month).
4. **Capture** — Filter with the user (keep / scope-creep / separate project). Viable ideas → "Future Ideas" with `status:idea`. Note rejected ideas + why in chat (prevents re-brainstorming).

Rules: diverge before converging; user drives selection; everything starts as `status:idea`; link inspirations; open questions are valuable output.

## Resume

Bridge the roadmap to active work.

1. **Check session** — If SESSION_PROGRESS.md has uncompleted tasks, ask whether to continue (delegate to `/track-session resume` and stop) or pick a new item.
2. **Present roadmap** — Read ROADMAP.md, filter out completed, present remaining grouped by category; ask which feature to work on.
3. **Confirm & plan** — Summarize the selected feature, ask clarifying questions if too high-level, get approval.
4. **Start session** — Invoke `/track-session` to create SESSION_PROGRESS.md, populate tasks from the feature, reference the ROADMAP item's ID, begin.

Rules: check session state first; user picks the feature (never auto-select); one feature at a time; SESSION_PROGRESS.md must reference the ROADMAP item ID; no ROADMAP.md → tell the user to run `/track-roadmap generate` first.
