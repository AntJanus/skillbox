---
name: color-system
description: Use this skill for any color decision — picking or building a palette, dark mode, contrast, chart and terminal colors. Triggers include "what colors should I use", "pick a palette for my dashboard", "set up dark mode", "does this pass WCAG contrast", "colorblind-safe chart colors", or "give me a terminal theme" — and it applies even when the user never says "color", as in "theme this app", "these status badges look wrong", or "this text is hard to read on the background". Ships curated light+dark palettes for web UI, marketing, data viz, and TUI, plus an OKLCH build-your-own recipe and WCAG/APCA thresholds. Do NOT use this skill for font size, weight, or pairing (see typography), for layout and component structure (see frontend-design), or for chart type, axis, and encoding choices that are not about color (see dataviz).
license: MIT
argument-hint: "[ui | marketing | dataviz | tui | contrast | palette-name]"
metadata:
  author: Antonin Januska
  version: "1.4.0"
  tags: [color, palette, design, accessibility, dark-mode, data-viz, theme]
---

# Color System

## Overview

A curated library of ready-to-use color palettes (light + dark) across four domains — **web-app UI**, **marketing/landing**, **data visualization**, and **terminal/TUI** — plus the methodology to build new palettes and verify their accessibility.

**Core principle:** choose colors by **semantic role** (background, text, primary, error…), not by raw hue. Every palette here maps hexes to roles, so a theme stays swappable, consistent, and accessible. Pick a role first, then read its hex — hardcoding a hex where a role belongs is what breaks theming later.

## Navigation

The index and role contract below answer "which palette" on their own. Load one reference file when the task needs its payload — not all four.

| Load | When |
|---|---|
| [references/palettes.md](references/palettes.md) | You need actual hex values — any of the four domains, light + dark |
| [references/contrast.md](references/contrast.md) | Verifying WCAG/APCA thresholds, colorblind safety, or debugging a pair that fails |
| [references/build-your-own.md](references/build-your-own.md) | No library palette fits and you're generating a new scale (the OKLCH recipe) |
| [references/theory.md](references/theory.md) | Choosing a harmony scheme, or justifying a color-space / scale decision |

## Palette Library (quick index)

Where one palette is the right first reach it is marked ⭐; marketing and TUI have no default because the choice follows the brand or the user's own terminal theme.

### Web App UI — light + dark, 13 semantic roles each
- **Carbon** ⭐ *(default)* — deep slate-blue, dark-first. Analytics dashboards, perf reports & dev tooling. Ships a full dashboard kit (A–F grade pills, ordered stage sequence, inline-code tone, success highlight). Reach for **Graphite** instead when light mode must be hand-tuned-equal.
- **Graphite** — cool slate + blue. Dense B2B dashboards, dev tools; the light+dark parity default.
- **Evergreen** — emerald brand on true-neutral zinc. Fresh, confident, non-blue identity.
- **Terracotta** — warm clay/espresso neutrals + rust. Editorial, content platforms, writing tools.
- **Bloom** — pastel periwinkle/violet, deep dark mode. Friendly dev tools, playful-but-clean apps.
- **Teal Slate** — deep teal on cool slate, single warm accent. Technical reports, SRE / rate-limit dashboards; pairs with a mono face for figures.

### Marketing / Landing — light + dark, hero gradients
- **Sunbloom** — refined coral/amber warmth. Approachable consumer/creator brands.
- **Tidewater** — teal/sage. Fintech, wellness, B2B trust.
- **Obsidian & Gold** — near-black + metallic gold. Premium, luxury, agency.
- **Paper & Ink** — warm paper + ink black + one terracotta accent. Blogs, long-form, portfolios.

### Data Viz — colorblind-aware, warm/cool earthy
- **Categorical:** Lunar Valley ⭐ *(default)* · Hearthstead · Vintage Warm · Glass Wall · Okabe-Ito *(use when CVD-safety is a hard requirement)*
- **Sequential:** Viridis ⭐ *(default)* · Magma · Inferno · Plasma · ColorBrewer Blues · YlOrRd *(all perceptually uniform)*
- **Diverging:** Console & Window ⭐ *(default)* · Alien Sun · Orchard Dusk · Coffee & Coolant — all warm↔cool, no red↔green

### Terminal / TUI — 16-ANSI + bg/fg/cursor/selection
- Solarized Dark · Nord · Catppuccin Mocha · Catppuccin Latte *(the one light scheme)* · Dracula · Tokyo Night

→ **Full hex tables for every palette:** [references/palettes.md](references/palettes.md)

## Semantic roles (the contract)

UI palettes fill these roles. Map intent to a role, then the role to a hex.

| Role | What it is |
|---|---|
| `background` | App/page base canvas |
| `surface` | Cards, panels, sheets |
| `surface-elevated` | Raised surfaces (popovers, modals); in dark mode **lighter = more elevated** |
| `border` | Dividers, input borders, focus rings |
| `text-primary` | High-emphasis foreground |
| `text-secondary` | Muted labels, hints, captions |
| `primary` / `primary-hover` | Brand action color + its hover state |
| `accent` | Secondary emphasis, distinct from primary |
| `success` / `warning` / `error` / `info` | Semantic states (green / amber / red / blue by Western convention) |

Data-viz palettes instead provide ordered color **lists** (categorical = distinct series; sequential = low→high ramp; diverging = warm↔cool with a neutral midpoint). TUI schemes provide the 16 ANSI slots plus 4 special roles.

## Core Concepts

