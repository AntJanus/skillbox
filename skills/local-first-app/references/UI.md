# UI, color/theme, data-viz & explainability — deep reference

Load when building the chart color system, theming, charts/tables, or the show-your-work surfaces. Pairs with the **color-system** and **typography** skills (use them for the actual palette/type decisions).

## Color & theme system

Centralize ALL data-viz color in one module (e.g. `lib/colors.ts`); restyle there, never hard-code chart colors in components.

- A typed `Palette` interface names colors by **semantic role** (e.g. `seriesA`, `seriesB`, `gain`, `loss`, `axisText`), not by hue.
- **Light + dark variants** of every palette; dark variants are *lightened* so each hue clears the dark surface.
- **Colorblind-aware (Okabe-Ito / Wong "Color Universal Design" basis):** co-occurring series use well-separated hues; the primary opposed pair rides on **blue-vs-orange (warm/cool), never red-vs-green**. Every signed figure ALSO carries a `+/−` (or ▲/▼) glyph so color is never the only signal. Cap a categorical set at ~8 hues; aggregate the rest into "Other".
- "Real"/secondary series use the **lightened sibling** of their nominal hue (same family, distinct luminance, still grayscale-separable).
- **Multiple selectable themes** (4–7 per app): each theme = a shared `base` (fonts, type scale, radius, surfaces) + its own brand color scale + dark neutral tuple + a chart `Palette`. Both the selected theme and the color scheme are **read on the server** from the settings table and rendered into the initial HTML, so a `useColors()` hook reads the framework's **computed** color scheme with no after-mount resolution and no hydration mismatch to design around — see CHROME.md. `gain`/`loss` stay semantically green/red across every theme.
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

- One app-shell `'use client'` chrome wraps every route: header + a collapsible **icon-rail sidebar** with real router links, active state via current path, mobile burger drawer. **Dashboard layout, never single-column.** Full recipe (dimensions, collapse persistence, logo, icons): **[CHROME.md](./CHROME.md)**.
- **Provider stack** (root layout, inside `<MantineProvider>`): `<Notifications>`. That's it — no `<ModalsProvider>`, because the single delete-confirm is a hand-rolled controlled `<Modal>` (`<ConfirmDeleteButton>`, see CHROME.md) rather than `openConfirmModal`. That modal is the only one sanctioned; all data entry stays on its own screen.
- **Theme and color scheme both persist server-side** in the settings table and render into `<html data-theme>` + `forceColorScheme` — no pre-paint script, no flash, no hydration mismatch. See CHROME.md.
- **Legibility is a recurring failure mode — set the floor at the theme/globals level, not per component.** Body text ≥16px (no stray 13px shrink variables), weight ≥400, contrast ≥4.5:1, line-height ≥1.5. Cards/tables/panels need a **surface background distinct from the canvas** (an elevated surface) for contrast — flat same-color containers read as illegible. Re-check dark mode with APCA.
- **The theme's `md` (16px) being safe doesn't mean the app is safe.** Several Mantine components default *below* their own base regardless of any `size` prop the app author writes: `Table` cells, `NavLink` label, `Tooltip`, `Menu` item, `Alert`, `Notification`, `Tabs` tab, and `Input` label/description all ship at the `sm` (14px) or `xs` (12px) token internally. There is no prop to grep for — override the *entire* `fontSizes` scale explicitly in the shared theme (don't leave `xs`/`sm` at Mantine's 12px/14px defaults) and spot-check the computed size of components you never explicitly sized. **"Override it explicitly" is not enough on its own:** an app can override all five tokens and still land `xs` at 14px, under the floor. The floor is the rule — smallest token ≥1rem, line-height ≥1.5 — and **[CHROME.md](./CHROME.md)** ships a known-good scale plus the `Badge --badge-fz` and `textTransform` workarounds that the scale alone doesn't reach.
- **A `next/font` variable scoped to `<body>` breaks Mantine's `:root`-scoped font-family.** Mantine injects `:root, :host { --mantine-font-family: var(--font-body) } ` when the theme sets `fontFamily: 'var(--font-body)'`. If `app/layout.tsx` applies the font's `.variable` class name to `<body>` (rather than `<html>`), `--font-body` doesn't exist at `:root` — custom properties never inherit upward — so the reference is guaranteed-invalid and every Mantine-styled element falls back to the browser's default serif, with the source looking entirely correct. Verify with `getComputedStyle(document.body).fontFamily` on a live page, not by reading the theme file. Fix: move the `.variable` class to `<html>`, or use Mantine's own documented pattern (inject the resolved `font.style.fontFamily` string instead of a CSS variable — [help.mantine.dev/q/next-load-fonts](https://help.mantine.dev/q/next-load-fonts)).
- **Generative fallback avatars** (hash the id/name → deterministic identicon) for entities with no image; make the entity name editable.
- Image uploads: client-side canvas downscale → WebP data URI. Any product/image fetch route must be SSRF/size/type-guarded.

## Bulk selection & the batch-edit overlay

The pattern for editing many rows at once (see SKILL.md for the rules; this is the anatomy). It is a **mode**, not a route — nothing about it goes in the URL.

**Chrome takeover.** A non-empty selection replaces the sidebar nav with a batch bar in the same slot: `N selected` + ✕ on top, one control per batchable field below. Reusing the nav slot (rather than floating a bar over the content) keeps the list fully visible while you refine the selection, which is the whole point of the mode. Two things fall out of it that are easy to miss:
- **A collapsed icon-rail sidebar can't hold the controls** — force the shell back to full width for as long as a selection lasts.
- **On mobile the sidebar is a closed drawer**, so the bar is invisible after selecting a row. Put an "N selected" button in the header (mobile-only) that opens the drawer, or the mode is unreachable on small screens.

**Where the state lives.** The bar renders into the chrome; the checkboxes render inside the page. They are siblings, so selection state hoists into a context provider **above the app shell**. The page registers its currently-visible rows with the provider (the bar has no other way to see them, and it needs them to compute each control's value). Key both the registration and the selection by pathname, and derive liveness from the current path — do **not** clear on navigation in an effect (child effects run first; you'd wipe the registration the page just made).

**Control state is three-valued, not two.** Each field across the selection is `uniform` (every row agrees — show the value) or `mixed` (show a "Mixed" placeholder and no value). A *shared absent* value — two unrated items — is `uniform: null`, not `mixed`: they agree that they're unrated, and rendering "Mixed" would imply there's something to preserve. Summarize per field independently; one mixed field must not drag the others into "mixed".

**Anatomy of the write.** One action taking `(ids, sparsePatch)`. Absent key = untouched, explicit `null` = cleared. Reuse the *single-item* setters inside the transaction rather than writing bespoke bulk SQL, so batch and per-item edits can't drift apart (a status setter that stamps `completed_at` keeps doing so in a batch). Return a count and toast it (`Updated 7 items.`); keep the selection alive after a successful write — setting a status and then a rating over the same rows is the common case.

**Table extras.** A header checkbox that selects/clears **all visible rows** (indeterminate when partial). "All" always means post-filter — never the unfiltered set.

## Importing external design mocks

When given design mocks or screenshots (e.g. from a design tool), **port the visual design while preserving the existing data, intent, and calculations** — the math/derivations are sacred, the skin is not. Adopt spacing, color, type, and layout; keep every computed figure and its meaning.
