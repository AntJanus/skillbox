# Type System Library — full token tables

Four ready-to-use systems. Copy the table you need into CSS variables. Every body default meets the readability floor (size ≥16px, weight ≥400, contrast ≥4.5:1, line-height ≥1.5). Sizes are given in px and rem (1rem = 16px); `line-height` is unitless; `tracking` is in `em`.

All four share the **8px spacing grid** (rhythm unit = 24px):

```css
--s1:4px; --s2:8px; --s3:12px; --s4:16px; --s6:24px; --s8:32px; --s12:48px; --s16:64px;
```

---

## 1. Product UI — system sans · 16px base · ratio 1.2

Dense dashboards, apps, dev tools, admin panels. Zero font-load cost. A 14px **compact** column is included for enterprise density (matches GitHub/Atlassian/IBM/Ant).

```css
--font-ui: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif,
  "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
--font-mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
```

| Role | px | rem | Line-height | Weight | Tracking | Notes |
|---|---|---|---|---|---|---|
| caption | 12 | 0.75 | 1.4 | 500 | +0.06em | uppercase labels, metadata |
| small | 14 | 0.875 | 1.45 | 400 | 0 | helper text, dense cells |
| **body** | **16** | **1** | **1.5** | **400** | 0 | reading baseline |
| lead | 18 | 1.125 | 1.5 | 400 | 0 | intro line |
| h5 | 20 | 1.25 | 1.35 | 600 | 0 | |
| h4 | 24 | 1.5 | 1.3 | 600 | 0 | |
| h3 | 30 | 1.875 | 1.2 | 600 | −0.01em | |
| h2 | 36 | 2.25 | 1.15 | 700 | −0.015em | |
| h1 | 48 | 3 | 1.05 | 700 | −0.02em | |

**Compact (14px base)** — shift body→14, small→13, lead→16, h5→18, h4→20, h3→24, h2→30, h1→38; body LH 1.43. Use only when density genuinely matters; never below 12px for any text.

**Data:** `font-variant-numeric: tabular-nums lining-nums;` on every metric, table cell, timer, and price so digits align and don't jitter.

---

## 2. Editorial / Long-form — serif body · 18px base · ratio 1.25 · 66ch

Articles, blogs, documentation prose, anything read for more than a glance. Body runs larger and looser than UI; measure is capped.

```css
--font-serif: "Newsreader", "Source Serif 4", Charter, "Bitstream Charter", "Sitka Text", Cambria, Georgia, serif;
--font-ui:    ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
/* Headings may use --font-serif (cohesive) or --font-ui (contrast). */
.prose { max-width: 66ch; }
```

| Role | px | rem | Line-height | Weight | Tracking |
|---|---|---|---|---|---|
| caption | 14 | 0.875 | 1.45 | 400 | 0 |
| **body** | **18** | **1.125** | **1.6** | **400** | 0 |
| lede | 23 | 1.4375 | 1.5 | 400 | 0 |
| h4 | 23 | 1.4375 | 1.35 | 600 | 0 |
| h3 | 28 | 1.75 | 1.3 | 600 | −0.005em |
| h2 | 35 | 2.1875 | 1.2 | 600 | −0.01em |
| h1 | 44 | 2.75 | 1.1 | 700 | −0.015em |

**Rhythm:** paragraph spacing = one rhythm unit (≈ body size, `margin-bottom: 1.5rem`). Use **space-between OR first-line indent, never both**. Headings: `margin-top` ≈ 1.25–2× unit, `margin-bottom` ≈ 0.5× unit (bind heading to the text below). Body color slightly off-black (`#1e293b`) reads softer than pure `#000` for long stretches.

---

## 3. Marketing / Landing — fluid display · 18px base · ratio 1.333

Heroes, landing pages, feature sections. Big fluid headlines, tight tracking at scale, generous body. Use a display face for headings, a clean sans for body — or one strong family across both.

```css
--font-display: "Fraunces", "Playfair Display", Georgia, serif;  /* or a display sans: "Space Grotesk", "Archivo" */
--font-ui:      ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
```

| Role | Size | Line-height | Weight | Tracking |
|---|---|---|---|---|
| eyebrow | 14px / 0.875rem | 1.4 | 600 | +0.14em uppercase |
| **body** | **18px / 1.125rem** | **1.5** | **400** | 0 |
| lead | `clamp(1.125rem, 1rem + 0.6vw, 1.375rem)` | 1.5 | 400 | 0 |
| h3 | 32px / 2rem | 1.2 | 600 | −0.015em |
| h2 | 43px / 2.6875rem | 1.1 | 700 | −0.02em |
| h1 | `clamp(2.5rem, 1.5rem + 4.5vw, 4rem)` | 1.05 | 700 | −0.025em |
| display | `clamp(3rem, 1.6rem + 5.5vw, 4.5rem)` | 1.05 | 700/400 | −0.025em |

**Text over image/gradient:** add a scrim (semi-opaque overlay) or `text-shadow`; verify the worst-case region ≥ 4.5:1. Cap hero copy at ~54ch and `text-wrap: balance` on headlines.

---

## 4. Docs / Technical — Product UI scale + first-class mono

API docs, READMEs, technical reference. Inherits the Product UI sans scale for prose; adds a deliberate mono treatment for code.

```css
--font-ui:   ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
--font-mono: ui-monospace, "JetBrains Mono", SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace;
.prose { max-width: 78ch; } /* docs run a touch wider than editorial; never past ~80ch */
```

Prose: use the **Product UI** table above. Mono additions:

| Role | Size | Line-height | Notes |
|---|---|---|---|
| code block | 14–15px / 0.875–0.9375rem | 1.5 | `font-variant-ligatures: none; tab-size: 2;` |
| inline code | 0.9em (relative to surrounding) | inherit | slightly smaller than body so it sits inline |
| API table | 14px / 0.875rem | 1.45 | `font-variant-numeric: tabular-nums slashed-zero;` |

```css
code, pre, kbd, samp { font-family: var(--font-mono); }
pre code { font-variant-ligatures: none; }          /* fused =>, !=, === hurt exact reading */
code { font-variant-numeric: slashed-zero; }         /* disambiguate 0 / O in IDs */
```

---

## Applying any system (drop-in)

```css
body {
  font-family: var(--font-ui);
  font-size: 1rem; line-height: 1.5; font-weight: 400;
  color: #1e293b; background: #f8fafc;
}
h1,h2,h3,h4,h5 { text-wrap: balance; font-synthesis: none; margin: 0; }
p  { text-wrap: pretty; }
.prose { max-width: 66ch; }
.data, td.num, .metric { font-variant-numeric: tabular-nums lining-nums; }
```

Map each element to a role, read the role's tokens from the table, and the result clears the readability floor by construction.
