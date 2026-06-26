# Fonts — stacks, recommendations, pairing, styling, loading

Load this when choosing or pairing typefaces, or tuning font-level CSS. **Default move: use one good family with multiple weights before reaching for a second.** Most product UIs never need a pairing.

## System font stacks (zero load, no CLS, native feel)

**Sans (the GitHub stack):**
```css
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif,
  "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
```
`-apple-system`/`BlinkMacSystemFont` → San Francisco; `"Segoe UI"` → Windows; `Roboto` → Android. Add `Oxygen-Sans, Ubuntu, Cantarell` before `sans-serif` for explicit Linux coverage.

**Monospace:**
```css
font-family: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, "Liberation Mono", "Courier New", monospace;
```
Use `ui-monospace` to reach Apple SF Mono reliably (naming `"SF Mono"` alone falls back to Menlo).

**Serif (transitional):**
```css
font-family: Charter, "Bitstream Charter", "Sitka Text", Cambria, Georgia, serif;
```

**`system-ui` keyword — caution:** resolves by **OS language, not just OS** (on zh-Hans Windows it maps to YaHei UI, rendering Latin text bold). Fine for short UI labels; for body/multilingual text use the explicit stack ending in `sans-serif`, and never place `system-ui` before `"Segoe UI"`. Full category stacks: [modernfontstacks.com](https://modernfontstacks.com/).

## Curated webfonts (all free, Google Fonts unless flagged)

**Versatile sans UI:** Inter (the safe default — see caveats), IBM Plex Sans (Inter's clarity + warmth), Source Sans 3, Public Sans (civic/gov), Geist (Vercel/dev tools), Manrope (friendly-modern), Work Sans.
> **Inter caveats:** tight default tracking (loosen at large sizes); ships an `opsz` axis / **Inter Display** for ≥20px headings — use it; tall x-height reads big; arguably overused/neutral. ([rsms.me/inter](https://rsms.me/inter/))

**Editorial / display:** Playfair Display, Fraunces (variable opsz/SOFT/WONK), DM Serif Display (headlines only), Libre Franklin, Archivo, Space Grotesk, Instrument Serif. (Clash Display — self-host via Fontshare, not GF.)

**Body serifs (long-form, screen-tuned):** Newsreader (3 optical sizes), Merriweather (large x-height, great at 14–18px), Source Serif 4, Lora, Literata, Bitter. Avoid PT Serif / Crimson Pro for small screen body.

**Monospace:** JetBrains Mono (ligatures), Fira Code (ligatures), Source Code Pro (no ligatures), IBM Plex Mono (no ligatures), Geist Mono.

**If unsure:** Inter for product UI; IBM Plex Sans to avoid the "every SaaS looks the same" effect; Newsreader/Merriweather for reading; JetBrains Mono for code.

## Pairing

- **Contrast across category** — pair a serif with a sans, not two near-identical sans (reads as a mistake).
- **Match x-height** for harmony; **share a mood/era** (contrast in form, agreement in feeling).
- **Superfamily = guaranteed harmony** — IBM Plex (Sans/Serif/Mono), Source Sans + Source Serif, DM Sans + DM Serif Display. Removes all guesswork.
- **Limit to 2 families (3 max);** assign by role (display/heading · body · mono).

**Proven pairings (heading → body):** Playfair Display → Source Sans 3 · Fraunces → Inter · **Inter → Inter** (single family, lowest risk) · IBM Plex Serif → IBM Plex Sans · Space Grotesk → Inter · DM Serif Display → DM Sans · Lora → Source Sans 3 · Newsreader → Inter.

**The one-family default:** pick Inter / Source Sans 3 / IBM Plex Sans / DM Sans and build hierarchy from weight + size (700 h1, 600 h2, 500 labels, 400 body). Add a second family only when you can name the role it fills.

## Font-level styling

**Weights:** ship 2–3 static cuts (400 body, 500/600 emphasis, 700 headings) or one variable font. Avoid 100–200 for body.
```css
h1, h2, h3 { font-synthesis: none; }   /* expose missing cuts instead of faux-bolding — dilated strokes, broken kerning */
```

**Numerals** ([font-variant-numeric](https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric)):
```css
.data-table td, .metric { font-variant-numeric: tabular-nums lining-nums; } /* align, no jitter */
code { font-variant-numeric: slashed-zero; }                                 /* 0 vs O */
```

**Ligatures:** standard on by default; **off in code** so fused `=>`/`!=`/`===` don't break exact reading:
```css
code, pre, .editor { font-variant-ligatures: none; }
```
Prefer high-level `font-variant-*` over `font-feature-settings` (the latter resets all tags); use the low-level form only for stylistic sets (`"ss01" 1`).

**Text wrapping** (Baseline 2024):
```css
h1, h2, h3, blockquote, figcaption { text-wrap: balance; } /* even line lengths, short blocks only */
p, li, article                     { text-wrap: pretty; }  /* kill orphans, fix rag */
```

**Font smoothing — don't blanket-apply.** `-webkit-font-smoothing: antialiased` thins/lightens text and is **macOS-only** — a contrast tradeoff, not a reset. Apply narrowly (e.g. light-on-dark) and verify contrast on non-Mac devices.

**Emphasis:** `<em>` italic for stress, `<strong>` bold for importance; use sparingly. Serif → italic for gentle emphasis; sans → prefer bold (sans italics are weakly differentiated).

## Loading performance

```
[ ] WOFF2 only          [ ] self-host (not the GF CDN — cache partitioning killed the shared-cache win; GDPR)
[ ] subset to latin     [ ] load only weights you use (each weight/italic = 1 file)
[ ] variable font once you'd use 3+ weights
[ ] preload ONLY the 1–2 critical above-the-fold faces (crossorigin is mandatory)
[ ] font-display: swap + metric-matched fallback (or optional for zero CLS)
[ ] total font payload ≤ ~100 KB
```

```css
@font-face { font-family:"Inter"; src:url(inter.woff2) format("woff2");
  font-weight:400; font-display:swap; }
```
`swap` = text always visible (FOUT); pair with a metric-matched fallback (`size-adjust`/`ascent-override`, or Next.js `next/font`) to kill the layout shift. `optional` = zero CLS but some first-visit users never see the webfont.

## Sources

- [Modern Font Stacks](https://modernfontstacks.com/) · [CSS-Tricks System Font Stack](https://css-tricks.com/snippets/css/system-font-stack/)
- [Google Fonts Knowledge — Pairing](https://fonts.google.com/knowledge/choosing_type/pairing_typefaces) · [Typewolf — Best Google Fonts](https://www.typewolf.com/google-fonts)
- [rsms.me/inter](https://rsms.me/inter/) · Butterick [font recommendations](https://practicaltypography.com/font-recommendations.html) · [bold or italic](https://practicaltypography.com/bold-or-italic.html)
- MDN [font-variant-numeric](https://developer.mozilla.org/en-US/docs/Web/CSS/font-variant-numeric) · [text-wrap](https://developer.mozilla.org/en-US/docs/Web/CSS/text-wrap) · [font-display](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)
- [web.dev — Font best practices](https://web.dev/articles/font-best-practices) · [Zach Leatherman — Comprehensive Webfonts](https://www.zachleat.com/web/comprehensive-webfonts/)
