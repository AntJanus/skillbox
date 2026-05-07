# Start Mode Workflow (`/track-session start`)

The `start` mode codifies a six-phase pattern for new multi-phase work, preventing the two most common failure modes of long sessions: starting execution before the plan is reviewed, and dumping a large synthesis when the user wants to make decisions one at a time.

## The six phases

1. **Explore** — Read the affected modules, identify existing patterns (architecture, naming, error handling, data flow). Use Glob/Grep to find related code. Read project docs (README, CLAUDE.md, PRDs).
2. **Ask** — Surface decisions one at a time via `AskUserQuestion`. Never dump a large synthesis when there are real choices to make. Each question = one tradeoff with 2-4 options.
3. **Plan** — Once decisions are settled, write `SESSION_PROGRESS.md` with a phased plan. Use the standard format (frontmatter, Plan with task IDs, Current Status). Keep tasks small enough that each maps to a verifiable change.
4. **Confirm** — Show the plan to the user. Wait for an explicit greenlight before any code is written. Edits to the plan are expected at this stage.
5. **Execute** — Work one phase at a time. Run tests after each phase. Update SESSION_PROGRESS.md after each task is checked off. If a phase fails, log the failure under "Failed Attempts" and try a different approach — never weaken a test or dismiss a failure.
6. **Commit** — Commit after each verified change. Single-line subjects. Conventional commits. No `Co-Authored-By: Claude` trailers.

## When start is the right mode

Use `start` when:
- The task spans multiple files or multiple phases.
- There are real architectural choices to make (e.g., schema A vs. B, sync vs. async).
- You want a recoverable plan in case the session is interrupted.
- You'd like the user to direct phase-by-phase rather than approve a big synthesis.

Don't use `start` for:
- Quick fixes (use no-arg `/track-session` or just the change directly).
- Tasks where the plan is already laid out by the user.
- Read-only exploration (use `deep-research` or `code-review`).

## Why phases matter

Each phase is a gate. Failing a gate halts the workflow until fixed:

- **No exploration → no plan** — guessing at architecture leads to rework.
- **No ask → no plan** — silent design choices accumulate technical debt.
- **No confirm → no execute** — the most common cause of "this isn't what I asked for."
- **No tests → no commit** — an untested change is not a verified change.

## Example flow

```bash
user: "I want to add real-time notifications to the app"
assistant: "/track-session start"
# 1. Explores notification-relevant modules (Read, Glob)
# 2. Asks: "WebSocket vs Server-Sent Events vs polling?" (one decision)
# 3. Asks: "Reuse Redis pub/sub or stand up a new broker?" (one decision)
# 4. Writes SESSION_PROGRESS.md with phased plan
# 5. Shows plan, waits for greenlight
# 6. Executes phase-by-phase, tests after each, commits incrementally
```
