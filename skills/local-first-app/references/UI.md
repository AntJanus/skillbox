# UI, color/theme, data-viz & explainability — deep reference

Load when building the chart color system, theming, charts/tables, or the show-your-work surfaces. Pairs with the **color-system** and **typography** skills (use them for the actual palette/type decisions).

## Color & theme system

Centralize ALL data-viz color in one module (e.g. `lib/colors.ts`); restyle there, never hard-code chart colors in components.

- A typed `Palette` interface names colors by **semantic role** (e.g. `seriesA`, `seriesB`, `gain`, `loss`, `axisText`), not by hue.
- **Light + dark variants** of every palette; dark variants are *lightened* so each hue clears the dark surface.
- **Colorblind-aware (Okabe-Ito / Wong "Color Universal Design" basis):** co-occurring series use well-separated hues; the primary opposed pair rides on **blue-vs-orange (warm/cool), never red-vs-green**. Every signed figure ALSO carries a `+/−` (or ▲/▼) glyph so color is never the only signal. Cap a categorical set at ~8 hues; aggregate the rest into "Other".
- "Real"/secondary series use the **lightened sibling** of their nominal hue (same family, distinct luminance, still grayscale-separable).
- **Multiple selectable themes**: each theme = a shared `base` (fonts, type scale, radius, surfaces) + its own brand color scale + dark neutral tuple + a chart `Palette`. A `useColors()` hook follows the framework's **computed** color scheme (not OS `prefers-color-scheme`) and the selected theme, resolving after mount to avoid hydration mismatch. `gain`/`loss` stay semantically green/red across every theme.
- **Per-entity brand theming** (e.g. categories, collections, tags): support an explicit brand key + **auto-detection from the entity name** + a neutral fallback, and keep a separate chart-legible color for any brand whose face color would vanish on a chart.

## Data-viz & tables (where most rework happens — defaults to get right the first time)

- **Never plot different-unit quantities on the same axis.** A running total (over months) next to a per-day figure on one chart misleads — the big bar looks scarier than it is. Compare like-for-like, or use the same scale / clearly-scaled separate views.
- **Show the actual value at the end of each bar** (data labels). Don't make the user read it off an axis.
- **Every chart gets a bar/line toggle**, plus scale-grouped views (e.g. Totals / Monthly / Over time) via a segmented control.
- **Line charts must not force a 0 baseline** — auto-fit the y-domain so trends are visible.
- **Tooltips/hover must work** — broken hover is a bug, not a detail.
- **One table with column-toggle pills, not many split tables.** When tempted to split (per-period vs cumulative, raw vs adjusted), build a single grouped-columns table whose pills (owned by the parent) drive which column groups AND which chart series show together. Always include the diff/delta column for paired figures.
- **No-decimal axis ticks where the extra precision isn't meaningful; high-contrast chart labels.** Tabular numerals for figure columns.

## Explainability (first-class when the app computes)

Applies when the app derives non-obvious numbers (projection or estimate tools). A pure CRUD tracker with no computed figures skips the formula surfaces below — but still ships the in-app `/docs` concept area. When there *are* computed numbers, the product is trusted only if the user can audit them:

- **Show the math.** Render each formula **once** at the top of its section in **KaTeX**, with values plugged in AND the pure symbolic form, plus a toggle to its **JavaScript form** for programmers. Below it, a collapsible per-step breakdown.
- Put a **collapsible "underlying math" section under dashboard stats** so any headline number can be traced to its inputs.
- Ship an in-app **`/docs` area** explaining the core concept with **Mermaid** diagrams (lazy client-only `import('mermaid')`, themed to the active scheme, surfacing parse errors instead of failing silently). Keep README + project docs in sync with it.
- When numbers can be raw or adjusted (corrections, normalization over time), **show both** — raw is easier to grasp, adjusted is the truth; carry both through tables and charts with a clear delta.

## Layout & legibility

- One app-shell `'use client'` chrome wraps every route: header + a collapsible **icon-rail sidebar** with real router links, active state via current path, mobile burger drawer. **Dashboard layout, never single-column.**
- **Provider stack** (root layout, inside `<MantineProvider>`): include `<ModalsProvider>` (`@mantine/modals`) and `<Notifications>` — the delete-confirm flow (`openConfirmModal`) throws without `<ModalsProvider>` mounted. This is the only place a modal is sanctioned; all data entry stays on its own screen.
- **Legibility is a recurring failure mode — set the floor at the theme/globals level, not per component.** Body text ≥16px (no stray 13px shrink variables), weight ≥400, contrast ≥4.5:1, line-height ≥1.5. Cards/tables/panels need a **surface background distinct from the canvas** (an elevated surface) for contrast — flat same-color containers read as illegible. Re-check dark mode with APCA.
- **Generative fallback avatars** (hash the id/name → deterministic identicon) for entities with no image; make the entity name editable.
- Image uploads: client-side canvas downscale → WebP data URI. Any product/image fetch route must be SSRF/size/type-guarded.

## Importing external design mocks

When given design mocks or screenshots (e.g. from a design tool), **port the visual design while preserving the existing data, intent, and calculations** — the math/derivations are sacred, the skin is not. Adopt spacing, color, type, and layout; keep every computed figure and its meaning.
