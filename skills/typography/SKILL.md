---
name: typography
description: Typography & type systems — font sizing, type scale, line-height, weight, vertical rhythm, font pairing, and a readability floor that stops tiny/thin/low-contrast text. Use this skill whenever the user wants to size text, build a type scale, fix unreadable type, set vertical rhythm, or pick and pair fonts. Do NOT use for color palettes — see color-system; layout — see frontend-design.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.3.1"
  tags: [typography, type-scale, font-size, line-height, vertical-rhythm, readability, accessibility, fonts]
---

# Typography

## Overview

Ready-to-use **type systems** (Product UI, Editorial, Marketing, Docs/Technical) plus the methodology to size text, build scales, set vertical rhythm, and pick fonts — so generated UI is readable instead of tiny, thin, and low-contrast.

**Core principle:** size text by **role on a scale**, never by eyeballed pixels. Pick a base (16px), a ratio (~1.2), and derive every size from it. Then keep text above the **readability floor** — the four numbers below — because most "impossible to read" output violates at least one of them.

## The readability floor (the contract)

These are the recede-defaults. Most unreadable AI typography breaks one of them; meet all four and text is legible by construction. Deviate only deliberately, with a reason.

| Floor | Default | Why |
|---|---|---|
| **Size** | body **≥ 16px / 1rem** | Browser default; iOS zooms `<input>` under 16px. Captions never < 12px. |
| **Weight** | body **≥ 400** | Weights 100–300 thin the stroke and drop perceived contrast on small text. |
| **Contrast** | text **≥ 4.5:1** (large ≥ 3:1) | WCAG 2 AA. Re-check dark mode / thin fonts with APCA — WCAG2 overstates contrast near black. |
| **Line-height** | body **≥ 1.5** | Cramped leading hurts reading and fails the WCAG 1.4.12 spacing override. |

The single worst combination is **small + thin + low-contrast** — any two is risky, all three is the canonical unreadable panel. → [references/readability.md](references/readability.md)

**Verify computed, not authored.** Reading the class/prop/token in source only tells you intent — check the actual rendered value (devtools Computed panel, or `getComputedStyle(el).fontSize`) before calling a size fixed. A "should be 16px" edit that's still 13px on screen is a common failure mode, not a rare one.

## How to use this skill

1. **Need a ready system?** → scan the Type System Library below, pick one, copy its token table from [references/systems.md](references/systems.md).
2. **Building a custom scale?** → [references/scale.md](references/scale.md) (ratios, vertical rhythm, measure).
3. **Checking readability?** → [references/readability.md](references/readability.md) (minimum sizes, WCAG/APCA, fluid `clamp()`, failure modes).
4. **Choosing/pairing fonts?** → [references/fonts.md](references/fonts.md) (system stacks, curated webfonts, pairing, font-level CSS, loading).

Load a reference only when the task needs it — keep context lean.

## Type System Library (quick index)

Each system ships a full token table (size · line-height · weight · tracking, light + values) in [references/systems.md](references/systems.md).

- **Product UI** — system sans, 16px base, ratio **1.2**. Dense dashboards, apps, dev tools. Tabular numerals for data. A 14px "compact" variant for enterprise density.
- **Editorial / Long-form** — serif body at **18px / LH 1.6**, ratio **1.25**, measure **66ch**. Articles, blogs, docs prose. Space-before > space-after on headings.
- **Marketing / Landing** — fluid `clamp()` display, ratio **1.333**, tight tracking at scale. Heroes, landing pages. Bigger body (18px), scrim on text-over-image.
- **Docs / Technical** — Product UI scale + first-class **mono** (code blocks, inline code, API tables). Ligatures off in code, slashed-zero, tabular numerals.

→ **Full token tables:** [references/systems.md](references/systems.md)

## Methodology (essentials)

- **Build the scale from a base × ratio.** `size(n) = base × ratio^n`. Dense UI → 1.125–1.2; product/general → 1.2–1.25; editorial → 1.333–1.414; hero/display → 1.5–1.618. Round to whole/half px, expose as `rem`.
- **Line-height scales inversely with size.** Body 1.5; headings 1.2; display 1.0–1.1. The bigger the text, the tighter the leading. Keep `line-height` **unitless** so it recomputes per element.
- **Vertical rhythm on an 8px grid.** Rhythm unit = body size × body LH = 24px. Make every margin/padding a multiple of 4/8px. Don't pixel-chase a literal baseline grid — enforce a consistent spacing scale instead.
- **Cap the measure.** Body `max-width: ~66ch` (≈ 45–75 characters/line). Too-long lines cause return-sweep errors; too-short break rhythm.
- **Tracking is optical.** 0 on body; **−0.01 to −0.025em** on large headings (tighten as size grows); **+0.05 to +0.12em** on ALL-CAPS / small labels. Set in `em` so it scales.
- **Weight carries hierarchy.** Body 400, headings 600 (700 for stronger). Large display can go lighter (400) because mass substitutes for weight. Prefer one good family with multiple weights before adding a second.
- **Size in `rem`, fluid via `clamp()`.** `clamp(min_rem, calc(rem + vw), max_rem)` — keep min/max in `rem` and the preferred mixing a `rem` term, so text still scales at 200% zoom. Never `vw`-only.

→ Deep dives: [scale.md](references/scale.md) · [readability.md](references/readability.md) · [fonts.md](references/fonts.md)

## Examples

### Example: body text sizing

✅ Desired

```css
body { font-size: 1rem; line-height: 1.5; font-weight: 400; color: #1e293b; } /* 16px, ~14:1 on white */
```

❌ Anti-pattern

```css
body { font-size: 13px; line-height: 1.25; font-weight: 300; color: #9ca3af; } /* small + thin + low-contrast: ≈2.5:1 */
```

