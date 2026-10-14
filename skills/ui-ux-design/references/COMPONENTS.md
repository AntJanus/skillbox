# Component contracts

Load when building or reviewing a specific interactive component, or the list, search, and selection surfaces around a collection. Each entry gives the base element, the ARIA that is actually required, the keyboard contract, and the focus rule — the four things that get invented at the keyboard when they aren't written down.

## Reach for the native element first

ARIA layered onto generic markup adds errors rather than removing them. Before any table below applies, check whether the platform already ships the behavior: `<details>` for a disclosure, `<dialog>` for a modal, `popover` for transient overlays, `<table>` for tabular data, `<button>` for anything that does something. The ARIA contracts below still hold where you build the component yourself; don't build it yourself where a native element covers it.

## The eight

| Component | Contract |
|---|---|
| **Tabs** | `role="tablist"` → `role="tab"` with `aria-selected` → `role="tabpanel"` with `aria-labelledby`. Arrow keys move between tabs; the selected tab is `tabindex="0"` and the rest `-1`; Tab moves into the panel, not along the tab strip. |
| **Disclosure** | `<h2><button aria-expanded="false">…</button></h2>` — the button nests *inside* the heading rather than replacing it — controlling a `hidden` region. `aria-expanded` is the only ARIA needed. Never rebuild with `role="button"`. Prefer `<details>`/`<summary>` unless you need the heading semantics. |
| **Notifications** | `role="status"` with `aria-live="polite"`. **Do not move focus** — "if there is nothing to be done with the tool, you don't put the tool in the person's hand." Focus moves only to dialogs containing actions. Put severity in the text (`Error:`), never in color alone. |
| **Data tables** | Real `<table>`, `<th scope="col">` and `<th scope="row">`. Sorting adds `aria-sort="ascending\|descending\|none"`. A scrollable table wraps in `role="group"` with `aria-labelledby` and `tabindex="0"` — the `tabindex` **only** when it actually overflows, or you add a pointless tab stop. Do not convert to an ARIA grid. |
| **Menu button** | `aria-haspopup="true"` + `aria-expanded` on the trigger; items `tabindex="-1"`. Enter/Space/↓ opens and focuses the first item; ↑↓ wrap; Escape closes and returns focus to the trigger; Tab exits rather than cycling. |
| **Toggle button** | `<button aria-pressed="true\|false">` — the value is explicit, never omitted to mean false. Focus ring via `box-shadow` rather than `outline` so the layout doesn't shift. State never carried by color alone. |
| **Tooltip vs toggletip** | Two components, not one. A **tooltip** labels an existing control, appears on hover *and* focus: `role="tooltip"` referenced by `aria-labelledby` (if it *is* the name) or `aria-describedby` (if it's supplementary). A **toggletip** *is* the control — an info button whose content lands in a `role="status"` live region, **not** `aria-describedby`. Neither contains interactive content. |
| **Cards** | Heading-wrapped link as the primary target: `<h2><a href="…">Title</a></h2>`. Reduce tab stops rather than nesting competing links. Style with `:focus-within` alongside `:focus`. A per-card control (pin, star, remove) is a `<button>` positioned as a sibling of the card's link, never nested in it. Reveal it on `:hover` and `:focus-within`, keep it visible while its state is on, and show it always under `@media (hover: none)`. Hover changes the card's border or background only, because a lift knocks one card out of line with its row. Key the control to the record's id, never its position in the list. |

**Site navigation is not an ARIA menu.** A `<nav>` containing a list of links outperforms `role="menu"`, which exists for application menus and brings a keyboard contract users don't expect on a website.

## List and search surfaces

Contracts for the surfaces that sit around a collection. These are behavior rules, not ARIA — most of them are what goes wrong once real data and real selection arrive.

| Component | Contract |
|---|---|
| **Row with a preview** | Two targets with two meanings: the item's **name links to its own page**; a separate labelled icon (an eye, "Preview") opens the in-place preview. Make the preview URL-driven so it can be linked and survives a reload. Never wrap a checkbox or a second control inside the row's link — the checkbox click navigates. |
| **Batch action bar** | Exists **only while something is selected** — no permanent toolbar of grayed buttons. States the count in words ("3 photos selected"). At most five actions; extras go in an overflow menu. Per-row controls switch off while the bar is up, so there is one live scope at a time. Cancel clears the selection and nothing else. Select-all is tri-state (`indeterminate` set in script). Clear the selection after an action runs. A field the selection disagrees about reads **Mixed**. |
| **Filter chips** | Every active filter renders as a removable chip, and the URL is the source of truth. Drive the URL grammar, the chips, the help text, and the query from one table, so a filter can't exist in one place and be missing from another. An unknown parameter or tab value falls back to the default **and says so**. |
| **Parsed search** | The box echoes how it read the query: each recognized qualifier (`status:open`) becomes its own removable chip, an exclusion says "not" in words rather than relying on a leading dash, and unrecognized text is shown as plain text rather than silently dropped. |
| **Command palette** | One binding opens three groups: commands, pages (with synonym keywords so "settings" finds "Preferences"), and entities. Entity search is debounced, each keystroke aborts the previous request, and a response for a query that is no longer current is dropped. End with a "See all results" row into the full search page. |
| **Long paths** | Truncate **from the left**, dropping whole segments — `…/invoices/2026/march.pdf`. The tail is what tells two paths apart, which is exactly what a CSS end-ellipsis throws away. |
| **Clipped scroll pane** | An inset shadow only on the edge that has more content behind it, recomputed on scroll and on content change, with a 1px tolerance so sub-pixel offsets don't flicker it. Reset `scrollTop` when the rows are replaced, or a shortened list opens scrolled past its only rows. |
| **Section rail** | Real links, with `aria-current` as the only active-state hook so the visual and announced state can't drift. Below its container-query width the rail wraps into a row and the accent moves from the left edge to the bottom edge, which is the tab form. Scroll tracking picks the topmost section in a reading band about 40% down, not the last heading crossed. Render no rail under about four sections. |
| **Markers on an image** | The marker layer spans the frame with `pointer-events: none`, and each marker takes `pointer-events: auto` back. The frame has an explicit `aspect-ratio`. Below the width where 44px markers fit, a container query swaps the layer for a list, hiding the other with `display: none`, never `aria-hidden` on focusable buttons. |
| **A select across kinds** | One `<select>` with an `optgroup` per kind and a value carrying kind and id, rather than a kind select feeding a second select. People think "Ada", not "a person, then Ada". Drop empty groups; split the value right before submit. |
| **Toggles that drive a list** | Filter tiles, slot pickers and segmented filters use `aria-pressed`, not tab roles: the list is a consequence of the press, and tabs promise arrow-key movement between panels that isn't there. Pressing the lit toggle again clears it. |

## Data display

Contracts for surfaces that show numbers. Each rule prevents a display that looks finished and misleads.

| Surface | Contract |
|---|---|
| **A figure people dispute** (a quote, a fee, a score) | Answer in the open. A native `<details>` below shows the formula once with live values substituted, then one row per term in computation order: the term, its value, and a sentence on what the term does, never the arithmetic restated. Recompute from the same inputs as the headline. Skip it for one visible step like price × quantity. |
| **A number that means nothing alone** | Place it on a track of reference points the reader already knows (course estimates, past projects, service tiers), scaled to the largest one. Past the end the bar stays full and the multiplier moves into the text: "3.4× past the long ending." Where the scale is a limit (a quota, a credit line), band the track into zones and draw usage over them. |
| **Work with several endings** (an import, a migration) | A bar partitioned by outcome (done, in flight, failed, skipped) that is always full: the composition changes, not the length. Each stage gets a glyph and a hue in the legend. The bar has one accessible sentence for the whole composition, and the total is printed beside it. |
| **A sequence as small marks** (series parts, turns in a thread) | One mark per item, each state encoded twice (fill plus border, size or opacity). A caption gives the position in words ("Part 3 of 4"). The legend is built from the same classes as the marks, or it drifts. |
| **A dense state grid** (chapters, days, seats) | One tab stop with a roving tabindex; arrows and Home/End move. Selecting a cell only selects it, and the write happens through an explicit button in a panel below, so a misclick can't rewrite progress. The initial selection is the next-up cell. |
| **A two-axis lookup table** | Sticky corner, column and row headers at three z-levels. Highlight the row and column with a negative-offset `outline`, never a border, which shifts neighbours in a collapsed table. Headers are buttons; `focusin` mirrors hover; a click pins the highlight, which is how it reaches touch. Every value gets a glyph as well as a fill. |
| **A dashboard card per source** | One shell owns the slots. It caps rows at three or four plus "and N more", names why a source is unavailable (not running, needs sign-in, didn't respond), pins the footer link with `margin-top: auto`, and lets the source's own color appear only in its mark. |

## Controls on a color you don't control

A tile wearing a brand color, a card tinted by data, a cover someone uploaded — the fill arrives from outside, so contrast has to hold across the whole range of colors that might land.

- **Nothing on the fill is translucent.** A translucent white plate inherits the fill's luminance; on a pale brand color its label drops to around 2:1. Opaque plates hold their ratio everywhere.
- **Darken the fill toward black as a gradient**, solving the strength per color until the title clears its ratio, with a floor so the brand isn't crushed. A fixed 90% darkening only works on colors that were already dark.
- **Two-tone focus ring** — a dark inner ring against the control, a white outer halo against the fill. One color vanishes at one end of the range.
- **Text over artwork nobody reviewed** sits on a scrim whose alpha is a written-down number, so it can be composited against the worst-case image and checked. Text whose ink is a theme token gets a scrim of the page's own background at high alpha; fixed white ink gets a fixed black scrim held flat under every line. Never `text-shadow` as the substitute — its effect depends on the exact pixels underneath.
- **Measure the composite**, not the color picker — the ratio someone reads is label against plate-over-fill.
- **Let the outside color appear in as few places as possible.** A card that tints its border, text, and controls from one unknown hex has four chances to fail instead of one.

**Text over images, in any style.** Choose the simplest surface that works. A solid band beneath the image or an opaque plate avoids all of what follows, and is often the better choice. Translucent panels (glass, frosted cards, tinted overlays) are one style among many. When a design uses one:

- **Blur is not contrast.** `backdrop-filter: blur()` removes detail, but a bright region is just as bright after blurring. Compute contrast from the panel's alpha alone, as if the image were a flat color at its worst luminance.
- **Set the alpha floor by measuring the harder theme over the worst-case image.** The dark scheme over bright art is usually the binding case, and it needs a higher alpha than it looks like it should.
- **Secondary text fails first.** Dimmed ink rarely clears 4.5:1 over an image at any usable alpha. Inside a translucent panel, use full ink and build hierarchy from size and weight.
- **Stacked translucent layers multiply.** The image reaching a glyph is (1 − panel alpha) × (1 − scrim alpha), so solve the two together.
- **Size the scrim to the text.** One short label needs only a pill: black at about 0.82 with white text holds contrast even over a white image. Text on a raw image with no surface at all gets an SVG text stroke in the background token with `paint-order: stroke fill`, an opaque halo that doesn't depend on the pixels underneath.

## Labeling, in order of preference

1. **Native HTML** — a real `<label>`, real text inside the button.
2. **`aria-labelledby`** pointing at visible text on the page.
3. **Hidden-but-present text** in the DOM.
4. **`aria-label`** — last resort. It blocks machine translation, breaks voice control ("click *the words I can see*"), and is skipped by reader modes.

Two hard stops:

- **Never `aria-label` on a link.** Text-to-speech ignores it, it blocks auto-translation, and it fails WCAG 2.5.3 Label in Name.
- **Never `aria-description` for content.** Firefox is the only browser that sometimes surfaces it.

## Focus management in dialogs

Where focus lands depends on the dialog, and a single rule gets it wrong somewhere:

- Short or simple dialog → the close button.
- Complex or interactive dialog → the dialog itself or its heading, so the user can orient before acting.
- A form → the first field, but only when the user deliberately opened it and the form is short.

## Anti-patterns

- ❌ `role="menu"` on site navigation
  ✅ `<nav>` with a list of links
- ❌ Moving focus to a toast so it gets announced
  ✅ `role="status"` with `aria-live="polite"`, focus untouched
- ❌ `aria-describedby` wiring an info button to its own content
  ✅ A toggletip: button plus a `role="status"` region that fills on click
- ❌ `aria-pressed` omitted to mean "not pressed"
  ✅ `aria-pressed="false"` explicitly
- ❌ `tabindex="0"` on every scroll container
  ✅ Add it only when `scrollWidth > clientWidth`
- ❌ `aria-label` to relabel a link's visible text
  ✅ Change the visible text; it fails WCAG 2.5.3 otherwise
- ❌ A row whose name opens a preview and whose checkbox sits inside the link
  ✅ The name links to the item's page, a labelled icon opens the preview, the checkbox sits outside both
- ❌ A batch toolbar always on screen with every button grayed out
  ✅ A bar that appears with the selection and says "3 selected"
- ❌ `text-overflow: ellipsis` on a file path
  ✅ Drop leading segments so the filename survives
- ❌ A `title` attribute as the tooltip
  ✅ A real tooltip element — `title` is unreachable by keyboard and touch
- ❌ A `<div role="button">` pin inside the card's link
  ✅ A real button beside the link in a positioned wrapper

## Gotchas

- **Symptom:** Screen-reader users report a tab strip they can't get out of. **Cause:** All tabs left at `tabindex="0"`, so Tab walks the strip instead of entering the panel. **Fix:** Roving tabindex — one `0`, the rest `-1`.
- **Symptom:** A voice-control user can't activate a button whose label they can read aloud. **Cause:** `aria-label` overrode the visible text. **Fix:** Remove it; make the visible text the accessible name.
- **Symptom:** A toast is never announced. **Cause:** The live region was added to the DOM at the same moment as its content. **Fix:** The `role="status"` container must already exist; insert only the message into it.
- **Symptom:** Layout jumps a pixel when a toggle receives focus. **Cause:** `outline` participates in layout in that context. **Fix:** `box-shadow` for the ring.
- **Symptom:** An accessibility audit worsens after adding ARIA to a table. **Cause:** A working `<table>` was converted to an ARIA grid. **Fix:** Revert to semantic table markup; add `aria-sort` only for sorting.
- **Symptom:** A translated page leaves some controls in English. **Cause:** Those names came from `aria-label`, which translation services don't process. **Fix:** Move the name into visible text or `aria-labelledby`.
- **Symptom:** The command palette shows results for something the user already stopped typing. **Cause:** A slow response for an earlier query landed after a faster one for the current query. **Fix:** Abort the previous request on each keystroke, and drop any response whose query isn't the current one.
- **Symptom:** A shared link applies a filter the screen doesn't show, and the user can't clear it. **Cause:** The URL accepts a parameter the chip row doesn't render. **Fix:** Drive URL parsing and chip rendering from the same table.
- **Symptom:** Clicks on captions and links under an image overlay do nothing, yet the test passes. **Cause:** A full-frame layer catches every click, and `element.click()` skips hit-testing. **Fix:** `pointer-events: none` on the layer, and test with `document.elementFromPoint` at the coordinate.
- **Symptom:** A dashboard's cards vary wildly in height, many of them mostly padding. **Cause:** Each source decided how many rows to return. **Fix:** The shell caps the rows.
