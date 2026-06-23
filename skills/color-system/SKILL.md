---
name: color-system
description: Curated color palettes (light + dark) plus build-your-own and contrast guidance. Use whenever the user wants to pick or build a palette, choose app/brand/chart/terminal colors, set up dark mode, or check contrast. Do NOT use for UI layout — see frontend-design.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.0.0"
  tags: [color, palette, design, accessibility, dark-mode, data-viz, theme]
---

# Color System

## Overview

A curated library of ready-to-use color palettes (light + dark) across four domains — **web-app UI**, **marketing/landing**, **data visualization**, and **terminal/TUI** — plus the methodology to build new palettes and verify their accessibility.

**Core principle:** choose colors by **semantic role** (background, text, primary, error…), not by raw hue. Every palette here maps hexes to roles, so a theme stays swappable, consistent, and accessible. Pick a role first, then read its hex — never hardcode a hex where a role belongs.

## How to use this skill

1. **Need a ready palette?** → scan the Palette Library index below, pick one, copy its role→hex table from [references/palettes.md](references/palettes.md).
2. **Building a new palette?** → [references/build-your-own.md](references/build-your-own.md) (the OKLCH scale recipe) with [references/theory.md](references/theory.md) (harmony schemes).
3. **Checking accessibility?** → [references/contrast.md](references/contrast.md) (WCAG/APCA thresholds, colorblind rules, the Okabe-Ito safe set).

Load a reference file only when the task needs it — keep context lean.

## Palette Library (quick index)

### Web App UI — light + dark, 13 semantic roles each
- **Graphite** — cool slate + blue. Dense B2B dashboards, dev tools; the recede-and-let-data-lead default.
- **Evergreen** — emerald brand on true-neutral zinc. Fresh, confident, non-blue identity.
- **Terracotta** — warm clay/espresso neutrals + rust. Editorial, content platforms, writing tools.
- **Bloom** — pastel periwinkle/violet, deep dark mode. Friendly dev tools, playful-but-clean apps.

### Marketing / Landing — light + dark, hero gradients
- **Sunbloom** — refined coral/amber warmth. Approachable consumer/creator brands.
- **Tidewater** — teal/sage. Fintech, wellness, B2B trust.
- **Obsidian & Gold** — near-black + metallic gold. Premium, luxury, agency.
- **Paper & Ink** — warm paper + ink black + one terracotta accent. Blogs, long-form, portfolios.

### Data Viz — colorblind-aware, warm/cool earthy
- **Categorical:** Hearthstead · Vintage Warm · Glass Wall · Lunar Valley *(signature)*
- **Sequential:** Viridis · Magma · Inferno · Plasma · ColorBrewer Blues · YlOrRd *(perceptually uniform)*
- **Diverging:** Alien Sun · Orchard Dusk · Coffee & Coolant · Console & Window *(signature)* — all warm↔cool, no red↔green

### Terminal / TUI — 16-ANSI + bg/fg/cursor/selection
- Solarized Dark · Nord · Catppuccin Mocha · Catppuccin Latte · Dracula · Tokyo Night

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

## Methodology (essentials)

- **Design in OKLCH, not HSL.** OKLCH is perceptually uniform; HSL "lightness" lies (equal-L blue looks far darker than equal-L yellow). See theory.md.
- **Harmony:** pick a scheme (monochromatic / analogous / complementary / triadic…) and let **one** color dominate in saturation and area; desaturate the rest.
- **Scales:** 10–12 steps, step lightness evenly, peak chroma in the mid-range and taper it at the extremes so tints aren't washed out and shades aren't muddy.
- **Light vs dark is not an inversion.** Dark mode: avoid pure `#000` backgrounds (use ~`#0d1117`–`#1e1e2e`), lift saturated brand/status hues one or two steps, and signal elevation by getting *lighter*.
- **Contrast:** WCAG AA — body text ≥ 4.5:1, large text & UI/borders ≥ 3:1. Validate **dark mode with APCA**, since WCAG 2 ratios overstate contrast near black.
- **Colorblind-safety:** never encode meaning by hue alone; pair color with text/icon/position. For diverging data use warm↔cool (blue/orange, teal/rose), never red↔green.

→ Deep dives: [theory.md](references/theory.md) · [contrast.md](references/contrast.md) · [build-your-own.md](references/build-your-own.md)

## Examples

### Example: choosing colors for a SaaS dashboard

✅ Desired

```
User: "I need colors for an admin dashboard, light and dark."
→ Recommend Graphite (cool slate + blue, made for dense UI).
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
Categorical series (≤8) → Lunar Valley or Hearthstead.
Continuous low→high → Viridis (perceptually uniform, colorblind-safe).
Signed data with a midpoint → Console & Window (warm↔cool, neutral center).
Never extend a categorical set past ~8 colors — aggregate into "Other" instead.
```

Why it works: matches the data's structure to the right palette family and respects the distinguishability limit.

## Gotchas

- **Symptom:** Brand color is unreadable as body text. **Cause:** Saturated mid-tones (amber, coral, teal) often fail 4.5:1 on their own background. **Fix:** use the brand color as a *fill* (white/dark text on top) or step to a darker shade for text; verify in contrast.md.
- **Symptom:** Dark mode "passes WCAG" but is hard to read. **Cause:** WCAG 2 math overstates contrast near black. **Fix:** re-check dark pairs with APCA (Lc), not the 4.5:1 ratio alone.
- **Symptom:** Dark theme looks flat, elevation unreadable. **Cause:** pure `#000` background + same-lightness surfaces. **Fix:** raise the base to ~`#0d1117`–`#1e1e2e` and make each elevation tier *lighter*.
- **Symptom:** A chart is unreadable for colorblind viewers. **Cause:** red↔green encoding or hue-only meaning. **Fix:** switch to a warm↔cool diverging palette and add labels/icons; for categorical use the Okabe-Ito safe set (in palettes.md).
- **Symptom:** TUI colors vanish on some terminals. **Cause:** hardcoded hex or relying on bright-black (slot 8) for important text. **Fix:** bind meaning to ANSI slots 1–6 so the user's theme renders it; never put load-bearing text in slot 8.
- **Symptom:** Palette steps look lumpy/uneven. **Cause:** stepping lightness in HSL/RGB. **Fix:** rebuild the scale in OKLCH; see build-your-own.md.

## Integration

- **frontend-design** — that skill builds the actual components/layout; this one supplies the color decisions. Use them together: pick a palette here, implement the UI there.
- **generate-skill / rate-skill** — used to author and grade this skill itself.

## References

- Full palette hex tables (all four domains, light + dark): [references/palettes.md](references/palettes.md)
- Color theory — wheel, harmony, OKLCH, scales: [references/theory.md](references/theory.md)
- Contrast & accessibility — WCAG, APCA, colorblind: [references/contrast.md](references/contrast.md)
- Build a new palette — step-by-step: [references/build-your-own.md](references/build-your-own.md)
- Activation eval set (spot-check triggers): [references/EVAL.md](references/EVAL.md)