- **Design in OKLCH, not HSL.** OKLCH is perceptually uniform; HSL "lightness" lies (equal-L blue looks far darker than equal-L yellow), so even HSL steps produce lumpy scales.
- **Harmony:** pick a scheme (monochromatic / analogous / complementary / triadic…) and let **one** color dominate in saturation and area; desaturate the rest.
- **Scales:** 10–12 steps, step lightness evenly, peak chroma in the mid-range and taper it at the extremes so tints aren't washed out and shades aren't muddy.
- **Light vs dark is not an inversion.** In dark mode, raise the base off pure `#000` (use ~`#0d1117`–`#1e1e2e`) because pure black causes halation and defeats elevation; lift saturated brand/status hues one or two steps, and signal elevation by getting *lighter*.
- **Contrast:** WCAG AA — body text ≥ 4.5:1, large text & UI/borders ≥ 3:1. Validate **dark mode with APCA**, since WCAG 2 ratios overstate contrast near black.
- **Colorblind-safety:** encode meaning with text, icon, or position *in addition to* hue, since ~8% of men can't separate the hues alone. For diverging data use warm↔cool (blue/orange, teal/rose) rather than red↔green.

## Examples

### Example: choosing colors for a SaaS dashboard

✅ Desired

```
User: "I need colors for an admin dashboard, light and dark."
→ Recommend Carbon (deep slate-blue, dark-first, made for dense data UI) — the default;
  offer Graphite if hand-tuned light-mode parity matters more than the dashboard kit.
→ Copy its role→hex table from palettes.md (both modes).
→ Apply by role: background→surface→border→text, primary for the main CTA,
  success/warning/error for status badges. Confirm text-primary on background ≥ 4.5:1.
```

Why it works: a role-mapped palette drops straight into CSS variables and is accessible by construction.

### Example: status badge color

✅ Desired

```css
.badge-error { background: var(--error); color: #fff; }   /* role, not a hardcoded red */
```

❌ Anti-pattern

```css
.badge-error { background: #ff0000; color: #000; }   /* raw hue; #f00 on #000 ≈ 5.2:1 but glares,
                                                         and won't theme or switch to dark mode */
```

Why it fails: hardcoding a hue breaks theming and dark mode, and pure-red/pure-black causes halation.

### Example: picking a chart palette

✅ Desired

```
Categorical series (≤8) → Lunar Valley (default), or Okabe-Ito when CVD-safety is required.
Continuous low→high → Viridis (perceptually uniform, colorblind-safe).
Signed data with a midpoint → Console & Window (warm↔cool, neutral center).
Past ~8 categorical colors, series stop being distinguishable — aggregate into "Other" instead.
```

Why it works: matches the data's structure to the right palette family and respects the distinguishability limit.

## Gotchas

- **Symptom:** Brand color is unreadable as body text. **Cause:** Saturated mid-tones (amber, coral, teal) often fail 4.5:1 on their own background. **Fix:** use the brand color as a *fill* (white/dark text on top) or step to a darker shade for text; verify in contrast.md.
- **Symptom:** Secondary/muted text ("dimmed", `text-secondary`) looks fine in the design tool but fails contrast in the app. **Cause:** component libraries ship a default muted-text color (e.g. Mantine's `dimmed`) tuned for visual hierarchy, not contrast — commonly landing around ~3.4:1, well under the 4.5:1 AA floor. **Fix:** pick and verify your own `text-secondary` hex against contrast.md instead of inheriting the library default, and re-check per theme — the same override can pass in one theme and fail in another. Re-verify on **tinted/elevated surfaces** (cards, striped rows) too, not just the flat canvas.
- **Symptom:** Dark mode "passes WCAG" but is hard to read. **Cause:** WCAG 2 math overstates contrast near black. **Fix:** re-check dark pairs with APCA (Lc), not the 4.5:1 ratio alone.
- **Symptom:** Dark theme looks flat, elevation unreadable. **Cause:** pure `#000` background + same-lightness surfaces. **Fix:** raise the base to ~`#0d1117`–`#1e1e2e` and make each elevation tier *lighter*.
- **Symptom:** A chart is unreadable for colorblind viewers. **Cause:** red↔green encoding or hue-only meaning. **Fix:** switch to a warm↔cool diverging palette and add labels/icons; for categorical use the Okabe-Ito safe set (in palettes.md).
- **Symptom:** Chart text stays low-contrast even though your palette defines the right text color. **Cause:** charting libraries (Recharts, Mantine charts) render axis/legend/value text as SVG with their own inline `fill`, bypassing your color tokens entirely. **Fix:** target the library's text elements directly (e.g. `.recharts-wrapper text { fill: var(--text) }`) — the CSS cascade never reaches it.
- **Symptom:** TUI colors vanish on some terminals. **Cause:** hardcoded hex, or load-bearing text placed in bright-black (slot 8). **Fix:** bind meaning to ANSI slots 1–6 so the user's own theme renders it, and keep slot 8 for de-emphasis only.
- **Symptom:** Palette steps look lumpy/uneven. **Cause:** stepping lightness in HSL/RGB. **Fix:** rebuild the scale in OKLCH; see build-your-own.md.

## Integration

- **frontend-design** — builds the components and layout; this skill supplies the color decisions. Pick a palette here, implement the UI there.
- **typography** — owns size, weight, and line-height; the two share only the contrast floor. When text is unreadable, decide first whether the defect is the color pair (here) or the size/weight (typography).
- **dataviz** — owns chart form, axes, and encoding. Take the categorical/sequential/diverging *palette* from here and hand it to that skill as the series colors.
