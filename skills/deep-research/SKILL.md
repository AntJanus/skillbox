---
name: deep-research
description: Use this skill for deep, multi-source web research with cited synthesis whenever the user wants to "research X", "deep research on Y", "deep dive on Z", "investigate this topic", "compare X and Y", "pros and cons of X", or "survey the landscape of Y" — even if they never say "research", any ask needing several independent sources cross-referenced and cited counts. Do NOT use this skill for a single fact one WebSearch answers, for reviewing code (see code-review), or for exploring files in the current repo (use Explore).
license: MIT
argument-hint: "<topic>"
effort: high
metadata:
  author: Antonin Januska
  version: "2.4.2"
---

# Deep Research

## Overview

Research a topic across many sources and return a cited, structured synthesis in the conversation. Breadth of angle, depth of cross-reference, and citation discipline are what separate this from a search snippet. Keep output in chat — write a file only when asked.

## Five search angles

Cover at least 3 every run; name them in the plan and tag each search.

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

For **opinion-shaped** asks ("should I use X?") where you already have a grounded take: answer directly first, then offer to escalate. Ten searches in response to a request for a confident opinion wastes the user's turn.

## Workflow — each step gates the next

1. **Local-first** — `rg "<topic>" .` and Read the obvious matches before any web search. If local material already covers it, default to UPDATE rather than CREATE. State what you found; "no local hits" is a fine result.
2. **Plan** — Post the interpretation, the angles you'll use, and the mode, then start searching. The posted plan is what step 5 measures against.
3. **Disambiguate** (when needed) — For ambiguous proper nouns and acronyms, run one broad search to fix the referent and state it. Ask the user if it's still unclear. When a query centers on a name you recognize from a fast-moving area — AI models, developer tools, anything that shifts within months — the name itself is the thing to verify: search before answering, and include it as the user wrote it in at least one query. Partial background is exactly what makes an out-of-date answer sound authoritative, so familiarity is not a reason to skip the search.
4. **Search** — 5+ searches minimum. Broad → specific → tension ("X criticism", "X vs alternatives") → currency. **WebFetch every source you'll cite substantively** — a search-results snippet is not a read. Prefer primary > secondary > tertiary. When two sources disagree, carry the disagreement into the report instead of silently picking one.
5. **Sufficiency gate** — Post one line: `searches: N | angles: <list> | full reads: M | gaps: <list>`. If a planned section has no material behind it, search again or cut it — don't pad.
6. **Synthesize** — Use the template below; adapt section names to the topic. Check the last round of findings against the plan from step 2; when they conflict, revise the Tl;dr rather than burying the conflict lower down.
7. **Cite-verify** — Every cited URL must trace to a page you fetched this run. Walk each non-trivial claim to its source, then restate the user's original question and cut sections that don't serve it.

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

**Source rules:** 8-15+ for a substantive topic; every claim traceable; annotate each source with what it contributed; include publication dates; mix official, industry, and community.

**Length:** match the report to the question — a default-mode run is roughly one screen of prose plus the source list. Cut any template section the sources don't fill rather than padding it, and offer to expand a section instead of writing it speculatively.

## Examples

✅ **Good** (`quick` mode, abbreviated — step numbers match the workflow above):

```
user: quick read on whether Bun is stable enough for a CLI tool
assistant:
[1] No local material. [2] Mode: quick. Angles: Official, Criticism, Currency.
[5] searches: 4 | angles: 3 | full reads: 3 | gaps: Windows support thin

Bun 1.x is stable for single-binary CLIs on macOS and Linux; Windows still
trails on a few Node APIs, so check your dependency list against the compat
table. *Confidence: med — official compat table + two 2026 issue threads; no
Windows production reports found.*
Sources: [bun.sh compat table (2026-06)](url) — API coverage · [GitHub issue (2026-05)](url) — Windows gaps · [HN thread (2026-04)](url) — field reports
```

❌ **Bad:** one search for "htmx" → "It's a lightweight JS library, alternative to React, some people like it. Sources: htmx.org" — no local check, no plan, no cross-reference, no confidence label, one source.

✅ **Good** (disagreement handled): "Source A (official docs, 2026) says the flag defaults on; Source B (widely-cited blog, 2024) says off. The default changed in v3 — B predates it." Both cited, dates carry the resolution.

Full default-mode (htmx) and comparison-mode walkthroughs: [references/EXAMPLES.md](./references/EXAMPLES.md).

## Gotchas

- **Fabricated citations are the dominant failure mode.** Cite a URL only if you fetched it this run. If a fetch fails, find a reachable equivalent or drop the claim — never reconstruct a plausible-looking URL.
- **WebFetch returns boilerplate or nothing on paywalled and JS-rendered pages.** That counts as not read. Say so, or search for an accessible mirror; don't backfill from the search snippet and count it toward `full reads`.
- **Top-ranked is not authoritative.** SEO content farms and AI-written recaps outrank primary docs on most technical queries. Prefer official docs, .gov/.edu, and peer-reviewed sources for technical claims, and take the publication date from the page itself — search-result dates are often re-index dates.
- **Pushback is not evidence.** When the user disputes a sourced claim, run another search rather than reversing. Report what the new sources say, including "they still support the original claim."
- **Multi-agent landscape runs drift hardest.** Each subagent optimizes its own angle, so the consensus pass in step 6 is where the original question gets re-read — not the end.
- **Three or more items still need the matrix, even in `quick` mode.** Prose comparison of 3+ options is unreadable; a five-row matrix costs less space than the paragraphs it replaces.
- **A stale year in a query silently poisons currency.** Put the current year in currency-angle queries — undated results skew years old.
- **Summaries reproduce source passages without marking them.** When a sentence is the source's wording, quote it and attribute it; otherwise reword in your own indirect speech. One short marked phrase per source is the pattern — the worked example in [references/EXAMPLES.md](./references/EXAMPLES.md) shows it.

## Integration

- **track-session** — for long research projects, save the plan and source list to SESSION_PROGRESS.md so the run is resumable.
- **track-roadmap** — research informs roadmap decisions; cite the summary in the entry.
- Research informs a decision; it doesn't make one. Reading the codebase is step 1, user preferences come from AskUserQuestion, and the design call stays with the user.

Multi-agent landscape mode, the save-as-note handoff, and troubleshooting: [references/PLAYBOOK.md](./references/PLAYBOOK.md).
