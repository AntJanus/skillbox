# Deep Research — Playbook (advanced modes + troubleshooting)

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
**Solution:** Use the Save-as-Note Handoff template above. Ask for the target path. Don't auto-save without being asked.
