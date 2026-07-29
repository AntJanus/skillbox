---
name: typography
description: Use this skill whenever the user wants typography work — sizing text, building a type scale, setting line-height or vertical rhythm, fixing unreadable type, or picking and pairing fonts. Triggers include "what font size should I use", "set up a type scale", "this text is too small to read", "what line-height for paragraphs", or "pair a heading font with a body font" — even if the user never says "typography" and only describes text that looks cramped, thin, or washed out. Do NOT use this skill for choosing a color palette or checking a color's contrast ratio — see color-system; or for page layout and component structure — see frontend-design.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.5.0"
  tags: [typography, type-scale, font-size, line-height, vertical-rhythm, readability, accessibility, fonts]
---

# Typography

## Overview

Ready-to-use **type systems** (Product UI, Editorial, Marketing, Docs/Technical) plus the methodology to size text, build scales, set vertical rhythm, and pick fonts — so generated UI is readable instead of tiny, thin, and low-contrast.

**Core principle:** size text by **role on a scale**, never by eyeballed pixels. Pick a base (16px), a ratio (~1.2), and derive every size from it — then keep every role above the readability floor, because most "impossible to read" output violates at least one of its four numbers.

## The readability floor (the contract)

These are the recede-defaults. Meet all four and text is legible by construction; deviate only deliberately and name the reason (a 14px compact scale for genuine enterprise density is a legitimate reason — "it looked better" is not).

| Floor | Default | Why |
|---|---|---|
| **Size** | body **≥ 16px / 1rem** | Browser default; iOS zooms `<input>` under 16px. Captions never < 12px. |
| **Weight** | body **≥ 400** | Weights 100–300 thin the stroke and drop perceived contrast on small text. |
| **Contrast** | text **≥ 4.5:1** (large ≥ 3:1) | WCAG 2 AA. Re-check dark mode / thin fonts with APCA — WCAG2 overstates contrast near black. |
| **Line-height** | body **≥ 1.5** | Cramped leading hurts reading and fails the WCAG 1.4.12 spacing override. |

The single worst combination is **small + thin + low-contrast** — any two is risky, all three is the canonical unreadable panel.

**Verify computed, not authored.** Reading the class, prop, or token in source only tells you intent — check the rendered value (devtools Computed panel, or `getComputedStyle(el).fontSize`) before calling a size fixed. A "should be 16px" edit that still renders 13px is a common failure mode, not a rare one.

## Navigation

| Load this | When |
|---|---|
| [references/systems.md](references/systems.md) | Copying a ready-made system — full token tables (size · line-height · weight · tracking) for all four |
| [references/scale.md](references/scale.md) | Building a custom scale, vertical rhythm, or measure from scratch |
| [references/readability.md](references/readability.md) | Verifying readability — minimum sizes, WCAG/APCA, fluid `clamp()`, known failure modes |
| [references/fonts.md](references/fonts.md) | Choosing, pairing, styling, or loading typefaces |
| [references/EVAL.md](references/EVAL.md) | Re-tuning this skill's own description |

Load one reference only when the task needs it — keep context lean.

## Type System Library

Pick one, then copy its token table from [references/systems.md](references/systems.md). When the product type is ambiguous, default to **Product UI**.

- **Product UI** — system sans, 16px base, ratio **1.2**. Dense dashboards, apps, dev tools. Tabular numerals for data. A 14px "compact" variant for enterprise density.
- **Editorial / Long-form** — serif body at **18px / LH 1.6**, ratio **1.25**, measure **66ch**. Articles, blogs, docs prose. Space-before > space-after on headings.
- **Marketing / Landing** — fluid `clamp()` display, ratio **1.333**, tight tracking at scale. Heroes, landing pages. Bigger body (18px), scrim on text-over-image.
- **Docs / Technical** — Product UI scale + first-class **mono** (code blocks, inline code, API tables). Ligatures off in code, slashed-zero, tabular numerals.

## Methodology (essentials)

- **Build the scale from a base × ratio.** `size(n) = base × ratio^n`. Dense UI → 1.125–1.2; product/general → 1.2–1.25; editorial → 1.333–1.414; hero/display → 1.5–1.618. Round to whole/half px, expose as `rem`.
- **Line-height scales inversely with size.** Body 1.5; headings 1.2; display 1.0–1.1. The bigger the text, the tighter the leading. Keep `line-height` **unitless** so it recomputes per element instead of inheriting a fixed length.
- **Vertical rhythm on an 8px grid.** Rhythm unit = body size × body LH = 24px. Make every margin/padding a multiple of 4/8px. Enforce a consistent spacing scale rather than pixel-chasing a literal baseline grid — sub-pixel rounding and nested padding break literal grids anyway.
- **Cap the measure.** Body `max-width: ~66ch` (≈ 45–75 characters/line). Too-long lines cause return-sweep errors; too-short break rhythm.
- **Tracking is optical.** 0 on body; **−0.01 to −0.025em** on large headings (tighten as size grows); **+0.05 to +0.12em** on ALL-CAPS / small labels. Set in `em` so it scales with size.
- **Weight carries hierarchy.** Body 400, headings 600 (700 for stronger). Large display can go lighter (400) because mass substitutes for weight. Reach for one good family with multiple weights before adding a second.
- **Size in `rem`, fluid via `clamp()`.** `clamp(min_rem, calc(rem + vw), max_rem)` — keep both bounds in `rem` and mix a `rem` term into the preferred value, because browsers don't scale `vw` on zoom and a `vw`-only size fails WCAG 1.4.4.

## Examples

### Body text sizing

✅ Desired

