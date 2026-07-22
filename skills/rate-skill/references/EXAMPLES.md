# Rate Skill — Worked Examples

## Example 1 — directive description rewrite (the most common P0 fix)

✅ Anthropic middle-ground form, third person, enumerated triggers, negative scoping:

```yaml
description: Use this skill whenever the user wants to review a React component for hook misuse, infinite-loop risk, or dependency-array bugs. Triggers include "review this component", "check my hooks", or "audit this React file". Do NOT use this skill for non-React JavaScript or for general code review.
```

❌ Passive single sentence — caps Category 1 at 70 and bleeds into Conciseness:

```yaml
description: Use when reviewing React components for hook issues.
```

## Example 2 — frontmatter cleanup

❌ Top-level fields that belong in `metadata`, plus a multiline description:

```yaml
---
name: My-Skill                # uppercase
version: "1.0.0"              # top-level — move under metadata
tags: [react, hooks]          # top-level — move under metadata
description: |                # multiline silently breaks discovery
  A skill for working with React.
  Helps with hooks.
---
```

*(`hooks` is **not** a finding — it's a valid Claude Code top-level key. Don't deduct for it; see the extension-key gotcha in SKILL.md.)*

✅ Patch:

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

## Example 3 — desired report opener (high-quality skill)

✅ What a good report looks like in practice:

```
# Skill Rating: track-session

**Detected type:** methodology
**Overall grade:** A (92/100)

## Strengths
- Description front-loads "track-session resumes work" — distinctive trigger in first 30 chars.
- ✅/❌ examples with desired pattern shown first.
- Body 287 lines with `references/TROUBLESHOOTING.md` for overflow.
```
