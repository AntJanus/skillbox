# Track Session — Recovering a Lost SESSION_PROGRESS.md

How `/track-session recover` rebuilds a missing or deleted `SESSION_PROGRESS.md` from the Claude Code session transcript.

The file's content survives in the transcript, but **not as one clean blob**. track-session updates incrementally, so a typical session shows one initial `Read` plus many `Edit`s and rarely a full `Write`. Recovery means: find the latest *full snapshot*, then replay the `Edit`s that came after it.

Content lives in three event shapes:

| Source | Cleanliness | Frequency |
|--------|-------------|-----------|
| `Write` tool_use → `input.content` | clean, verbatim | only on create / full rewrite |
| `Read` tool_result text | full, but `cat -n` line-number prefixed | every resume |
| `Edit` tool_use → `old_string`/`new_string` | clean fragments | most updates |

## Step 1 — Narrow the search

Ask the user for **branch**, **rough date**, and **topic** — these cut a large transcript set down fast.

## Step 2 — Locate the transcript

One directory per project, named by the cwd with `/` → `-` (leading slash becomes a leading `-`):

```bash
SLUG=$(pwd | sed 's/\//-/g')          # /Users/x/proj  ->  -Users-x-proj
DIR="$HOME/.claude/projects/$SLUG"
grep -rl 'cc-dash/session@1' "$DIR"/*.jsonl   # transcripts that touched a SESSION_PROGRESS.md
grep -o '"gitBranch":"[^"]*"' "$DIR"/<file>.jsonl | sort -u   # confirm the branch
```

Prefer the most recent match for the user's branch/topic.

## Step 3 — Reconstruct (use Python, not jq)

`jq 1.7.1-apple` mis-parses multi-step filters here and dumps its help text — **do not rely on it.** Python's `json` is reliable. This script walks the transcript in order, picks the latest full snapshot (a `Write`, else a `Read` result with line-number prefixes stripped), and replays later `Edit`s:

```python
import json, sys, re
f, TARGET = sys.argv[1], "SESSION_PROGRESS.md"
read_ids, events = {}, []
for line in open(f):
    line = line.strip()
    if not line: continue
    try: d = json.loads(line)
    except: continue
    msg = d.get("message")
    content = msg.get("content") if isinstance(msg, dict) else None
    if not isinstance(content, list): continue
    for b in content:
        if not isinstance(b, dict): continue
        if b.get("type") == "tool_use":
            inp = b.get("input", {}) or {}
            if TARGET not in str(inp.get("file_path", "")): continue
            if b.get("name") == "Write": events.append(("write", inp.get("content", "")))
            elif b.get("name") == "Edit": events.append(("edit", inp.get("old_string", ""), inp.get("new_string", "")))
            elif b.get("name") == "Read": read_ids[b.get("id")] = True
        elif b.get("type") == "tool_result" and b.get("tool_use_id") in read_ids:
            c = b.get("content", "")
            if isinstance(c, list): c = "".join(x.get("text", "") for x in c if isinstance(x, dict))
            events.append(("read", c))

# Base = last Write (clean); else the LONGEST Read result (a partial/offset read
# would lose the frontmatter). Then replay every later Edit — edits already baked
# into the base simply won't match and no-op.
writes = [(i, e[1]) for i, e in enumerate(events) if e[0] == "write"]
reads = [(i, e[1]) for i, e in enumerate(events) if e[0] == "read"]
if writes:
    base_idx, base = writes[-1]
elif reads:
    base_idx, raw = max(reads, key=lambda r: len(r[1]))
    base = "\n".join(re.sub(r'^\s*\d+\t', '', ln) for ln in raw.splitlines())  # strip cat -n prefixes
else:
    base_idx, base = -1, None
for e in events[base_idx + 1:]:
    if e[0] == "edit" and base and e[1] in base:
        base = base.replace(e[1], e[2], 1)
print(base or "")
```

```bash
python3 recover.py "$DIR/<transcript>.jsonl" > SESSION_PROGRESS.md
```

Then **re-stamp `last_updated`** to now and set `status` (usually `paused`). If the base came from a `Read` (not a `Write`), tell the user the result is reconstructed and may miss edits made after the last read in the transcript.

## Step 4 — Fallback when no transcript content exists

Transcripts cleared, different machine, or no `SESSION_PROGRESS` events found — **do not fabricate a confident plan.** Rebuild only what's verifiable and label it partial:

```bash
git reflog --date=relative | head -30      # what moved when
git log --oneline -15 BRANCH               # commit messages ≈ the plan
git diff main...BRANCH --stat              # files touched = scope
```

Write a fresh file from that plus the user's recollection, mark uncertain items, and note in it that it was reconstructed from git history, not recovered.

## Step 5 — Hand off

Once the file exists, switch to `resume`: read it, continue from **Next**.

## Gotchas

- **No single `Write` is the norm** — incremental `Edit`s mean you must replay, not grab one blob. A pure-Edit session has no clean base; fall back to the latest `Read` result.
- **`Read` results carry `cat -n` prefixes** (`   123\t…`) and may be truncated on huge files — strip prefixes; flag possible truncation.
- **jq is unreliable here** — use the Python script. If you must grep, grep for `cc-dash/session@1` to find the right transcript.
- **`TodoWrite` is not a plan source** — many sessions never call it. Trust the file's own logged content.
- **Same machine/user only** — transcripts are `0600` under `~/.claude/projects/`; `gitBranch` can be empty if the session ran outside a git branch.
