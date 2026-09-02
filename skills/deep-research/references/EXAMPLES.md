# Deep Research — Worked Examples

## Example 1: Technical Topic (default mode)

✅ **Good:**

```
user: research htmx for me — thinking about using it for a side project

assistant: [1] No local material found.
[2] Interpreted as: htmx for a side project. Mode: default.
Angles: Official, Comparative, Criticism, Currency, Community.
[4] 8 searches; WebFetch on htmx.org, two recent comparison posts, HN thread.
[5] searches: 8 | angles: 5 | full reads: 4 | gaps: htmx + auth flows thin

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

❌ **Bad:**

```
user: research htmx for me

assistant: [Runs one search "htmx"]

htmx is a JavaScript library that lets you do AJAX with HTML attributes.
It's lightweight and an alternative to React. Some people like it.

Sources: htmx.org
```

**Why this is bad:** No local-first check, no plan, single search, no cross-referencing, no Tl;dr, no confidence, vague unsourced claims, one source.

## Example 2: Comparison Mode

✅ **Good:**

```
user: should I use Postgres or SQLite for a small SaaS?

assistant: [1] No local notes.
[2] Interpreted as: small SaaS = single-region, modest scale.
Mode: comparison. All five angles. Matrix required.
[4] 12 searches; WebFetch on official docs, Litestream/LiteFS, migration writeups.

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

❌ **Bad:**

```
user: should I use Postgres or SQLite

assistant: Postgres is more powerful, SQLite is simpler. Use Postgres for
production, SQLite for prototypes.

Sources: Wikipedia
```

**Why this is bad:** No matrix in comparison mode, ignores user's context, oversimplified, one weak source.

## Quoting retrieved sources

One complete example, kept here because the pattern is easier to match than to describe. The tool lines are templated tool output, not text to emit.

✅ **Good:**

```
user: look up how the Riverton Ledger and the Coast Dispatch each covered the Harbor Bridge closure and compare their reporting

assistant:
[WebSearch: Harbor Bridge closure Riverton Ledger]
[WebSearch: Harbor Bridge closure Coast Dispatch]
Both outlets agree on the basics: the bridge closed on March 3 after inspectors found cracked welds, and the state expects repairs to take about eight months. Where they differ is emphasis. The Ledger treats it as a local-economy story. The Dispatch frames it as a funding failure; its editorial calls the closure "entirely foreseeable." Read together, the Ledger explains who is affected now and the Dispatch explains how it came to this — neither account alone gives the whole picture.
```

**Why this is good:** Organized around where the two outlets agree and differ, not as a walk through either article. Each outlet's reporting is conveyed in one or two sentences of the assistant's own indirect speech. One short marked phrase from one source; every other claim is reworded. Still specific and complete.

❌ **Bad:** the same answer with two sentences lifted verbatim from the Dispatch editorial and no quotation marks — the reader can't tell the source's claim from the assistant's, and the passage reads as the assistant's own finding.
