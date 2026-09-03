---
name: track-session
description: Use this skill to maintain SESSION_PROGRESS.md and track multi-session work — resuming, checkpointing, and handing off long tasks. Triggers include "resume work", "pick up where I left off", "what was I doing", "save progress", "checkpoint before I lose context", "are we done", or "I lost my SESSION_PROGRESS" — even if the user never says "session", as when they return to a multi-day refactor or ask you to write down where things stand. Applies to multi-phase work, cross-file refactors, and long debugging runs; skip it for quick one-file fixes. Do NOT use this skill for feature or milestone planning (see track-roadmap) or for a one-off summary or handoff doc that doesn't live in SESSION_PROGRESS.md (see work-summary).
license: MIT
argument-hint: "[start|save|resume|verify|recover]"
metadata:
  author: Antonin Januska
  version: "6.2.2"
---

# Session Progress

## Overview

Track multi-session work in `SESSION_PROGRESS.md` at the project root so work can pause and resume without a context rebuild. The file is only worth having if it matches reality, so checkpoint as work happens — after a completed task, a plan change, a failure, or before asking the user a question — rather than waiting to be told to save.

The cc-dash dashboard ingests this file, which is why the frontmatter schema and the HTML id markers below are load-bearing rather than decorative.

## File format

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

`## Plan` and `## Current Status` are load-bearing; `## Decisions`, `## Failed Attempts`, and `## Completed Work` are optional — add them when there's something real to record.

**Length:** one line per task; Decisions and Failed Attempts get 1–2 sentences each. The file is a state record, not a narrative — no filler sections, no restated summaries, no recap of work already listed under Completed Work.

**What must survive a context reset**, in priority order: problems that came up and how they were resolved (Failed Attempts); options raised, tried, or set aside, and why (Decisions); anything the user asked for, ruled out, or set as a constraint, stated close to their own words; exactly where things stand (Current Status); what is still open or promised (Plan); and details that are hard to reconstruct — names, numbers, exact wording, links — kept exact. Be complete on these even at the cost of length. Condense your own reasoning to what it concluded.

**IDs:** `t_` (task) or `f_` (failed attempt) plus a short unique token. Five random `[a-z0-9]` chars is the default; a mnemonic slug (`t_redis-mw`, `t_authfix`) also works. Keep an id stable once written, because `dep:` references point at it. Every plan item carries an `id` and a `dep` (`dep:none` or `dep:t_XXXXX`).

**Log every failed approach with its reason** so it isn't blindly retried. When a failure was environment-scoped — an MCP server not connected, missing credentials, a service down — say so in the entry; a later session may have a different environment, so re-checking it is correct rather than a repeat.

## Workflow

### Routing a bare invocation

On `/track-session` with no argument, take the first branch that matches and stop:

1. No `SESSION_PROGRESS.md` at the project root → **Start**.
2. File exists **and this conversation has produced work the file doesn't record yet** (edits, test runs, decisions since its `last_updated`) → **checkpoint**, then keep working.
3. Otherwise — fresh context, the file is the only record → **Resume**.

The discriminator is unrecorded work in the current conversation, not how finished the file looks. Use it as a tiebreak whenever branches 2 and 3 both seem to fit: checkpoint. Writing a near-empty delta costs one turn, whereas resuming on top of unrecorded work drops it from the file and hands the next session a stale plan.

### Start mode

Derive `project:` from the repo (folder name, `package.json`, `pyproject.toml`) rather than inheriting it from a file you're about to overwrite. Stamp `started` and `last_updated`, set `status: in-progress`, and write at least `## Plan` and `## Current Status`.

If a `SESSION_PROGRESS.md` already exists, read it, then check whether git tracks it — that determines whether replacing it is reversible:

```bash
git ls-files --error-unmatch SESSION_PROGRESS.md   # exit 0 = tracked; non-zero = untracked or ignored
```

- **Same work, unfinished** → this isn't Start, it's Resume. Stop here.
- **Tracked, and the prior session is `completed`/`paused` and unrelated** → confirm with the user, then replace the file; git holds the old copy.
- **Untracked or gitignored** → archive to `SESSION_ARCHIVE_<topic>.md` first, then write the clean file. Replacing an untracked file destroys it permanently; public repos commonly gitignore `SESSION_PROGRESS.md` on purpose. When they do, offer to add `SESSION_ARCHIVE_*.md` to `.gitignore` too, so the archive doesn't become the thing that leaks.

