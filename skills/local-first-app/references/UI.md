# UI, color/theme, data-viz & explainability — deep reference

Load when building the chart color system, charts and tables, bulk selection, or the show-your-work surfaces. Pairs with **color-system** and **typography** for the actual palette and type values. Shell, theming mechanism and type scale live in **[CHROME.md](./CHROME.md)**.

## Color & theme system

Centralize all data-viz color in one module (`lib/colors.ts`); restyle there, never hard-code chart colors in components.

- A typed `Palette` names colors by **semantic role** (`seriesA`, `gain`, `loss`, `axisText`), not by hue.
- **Light + dark variants** of every palette; dark variants are _lightened_ so each hue clears the dark surface.
- **Colorblind-aware** (Okabe-Ito / Wong basis): co-occurring series use well-separated hues, and the primary opposed pair rides on **blue-vs-orange (warm/cool), never red-vs-green**. Every signed figure also carries a `+/−` or ▲/▼ glyph so color is never the only signal. Cap a categorical set at ~8 hues; aggregate the rest into "Other".
- Secondary series use the **lightened sibling** of their nominal hue — same family, distinct luminance, still grayscale-separable.
- **Each named theme carries its own chart `Palette`** alongside its brand scale and dark neutral tuple. `gain`/`loss` stay semantically green/red across every theme.
- **Per-entity brand theming** (categories, collections, tags): an explicit brand key + auto-detection from the entity name + a neutral fallback. Keep a separate chart-legible color for any brand whose face color would vanish on a chart.

## Data-viz & tables

Where most rework happens. Defaults to get right the first time:

- **Never plot different-unit quantities on the same axis.** A running total next to a per-day figure misleads — the big bar looks scarier than it is. Compare like-for-like, or use clearly-scaled separate views.
- **Show the actual value at the end of each bar.** Don't make the user read it off an axis.
- **Every chart gets a bar/line toggle**, plus scale-grouped views (Totals / Monthly / Over time) via a segmented control.
- **Line charts must not force a 0 baseline** — auto-fit the y-domain so trends are visible. Broken hover is a bug, not a detail.
- **One table with column-toggle pills, not many split tables.** When tempted to split (per-period vs cumulative, raw vs adjusted), build a single grouped-columns table whose pills — owned by the parent — drive which column groups _and_ which chart series show together. Always include the diff/delta column for paired figures.
- **No-decimal axis ticks** where the precision isn't meaningful; high-contrast chart labels; tabular numerals for figure columns.

## Explainability

Applies when the app derives non-obvious numbers. A pure CRUD tracker skips all of it.

- **Show the math.** Render each formula once at the top of its section in **KaTeX**, with values plugged in and the symbolic form, plus a toggle to the **JavaScript form**. Below it, a collapsible per-step breakdown.
- **A collapsible "underlying math" section under dashboard stats**, so any headline number traces to its inputs.
- **Ship a `/docs` area only when the app has a concept a new user would get wrong** — a term the UI uses in a specific sense ("missing" vs "deleted", "stale", "root"), or a rule the user must model to trust the output. Where it earns its place, explain that concept with **Mermaid** (lazy client-only `import('mermaid')`, themed to the active scheme, surfacing parse errors instead of failing silently). A plain media library has no such concept and produces a stub nobody reads.
- **When numbers can be raw or adjusted** (corrections, normalization over time), show both with a clear delta — raw is easier to grasp, adjusted is the truth.

## Legibility

- **Set the floor at the theme/globals level, not per component:** body ≥16px, weight ≥400, contrast ≥4.5:1, line-height ≥1.5. Cards, tables and panels need a **surface background distinct from the canvas**; flat same-color containers read as illegible.
- **Two of the four floor values are invisible in source, so reading the theme can never verify them.** Size and weight are greppable tokens. Line-height resolves against the _computed_ font-size, and contrast depends on the _painted_ background — the nearest non-transparent ancestor, composited through alpha — neither of which exists until a page renders. An app can override every token exactly as instructed and still ship a wordmark at 1.00:1. The theme is necessary and insufficient; the **legibility gate** in SKILL.md is what makes the floor real.
- **The theme's `md` being safe doesn't mean the app is safe.** `Table` cells, `NavLink` label, `Tooltip`, `Menu` item, `Alert`, `Notification`, `Tabs` tab and `Input` label/description all read the `sm` (14px) or `xs` (12px) token internally, with no prop to grep for. Override the _entire_ `fontSizes` scale, and note that overriding all five tokens still fails if `xs` lands at 14px — the floor is the rule. CHROME.md ships a known-good scale plus the `Badge` workarounds the scale alone doesn't reach.
- **Line length is part of legibility.** Cap running text near 65–85 characters; a prose column inheriting the dashboard shell's full width lands past 100 and reads badly at any contrast ratio. The same text-node walk measures it.
- **Anything whose whole job is to look different must be measurably different.** Theme swatches, status dots and category chips need a real perceptual gap. A picker whose swatches sit within 1.00:1–1.10:1 renders as identical squares while the theme system underneath is perfectly correct — the control is useless while nothing about the theming is wrong. Assert the gap.
- **A `next/font` variable scoped to `<body>` breaks Mantine's `:root`-scoped font-family.** Mantine injects `:root, :host { --mantine-font-family: var(--font-body) }`. Apply the `.variable` class to `<body>` and `--font-body` doesn't exist at `:root` — custom properties never inherit upward — so the reference is invalid and every Mantine element falls back to the browser's default serif, with the source looking correct. Verify with `getComputedStyle(document.body).fontFamily` on a live page. Fix by moving the class to `<html>`, or inject the resolved `font.style.fontFamily` string ([help.mantine.dev/q/next-load-fonts](https://help.mantine.dev/q/next-load-fonts)).

