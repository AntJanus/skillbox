---
name: reflect
description: |
  Extract learnings from today's Claude Code conversations and save them to CLAUDE.md or auto-memory.
  Use when asked to "reflect on today", "what did I learn today", "extract learnings",
  "save what I learned", "learn from today", "reflect on this session", "capture insights",
  or at the end of a work session when the user wants to preserve discoveries, corrections,
  and decisions as persistent knowledge.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.0.0"
  argument-hint: "[global]"
tags: [memory, learning, reflection, context, session, knowledge]
---

# Reflect

> **Reflection activated** - I'll analyze today's conversations, extract learnings, and help you save them where they'll be most useful.

## Overview

Reads today's Claude Code conversation history for the current project, identifies corrections, discoveries, architecture decisions, and debugging breakthroughs, then presents each learning for the user to save to their preferred location (project CLAUDE.md, global CLAUDE.md, or auto-memory).

**Core principle:** Conversations contain valuable knowledge that evaporates when sessions end. Capture it before it's gone.

## Usage Modes

| Mode | Command | What it does | Use when |
|------|---------|-------------|----------|
| **Default** | `/reflect` | Analyze current project's today conversations | End of work session or during breaks |
| **Global** | `/reflect global` | Analyze ALL projects' conversations from today | End of day, reviewing cross-project work |

## When to Use

**Always use when:**
- Ending a long work session where you learned something new
- After debugging sessions that revealed important insights
- After making architecture decisions you want to remember
- When the user says "that was useful, let's save that" or similar
- End of day to capture cross-session discoveries

**Useful for:**
- Building up project CLAUDE.md with hard-won knowledge
- Capturing debugging patterns to prevent repeating mistakes
- Recording architecture decisions with rationale
- Saving workflow tips and build command discoveries
- Accumulating team conventions from real usage

**Avoid when:**
- Session was trivial (quick fixes, typo corrections)
- User already manually documented learnings
- No conversations exist for today
- Quick one-off tasks where nothing new was learned

---

## Process

### Phase 1: Gather Conversations

**1. Determine project slug**

The project slug is derived from the git repo root path with `/` replaced by `-` and prefixed with `-`:
- `/Users/antonin/projects/myapp` → `-Users-antonin-projects-myapp`

If unsure, list `~/.claude/projects/` and match by checking the `cwd` field in conversation files.

**2. Find today's conversation files**

For **default mode** (current project only):
```bash
# List JSONL files modified today in the project directory
ls -lt ~/.claude/projects/{project-slug}/*.jsonl
```

Filter to files modified today (compare file mtime with current date). Skip files under 1KB (abandoned sessions).

For **global mode** (all projects):
```bash
# Read history.jsonl and find all today's session IDs
# Then locate their full JSONL files across all project directories
```

Parse `~/.claude/history.jsonl` entries where `timestamp` falls within today's date range. Group by `project` and `sessionId`. Then read the full JSONL files from each project's directory.

**3. Parse conversation content**

For each JSONL file, read line by line and extract messages:

- **Include:** Lines where `type` is `"user"` or `"assistant"`
- **Skip:** Lines where `isSidechain: true` (subagent noise)
- **Skip:** Lines where `isCompactSummary: true` (machine-generated summaries)
- **Skip:** Lines where `type` is `"progress"` or `"file-history-snapshot"` (metadata)
- **Extract from user messages:** `message.content` (string or array of content blocks)
- **Extract from assistant messages:** Text content blocks (`type: "text"`) and thinking blocks (`type: "thinking"`)

Focus on extracting the **conversation flow** - user requests, Claude responses, corrections, and outcomes.

**Verification before analyzing:**
- [ ] Project slug resolved correctly
- [ ] Today's JSONL files identified (at least 1 found)
- [ ] Messages parsed with sidechains and metadata filtered out

### Phase 2: Analyze for Learnings

Read through the parsed conversations and identify these categories of learnings:

**Category 1: Corrections** (highest value)
User corrected Claude's approach or output. Look for:
- "Actually, use X instead of Y"
- "No, that's wrong because..."
- "That doesn't work, try..."
- User providing a better solution after Claude's attempt
- Repeated attempts before finding the right approach

**Category 2: Discoveries**
New information that wasn't known before:
- "Oh, I didn't know X supported Y"
- Build commands or config that worked after troubleshooting
- API behaviors discovered through testing
- Library features or patterns found during implementation

**Category 3: Architecture Decisions**
Choices made about how to structure code:
- "Let's use pattern X because..."
- User confirming or rejecting a proposed approach
- Trade-off discussions with a clear winner
- Convention choices ("we'll always do X this way")

