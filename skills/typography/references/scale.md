# Type scale, vertical rhythm & measure

Load this when building a custom scale or reasoning about spacing/rhythm from scratch.

## The modular scale

A scale is a geometric sequence from a **base size** and a **ratio**:

```
size(n) = base × ratio^n      (n = 0 at base; negative = smaller)
```

Round results to whole/half px and expose as `rem`. Pick the ratio by product type:

| Ratio | Name | Decimal | Use for |
|---|---|---|---|
| Major second | 8:9 | **1.125** | Dense dashboards, data UI — many usable steps, small jumps |
| Minor third | 5:6 | **1.2** | Product UI / general apps — the workhorse default |
| Major third | 4:5 | **1.25** | Stronger hierarchy, still dense — safe editorial default |
| Perfect fourth | 3:4 | **1.333** | Editorial / marketing — the classic web ratio |
| Aug. fourth | 1:√2 | 1.414 | Dramatic editorial |
| Perfect fifth | 2:3 | **1.5** | Hero / landing — strong contrast, few steps |
| Golden | — | 1.618 | Maximum drama, luxury/display |

Large systems often run **two scales**: a tight UI scale (1.125–1.2) and a looser content scale (1.333–1.5), applied by context. Tools: [type-scale.com](https://typescale.com/), [modularscale.com](https://www.modularscale.com/).

**Worked example — base 16, ratio 1.2:**
12 · 14 · 16 · 20 · 24 · 30 · 36 · 48 (rounded). Each step is the prior × 1.2, snapped to a clean px.

## Line-height (leading)

- **Body 1.5** (range 1.4–1.6). Butterick's canonical range is 120–145% of size.
- **Headings 1.1–1.25.** **Display 1.0–1.1.**
- **Inverse to size:** the bigger the text, the smaller the multiplier (absolute leading still grows).

| Size | LH ratio | Rendered |
|---|---|---|
| 12px | 1.5–1.6 | 18–19px |
| 16px | 1.4–1.5 | 22–24px |
| 24px | 1.15–1.2 | ~28px |
| 32px | 1.05–1.1 | ~35px |
| 48px | 1.0–1.05 | ~50px |

**Always unitless.** `line-height: 1.5` inherits as a multiplier and recomputes per element. `line-height: 24px` or `1.5em` inherits a *fixed length* — an `h1` then gets 24px leading and overlaps. ([MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/line-height))

Optional fluid leading (longer measure wants more leading): `line-height: clamp(1.3, 0.9rem + 0.4vw, 1.6);`

## Vertical rhythm & the 8px grid

- **Rhythm unit = body size × body line-height = 16 × 1.5 = 24px.** All vertical margins/padding are multiples (or clean sub-multiples) of it.
- Build spacing on a **4/8px grid** — 24 = 3 × 8 is grid-friendly, scales cleanly at @2x. Token set: 4 · 8 · 12 · 16 · 24 · 32 · 48 · 64.
- **Don't pixel-chase a literal baseline grid.** Sub-pixel rounding, mixed sizes, images, and nested padding all break it; CSS `line-height` has no baseline-snap. Enforce a **consistent spacing scale** instead — that delivers the perceived rhythm without the fragility. ([Smashing: CSS Baseline](https://www.smashingmagazine.com/2012/12/css-baseline-the-good-the-bad-and-the-ugly/))

### Paragraph & heading spacing
- Paragraphs: **space-between OR first-line indent, never both.** Space-between ≈ 0.75–1× rhythm unit (`margin-bottom: 1.5rem`).
- Headings: **space-before > space-after.** `margin-top` ≈ 1.25–2× unit, `margin-bottom` ≈ 0.375–0.75× unit — bind the heading to the content below it (Gestalt proximity).

## Measure (line length)

- **Optimal ≈ 66 characters/line** (range 45–75; Bringhurst's 66, Butterick's "2–3 alphabets" = 52–78).
- Set with `ch`: `max-width: 66ch` for body, `~50ch` for narrow columns, never past `~80ch`.
- `ch` = width of the "0" glyph, so it slightly **over**estimates real CPL (0 is wider than average) — treat 66ch as ~60–70 actual characters; verify on real content.
- Too-long lines → return-sweep errors (eye loses the next line's start) → fatigue and re-reading. Too-short → broken rhythm.

## Letter-spacing (tracking)

Set in **em** so it scales with size.

| Context | em | Direction |
|---|---|---|
| Large display / h1 | −0.02 to −0.025 | tighten |
| h2–h3 | −0.01 to −0.015 | slight tighten |
| **Body** | **0** | leave alone |
| Captions (<12px) | +0.01 to +0.02 | slight loosen |
| **ALL-CAPS / small labels** | **+0.05 to +0.12** | loosen |

Negative on large text, zero on body, positive on all-caps/small — the optical pattern Material and Carbon both encode. Simpler systems (Bootstrap, Primer, Ant) ship zero everywhere; that's also fine.

## Sources

- Butterick, *Practical Typography* — [line spacing](https://practicaltypography.com/line-spacing.html) · [line length](https://practicaltypography.com/line-length.html) · [letterspacing](https://practicaltypography.com/letterspacing.html)
- [A List Apart — More Meaningful Typography](https://alistapart.com/article/more-meaningful-typography/)
- [Smashing — Fluid Typography with clamp()](https://www.smashingmagazine.com/2022/01/modern-fluid-typography-css-clamp/)
- [Spec.fm — The 8-Point Grid](https://spec.fm/specifics/8-pt-grid) · [IBM Carbon Spacing](https://carbondesignsystem.com/elements/spacing/overview/)
- [Tim Brown — Molten Leading](https://tbrown.org/notes/2012/02/03/molten-leading-or-fluid-line-height/)
