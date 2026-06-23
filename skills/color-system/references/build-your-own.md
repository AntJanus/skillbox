# Build your own palette — step by step

Use this when no library palette fits and you need a new one. Work in OKLCH throughout (see theory.md for why).

## 1. Pick the brand/seed hue

Choose one anchor color that carries the brand. Convert it to OKLCH at [oklch.com](https://oklch.com). Note its hue (H) — you'll hold it constant for the neutral and primary scales.

Decide the **temperature of your neutrals**:
- Cool neutrals (slate, blue-gray) → professional, techy (e.g. Graphite).
- True neutral (zinc/gray) → versatile, lets the brand lead (e.g. Evergreen).
- Warm neutrals (stone, clay) → editorial, cozy (e.g. Terracotta).

Two palettes that share a brand hue but differ in neutral temperature read as distinct — use this to differentiate a family.

## 2. Generate the neutral scale (12 steps)

This is most of your UI. Hold a low-chroma version of a hue (often a hint of the brand hue for cohesion):

1. 12 stops, lightness ≈ 98% → 12% in even OKLCH steps.
2. Keep chroma very low (≈ 0.01–0.03); a whisper of the brand hue beats pure gray.
3. Map to roles: 1 background · 2 subtle bg · 3–5 surfaces/hover/active · 6–8 borders · 11 muted text · 12 primary text. (Radix step map in theory.md.)

## 3. Generate the brand/primary scale

Same 12-step process at full chroma, hue held. The **solid step** (≈ L 55–60%) is your `primary`; the step above it is `primary-hover`; a darker step (~L 45%) is your accessible `primary` *text* color when needed.

## 4. Add accent + semantic states

- **Accent:** a second hue, typically analogous (+30°) or split-complementary, used at ~10% (the "10" in 60-30-10).
- **Success / warning / error / info:** start from green / amber / red / blue, then nudge each toward your brand's chroma and temperature so they feel part of the set (not stock Bootstrap colors). Give each a low-sat **container** tint + a high-contrast **on-** foreground.

## 5. Derive the dark mode (do NOT just invert)

For each role:
- `background`: a dark near-neutral, **not** `#000` (≈ `#0d1117`–`#1e1e2e`).
- `surface` / `surface-elevated`: each tier **lighter** than the last (elevation = lighter).
- `text-primary`: off-white (`#e0e0e0`–`#f5f5f5`), not pure `#fff`.
- `primary` / `accent` / states: lift one or two steps brighter than light mode (saturated mid-tones go muddy on dark).

## 6. Verify accessibility (gate before shipping)

Run the contrast.md checklist:
- text-primary / text-secondary on background ≥ 4.5:1, both modes.
- borders + focus rings ≥ 3:1.
- brand/accent as text checked (use as a fill if it fails).
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
5. Dark mode: bg `#18181b`, surfaces lighter per tier, brand lifted to `#34d399`.
6. Verified: text-primary `#18181b` on `#fafafa` ≈ 16:1; `#34d399` used as fill, not body text.

→ Compare your result against the library in palettes.md; if it's too close to an existing one, change the neutral temperature or shift the brand hue.