**Category 4: Debugging Breakthroughs**
Root causes found during debugging:
- Error messages and their actual causes
- "The issue was actually..."
- Environment/config gotchas
- Subtle bugs and their fixes

**Category 5: Workflow Insights**
Process or tooling discoveries:
- Commands that work better than expected
- Workflow optimizations
- Tool configurations
- Integration patterns between tools

**For each learning, extract:**
1. **Title** - Short, descriptive label (e.g., "pytest requires -n flag for parallel workers")
2. **Context** - What prompted this learning (1-2 sentences)
3. **Learning** - The actual insight, formatted as an actionable rule or note
4. **Category** - One of the 5 categories above
5. **Suggested scope** - `project` (specific to this codebase), `global` (useful everywhere), or `memory` (transient working knowledge)

**Verification before presenting:**
- [ ] At least 1 learning extracted (if none found, report honestly)
- [ ] Each learning has title, context, learning text, category, and suggested scope
- [ ] Learnings are deduplicated (same insight from multiple conversations = one learning)
- [ ] Sensitive data stripped (no API keys, tokens, passwords)

### Phase 3: Present and Save

**Present learnings to the user one at a time** using this format:

```markdown
### Learning #N: [Title]
**Category:** [Correction | Discovery | Architecture Decision | Debugging Breakthrough | Workflow Insight]
**Context:** [What prompted this]
**Learning:** [The actionable insight]
**Suggested scope:** [project | global | memory]
```

**For each learning, ask the user via AskUserQuestion:**

```
Question: "Where should this learning be saved?"
Options:
1. Project CLAUDE.md - Save under ## Learnings in ./CLAUDE.md
2. Global CLAUDE.md - Save under ## Learnings in ~/.claude/CLAUDE.md
3. Auto-memory - Save to project's MEMORY.md (working knowledge)
4. Skip - Don't save this one
```

**When saving to CLAUDE.md (project or global):**

1. Read the existing CLAUDE.md file
2. Look for a `## Learnings` section
3. If it exists, append the new learning under it
4. If it doesn't exist, add `## Learnings` before the last section (or at the end)
5. Format the learning as a bullet point:

```markdown
## Learnings

- **[Title]** — [Learning text] _(captured [date])_
```

**When saving to auto-memory:**

1. Read `~/.claude/projects/{project-slug}/memory/MEMORY.md`
2. Create the file if it doesn't exist
3. Look for a `## Session Learnings` section
4. Append the learning:

```markdown
## Session Learnings

- **[Title]** — [Learning text] _(captured [date])_
```

If MEMORY.md is approaching 200 lines, warn the user: "MEMORY.md is near the 200-line auto-load limit. Consider moving older entries to a topic file."

**After saving all learnings, present a summary:**

```markdown
## Reflection Complete

**Learnings saved:**
- [N] to project CLAUDE.md
- [N] to global CLAUDE.md
- [N] to auto-memory
- [N] skipped

**Files modified:**
- [list of files that were written to]
```

**Verification:**
- [ ] All user-approved learnings saved to chosen locations
- [ ] CLAUDE.md formatting preserved (no broken markdown)
- [ ] Summary presented with counts

---

## Rules

1. **Read before analyzing** - Always parse actual conversation JSONL files. Never fabricate learnings.
2. **User controls every save** - Present each learning individually and let the user decide where (or whether) to save it. Never auto-save without approval.
3. **Actionable over anecdotal** - Transform observations into actionable rules. Bad: "We debugged pytest". Good: "pytest -n flag requires pytest-xdist package to be installed".
4. **Strip sensitive data** - Never include API keys, tokens, passwords, or credentials in saved learnings.
5. **Respect existing structure** - When appending to CLAUDE.md, preserve existing sections and formatting. Add a `## Learnings` section if needed, don't restructure the file.
6. **Honest about gaps** - If no learnings are found, say so. Don't generate fake insights to fill space.
7. **Deduplicate** - If the same insight appears in multiple conversations, save it once.

---

## Examples

### Example: Correction Learning

<Good>
```markdown
### Learning #1: Use dataclasses not TypedDict for structured config
**Category:** Correction
**Context:** Started with TypedDict for app configuration but user corrected to use dataclasses.
**Learning:** Prefer `@dataclass` over `TypedDict` for structured configuration objects — dataclasses provide runtime validation, default values, and `__post_init__` hooks that TypedDict lacks.
**Suggested scope:** global
```

**Saved to `~/.claude/CLAUDE.md` as:**
```markdown
## Learnings

- **Use dataclasses not TypedDict for structured config** — Prefer `@dataclass` over `TypedDict` for structured configuration objects — dataclasses provide runtime validation, default values, and `__post_init__` hooks that TypedDict lacks. _(captured 2026-03-21)_
```
</Good>

