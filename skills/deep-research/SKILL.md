---
name: deep-research
description: |
  Conduct multi-source web research on a topic and synthesize a comprehensive,
  well-sourced summary directly in the conversation. Use when asked to
  "research X", "do a deep dive on Y", "look into Z", "investigate this topic",
  "find out about Q", "what's the current state of X", "give me a thorough
  overview of Y", or when the user needs current, well-cited information
  before making a decision or starting a project. No files are created
  unless explicitly requested.
license: MIT
argument-hint: "<topic>"
metadata:
  author: Antonin Januska
  version: "1.0.0"
---

# Deep Research

> **Deep research activated** — I'll run multi-source web research on this topic, cross-reference findings, and present a structured summary with sources in the conversation.

## Overview

Run thorough, multi-source web research on a topic. Search across 5-10+ queries with diverse angles, cross-reference claims across sources, prioritize current and authoritative material, and synthesize the findings into a structured, fully-cited summary returned in the conversation.

**Core principle:** Research depth comes from query diversity and source cross-referencing, not from a single search. Always cite. Never fabricate.

## Usage

| Invocation | What happens |
|------------|--------------|
| `/deep-research <topic>` | Research the topic and present a structured summary with sources |
| `research X for me` | Same as above (auto-activates) |
| `look into Y and report back` | Same as above |

**Default behavior:** Output stays in the conversation. No files are created. If the user wants the report saved, they can ask explicitly afterward — that's a follow-up step, not part of this skill.

## When to Use

**Always use when:**
- User asks to "research", "investigate", "look into", or "deep dive on" a topic
- User needs current information before making a decision (tool choice, framework selection, product comparison)
- User wants a thorough overview of something unfamiliar
- User asks "what's the current state of X" or "what should I know about Y"

**Useful for:**
- Pre-implementation research (libraries, patterns, trade-offs)
- Comparative analysis (Tool A vs Tool B vs Tool C)
- Catching up on recent developments in a fast-moving space
- Sanity-checking assumptions against authoritative sources

**Avoid when:**
- Question can be answered from the codebase (use Read/Grep first)
- User wants a quick fact, not a synthesis (a single search is enough)
- Topic is internal to the user's project (no public sources will exist)
- User has already done the research and just wants implementation help

---

## Process

### Phase 1: Plan the Search

**Before searching, briefly state:**
- The interpretation of the topic (especially if ambiguous)
- 3-5 search angles you'll use

**Search angles should diversify across:**
- Official documentation and specifications
- Recent developments (current year and previous year)
- Comparative analyses ("X vs Y", "alternatives to X")
- Real-world usage and case studies
- Common pitfalls, criticisms, and limitations
- Community discussion (HN, Reddit, Stack Overflow, blog posts)

### Phase 2: Execute Searches

**Run 5-10+ web searches minimum.** A single search is not deep research.

**Query strategy:**
- Start broad ("what is X", "X overview")
- Narrow into specifics ("X best practices", "X performance characteristics")
- Look for tension ("X criticism", "problems with X", "X vs alternatives")
- Look for currency (include the year in queries when relevant)
- Use WebFetch to read full articles when search snippets are insufficient

**Source quality priorities:**
1. Official docs, specifications, and primary sources
2. Reputable industry publications and recent technical blogs
3. Academic papers (arXiv) when relevant
4. Community discussion (treat as signal, not authority)

**Cross-reference rule:** If two sources disagree, note the disagreement explicitly. Do not silently pick one.

### Phase 3: Handle Ambiguity

If the topic is vague:
1. Interpret generously — research the most likely intended meaning
2. State the interpretation at the top: "Interpreted as: [your read]"
3. Cover breadth before depth so the user can narrow
4. Mark thin sections honestly: "Limited sources available" beats speculation

### Phase 4: Synthesize and Report

Output a structured summary in this format. Adapt section names to fit the topic (technical vs. product vs. concept):

```markdown
# [Topic] — Research Summary

> Interpreted as: [if ambiguity was present]

## Overview
Clear definition, why this matters, key concepts.

## Core Information
How it works, main features, technical details. Tailor sections to the topic.

## Practical Details
Tools, libraries, products in this space. Best practices. Common pitfalls.

## Trade-offs and Criticism
Limitations, valid criticisms, when not to use this.

## Current Landscape
Recent developments, adoption signal, where things are heading.
Note any source disagreements explicitly.

## Sources
- [Source title 1](url) — what this contributed
- [Source title 2](url) — what this contributed
- ...
```

**Source list rules:**
- Every claim in the summary should be traceable to a listed source
- Include 8-15+ sources for a substantive topic
- Annotate each source briefly (one phrase: what it contributed)
- Mix official, industry, and community sources

---

## Examples

### Example 1: Technical Topic

