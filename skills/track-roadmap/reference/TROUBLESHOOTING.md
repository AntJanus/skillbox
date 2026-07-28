# Track Roadmap — Extended Troubleshooting

Additional troubleshooting beyond the Gotchas in SKILL.md. Load when a mode stalls or produces unusable output.

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

## Problem: User wants to switch features mid-session

**Cause:** Resume found an active SESSION_PROGRESS.md but the user changed their mind.

**Solution:**
- Offer `/track-session save` first — switching replaces the file with the new feature's plan
- Only proceed once the user has confirmed the in-flight progress is safe to lose

## Problem: Roadmap still exceeds 15 committed features after an audit

**Cause:** The project genuinely has more scope than one roadmap can express.

**Solution:**
- Split into milestones rather than continuing to trim
- Each milestone gets its own category with a `<!-- category:slug -->` marker
- Keep only the current milestone's features in the top sections

## Problem: Brainstorm produces no useful ideas

**Cause:** Project context is too narrow or user is stuck in execution mode.

**Solution:**
- Widen the lens — ask "what inspires you?" and "what do you wish existed?"
- Introduce constraint-breaking prompts: "if budget/time didn't matter, what would you add?"
- Reference adjacent projects — "what would [similar tool] do here?"
- If still stuck, note the block in the conversation and try again after a break

## Problem: Features keep drifting from original scope

**Cause:** Feature descriptions are too vague ("user authentication") and interpretation shifts session-to-session.

**Solution:**
- Tighten descriptions during audit — add a 1-sentence success criterion
- ✅ Good: "User authentication — email/password login with session persistence across browser restarts"
- ❌ Bad: "User authentication"
- The criterion should be testable, not aspirational

## Problem: Can't decide priority order

**Cause:** Too many features look equally important.

**Solution:**
- Ask the user: "If we could only ship 3 things this quarter, which 3?"
- Put those at the top of their respective categories
- Move the rest to "Future Ideas" temporarily — you can promote them back up next planning cycle
- Prefer category + order over numeric priority scores (P0/P1/P2), which encourage false precision