### Checkpoint (bare invocation) and Save

Both write the current state into the file: tick completed tasks, update `## Current Status`, append decisions and failed attempts, re-stamp `last_updated`. The only difference is what happens next — a bare `/track-session` checkpoints and **keeps working**, while `/track-session save` checkpoints and **stops**.

### Resume mode

Read the file, then lead the reply with where things actually stand — `status`, tasks done out of total, working-tree state, last commit, and the next action — before any fresh analysis. Handoffs that open with narration ("I'll read the session file now, then look at the tests") bury the state the user came back for, and they end up re-deriving it themselves.

Resume is also the natural reconciliation point: if `project:` or `status:` have drifted from reality, fix them in place while you're there.

### Verify and Recover — load on demand

- **`/track-session verify`** confirms `[x]` tasks actually meet their requirements — read the files, run the tests, tie each claim to evidence from this run, and append a `## Verification Results` section. Load [reference/VERIFICATION.md](./reference/VERIFICATION.md) when the user asks to verify, or when ticked boxes are the only evidence the work is done.
- **`/track-session recover`** rebuilds a deleted `SESSION_PROGRESS.md` from the Claude Code transcript. Load [reference/RECOVERY.md](./reference/RECOVERY.md) when the file is missing and the user wants it back — it carries the transcript-slug derivation and a tested Python reconstructor, which the reference explains is necessary because jq mis-parses these transcripts.

## Examples

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

✅ A resume reply that opens with state:

```
Paused, 4 of 7 plan tasks done, working tree clean, last commit 3cf23e0 "add session middleware".
Next: add the Redis client in src/auth/session.ts, then wire it in app.ts.
```

❌ A resume reply that opens with narration:

```
Let me start by reading your SESSION_PROGRESS.md to understand the context.
Then I'll check the git log and look through the auth directory...
```

✅ A failed attempt that won't be blindly retried:

```markdown
## Failed Attempts
- <!-- id:f_k7m2p task:t_g5h6i --> Tried `ioredis` autoReconnect for the session store: reconnect storms under the test harness's socket limit. Switched to a single shared client in src/auth/redisClient.ts.
- <!-- id:f_q9r4s task:t_g5h6i --> Ran the e2e suite against staging: env-scoped — STAGING_URL unset in this shell. Re-check before treating this as a real failure.
```

❌ A failed attempt that will be retried:

```markdown
## Failed Attempts
- Redis didn't work, trying something else
```

✅ Every good version names the file, the id, and the reason; every weak one makes the reader rebuild context from scratch.

## Gotchas

- **Only the top frontmatter block is parsed.** Anything below a second `---` is invisible to cc-dash, so a file with stacked sessions silently reports only the newest one.
- **`SESSION_PROGRESS.md` is gitignored in many public repos**, which makes "just replace it, git has the history" false there. Check `git ls-files --error-unmatch` before replacing, and archive first when it comes back non-zero.
- **The dashboard's read path is lenient about ids, its write path isn't.** Mnemonic slugs like `t_authfix` survive a read fine, so don't "fix" them into random tokens — renaming an id orphans every `dep:` pointing at it.
- **Re-stamp `last_updated` on every write.** The dashboard's staleness view keys off it, so a checkpoint that skips the stamp makes active work look abandoned.
- **`save` stops work.** Users who type it mid-flow expecting a checkpoint then wonder why you halted; a bare `/track-session` is the one that checkpoints and continues.
- **Recovery rarely finds a clean blob.** Because updates are incremental `Edit`s, the transcript usually holds no full `Write` — expect to replay edits over the latest snapshot rather than lifting one copy out.

## Integration

- **track-roadmap** — pick a feature from the roadmap, then link its implementation here via `roadmap_ref: r_XXXXX`.
- Checkpoint between commits and test phases, so the file's state lines up with a commit boundary a later session can `git show`.

See [reference/TROUBLESHOOTING.md](./reference/TROUBLESHOOTING.md) for resume failures, oversized session files, and verify edge cases.
