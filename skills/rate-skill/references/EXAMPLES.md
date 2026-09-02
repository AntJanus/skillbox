# Rate Skill — Worked Examples

Four pairs, each a different situation: description matchability, frontmatter shape, verification content (§7), and a full report instance.

## 1. Description — matchable vs. the vague-trigger cap

✅ Distinctive noun, literal user-language triggers, negative scope:

```yaml
description: Use this skill to update a CHANGELOG.md whenever the user wants to log a release. Triggers include "add this to the changelog", "prepare the v2.1 release notes", or "what changed since the last tag". Do NOT use this skill for writing commit messages.
```

❌ Same job, caps Category 1 at 50 — nothing an agent can match a request against:

```yaml
description: Use this skill whenever the user needs help with documentation tasks and related workflows.
```

## 2. Frontmatter — accepted keys only

✅ Extras nested under `metadata`:

```yaml
---
name: react-hooks-audit
description: Use this skill whenever the user wants to review a React component for hook misuse, infinite-loop risk, or dependency-array bugs. Triggers include "review this component", "check my hooks", or "audit this React file". Do NOT use this skill for non-React JavaScript.
license: MIT
argument-hint: "<path/to/component.tsx>"
metadata:
  author: <author>
  version: "1.0.0"
  tags: [react, hooks]
---
```

❌ Before the patch — top-level fields that belong in `metadata`, plus a first-person vague description:

```yaml
---
name: My-Skill                # uppercase
version: "1.0.0"              # top-level — move under metadata
tags: [react, hooks]          # top-level — move under metadata
description: I help you work with React and hooks.   # first-person + no triggers
---
```

*(`hooks` is **not** a finding — a valid Claude Code top-level key. See the extension-key gotcha in SKILL.md.)*

## 3. Verification — external state vs. self-re-check

✅ Gates on something outside the agent. Scores fine:

```markdown
Run `npm test -- auth.spec.ts` and confirm it exits 0 before starting Phase 3.
Confirm `dist/index.js` exists and parses before tagging.
```

✅ Audits a progress claim against evidence, or hands the judgment to a fresh-context agent. Scores fine — both are recommended for long-running work:

```markdown
Before reporting progress, tie each claim to a tool result from this session;
say plainly which items are not yet verified.
Dispatch one verifier agent with the diff and the candidate findings; it re-reads
each cited line and drops findings whose citation is wrong.
```

❌ Tells the model to re-read its own output with nothing external to check against — §7 deduction, because it already does this and the instruction compounds:

```markdown
Before responding, double-check your answer. For any non-trivial task, add a
final verification step and use a subagent to verify your work.
```

## 4. A complete report (abridged category rows, one finding shown)

✅ Every section present; the finding ships a paste-ready patch:

```
# Skill Rating: track-session

**Detected type:** methodology
**Overall grade:** A (92/100)
**Eval set:** present + conforms (20 queries, 60/40 split, protocol stated)

## Category scores

| Category | Score | Weight | Weighted |
|---|---|---|---|
| Description quality | 95 | 25 | 23.8 |
| Frontmatter validity | 100 | 20 | 20.0 |
| Length & disclosure  | 100 | 15 | 15.0 |
| Structure            | 90 | 15 | 13.5 |
| Examples             | 85 | 10 |  8.5 |
| Conciseness          | 80 | 10 |  8.0 |
| Anti-patterns/calib. | 65 |  5 |  3.3 |

## Strengths
- Description front-loads "track-session resumes work" — distinctive trigger in first 30 chars.
- ✅/❌ examples with desired pattern shown first.
- Body 287 lines with `references/TROUBLESHOOTING.md` for overflow.

## Findings (prioritized)

### P1 — Bare "NEVER retry" mandate without reasoning
**Why:** §7 — rigid directive where explained reasoning is official guidance.
**Fix:**
```markdown
Don't retry a failed approach unchanged — repeating it wastes the turn and
re-triggers the same failure. Exception: the environment changed (e.g., an MCP
server reconnected); then one retry is justified.
```

## Estimated grade after P0+P1: A (95/100)

fix(track-session): replace bare NEVER-retry mandate with explained rule
```

## Retired rules (do not reintroduce)

- **Multiline `description:` breaking discovery (#9817)** — real through mid-2026, fixed as of Claude Code 2.1.220, verified with probe skills 2026-07-27. Scalar style is no longer scored.
- **The ≤230-char description soft target** — no official basis. Listing eviction is least-invoked-first, so workhorse skills keep their full text; official sizing is "a few sentences to a short paragraph."
- **The +5 bonus for shipping an eval set** — replaced by a standing P1 for its absence (skill-creator optimizer shipped 2026-03-03).
- **`## Verification Checklist` as a recommended methodology section** — dropped from §4 in 5.0.0. The Opus 5 guidance was to *remove* carried-over verification instructions rather than reword them, since they compound with behavior the model already performs. Narrowed in 6.0.0: the Fable 5.1 guidance keeps test-or-check-before-reporting instructions, recommends fresh-context verifier agents over self-critique, and recommends auditing progress claims against tool results. Generic self-re-check with no external referent stays a §7 deduction; the three carve-outs in §7 score fine (see pair 3). Don't reintroduce the section as a spec requirement — judge content, not headings.
