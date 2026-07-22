---
name: track-session
description: Resume work, track progress across sessions, verify completion, recover a lost session file. Use this skill whenever the user wants to "resume work", "pick up where I left off", "what was I doing", "save progress", "are we done", "I lost my SESSION_PROGRESS", or "reconstruct my session". For multi-session tasks.
license: MIT
argument-hint: "[save|resume|verify|recover]"
metadata:
  author: Antonin Januska
  version: "5.2.0"
---

# Session Progress

Track multi-session work in `SESSION_PROGRESS.md` at the project root so work can pause and resume without losing context. Keep the file current — it should always reflect actual state.

**On a bare `/track-session` (no argument):** look for `SESSION_PROGRESS.md` first. **No file → Start** (create one). **File exists and is yours to continue → Resume**. **File exists mid-work → checkpoint** (Default). Never sit idle waiting for an argument.

## Modes

| Mode | Command | Behavior |
|------|---------|----------|
| **Start** | `/track-session` (no file yet) or `start` | Create a fresh `SESSION_PROGRESS.md` — see [Start mode](#start-mode) for the collision policy when one already exists |
| **Default** | `/track-session` (file exists) | Checkpoint progress, then keep working. Re-checkpoint after every completed task, plan change, or failure — don't wait to be asked |
| **Save** | `/track-session save` | Checkpoint progress and stop |
| **Resume** | `/track-session resume` | Read `SESSION_PROGRESS.md`, re-orient, continue from "Next" — see [Resume mode](#resume-mode) |
| **Verify** | `/track-session verify` | Validate completed work against requirements before declaring done |
| **Recover** | `/track-session recover` | Rebuild a lost/deleted `SESSION_PROGRESS.md` from the session transcript |

## File format

cc-dash schema frontmatter (parsed by the dashboard) plus markdown checkboxes:

```markdown
---
schema: cc-dash/session@1
project: project-name
session_id: s_YYYY-MM-DD_topic-slug
roadmap_ref: r_XXXXX          # optional — links a roadmap feature
started: YYYY-MM-DDTHH:MM:SS-TZ
last_updated: YYYY-MM-DDTHH:MM:SS-TZ
status: in-progress           # in-progress | paused | completed | blocked
---

# Session Progress

## Plan

- [ ] <!-- id:t_a1b2c dep:none --> Task: description
- [x] <!-- id:t_d3e4f dep:t_a1b2c --> Task: description

## Current Status

Working on: <current task>
Next: <specific next action — name files and functions, not "fix the bug">

## Decisions

- <!-- at:YYYY-MM-DDTHH:MM:SS-TZ --> Durable choice + why, so it isn't relitigated on resume

## Failed Attempts

- <!-- id:f_x1y2z task:t_d3e4f --> Tried X: failed because Y, trying Z instead

## Completed Work

- <!-- ref:t_d3e4f at:YYYY-MM-DDTHH:MM:SS-TZ --> What was done
```

**IDs:** `t_` (task) or `f_` (failed attempt) + a short, unique, stable token — 5 random `[a-z0-9]` chars is the default, but a mnemonic slug (`t_redis-mw`, `t_authfix`) is fine; the dashboard parser accepts `[a-z0-9-]+` and reads them either way. Keep an id **stable** once written — `dep:` references point at it. `session_id` uses date + slug. Every plan item gets an `id` and a `dep` (`dep:none` or `dep:t_XXXXX`). These markers are what the dashboard ingests — don't omit them.

**`## Decisions` and `## Completed Work` are optional** — add them when there's something to record; `## Plan` and `## Current Status` are the load-bearing ones.

**Log every failed approach with its reason**, so it's not blindly retried. **Exception:** if a failure was environment-scoped (an MCP server not connected, missing credentials, a service down) rather than a wrong approach, note that in the entry — a later session may have a different environment, so re-checking is correct, not a violation.

**Update** after completing a task, changing the plan, hitting a failure, or before asking the user questions. This is the single most-skipped rule — checkpoint proactively, don't wait for the user to say "save".

## Start mode

Creating a fresh `SESSION_PROGRESS.md`. Derive `project:` from the repo (folder name / `package.json` / `pyproject.toml`) — **don't inherit it from an unrelated file you're overwriting**. Stamp `started` and `last_updated`, set `status: in-progress`, write at least `## Plan` and `## Current Status`.

**If a `SESSION_PROGRESS.md` already exists, do not blindly overwrite or stack onto it.** Read it first, then:

- **It's yours to continue** (same work, unfinished) → this isn't Start, it's **Resume**.
- **Prior work is `completed`/`paused` and unrelated** → confirm with the user, then **replace** the file with the new session. History lives in git — don't accrete multiple sessions in one file (the dashboard parses only the top frontmatter block; everything below a second `---` is invisible to it).
- **You genuinely need the old context visible** → archive it to a separate `SESSION_ARCHIVE_<topic>.md`, then write a clean new file. (Only if actually needed — in practice, replace-and-trust-git is simpler.)

## Resume mode

Read the file, then **lead your first response with the state** — don't bury it under fresh analysis. Required opening, 2-3 lines:

```
State: <status>, <N of M plan tasks done>, working tree <clean/dirty>, last commit <hash/subject>.
Next: <the "Next" line, verbatim or sharpened>.
```

Then continue the work. Also re-check that frontmatter still matches reality (`project:` correct, `status:` accurate) and fix it in place if it drifted — Resume is the natural reconciliation point.

## Verify mode

`/track-session verify` confirms completed (`[x]`) tasks actually meet requirements — ticked boxes alone don't mean done. Read the relevant files, run tests, collect evidence, and ask the user about anything ambiguous. Append results:

```markdown
## Verification Results

### Successfully Verified
- Task: evidence (e.g. tests 23/23 passing)

### Minor Issues Found
- Issue: impact

### Blocking Issues
- None
```

See [reference/VERIFICATION.md](./reference/VERIFICATION.md) for the full methodology.

## Recover mode

`/track-session recover` rebuilds a missing `SESSION_PROGRESS.md`. Its content survives in the session transcript — but as incremental `Edit`s, not one clean blob.

1. Ask the user for **branch**, **rough date**, and **topic** to narrow the search.
2. Find the transcript under `~/.claude/projects/<cwd-slug>/` (grep `cc-dash/session@1`, confirm `gitBranch`).
3. Reconstruct: take the latest full snapshot (a `Write`, else a `Read` result with line-number prefixes stripped), then replay later `Edit`s. Re-stamp `last_updated`.
4. If no transcript content exists, rebuild from `git reflog`/`git log` and say plainly it's partial — never fabricate a confident plan.
5. Hand off to `resume`.

See [reference/RECOVERY.md](./reference/RECOVERY.md) for the slug derivation and the tested Python reconstructor (jq is unreliable here).

## Example

✅ Specific and resumable:

```markdown
## Plan
- [x] <!-- id:t_a1b2c dep:none --> Phase 1: choose session store (picked Redis)
- [ ] <!-- id:t_g5h6i dep:t_a1b2c --> Phase 2: add session middleware

## Current Status
Working on: Phase 2
Next: add Redis client in src/auth/session.ts, then wire middleware in app.ts
```

❌ Too vague to resume:

```markdown
## Plan
- [ ] Do auth stuff
- [ ] Fix sessions
Working on auth. Tried some things that didn't work.
```

The good version names the next action, files, and decisions; the bad one forces a context rebuild from scratch.

## When to use

For multi-phase work, cross-file refactors, long debugging sessions, or anything spanning multiple sessions / context resets. Skip quick 1–2 file changes and obvious fixes.

## Integration

- **track-roadmap** — pick a feature from the roadmap, then track its implementation here via `roadmap_ref`.
- Pairs with commit and testing workflows: checkpoint between commits and test phases.

See [reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) for resume failures, file-size management, and verify edge cases.