<Good>
```
user: research htmx for me — thinking about using it for a side project

assistant: [Interpretation: htmx as a hypermedia-driven frontend approach,
with focus on whether it fits a side project context.]

[Runs 8 searches: "htmx official docs", "htmx vs react 2026", "htmx use cases",
"htmx limitations", "htmx production usage", "htmx state management",
"htmx alternatives", "htmx criticism"]

[Reads htmx.org docs via WebFetch, reads two recent comparison blog posts,
checks HN discussion]

# htmx — Research Summary

## Overview
htmx is a hypermedia-driven frontend library that extends HTML with
attributes for AJAX, WebSockets, and Server-Sent Events. Returns HTML
fragments from the server instead of JSON+client rendering...

## How It Works
[Technical detail with examples]

## When It Fits
- Server-rendered apps with light interactivity
- Teams already strong on the backend
- ...

## Trade-offs
- [Real limitations from sources]
- Community sentiment splits between "elegant return to basics" and
  "not a substitute for SPAs at scale" — note the disagreement

## Sources
- [htmx.org Documentation](url) — official reference
- [htmx vs React Comparison (Mar 2026)](url) — recent benchmarks
- [HN discussion thread](url) — community sentiment
- ...
```

**Why this is good:** States interpretation, runs many varied searches, cross-references via WebFetch, structures output cleanly, surfaces disagreement, every claim is backed by a cited source.
</Good>

<Bad>
```
user: research htmx for me

assistant: [Runs one search "htmx"]

htmx is a JavaScript library that lets you do AJAX with HTML attributes.
It's lightweight and an alternative to React. Some people like it.

Sources: htmx.org
```

**Why this is bad:** Single search, no cross-referencing, no interpretation of context, no trade-offs, vague claims without attribution, one source for a substantive topic.
</Bad>

### Example 2: Comparative Research

<Good>
```
user: investigate the tradeoffs between Postgres and SQLite for a small SaaS

assistant: [Interpretation: small SaaS = single-region, modest scale,
prioritize operational simplicity vs. scaling headroom.]

[Runs 9 searches across official docs, scaling case studies, recent
"litestream" / "fly.io SQLite at scale" content, Postgres operational
guides, real-world migration stories]

# Postgres vs SQLite for Small SaaS — Research Summary

## Overview
Both are mature, but optimized for different operational profiles...

## When SQLite Fits
[Concrete criteria with sources]

## When Postgres Fits
[Concrete criteria with sources]

## The Middle Ground
Litestream and LiteFS have shifted the conversation in 2024-2026...

## Migration Cost
[Practical detail]

## Sources
- [SQLite official docs - Appropriate Uses](url)
- [Fly.io: SQLite at scale (2025)](url)
- [Postgres operations guide](url)
- [Migration story: SQLite → Postgres at startup X](url)
- ...
```

**Why this is good:** Frames the comparison around the user's actual context (small SaaS), covers recent developments that change the answer (Litestream/LiteFS), addresses migration cost which is the real decision risk.
</Good>

<Bad>
```
user: investigate the tradeoffs between Postgres and SQLite

assistant: Postgres is more powerful, SQLite is simpler. Use Postgres
for production, SQLite for prototypes.

Sources: Wikipedia
```

**Why this is bad:** Generic answer that ignores the user's stated context, oversimplified to the point of being wrong (SQLite runs production at scale at many companies), one weak source.
</Bad>

---

## Quality Signals

A good deep-research output has these properties:

- **Interpretation stated upfront** — when the topic is ambiguous, the read is explicit and the user can correct it
- **5-10+ searches with diverse angles** — official, comparative, criticism, currency, community
- **Cross-referenced claims** — disagreements between sources are surfaced, not hidden
- **Current information prioritized** — recent dates appear in queries and citations
- **Every claim is sourced** — no orphan assertions, no fabricated facts
- **Trade-offs section is real** — limitations and criticisms appear, not just the rosy view
- **Source list is annotated** — each entry says what it contributed
- **Section names fit the topic** — technical topics get technical sections, product topics get comparison tables, etc.

---

## Troubleshooting

### Problem: Sources disagree and I'm not sure which is right

**Solution:** Surface the disagreement explicitly. Cite both, note the date and authority of each, and let the user judge. "Source A (official docs, 2026) says X. Source B (popular blog, 2024) says Y. The discrepancy may be due to a recent API change."

### Problem: Topic is too obscure — searches return little

**Solution:**
1. Try alternative phrasings and adjacent terms
2. Search for the broader category and narrow from there
3. If sources are genuinely thin, say so. Mark sections "Limited sources available." Do not pad with speculation.

### Problem: Output is becoming too long

**Solution:** Default to a single, well-structured summary. If the topic genuinely needs more depth, offer the user a choice: "I have material for a deeper section on X — want me to expand?" Don't dump everything by default.

### Problem: User asks to save the research to a file

**Solution:** That's a follow-up step, not part of this skill. Ask where to save it (e.g., `notes/research-topic.md`) and write a clean version with frontmatter. Don't auto-save without being asked.

### Problem: Research keeps drifting from the user's actual question

**Solution:** Re-anchor on the original ask. Restate the question at the top of the summary and check that every section serves it. Cut sections that don't.

---

## Integration

**This skill works with:**
- **track-session** — For long research projects, save the topic plan and source list to SESSION_PROGRESS.md so it's resumable
- **track-roadmap** — Use research to inform roadmap decisions; cite the research summary in the roadmap entry
- **reflect** — After research informs a decision, capture the decision and rationale via reflect

**Does not replace:**
- Reading the codebase (use Read/Grep first for project-internal questions)
- Asking the user (use AskUserQuestion when you need their preference, not facts)
- Architecture or design skills (research informs them; it doesn't make decisions)

**Pairs naturally with:**
- Pre-implementation planning — research first, then design
- Tool/framework selection — research the candidates before recommending
- Catching up on a fast-moving space before contributing to it
