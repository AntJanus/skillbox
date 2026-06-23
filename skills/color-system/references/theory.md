# Color theory — wheel, harmony, color spaces, scales

Load this when building or reasoning about a palette from scratch.

## Color spaces — design in OKLCH

| Space | What it is | Use it for |
|---|---|---|
| HEX / RGB | Channel intensities. Opaque to humans. | Final output only. |
| HSL | Hue, saturation, lightness. Intuitive but **not perceptually uniform**. | Quick tweaks; never for scales. |
| OKLCH / OKLab | Perceptual: Lightness, Chroma, Hue (Björn Ottosson, 2020). | **Generating palettes and scales.** |

**"HSL lightness lies":** `hsl(240 100% 50%)` (blue) and `hsl(60 100% 50%)` (yellow) share L=50% but yellow reads ~2–3× brighter. Stepping lightness evenly in HSL produces lumpy scales (dull blues, washed-out yellows). OKLCH's L tracks actual perceived brightness, so equal steps look equal.

Tooling: [oklch.com](https://oklch.com) (Evil Martians) for conversions + gamut checks; Culori / Chroma.js programmatically. OKLCH is baseline-available in browsers since 2023.

## The color wheel & harmony schemes

Apply the **60-30-10 rule** to distribute any scheme: 60% dominant/neutral, 30% secondary, 10% accent.

| Scheme | Geometry | Use | Failure mode |
|---|---|---|---|
| Monochromatic | One hue, vary L/C | Minimal, sophisticated | Flat if light–dark spread too small |
| Analogous | 3 adjacent (~30° apart) | Calm, cohesive, gradients | Weak CTA contrast; passive |
| Complementary | 2 opposite (180°) | High-energy CTAs, emphasis | Garish if both fully saturated |
| Split-complementary | base + 2 neighbors of complement | Drama without harshness | Incoherent without a dominant hue |
| Triadic | 3 evenly spaced (120°) | Playful, vibrant brands | "Visual bazaar" at full saturation |
| Tetradic / square | 2 complementary pairs | Maximum variety | Hardest to balance; force a dominant |

**Rule across all:** one color dominates in saturation *and* area; desaturate or tint the rest.

## Building a color scale (10–12 steps)

Modern systems (Radix 12-step, Tailwind `50`→`950`, Material HCT tones) follow the same shape:

1. Pick a base hue in OKLCH, e.g. `oklch(57% 0.18 286)`.
2. **Hold the hue.** Step **lightness** evenly across 12 stops (≈ 97% → 15%).
3. **Taper chroma:** peak it in the mid-range (L ≈ 45–65%), reduce at both extremes (so tints aren't washed out, shades aren't muddy).
4. **Reserve each step for a use** and bake in contrast: app bg → subtle bg → component bg/hover/active → borders → solid fill → hover → low-contrast text → high-contrast text (the Radix step semantics).

Radix 12-step role map (a proven reference):

| Step | Role | Step | Role |
|---|---|---|---|
| 1 | App background | 7 | Border / focus ring |
| 2 | Subtle background | 8 | Hovered border |
| 3 | Component background | 9 | Solid fill (purest hue) |
| 4 | Hovered component | 10 | Hovered solid |
| 5 | Active / selected | 11 | Low-contrast text |
| 6 | Subtle border | 12 | High-contrast text |

## Semantic roles & "on-" pairing

Every prominent color needs a guaranteed-accessible foreground. Material 3 ships colors as quads — `primary / on-primary / primary-container / on-primary-container`. Practically: each `success/warning/error/info` wants a low-saturation **container** (background tint) and a high-contrast **on-** foreground.

Conventional state hues (Western, document as starting points, not universal): success = green, warning = amber, error = red, info = blue.

## Warm vs cool & saturation (use as weak heuristics)

- "Warm advances, cool recedes" is **unreliable** — depends on contrast and context more than temperature. Treat as a hint, not a rule.
- High saturation drives attention/arousal → reserve for CTAs, alerts, focal points. Desaturated colors reduce eye strain over large areas and long sessions.
- Red text reports the highest visual fatigue; yellow the lowest.

## Sources

- OKLab/OKLCH: https://bottosson.github.io/posts/oklab/ · https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl
- Radix scale semantics: https://www.radix-ui.com/colors/docs/palette-composition/understanding-the-scale
- Tailwind colors: https://tailwindcss.com/docs/colors · Material 3 color: https://m3.material.io/styles/color/system/how-the-system-works
- Color harmony: https://www.interaction-design.org/literature/topics/color-harmony
