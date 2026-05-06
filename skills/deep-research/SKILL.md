---
name: deep-research
description: |
  Conduct multi-source web research on a topic and synthesize a comprehensive,
  well-sourced summary directly in the conversation. Use when asked to
  "research X", "do some research on Y", "I'd like you to do some research on Z",
  "deep dive on Q", "deep research on R", "look into S", "investigate this topic",
  "find out about T", "what's the current state of X", "what's new with Y",
  "is X still relevant", "give me a thorough overview of Z",
  "compare X and Y", "pros and cons of X", "should I use X or Y",
  "before I build X", or "survey the landscape of Y". Use when the user needs
  current, well-cited information before making a decision or starting a project.
  No files are created unless explicitly requested.
license: MIT
argument-hint: "<topic>"
metadata:
  author: Antonin Januska
  version: "2.0.0"
---

# Deep Research

> **Deep research activated** — running a local-first → web-multi-source pipeline. I'll plan, disambiguate, search across diverse angles, cross-reference, and deliver a structured summary with cited sources.

## Overview

Multi-source research that earns its name through **breadth of angle, depth of cross-reference, and discipline of citation**. Run 5-10+ web searches across diverse angles, prefer primary sources, surface disagreements, and synthesize a structured summary returned in the conversation.

**Core principle:** Research depth comes from query diversity, source cross-referencing, and an honest accounting of gaps. Always cite. Never fabricate. Surface disagreement; don't paper over it.

## The Five Search Angles

Every substantive research run covers these angles. State which you'll use in the plan; tag each search with one.

| Angle         | Looks for |
|---------------|-----------|
| Official      | Primary docs, specs, vendor sources, peer-reviewed papers |
| Comparative   | "X vs Y", alternatives, head-to-head analyses |
| Criticism     | Limitations, known issues, failure stories, public criticism |
| Currency      | Recent developments (current and previous year), changelogs, trend pieces |
| Community     | HN, Reddit, blog posts, Stack Overflow — signal not authority |

## Pipeline

```
┌─────────┐   ┌──────┐   ┌────────────┐   ┌────────┐   ┌─────────┐   ┌────────────┐   ┌──────────────┐
│ Phase 0 │ → │ P1   │ → │ P2         │ → │ P3     │ → │ P4      │ → │ P5         │ → │ P6           │
│ Local   │   │ Plan │   │ Disambig.  │   │ Search │   │ Reflect │   │ Synthesize │   │ Cite-verify  │
└─────────┘   └──────┘   └────────────┘   └────────┘   └─────────┘   └────────────┘   └──────────────┘
```

Every phase has a `MUST` gate before moving to the next.

## Modes

| Mode         | When                                       | Searches | Output                              |
|--------------|--------------------------------------------|----------|-------------------------------------|
| `quick`      | Fast lookup, low-stakes context            | 3-5      | One-paragraph answer + 3-5 sources  |
| default      | Standard topic, single-domain              | 5-10+    | Full synthesis template             |
| `comparison` | 3+ items being compared                    | 10-15    | Mandatory matrix at top of report   |
| `landscape`  | Broad survey of an unfamiliar/wide space   | 10+      | Parallel research subagents → consensus report |

## Usage

| Invocation | What happens |
|------------|--------------|
| `/deep-research <topic>` | Default mode — full synthesis with sources in chat |
| `research X for me` | Auto-activates default mode |
| `compare X and Y` | Auto-activates `comparison` mode |
| `survey the landscape of X` | Auto-activates `landscape` mode |

**Default behavior:** Output stays in the conversation. No files are created. If the user wants the report saved, that's a follow-up step (see Save-as-Note Handoff).

## When to Use

**Always use when:**
- User asks to "research", "investigate", "look into", "deep dive on", "find out about" a topic
- User needs current information before a decision (tool choice, framework selection, product comparison)
- User asks "what's the current state of X" or "is Y still relevant"
- User asks to compare 3+ things or survey an unfamiliar space