```css
body { font-size: 1rem; line-height: 1.5; font-weight: 400; color: #1e293b; } /* 16px, ~14:1 on white */
```

❌ Anti-pattern

```css
body { font-size: 13px; line-height: 1.25; font-weight: 300; color: #9ca3af; } /* small + thin + low-contrast: ≈2.5:1 */
```

Why it fails: 13px is below the floor, 300 thins the stroke, `#9ca3af` on white is ≈2.5:1 — all three readability failures at once, and px ignores the user's font-size setting.

### Fluid heading

✅ Desired

```css
h1 { font-size: clamp(1.75rem, 1.1rem + 3.2vw, 3rem); line-height: 1.1; letter-spacing: -0.02em; } /* scales, caps, still zooms */
```

Why it works: `rem` bounds plus a `rem`-anchored preferred value keep it readable at 200% zoom, and the cap stops a runaway hero size.

### Table header and caption

✅ Desired

```css
th         { font-size: 1rem; line-height: 1.5; font-weight: 600; }
figcaption { font-size: 0.875rem; line-height: 1.45; color: #5b6b7d; } /* 14px floor, 4.9:1 */
```

❌ Anti-pattern

```css
th { font-size: 0.75rem; font-weight: 500; color: #9ca3af; } /* 12px, ≈2.5:1 */
```

Why it fails: chrome is where the floor breaks first — 12px is under the 14px hard minimum, and `#9ca3af` on white misses 4.5:1 by half.

## Gotchas

- **Symptom:** Headings size right but feel cramped or loose. **Cause:** one fixed line-height everywhere. **Fix:** line-height *inverse* to size — body 1.5, headings 1.2, display ~1.05.
- **Symptom:** Inputs zoom/jump on iPhone. **Cause:** form-control text < 16px. **Fix:** inputs ≥16px; never `user-scalable=no` (it disables pinch-zoom and fails WCAG).
- **Symptom:** Long paragraphs are tiring to read. **Cause:** lines run 100+ characters. **Fix:** `max-width: 66ch` on body/prose containers.
- **Symptom:** Heading floats between two sections. **Cause:** equal margin above and below. **Fix:** space-before > space-after, binding the heading to the text under it.
- **Symptom:** Numbers in a table shift width as they change. **Cause:** proportional figures. **Fix:** `font-variant-numeric: tabular-nums`.
- **Symptom:** Fluid type stops scaling at 200% zoom. **Cause:** `vw`-only `font-size`. **Fix:** `clamp(rem, calc(rem + vw), rem)`; browsers don't zoom `vw`.
- **Symptom:** `line-height: clamp(1.3, 0.9rem + 0.4vw, 1.6)` silently does nothing. **Cause:** `clamp()` can't mix `<number>` bounds with a `<length>` preferred value, so the declaration is dropped. **Fix:** keep the unitless ratio and step it at a breakpoint instead of making leading fluid.
- **Symptom:** Text over a hero image is unreadable in spots. **Cause:** no scrim; contrast varies per pixel. **Fix:** add a semi-opaque overlay or `text-shadow`, and verify the worst-case region.
- **Symptom:** Bold looks smeared, italics weak. **Cause:** faux-synthesized weight/style the font file lacks. **Fix:** load real weights or a variable font; `font-synthesis: none` exposes the gaps.
- **Symptom:** The theme says text should be ≥16px, but it renders small anyway. **Cause:** size-token names lie — Mantine `size="sm"`/`"xs"` and Tailwind `text-sm`/`text-xs` all compute to 14px/12px, under the floor; nested `em` units also compound multiplicatively as components nest. **Fix:** read the *computed* font-size in devtools, not the source token, and prefer `rem` for font-size so it can't compound.
- **Symptom:** Body text passes the floor but chart text is still tiny and washed out. **Cause:** charting libraries (Recharts, Mantine charts) render SVG text with their own inline `font-size`/`fill`, which never inherits your type scale or color tokens. **Fix:** target the library's text elements directly (e.g. `.recharts-wrapper text { font-size: …; fill: var(--text) }`) and re-verify computed size and color.
- **Symptom:** Every heading — often all body text too — renders in the browser's fallback serif, even though the fonts are imported and the theme references them correctly; source review finds nothing wrong. **Cause:** `next/font` in `variable` mode combined with a UI library that injects its font-family at `:root` (Mantine does: `:root, :host { --mantine-font-family: var(--font-body) }`). If the font's `.variable` class is applied only to `<body>`, `--font-body` doesn't exist at `:root` — custom properties never inherit upward — so every `var()` reference is invalid and falls back. It only shows up in `getComputedStyle(document.body).fontFamily`. **Fix:** apply the `.variable` class to `<html>`, or follow the library's own documented pattern where one exists ([Mantine injects the resolved `font.style.fontFamily` string](https://help.mantine.dev/q/next-load-fonts)).
- **Symptom:** Body text passes the floor everywhere you checked, but tables, nav labels, tooltips, menus, and form-field labels are still ~14px — with no `size` prop anywhere to explain it. **Cause:** component libraries ship individual components below their own base — Mantine's `Table` cell, `NavLink` label, `Tooltip`, `Menu` item, `Alert`, `Notification`, `Tabs` tab, and `Input` label/description all default to `sm` (14px) or `xs` (12px) while `Text` defaults to `md` (16px). There's no authored prop to grep for. **Fix:** override the whole size scale explicitly in the shared theme, and spot-check components you never sized rather than only the ones you did.

## Integration

- **color-system** — supplies the text/background hexes and verifies contrast; this skill sets size, weight, and rhythm. Pick colors there, size type here.
- **frontend-design** — builds the components and layout; this skill decides the type. Pick a system here, implement the UI there.
