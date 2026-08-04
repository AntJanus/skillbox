# Layout

Load when setting up a grid, deciding responsive behavior, or building a page whose structure is a known recipe.

## Grid

- **Pick a base unit of 8px and express it in rem** (`0.5rem`), with 4px available for fine adjustment. Every size, gap, and padding is a multiple. Pixel-locked spacing breaks when a user zooms.
- **Soft grids over hard grids.** A hard grid snaps everything to baseline rows and columns; it's expensive to hold across device sizes and largely obsolete for screens. A consistent base unit, loosely held, is the digital default. Pixel perfection is not the goal.
- **Columns: 2–12, and three is the sweet spot** for content laid side by side. The 12-column reflex is a container for column *spans*, not a mandate to use twelve visible tracks.
- **Gutter width is a grouping signal.** Two cards a half-gutter apart read as one unit; that's Gestalt proximity doing the work, so set gutters deliberately.
- **Margins: small and fixed on mobile** so content never touches the edge; **liquid on desktop** so text doesn't stretch across an ultrawide display. This is the actual reason behind `max-width` on a prose container — measure, not aesthetics.

Grid shapes worth knowing by name: **manuscript** (one wide column — articles and long-form; needs whitespace, dividers, and subheads or it reads as a wall), **column**, **modular** (columns and rows — galleries, product grids), **baseline** (couples text size, line-height, margin, and padding into one rhythm), **hierarchical** (modules sized by importance; the most flexible under responsive reflow).

## Responsive

Mobile-first. Start at the smallest viewport and add complexity as space appears — the reverse order produces desktop layouts with things awkwardly removed.

```css
/* Let the grid decide the count rather than hard-coding one per breakpoint */
.cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(16rem, 1fr)); gap: 1rem; }

/* Fluid type with a floor and a ceiling */
h1 { font-size: clamp(1.75rem, 5vw, 3rem); }

img, video { max-width: 100%; height: auto; }
```

- Prefer intrinsic sizing (`auto-fit`, `minmax`, `clamp`) over a ladder of breakpoints. Add a breakpoint when the layout actually breaks, not at a number someone published.
- **Navigation simplifies as the viewport shrinks** — a full menu becomes a hamburger, an accordion, or tabs. Collapse or hide secondary navigation before it compromises the primary content.
- Test at 200% zoom, not just at narrow widths. They fail differently.
- Hover-triggered tooltips need a tap-triggered equivalent, or the content is unreachable on touch.

## Where the eye goes

- **Z-pattern** for sparse pages — top-left, across, diagonal down, across again. Nav and logo top-left, primary action bottom-right of the fold.
- **F-pattern** for text-dense pages — a horizontal scan of the top, then a shorter one, then a descent down the left edge. Front-load the meaningful words in headings and list items.
- **Layer cake** for well-structured pages — headings and subheads scanned first, body only where a heading earns it. This is the one to design *for*: it means headings must carry the claim, not label the topic.
- Attention gravitates to the upper left first. Navigation, brand, and search belong there.

## Whitespace

Load-bearing, not leftover. It groups (proximity), it emphasizes (an isolated element reads as important), and it's the fix for both a cluttered layout and a monotonous single-column one. When a page feels wrong and nothing is obviously broken, the answer is usually spacing.

## Page recipes

**Landing page.** Above the fold: headline, hero visual, value proposition, primary CTA. **Remove or minimize top-level navigation** — the page has one job and links are exits. Apply hierarchy in the order size → color → spacing → weight, so the most important element is unambiguously the most dominant. CTA in a contrasting color with an action verb. Trust signals: security badges, testimonials, ratings, logos, a privacy link. **Message match** — the copy must echo the ad or link that delivered the visitor.

**Pricing page.** Three or four tiers: fewer fails to serve distinct segments, more triggers analysis paralysis. **4–6 features per tier**, each tied to a use case, using "Everything in [previous tier], plus…" instead of repeating. Order low to high commitment. Badge the middle tier in a contrasting color — that's the decoy effect, and it works. CTA copy follows intent: "start for free" for a trial, "get started" for a paid plan, "talk to sales" at the top tier; one per tier, visible on load, repeated near the comparison table, plus a sticky one. Billing toggle up top, showing the annual saving and stating which plans it applies to. Whole numbers with the unit adjacent ("per user / month"). Benefit language, not spec language — "manages 10,000 customers", not "10 GB storage". Close with **five FAQ entries, answers of one to three sentences**, covering cancellation, plan changes, trials, hidden fees, and data security. On mobile: cards stack, the comparison table becomes an accordion, the CTA sticks to the bottom.

**Portfolio or case-study page.** Hero (who, what, a preview) → work gallery → case studies → about → contact, with contact also persistently reachable. Each case study carries the role and objective, the process and its iterations, **quantified impact**, a visual walkthrough, and credit to collaborators. Curate; don't exhaust.

## Performance is a UX property

- People form an opinion of a page in about **50 milliseconds**, and a one-second load converts roughly 2.5× better than a five-second one.
- Median mobile page weight has roughly tripled in a decade, and under half of mobile sites hit "good" Core Web Vitals. Don't assume the baseline you're comparing against is good.
- Compress and correctly format images, minify, and make server-versus-client rendering a deliberate decision rather than a framework default.
- Skeletons and spinners are a treatment for latency, not a substitute for removing it.