**Useful for:**
- Pre-implementation research (libraries, patterns, trade-offs)
- Comparative analysis (Tool A vs Tool B vs Tool C)
- Catching up on a fast-moving space
- Sanity-checking assumptions against authoritative sources

**Avoid when:**
- Question can be answered from the codebase (use Read/Grep first; that's Phase 0 anyway)
- User wants a quick fact, not a synthesis (single search is enough)
- Topic is internal to the user's project (no public sources will exist)
- User has already done the research and just wants implementation help

## Quick-Answer-Before-Research

For **opinion-shaped or judgment questions** ("should I use X?", "is Y any good?", "why is Z popular?") where the model already has a confident grounded answer:

1. Give a brief direct answer first (2-4 sentences)
2. Offer to escalate: "Want me to run full research on this?"
3. Only escalate to the full pipeline on user pushback ("you sure?") or explicit ask ("yes, research it")

This prevents launching a 10-search investigation when the user just wanted a confident take.

---

## Process

### Phase 0: Local-first Check

**Before any web search, you MUST:**
- [ ] Check the working directory for existing material on this topic — `rg "<topic>" .` (case-insensitive), and Read any obvious matches
- [ ] If existing local material covers the question, **default to UPDATE not CREATE** — surface what exists and ask whether to extend it
- [ ] State what you found (or "no local hits") in chat before moving to Phase 1

This step is mandatory even for purely web-shaped topics — it costs little and prevents duplicating existing knowledge.

### Phase 1: Plan

**Before searching, you MUST post:**
- [ ] The interpretation of the topic ("Interpreted as: …") — especially if ambiguous
- [ ] The 3-5 search angles you'll use, drawn from the Five Search Angles table
- [ ] The mode you're operating in (`quick` / default / `comparison` / `landscape`)

Wait one beat after posting. Don't start searching until the plan is in chat.

### Phase 2: Disambiguate (when needed)

**Before deep search, you MUST:**
- [ ] If the subject is a proper noun, acronym, product name, or otherwise ambiguous, run **one broad search** to fix the referent
- [ ] State the resolved subject explicitly ("Confirmed: X = the Y from Z")
- [ ] If still ambiguous, ask the user to disambiguate before continuing

Skip this phase when the subject is unambiguous (a well-known concept, a clear technical term).

### Phase 3: Execute Searches

**Hard floor: 5+ web searches minimum** for default and above. Less than that is not deep research.

**Query strategy:**
- Start broad ("what is X", "X overview")
- Narrow into specifics ("X best practices", "X performance characteristics")
- Look for tension ("X criticism", "problems with X", "X vs alternatives")
- Look for currency (include the year in queries when relevant)
- Use **WebFetch** to read full articles when search snippets are insufficient — every source you cite substantively should be fetched, not skimmed

**Source quality priorities (CRAAP-ish):**
1. Official docs, specifications, primary sources, peer-reviewed papers
2. Reputable industry publications and recent technical blogs
3. Comparative analyses from credible authors
4. Community discussion (treat as signal, not authority)

**Prefer primary > secondary > tertiary.** SEO-optimized content farms outrank authoritative PDFs in search results — actively look past them.

**Cross-reference rule:** If two sources disagree, note the disagreement explicitly in the output. Do not silently pick one.

### Phase 4: Sufficiency Check (Reflection Gate)

**Before synthesizing, you MUST post a one-line check to chat:**
- [ ] Searches run: N | angles covered: <list> | full reads (WebFetch): M
- [ ] Material for each planned section: yes/no
- [ ] Open questions / gaps identified: <list, or "none non-trivial">
- [ ] Reflection: "what would change my conclusion?" — answer in one sentence

If a planned section has no material, either run more searches or remove the section. Do not pad with speculation.

### Phase 5: Synthesize and Report

Use the synthesis template below. Adapt section names to fit the topic — technical, product, conceptual.

```markdown
# [Topic] — Research Summary

> Interpreted as: [if ambiguity was present]

## Tl;dr
[2-3 sentences directly answering the original question.]
*Confidence: high/medium/low — [why]*

## Overview
Definition, why this matters, key concepts.
*Confidence: ...*

## Core Information
How it works, main features, technical details.
*Confidence: ...*

## Comparison Matrix  [REQUIRED when comparing 3+ items]
| Item | Dimension 1 | Dimension 2 | Dimension 3 | Notes |
|------|-------------|-------------|-------------|-------|
| ...  | ...         | ...         | ...         | ...   |

## Practical Details
Tools, libraries, products in this space. Best practices. Common pitfalls.
*Confidence: ...*

## Trade-offs and Criticism
Limitations, valid criticisms, when not to use this.
*Confidence: ...*

## Current Landscape
Recent developments, adoption signal, where things are heading.
Note any source disagreements explicitly.
*Confidence: ...*

## What we still don't know  [include when gaps are non-trivial]
- Open question 1
- Open question 2

## Sources

### Official Documentation  [group when sources >5]
- [Title (YYYY-MM-DD)](url) — what this contributed

### Comparative Analyses
- [Title (YYYY-MM-DD)](url) — what this contributed

### Community Guides
- ...
```

**Source list rules:**
- Every claim in the summary should be traceable to a listed source
- Include 8-15+ sources for a substantive topic
- Annotate each source briefly (one phrase: what it contributed)
- Include the source's publication date in the link text when available — `(YYYY-MM-DD)` or `(Mar 2026)`
- When sources >5, group under sub-headers (Official Documentation / Comparative Analyses / Community Guides / etc.)
- Mix official, industry, and community sources

### Phase 6: Cite-Verify

**Before delivering, you MUST:**
- [ ] Walk every non-trivial claim and verify it traces to a fetched source
- [ ] Confirm every cited URL was actually opened in this run (no plausible-sounding fabrications)
- [ ] Restate the original question silently and check that every section serves it

---

## Modes — Detail

### `quick`
Triggered by: "quick research on X", "give me a fast read on Y", small/low-stakes asks.
- 3-5 searches, 1-2 angles
- Output: one paragraph + 3-5 annotated sources
- Skip the full template; keep Phase 0, 1, 4, 6 gates lighter

### `comparison`
Triggered by: "compare X and Y", "X vs Y vs Z", "pros and cons of X".
- 10-15 searches, 5+ angles
- **Comparison Matrix is required at top of report** (right after Tl;dr)
- Cover each item across the same dimensions; do not give one item more dimensions than another

### `landscape`
Triggered by: "survey the landscape of X", "what's the current state of the Y space", broad/unfamiliar domains.
- Use parallel research subagents (see Multi-Agent Sub-Mode below)
- Synthesize their findings into a single consensus report
- Surface disagreements between subagent findings as first-class output

---

## Multi-Agent Sub-Mode

For `landscape` mode, or when a topic genuinely spans multiple distinct sub-domains:

1. Decompose the topic into 3-5 angles or sub-topics
2. Dispatch one research subagent per angle, in parallel — each gets its own brief, search budget, and angle assignment
3. Each subagent returns structured findings + sources
4. The orchestrator synthesizes a consensus report:
   - What all subagents agreed on (high confidence)
   - Where they diverged (call out explicitly)
   - What no subagent found (gaps)

This pattern outperforms a single-agent run for breadth-heavy topics but uses substantially more tokens — reserve for landscape-scope work.

---

## Save-as-Note Handoff

When the user explicitly asks to save the research as a note (after the in-chat report), use this generic template. Ask for the path before writing.

```markdown
---
title: <Topic>
created_at: YYYY-MM-DD
source: web-research
tags: [topic-tag, area-tag]
---

# <Topic>

[Same body as the in-chat report — Tl;dr, Overview, Core Information, etc.]

## Sources
[Grouped + annotated source list, with publication dates]
```

Adapt the frontmatter to the user's project conventions if they have an established schema — read one or two existing notes in the target directory first to match the style.

---

## Quality Signals

A good deep-research output has:

- **Plan posted before searching** — interpretation, angles, mode all stated upfront
- **Local-first check completed** — even when the answer was unambiguously a web question
- **5-10+ searches with diverse angles** — covering at least 3 of the Five Search Angles
- **Cross-referenced claims** — disagreements between sources surfaced, not hidden
- **Current information prioritized** — recent dates appear in queries and citations
- **Every claim is sourced** — no orphan assertions, no fabricated URLs
- **Trade-offs section is real** — limitations and criticisms appear, not just the rosy view
- **Confidence labels per section** — reader knows what's solid vs thin
- **Source list is grouped + annotated** — each entry says what it contributed, with publication date when available
- **Section names fit the topic** — technical topics get technical sections, product topics get matrices

---

## Failure Modes

Defenses for the well-documented failure modes of LLM web research:

### Sycophancy
**Don't change a sourced claim under user pushback without new evidence.** "I might be wrong" is fine; flipping the answer because the user disagreed is not. If the user pushes back, the next move is *another search*, not capitulation.

### Anchoring
**Before synthesizing, ask: "what would change my conclusion?"** If recent searches gave evidence that contradicts the early framing, update — don't paper over it. The reflection step in Phase 4 is the place to catch this.

### Source laundering / SEO bias
**Prefer primary > secondary > tertiary.** For technical claims prefer official docs, .gov, .edu, peer-reviewed papers. Top search hits are not the same as authoritative sources — actively look past content farms to find the primary source.

### Fabricated citations
**Every cited URL must have been actually fetched in this run.** If you didn't open it, don't cite it. Plausible-sounding URLs that don't exist are the dominant hallucination class in long-form research.

### Drift
**Restate the original question at synthesis time and check every section serves it.** Multi-agent runs are especially prone to drifting toward the majority subagent view and away from the user's actual ask.

---

## Troubleshooting

### Problem: Sources disagree and I'm not sure which is right
**Solution:** Surface the disagreement explicitly. Cite both, note the date and authority of each, and let the user judge. "Source A (official docs, 2026) says X. Source B (popular blog, 2024) says Y. The discrepancy may be due to a recent API change."

### Problem: Topic is too obscure — searches return little
**Solution:** Try alternative phrasings and adjacent terms. Search for the broader category and narrow from there. If sources are genuinely thin, say so. Mark sections "Limited sources available." Do not pad with speculation.

### Problem: Output is becoming too long
**Solution:** Default to a single, well-structured summary. If the topic genuinely needs more depth, offer the user a choice: "I have material for a deeper section on X — want me to expand?" Don't dump everything by default.

### Problem: Research keeps drifting from the user's actual question
**Solution:** Re-anchor. Restate the original ask at the top of the summary and check every section serves it. Cut sections that don't. The Cite-Verify gate (Phase 6) is the last chance to catch this.

### Problem: Tempted to call it done after 1-2 searches
**Solution:** That's not deep research — that's a search snippet. The 5+ floor exists because single-search answers consistently miss criticism, currency, and counter-examples. If the user genuinely wants a one-shot answer, they should ask for a quick fact, not invoke this skill.

### Problem: A cited URL doesn't actually exist or returns 404
**Solution:** Stop. Walk every cited URL against your tool history — every citation must trace to an actual WebSearch hit or WebFetch read. Drop fabricated URLs entirely; do not "fix" them by guessing a working URL.

### Problem: User asks to save the research to a file
**Solution:** Use the Save-as-Note Handoff template. Ask for the target path. Don't auto-save without being asked.

---

## Examples

### Example 1: Technical Topic (default mode)

<Good>
```
user: research htmx for me — thinking about using it for a side project

assistant: [P0] No local material found.
[P1] Interpreted as: htmx for a side project. Mode: default.
Angles: Official, Comparative, Criticism, Currency, Community.
[P3: 8 searches; WebFetch on htmx.org, two recent comparison posts, HN thread.]
[P4: 8 searches, 5 angles, 4 full reads. Gap: htmx + auth flows thin.]

# htmx — Research Summary

## Tl;dr
htmx fits server-rendered side projects with light-to-moderate
interactivity. Poor fit for stateful client-rich UX.
*Confidence: high — official docs + three recent analyses converge.*

## Overview
Hypermedia-driven library extending HTML with AJAX/SSE/WS attributes...

## Trade-offs
- [Real limitations from sources]
- Sentiment splits "elegant return to basics" vs "not a SPA replacement" — note the disagreement

## What we still don't know
- Production-scale auth-flow patterns are under-documented
- Long-term maintenance signal post-1.x is thin

## Sources

### Official Documentation
- [htmx.org Documentation (2026)](url) — official reference
- [htmx essays (2025)](url) — author's design rationale

### Comparative Analyses
- [htmx vs React (Mar 2026)](url) — recent benchmarks

### Community Guides
- [HN discussion thread (Jan 2026)](url) — sentiment + counter-examples
```

**Why this is good:** Local-first checked, plan posted, 5+ angles, sufficiency check posted, Tl;dr leads, confidence labels per section, gaps section honest, sources grouped + annotated + dated, every claim traces to a cited source.
</Good>

<Bad>
```
user: research htmx for me

assistant: [Runs one search "htmx"]

htmx is a JavaScript library that lets you do AJAX with HTML attributes.
It's lightweight and an alternative to React. Some people like it.

Sources: htmx.org
```

**Why this is bad:** No Phase 0, no plan, single search, no cross-referencing, no Tl;dr, no confidence, vague unsourced claims, one source.
</Bad>

### Example 2: Comparison Mode

<Good>
```
user: should I use Postgres or SQLite for a small SaaS?

assistant: [P0] No local notes.
[P1] Interpreted as: small SaaS = single-region, modest scale.
Mode: comparison. All five angles. Matrix required.
[P3: 12 searches; WebFetch on official docs, Litestream/LiteFS, migration writeups.]

# Postgres vs SQLite for Small SaaS — Research Summary

## Tl;dr
SQLite + Litestream is a viable default for single-region small SaaS
unless concurrent writers exceed ~1k/sec. Postgres remains the safe
choice once you anticipate horizontal scaling or multi-region. *Confidence: high.*

## Comparison Matrix
| Dimension          | SQLite (+ Litestream)        | Postgres                   |
|--------------------|------------------------------|----------------------------|
| Operational cost   | Near-zero                    | Managed service or ops     |
| Write concurrency  | Limited (WAL helps)          | High                       |
| Replication        | Litestream / LiteFS          | Native streaming           |
| Migration cost     | Schema-flexible              | Strict, mature tooling     |
| Backup story       | File-level                   | pg_dump + WAL              |

## When Each Fits
[Concrete criteria with sources, per side]

## Current Landscape
Litestream and LiteFS reset the conversation in 2024-2026...

## Sources
[8+ grouped, dated, annotated]
```

**Why this is good:** Frames around the user's actual context, mandatory matrix at the top, covers recent developments that change the answer, confidence labels, addresses migration cost (the real decision risk).
</Good>

<Bad>
```
user: should I use Postgres or SQLite

assistant: Postgres is more powerful, SQLite is simpler. Use Postgres for
production, SQLite for prototypes.

Sources: Wikipedia
```

**Why this is bad:** No matrix in comparison mode, ignores user's context, oversimplified, one weak source.
</Bad>

---

## Integration

**This skill works with:**
- **track-session** — For long research projects, save the topic plan and source list to SESSION_PROGRESS.md so it's resumable
- **track-roadmap** — Use research to inform roadmap decisions; cite the research summary in the roadmap entry

**Pairs naturally with:**
- Pre-implementation planning — research first, then design
- Tool/framework selection — research the candidates before recommending
- Catching up on a fast-moving space before contributing to it
- Parallel-agent dispatch (`landscape` mode) when a topic genuinely spans multiple domains

**Does not replace:**
- Reading the codebase (Phase 0 is the codebase pass)
- Asking the user (use AskUserQuestion when you need their preference, not facts)
- Architecture or design skills (research informs them; it doesn't make decisions)