<Bad>
```
We used dataclasses today. They're good.
```

**Why this is bad:** Not actionable, no context, no comparison to the alternative, no rationale.
</Bad>

### Example: Debugging Breakthrough

<Good>
```markdown
### Learning #3: CORS errors on localhost are often port mismatch
**Category:** Debugging Breakthrough
**Context:** API calls from React dev server (port 3000) to FastAPI (port 8000) returned CORS errors despite allow_origins=["*"].
**Learning:** When debugging CORS on localhost, check that `allow_origins` includes the full origin with port (e.g., `http://localhost:3000`). The wildcard `*` doesn't work with `allow_credentials=True`.
**Suggested scope:** global
```
</Good>

<Bad>
```
Fixed CORS. It was a config issue.
```

**Why this is bad:** Doesn't explain what the fix was, so it won't help prevent the same issue next time.
</Bad>

### Example: No Learnings Found

<Good>
```markdown
## Reflection Complete

No significant learnings found in today's conversations. The sessions were routine
work (commits, minor fixes) without corrections, discoveries, or decisions worth
capturing.

**Sessions analyzed:** 3
**Time range:** 09:00 - 14:30
```
</Good>

<Bad>
```
ERROR: No learnings detected. Reflection failed.
```

**Why this is bad:** Finding no learnings is a valid outcome, not an error.
</Bad>

---

## Troubleshooting

### Problem: No conversation files found for today

**Cause:** No Claude Code sessions were run today in this project, or the project slug doesn't match.

**Solution:**
- List `~/.claude/projects/` and look for a matching slug
- Check if the repo root path matches the expected slug format
- Try `/reflect global` to scan all projects
- If truly no sessions today, report: "No conversations found for today."

### Problem: Very large JSONL files (>1MB)

**Cause:** Long sessions produce large files.

**Solution:**
- Read only `type: "user"` and `type: "assistant"` lines
- Skip `progress`, `file-history-snapshot`, and `isSidechain: true` entries
- Focus on the last 50 user messages if the file is extremely large
- Consider processing in chunks

### Problem: CLAUDE.md has no ## Learnings section

**Cause:** First time saving learnings to this file.

**Solution:**
- Add `## Learnings` section at a logical position (before "Do Not" section if one exists, or at the end)
- Don't restructure existing content
- Add a brief intro line: learnings captured from work sessions

### Problem: MEMORY.md over 200 lines

**Cause:** Auto-memory has accumulated a lot of content.

**Solution:**
- Warn the user that only the first 200 lines are auto-loaded
- Suggest moving older or topic-specific entries to separate files (e.g., `debugging.md`)
- Link from MEMORY.md: `See [debugging notes](./debugging.md) for detailed debugging patterns`

### Problem: Learnings seem trivial or obvious

**Cause:** AI extraction is overly aggressive on minor points.

**Solution:**
- Apply a significance threshold: skip learnings that are common knowledge
- Focus on corrections (user explicitly said something was wrong) and debugging breakthroughs (actual problems solved)
- When in doubt, present it to the user - they can skip trivially

---

## Integration

**This skill works with:**
- **remember** - `/remember` reconstructs context from past sessions. `/reflect` extracts and persists learnings from today's sessions. Use `/remember` when returning to a project, `/reflect` when ending a session.
- **track-session** - If a session is active, `/reflect` can include SESSION_PROGRESS.md context when analyzing what was learned during tracked work.
- **track-roadmap** - Architecture decisions captured by `/reflect` often relate to roadmap features in progress.

**Workflow pattern:**
```
Work session → /reflect → Save learnings → /track-session save → End session
```

**How this skill differs from related commands:**

| Command | Purpose | Use when |
|---------|---------|----------|
| `/reflect` | Extract and save learnings from today | End of session, want to preserve knowledge |
| `/remember` | Reconstruct context from past sessions | Starting a session, need to catch up |
| `/memory` | View/edit Claude's auto-memory directly | Manual memory management |
| `claude --continue` | Resume last conversation | Want to keep the same context window |

---

## References

- [Claude Code Memory Documentation](https://code.claude.com/docs/en/memory) - Official auto-memory system docs
- [claude-reflect](https://github.com/BayramAnnakov/claude-reflect) - Inspiration for correction detection patterns
- [Claudeception](https://github.com/blader/Claudeception) - Autonomous skill extraction approach
- [claude-mem](https://github.com/thedotmack/claude-mem) - Full session capture and compression
