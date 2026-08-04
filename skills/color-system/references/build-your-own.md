# Build your own palette — step by step

Use this when no library palette fits and you need a new one. Work in OKLCH throughout (see theory.md for why).

## 1. Pick the brand/seed hue

Choose one anchor color that carries the brand. Convert it to OKLCH at [oklch.com](https://oklch.com). Note its hue (H) — you'll hold it constant for the neutral and primary scales.

Decide the **temperature of your neutrals** — as a function of the accent, not independently (Radix's composition rule: pure gray for a neutral feel, or a gray tinted toward the accent hue for a warmer, more harmonious one).

- Cool neutrals (slate, blue-gray) → professional, techy (e.g. Graphite).
- True neutral (zinc/gray) → versatile, lets the brand lead (e.g. Evergreen).
- Warm neutrals (stone, clay) → editorial, cozy (e.g. Terracotta).

Two palettes that share a brand hue but differ in neutral temperature read as distinct — use this to differentiate a family.

**Pick it per mode, not once.** A warm tint that reads as paper at high lightness reads as mud at low lightness. Driftwood holds sand neutrals (hue 64, chroma 0.014) in light mode and swings to hue 224 in dark; Meadow's sage survives both and holds one hue. Generate the dark ramp before you commit — this is the single most common reason a palette that looks right in light mode feels muddy in dark.

A useful seed source: gallery sites like Color Hunt and Coolors. Take the **hues**, not the palette — of the 30 most-liked Color Hunt palettes, 16 cannot carry 4.5:1 body text with any pair of their four colors. They are hue material; the scales below are what make them usable.

## 2. Generate the neutral scale (12 steps)

This is most of your UI. Hold a low-chroma version of a hue (often a hint of the brand hue for cohesion):

1. 12 stops, lightness ≈ 98% → 12% in even OKLCH steps.
2. Keep chroma very low (≈ 0.01–0.03); a whisper of the brand hue beats pure gray.
3. Map to roles: 1 background · 2 subtle bg · 3–5 surfaces/hover/active · 6–8 borders · 11 muted text · 12 primary text. (Radix step map in theory.md.)

## 3. Generate the brand/primary scale

Same 12-step process at full chroma, hue held. The **solid step** (≈ L 55–60%) is your `primary`; the step above it is `primary-hover`; a darker step (~L 45%) is your accessible `primary` *text* color when needed.

## 4. Add accent + semantic states

- **Accent:** a second hue, typically analogous (+30°) or split-complementary, used at ~10% (the "10" in 60-30-10).
- **Success / warning / error / info:** start from green / amber / red / blue, then nudge each toward your brand's chroma and temperature so they feel part of the set (not stock Bootstrap colors).

Give every one of them — accent and states included — a full **triad**, since one hex cannot be sat on, used as a badge background, and read as a label all at once:

| Token | From the scale | Used for |
|---|---|---|
| `fill` | step 9 | Buttons, active chips, solid badges |
| `on-fill` | white, or step 12 / step 1 | The label on that fill |
| `subtle` | step 3 | Badge and callout backgrounds, validation fields |
| `subtle-border` | step 6 | The border around that background |
| `emphasis` | step 11 | The label on that subtle background |
| `as text` | step 11, solved on `surface` | The same hue as a link |

Keep `fill` and `as text` as separate values. See theory.md for why, and palettes.md for nine worked examples.

## 5. Derive the dark mode (do NOT just invert)

For each role:
- `background`: a dark near-neutral, **not** `#000` (≈ `#0d1117`–`#1e1e2e`).
- `surface` / `surface-elevated`: each tier **lighter** than the last (elevation = lighter).
- `text-primary`: off-white (`#e0e0e0`–`#f5f5f5`), not pure `#fff`.
- `primary` / `accent` / states: lift one or two steps brighter than light mode (saturated mid-tones go muddy on dark).
- **Neutral hue and chroma: re-decide them here.** Do not inherit the light-mode tint by default. Regenerate the dark neutral ramp and look at it — a warm hue that made the light canvas feel like paper will make the dark canvas feel brown. Swinging cool (toward the primary's hue, at very low chroma) is the usual fix.
- `on-fill` flips: dark-mode fills are light hues, so their labels are the palette's *darkest* neutral, not white. Nothing about the light-mode palette predicts this.

## 6. Solve, then verify (gate before shipping)

The scale gets you evenly-stepped values; it does not get you to AA. Expect to move these four:

1. **`fill`** — raw step 9 rarely carries a 4.5:1 button label. **Direction matters:** in light mode commit to a white label and step the fill *darker*; in dark mode keep step 9 and take a dark label. Picking whichever label already scores higher lightens a light-mode fill into a pale wash that passes and looks weak.
2. **`border-strong`** — step 8 is the "hovered border" step, not a 3:1 control edge. Step it until it clears against `surface`. Keep the untouched `border` for dividers, which are exempt.
3. **`emphasis`** — step 11 on step 3 usually passes; solve it when it doesn't.
4. **`text-secondary`** — verify on `surface-elevated`, not just `background`. It commonly passes on the flat canvas and misses on a raised card.

Solve by stepping OKLab **lightness** while holding hue and the a/b axes, so the color stays recognisably itself.

Then run the contrast.md checklist:
- text-primary / text-secondary on background *and* on surface-elevated ≥ 4.5:1, both modes.
- every `on-fill` and `emphasis` against its own ground ≥ 4.5:1.
- `border-strong` and focus rings ≥ 3:1.
- brand/accent as text checked separately from brand/accent as fill.
- dark mode re-checked with **APCA**.

## 7. For data-viz palettes specifically

- **Categorical:** pick ≤ 8 hues that differ in **both** hue and lightness; verify they stay distinct in a CVD simulator. Cap at 8 — aggregate beyond that.
- **Sequential:** step lightness monotonically through one or two hues; keep it perceptually uniform (or just reuse Viridis/Blues/YlOrRd from palettes.md).
- **Diverging:** two hues that differ in hue *and* lightness, meeting at a **light neutral** midpoint. Use warm↔cool (blue/orange, teal/rose), never red↔green. 9–11 stops.

## Worked mini-example (the "Evergreen" logic)

1. Brand seed: emerald `#059669` → hold its hue.
2. Neutrals: true-neutral zinc (no blue tint) → differentiates it from cool-slate Graphite.
3. Primary scale: emerald held; solid `#059669`, hover `#047857`.
4. Accent: teal `#0d9488` (analogous). States nudged warm-neutral-compatible.
5. Split the brand: `#059669` carries a button label at 4.70:1, but as a link on white it reaches only 3.77:1 — so `as text` steps to `#00875b`. This is the one palette in the library where fill and text diverge.

## Worked mini-example (the "Driftwood" logic — generated, per-mode neutral)

1. Seed hues lifted from a popular Color Hunt palette; the palette itself maxes at 5.9:1 and cannot carry an interface.
2. Primary: marine, hue 228 @ peak chroma 0.130. Accent: clay, hue 38.
3. Neutrals **light**: warm sand, hue 64 @ 0.014 — the thing that makes it distinctive.
4. Neutrals **dark**: hue 224 @ 0.015, tinted toward the marine primary. The sand hue read as mud at low lightness.
5. Solve: light `fill` darkened from step 9 to clear 4.5:1 against white; `border-strong` stepped from 8 until it cleared 3:1.
6. Result: body text at 11.8:1 light / 13.6:1 dark, from a seed whose best internal pair was 5.9:1.
5. Dark mode: bg `#18181b`, surfaces lighter per tier, brand lifted to `#34d399`.
6. Verified: text-primary `#18181b` on `#fafafa` ≈ 16:1; `#34d399` used as fill, not body text.

→ Compare your result against the library in palettes.md; if it's too close to an existing one, change the neutral temperature or shift the brand hue.