**Provider stack** (root layout, inside `<MantineProvider>`): `<Notifications>`, and nothing else. No `<ModalsProvider>` — the single delete-confirm is hand-rolled.

**Images:** generative fallback avatars (hash the id/name → deterministic identicon) for entities with no image. Uploads go client-side canvas downscale → WebP data URI, and any image-fetch route is SSRF/size/type-guarded.

## Bulk selection & the batch-edit overlay

Editing many rows at once. **Build it when repeated single-row editing actually bites**; shipping without it is a scheduling decision. It is a **mode**, not a route — nothing about it goes in the URL.

**Four rules keep it safe.**

1. **Sparse patch.** The write carries only the fields actually touched. An **absent key means "leave it alone"; an explicit `null` means "clear it"** — different writes. A status batch that silently wipes everyone's rating is this feature's worst failure mode. Enforce it at the zod boundary (`.optional()` and `.nullable()` are not the same thing) and make the patch schema **`.strict()`**, so a renamed field errors instead of being stripped into a successful no-op.
2. **All-or-nothing.** Check every id is valid _before_ writing any, then write in one transaction. A selection goes stale easily, and half-applying a batch is worse than failing it.
3. **Selection prunes to what's visible.** Filtering a selected row off screen must drop it, or the bar reads "3 selected" while the write hits a fourth row the user can no longer see. Pure: `retainSelected(selectedIds, visibleIds)` — and it must return the **same array reference** when nothing was pruned, or the effect syncing it re-fires forever.
4. **A field is `uniform` or `mixed`** across the selection; a control can only show a value when every selected row agrees. A _shared absent_ value (two unrated items) is `uniform: null`, not `mixed` — they agree that they're unrated, and "Mixed" would imply there's something to preserve. Summarize per field independently.

**Chrome takeover.** A non-empty selection replaces the sidebar nav with a batch bar in the same slot: `N selected` + ✕ on top, one control per batchable field below. Reusing the nav slot rather than floating a bar over the content keeps the list visible while you refine the selection, which is the point of the mode. Two consequences:

- **A collapsed icon-rail can't hold the controls** — force the shell to full width while a selection lasts.
- **On mobile the sidebar is a closed drawer**, so the bar is invisible after selecting a row. Put an "N selected" button in the header (mobile-only) that opens the drawer, or the mode is unreachable on small screens.

**Where the state lives.** The bar renders into the chrome; the checkboxes render inside the page. They're siblings, so selection state hoists into a context provider **above the app shell**. The page registers its currently-visible rows with the provider, which needs them to compute each control's value. Key registration and selection by pathname and derive liveness from the current path — do **not** clear on navigation in an effect, since child effects run first and you'd wipe the registration the page just made.

**Anatomy of the write.** One action taking `(ids, sparsePatch)`. Reuse the _single-item_ setters inside the transaction rather than bespoke bulk SQL, so batch and per-item edits can't drift apart (a status setter that stamps `completed_at` keeps doing so in a batch). Return a count and toast it (`Updated 7 items.`), and keep the selection alive after a successful write — setting a status and then a rating over the same rows is the common case.

**Table extras.** A header checkbox selecting/clearing **all visible rows** (indeterminate when partial). "All" always means post-filter, never the unfiltered set.

## Importing external design mocks

Port the visual design while preserving the existing data, intent, and calculations. The math and derivations are sacred; the skin is not. Adopt spacing, color, type and layout, and keep every computed figure and its meaning.
