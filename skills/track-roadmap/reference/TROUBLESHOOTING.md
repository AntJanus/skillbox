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
