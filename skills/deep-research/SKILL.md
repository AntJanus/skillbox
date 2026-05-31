---
name: deep-research
description: Multi-source web research with cited synthesis in chat. Use when asked to "research X", "deep research on Y", "deep dive on Z", "investigate this topic", "compare X and Y", "pros and cons of X", or "survey the landscape of Y".
license: MIT
argument-hint: "<topic>"
metadata:
  author: Antonin Januska
  version: "2.2.0"
---

# Deep Research

Multi-source research that earns its name through **breadth of angle, depth of cross-reference, and discipline of citation.** Run 5+ web searches across diverse angles, prefer primary sources, surface disagreements, and return a structured, cited summary in the conversation. Always cite. Never fabricate. Output stays in chat — no files unless asked.

## Five Search Angles

Cover at least 3 every run; state which in the plan and tag each search.

| Angle | Looks for |
|-------|-----------|
| Official | Primary docs, specs, vendor sources, peer-reviewed papers |
| Comparative | "X vs Y", alternatives, head-to-head analyses |
| Criticism | Limitations, known issues, failure stories |
| Currency | Recent developments, changelogs, trend pieces (include the year in queries) |
| Community | HN, Reddit, blogs, Stack Overflow — signal, not authority |

## Modes

| Mode | Trigger | Searches | Output |
|------|---------|----------|--------|
| `quick` | "quick read on X", low-stakes | 3-5 | One paragraph + 3-5 sources; lighter gates |
| default | standard single-domain topic | 5-10+ | Full synthesis template |
| `comparison` | "compare X and Y", "pros and cons" | 10-15 | Matrix required at top of report |
| `landscape` | "survey the landscape of X", broad space | 10+ | Parallel subagents → consensus ([PLAYBOOK](./references/PLAYBOOK.md)) |

For **opinion-shaped** asks ("should I use X?") where you already have a grounded take: give a brief direct answer first, then offer to escalate. Don't launch 10 searches when the user wanted a confident opinion.

## Process — each phase gates the next

1. **Local-first** — `rg "<topic>" .` and Read obvious matches before any web search. If local material covers it, default to UPDATE not CREATE. State what you found ("no local hits" is fine).
2. **Plan** — Post the interpretation, the angles you'll use, and the mode. Wait one beat before searching.
3. **Disambiguate** (when needed) — For ambiguous proper nouns/acronyms, run one broad search to fix the referent; state it. Ask the user if still unclear.
4. **Search** — 5+ searches minimum. Broad → specific → tension ("X criticism", "X vs alternatives") → currency. **WebFetch every source you'll cite substantively** — don't cite from snippets. Prefer primary > secondary > tertiary; look past SEO content farms to the authoritative source. If two sources disagree, surface it — don't silently pick one.
5. **Reflect** (sufficiency gate) — Post one line: `searches: N | angles: <list> | full reads: M | gaps: <list>` and answer "what would change my conclusion?" If a planned section has no material, search more or cut it. Don't pad.
6. **Synthesize** — Use the template below; adapt section names to the topic.
7. **Cite-verify** — Every cited URL must have been actually fetched this run. Walk each non-trivial claim to a source. Restate the original question and confirm every section serves it.

## Synthesis template

```markdown
# [Topic] — Research Summary
> Interpreted as: [if ambiguity was present]

## Tl;dr
[2-3 sentences answering the original question.] *Confidence: high/med/low — why.*

## Overview / Core Information
Definition, how it works, key concepts. *Confidence: ...*

## Comparison Matrix  [REQUIRED when comparing 3+ items, place right after Tl;dr]
| Item | Dimension 1 | Dimension 2 | Notes |
|------|-------------|-------------|-------|

## Trade-offs and Criticism
Limitations, valid criticisms, when not to use this. *Confidence: ...*

## Current Landscape
Recent developments, adoption signal, direction. Note disagreements. *Confidence: ...*

## What we still don't know  [when gaps are non-trivial]
- Open question

## Sources  [group under sub-headers when >5]
- [Title (YYYY-MM-DD)](url) — what this contributed
```

**Source rules:** 8-15+ for a substantive topic; every claim traceable; annotate each with what it contributed; include publication dates; mix official, industry, and community.

## Failure-mode defenses

The non-obvious value of this skill — guard against the documented LLM-research failure modes:

- **Sycophancy** — Don't flip a sourced claim under user pushback without new evidence. The next move on pushback is *another search*, not capitulation.
- **Anchoring** — At synthesis, ask "what would change my conclusion?" If late searches contradict the early framing, update.
- **SEO / source laundering** — Top search hits ≠ authoritative. Prefer official docs, .gov, .edu, peer-reviewed for technical claims.
- **Fabricated citations** — The dominant hallucination class. If you didn't open it, don't cite it.
- **Drift** — Restate the original question at synthesis and cut sections that don't serve it (multi-agent runs drift hardest).

## Example

✅ **Good** (default mode, abbreviated):

```
user: research htmx for me — thinking about a side project
assistant:
[P0] No local material. [P1] Mode: default. Angles: Official, Comparative, Criticism, Currency, Community.
[P4] 8 searches, 5 angles, 4 full reads. Gap: htmx + auth thin.

# htmx — Research Summary
## Tl;dr
Fits server-rendered side projects with light-to-moderate interactivity; poor fit for client-rich UX.
*Confidence: high — official docs + three recent analyses converge.*
## Trade-offs
- Sentiment splits "elegant return to basics" vs "not a SPA replacement" — disagreement noted
## Sources
### Official — [htmx.org (2026)](url) — reference
### Comparative — [htmx vs React (Mar 2026)](url) — benchmarks
```

❌ **Bad:** one search "htmx" → "It's a lightweight JS library, alternative to React, some people like it. Sources: htmx.org" — no Phase 0, no plan, no cross-reference, no confidence, one source.

See [references/EXAMPLES.md](./references/EXAMPLES.md) for full default-mode and comparison-mode walkthroughs.

## Integration

- **track-session** — for long research projects, save the plan + source list to SESSION_PROGRESS.md so it's resumable.
- **track-roadmap** — research informs roadmap decisions; cite the summary in the entry.
- Does **not** replace reading the codebase (that's Phase 0), asking the user for preferences (use AskUserQuestion), or making the design decision (research informs, it doesn't decide).

See [references/PLAYBOOK.md](./references/PLAYBOOK.md) for multi-agent landscape mode, the save-as-note handoff, and troubleshooting.
