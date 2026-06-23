# Contrast & accessibility

Load this when verifying a palette or choosing text/background pairings.

## WCAG 2.x contrast ratios

Contrast is a luminance ratio from `1:1` (identical) to `21:1` (black on white).

| Content | AA | AAA |
|---|---|---|
| Normal text | **4.5:1** | 7:1 |
| Large text (≥18pt, or ≥14pt bold) | **3:1** | 4.5:1 |
| UI components, borders, graphical objects, focus rings | **3:1** | — |

Formula: `(L1 + 0.05) / (L2 + 0.05)`, L1 = lighter, L2 = darker.
Relative luminance (sRGB): `L = 0.2126·R + 0.7152·G + 0.0722·B`, where each channel `C` is linearized: `C ≤ 0.03928 → C/12.92`, else `((C + 0.055)/1.055)^2.4`.

- **Disabled** elements are exempt (low contrast is the affordance).
- **Placeholder / muted text** that conveys information must still meet 4.5:1.
- **Focus rings** are load-bearing — keep ≥ 3:1 against adjacent colors.

## APCA (WCAG 3 candidate — use for dark mode)

APCA (Andrew Somers / Myndex) outputs a perceptual **Lc** value (~0 to ±108), polarity-aware: **positive Lc = dark text on light**, **negative = light text on dark**. Light and dark are *not* simple inversions.

| Lc | Use |
|---|---|
| 90 | Body text, preferred |
| 75 | Body text, minimum |
| 60 | Non-body / large content text |
| 45 | Large/heavy text, headlines |
| 30 | Spot / placeholder / disabled / icons (floor) |

**Why it matters:** WCAG 2 math *overstates* contrast for near-black colors, so a "passing" 4.5:1 dark-mode pair can be functionally unreadable. **Validate dark themes with APCA, not the ratio alone.** Status: WCAG 3 is still a draft — treat APCA as guidance, not compliance. Calculator: https://www.myndex.com/APCA/

## Don't use pure black on pure white

`#000` on `#fff` (21:1) causes **halation** — light text blooms into the dark field, straining eyes (worse for the ~1/3 with astigmatism). Use **near-black** text (`#1a1a1a`–`#222`) on **near-white** (`#fafafa`–`#f5f5f5`).

## Dark mode specifics

- Avoid pure `#000` backgrounds — same halation, and it defeats elevation. Use ~`#0d1117`–`#1e1e2e` (Material's baseline is `#121212`).
- Convey elevation by getting **lighter**, not by shadow alone.
- Prefer **off-white** body text (`#e0e0e0`–`#f5f5f5`) over pure `#fff` to cut glare.
- Lift saturated brand/status hues one or two steps vs their light-mode values; mid-tones that pass on white go muddy on near-black.

## Colorblind-safety (~8% of men, ~0.5% of women)

- **Never encode meaning by hue alone** — pair color with text, icon, pattern, or position (WCAG 1.4.1).
- **Avoid red↔green** (indistinguishable for most CVD). Safer: blue/orange, blue/red, teal/rose, or any pair with strong **lightness** difference.
- For diverging data use a warm↔cool axis with a neutral light midpoint — never red↔green.

**Okabe-Ito 8-color safe categorical set** (CVD-safe for protan/deutan/tritan):

| Name | Hex | Name | Hex |
|---|---|---|---|
| Black | `#000000` | Blue | `#0072B2` |
| Orange | `#E69F00` | Vermillion | `#D55E00` |
| Sky Blue | `#56B4E9` | Reddish Purple | `#CC79A7` |
| Bluish Green | `#009E73` | Yellow | `#F0E442` |

Simulate with Coblis (web) or Sim Daltonism (macOS/iOS).

## Quick checklist

- [ ] text-primary on background ≥ 4.5:1 (both modes)
- [ ] text-secondary ≥ 4.5:1 if informational
- [ ] borders / focus rings ≥ 3:1
- [ ] brand/accent as *text* verified (saturated hues often fail — use as fill instead)
- [ ] dark mode re-checked with APCA
- [ ] no meaning carried by hue alone; charts CVD-simulated

## Sources

- WCAG 1.4.3: https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html
- WebAIM contrast: https://webaim.org/articles/contrast/
- APCA: https://git.apcacontrast.com/documentation/APCA_in_a_Nutshell.html · Why APCA / dark mode: https://github.com/Myndex/SAPC-APCA/blob/master/documentation/WhyAPCA.md
- Okabe-Ito: https://siegal.bio.nyu.edu/color-palette/ · Material dark theme: https://m2.material.io/design/color/dark-theme.html
