# Track Roadmap — Extended Troubleshooting

Additional troubleshooting beyond the common issues covered in SKILL.md.

## Problem: Roadmap doesn't match what's actually being built

**Cause:** Roadmap wasn't updated as priorities shifted.

**Solution:**
- Run `/track-roadmap audit` to reconcile plan vs. reality
- Update the roadmap to reflect actual direction
- Set a habit: audit after every major feature completion

## Problem: Codebase scan suggests irrelevant features

**Cause:** Discovery picked up on implementation details, not user features.

**Solution:**
- Treat scan results as suggestions, not requirements
- Always confirm with user before adding to roadmap
- Focus on user-facing capabilities, not internal architecture

## Problem: Resume can't find ROADMAP.md

**Cause:** No roadmap has been created for this project yet.

**Solution:**
- Run `/track-roadmap generate` to create a ROADMAP.md first
- Then use `/track-roadmap resume` to pick a feature and start working

## Problem: Resume finds an active session but user wants to switch features

**Cause:** User changed their mind about what to work on.

**Solution:**
- Resume will ask whether to continue the active session or pick a new item
- If switching: the current SESSION_PROGRESS.md will be overwritten with the new feature's plan
- Consider running `/track-session save` first to preserve progress if needed

## Problem: Roadmap has ballooned to 30+ features

**Cause:** Every idea gets committed to the roadmap with no filtering.

**Solution:**
- Run `/track-roadmap audit` — most items will be stale or speculative
- Move speculative features to "Future Ideas" with `status:idea`
- Delete items that no longer fit the project direction (don't archive — history is in git)
- If the roadmap still exceeds 15 committed features, consider splitting into milestones

## Problem: Brainstorm produces no useful ideas

**Cause:** Project context is too narrow or user is stuck in execution mode.

**Solution:**
- Widen the lens — ask "what inspires you?" and "what do you wish existed?"
- Introduce constraint-breaking prompts: "if budget/time didn't matter, what would you add?"
- Reference adjacent projects — "what would [similar tool] do here?"
- If still stuck, note the block in the conversation and try again after a break

## Problem: Audit can't determine if a feature is Done

**Cause:** Codebase scan sees partial implementations or experimental code.

**Solution:**
- Default to "Unclear" status when evidence is ambiguous — don't guess
- Present findings to the user: "I see `src/auth/` exists but no tests — is auth done?"
- User confirms Done/In-Progress/Not-Started status before committing to the roadmap
- When Done, always add `completed:YYYY-MM-DD` date for future audit grounding

## Problem: Features keep drifting from original scope

**Cause:** Feature descriptions are too vague ("user authentication") and interpretation shifts session-to-session.

**Solution:**
- Tighten descriptions during audit — add a 1-sentence success criterion
- Bad: "User authentication"
- Good: "User authentication — email/password login with session persistence across browser restarts"
- The criterion should be testable, not aspirational

## Problem: Can't decide priority order

**Cause:** Too many features look equally important.

**Solution:**
- Ask the user: "If we could only ship 3 things this quarter, which 3?"
- Put those at the top of their respective categories
- Move the rest to "Future Ideas" temporarily — you can promote them back up next planning cycle
- Avoid numeric priority scores (P0/P1/P2) — they encourage false precision; category + order is enough

## Problem: User wants to rename or merge features

**Cause:** Feature naming or grouping has evolved since initial roadmap.

**Solution:**
- **Rename:** Edit the feature text but preserve the `<!-- id:r_XXXXX -->` comment. IDs are permanent.
- **Merge:** Pick the surviving ID, delete the other item, update the survivor's description to cover both
- **Split:** Keep the original ID on one half, generate a new ID for the new half
- Always ask the user before structural changes — IDs link to SESSION_PROGRESS.md references
