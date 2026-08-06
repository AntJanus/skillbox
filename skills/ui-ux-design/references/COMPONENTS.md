# Component contracts

Load when building or reviewing a specific interactive component. Each entry gives the base element, the ARIA that is actually required, the keyboard contract, and the focus rule — the four things that get invented at the keyboard when they aren't written down.

Source: Heydon Pickering's Inclusive Components (https://inclusive-components.design/) and Adrian Roselli (https://adrianroselli.com/). Where they predate a native element that now exists, the note says so.

## Reach for the native element first

Pages using ARIA average twice as many accessibility errors as pages without it. Before any table below applies, check whether the platform already ships the behavior: `<details>` for a disclosure, `<dialog>` for a modal, `popover` for transient overlays, `<table>` for tabular data, `<button>` for anything that does something. Pickering's articles predate `<dialog>` (2022) and `popover` (2024) — his ARIA contracts still hold, but his "build it yourself" framing is dated wherever a native element now covers it.

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
| **Cards** | Heading-wrapped link as the primary target: `<h2><a href="…">Title</a></h2>`. Reduce tab stops rather than nesting competing links. Style with `:focus-within` alongside `:focus`. |

**Site navigation is not an ARIA menu.** A `<nav>` containing a list of links outperforms `role="menu"`, which exists for application menus and brings a keyboard contract users don't expect on a website.

## Labeling, in order of preference

1. **Native HTML** — a real `<label>`, real text inside the button.
2. **`aria-labelledby`** pointing at visible text on the page.
3. **Hidden-but-present text** in the DOM.
4. **`aria-label`** — last resort. It blocks machine translation, breaks voice control ("click *the words I can see*"), and is skipped by reader modes.

Two hard stops from Roselli:

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
- ❌ A `title` attribute as the tooltip
  ✅ A real tooltip element — `title` is unreachable by keyboard and touch

## Gotchas

- **Symptom:** Screen-reader users report a tab strip they can't get out of. **Cause:** All tabs left at `tabindex="0"`, so Tab walks the strip instead of entering the panel. **Fix:** Roving tabindex — one `0`, the rest `-1`.
- **Symptom:** A voice-control user can't activate a button whose label they can read aloud. **Cause:** `aria-label` overrode the visible text. **Fix:** Remove it; make the visible text the accessible name.
- **Symptom:** A toast is never announced. **Cause:** The live region was added to the DOM at the same moment as its content. **Fix:** The `role="status"` container must already exist; insert only the message into it.
- **Symptom:** Layout jumps a pixel when a toggle receives focus. **Cause:** `outline` participates in layout in that context. **Fix:** `box-shadow` for the ring.
- **Symptom:** An accessibility audit worsens after adding ARIA to a table. **Cause:** A working `<table>` was converted to an ARIA grid. **Fix:** Revert to semantic table markup; add `aria-sort` only for sorting.
- **Symptom:** A translated page leaves some controls in English. **Cause:** Those names came from `aria-label`, which translation services don't process. **Fix:** Move the name into visible text or `aria-labelledby`.