Why it fails: 13px is below the floor, 300 thins the stroke, `#9ca3af` on white is ≈2.5:1 — all three readability failures at once, and px ignores the user's font-size setting.

### Example: fluid heading

✅ Desired

```css
h1 { font-size: clamp(1.75rem, 1.1rem + 3.2vw, 3rem); line-height: 1.1; letter-spacing: -0.02em; } /* scales, caps, still zooms */
```

Why it works: `rem` bounds + a `rem`-anchored preferred keep it readable at 200% zoom; the cap stops a runaway hero size.

## Gotchas

- **Symptom:** Headings size right but feel cramped or loose. **Cause:** one fixed line-height everywhere. **Fix:** line-height *inverse* to size — body 1.5, headings 1.2, display ~1.05.
- **Symptom:** Inputs zoom/jump on iPhone. **Cause:** form control text < 16px. **Fix:** inputs ≥16px; never `user-scalable=no`.
- **Symptom:** Long paragraphs are tiring to read. **Cause:** lines run 100+ characters. **Fix:** `max-width: 66ch` on body/prose containers.
- **Symptom:** Heading floats between two sections. **Cause:** equal margin above and below. **Fix:** space-before > space-after (bind heading to the text under it).
- **Symptom:** Numbers in a table shift width as they change. **Cause:** proportional figures. **Fix:** `font-variant-numeric: tabular-nums`.
- **Symptom:** Fluid type stops scaling at 200% zoom. **Cause:** `vw`-only `font-size`. **Fix:** `clamp(rem, calc(rem + vw), rem)`; browsers don't zoom `vw`.
- **Symptom:** Text over a hero image is unreadable in spots. **Cause:** no scrim; contrast varies per pixel. **Fix:** add a semi-opaque overlay / `text-shadow`; verify the worst-case region.
- **Symptom:** Bold looks smeared, italics weak. **Cause:** faux-synthesized weight/style the font file lacks. **Fix:** load real weights or use a variable font; `font-synthesis: none` to expose gaps.
- **Symptom:** Theme/CSS says text should be ≥16px, but it renders small anyway. **Cause:** size-token names lie — Mantine `size="sm"`/`"xs"` compute to 14px/12px, Tailwind `text-sm`/`text-xs` to 14px/12px, both under the floor; nested `em` units also compound multiplicatively per level, shrinking silently as components nest. **Fix:** read the *computed* font-size in devtools, not the source class/token; prefer `rem` for font-size so it can't compound.
- **Symptom:** Body text passes the floor but chart/graph text is still tiny and washed out. **Cause:** charting libraries (Recharts, Mantine charts) render text as SVG with their own inline `font-size`/`fill` — it doesn't inherit your CSS type scale or color tokens. **Fix:** target the library's text elements directly (e.g. `.recharts-wrapper text { font-size: …; fill: var(--text) }`) and re-verify the computed size/color — your stylesheet's cascade never reaches it.
- **Symptom:** Every heading — often all body text too — silently renders in the browser's fallback serif (e.g. `Times`), even though the right fonts are imported and the theme references them correctly; source review finds nothing wrong. **Cause:** a CSS-variable-scope bug from combining `next/font`'s `variable` mode with a UI library that injects its font-family at `:root` (Mantine does this: `:root, :host { --mantine-font-family: var(--font-body) } `). If the font's `.variable` class name is applied only to `<body>` (a common `next/font` pattern), `--font-body` doesn't exist at `:root` — CSS custom properties never inherit upward from a descendant to an ancestor — so the `var()` reference is guaranteed-invalid and every consuming `font-family` rule falls back to the browser default. This is invisible from source; it only shows up in `getComputedStyle(document.body).fontFamily`. **Fix:** apply the font's `.variable` class name to `<html>`, not `<body>` — or better, follow the library's own documented pattern where one exists (Mantine's official guidance injects the resolved `font.style.fontFamily` string directly instead of a CSS variable, which sidesteps the bug entirely: [help.mantine.dev/q/next-load-fonts](https://help.mantine.dev/q/next-load-fonts)).
- **Symptom:** Body text passes the floor everywhere you checked, but tables, nav labels, tooltips, menus, and form-field labels are still ~14px — and there's no `size` prop anywhere to explain it. **Cause:** component libraries commonly ship internal default sizes *below their own base* on specific components even though `Text`'s own default is safe — e.g. Mantine's `Table` cells, `NavLink` label, `Tooltip`, `Menu` item, `Alert`, `Notification`, `Tabs` tab, and `Input` label/description all default to the `sm` (14px) or `xs` (12px) token while `Text` defaults to `md` (16px). Grepping app code for `size="xs"`/`"sm"` finds none of these — there's no prop authored to grep for. **Fix:** override the *entire* size scale explicitly in the shared theme rather than assuming a safe `md` base means smaller components inherit it, and spot-check components you never explicitly sized, not just the ones you did.

## Integration

- **color-system** — supplies the text/background hexes and contrast verification; this skill sets size, weight, and rhythm. Use together: pick colors there, size type here.
- **frontend-design** — builds the actual components/layout; this one decides the type. Pick a system here, implement the UI there.
- **generate-skill / rate-skill** — used to author and grade this skill itself.

## References

- Full token tables for all four systems (light, with rem/px/LH/weight/tracking): [references/systems.md](references/systems.md)
- Type scale, vertical rhythm, measure, ratios: [references/scale.md](references/scale.md)
- Readability & accessibility — minimum sizes, WCAG/APCA, fluid `clamp()`, failure modes: [references/readability.md](references/readability.md)
- Fonts — system stacks, curated webfonts, pairing, font-level CSS, loading: [references/fonts.md](references/fonts.md)
- Activation eval set (spot-check triggers): [references/EVAL.md](references/EVAL.md)
