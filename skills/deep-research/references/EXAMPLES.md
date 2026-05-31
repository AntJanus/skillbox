# Deep Research — Worked Examples

## Example 1: Technical Topic (default mode)

✅ **Good:**

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

❌ **Bad:**

```
user: research htmx for me

assistant: [Runs one search "htmx"]

htmx is a JavaScript library that lets you do AJAX with HTML attributes.
It's lightweight and an alternative to React. Some people like it.

Sources: htmx.org
```

**Why this is bad:** No Phase 0, no plan, single search, no cross-referencing, no Tl;dr, no confidence, vague unsourced claims, one source.

## Example 2: Comparison Mode

✅ **Good:**

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

❌ **Bad:**

```
user: should I use Postgres or SQLite

assistant: Postgres is more powerful, SQLite is simpler. Use Postgres for
production, SQLite for prototypes.

Sources: Wikipedia
```

**Why this is bad:** No matrix in comparison mode, ignores user's context, oversimplified, one weak source.
