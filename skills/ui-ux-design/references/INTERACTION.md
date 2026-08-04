# Interaction

Load when building or reviewing a control, deciding motion, or explaining why a layout draws the eye where it does.

## The nine states, in full

A reference implementation. The selectors matter more than the values — swap the palette for the project's tokens.

```css
.btn {
  padding: 0.625rem 1.25rem;      /* 10px 20px */
  border-radius: 0.375rem;        /* 6px */
  border: 2px solid transparent;
  background: var(--color-action-primary);
  color: #fff;
  transition: background-color 150ms ease, outline 150ms ease;
}
.btn:hover              { background: var(--color-action-primary-hover); }
.btn:active             { background: var(--color-action-primary-active); transform: scale(0.98); }
.btn:focus-visible      { outline: 3px solid var(--color-focus-ring); outline-offset: 3px; }
.btn:disabled,
.btn[aria-disabled="true"] { background: var(--color-surface-disabled); color: var(--color-text-disabled); cursor: not-allowed; }
.btn.is-loading         { opacity: 0.75; cursor: wait; pointer-events: none; }
.btn[aria-pressed="true"] { background: var(--color-action-selected); }
```

The nine states and their CSS hooks are in SKILL.md. This table carries only what that summary leaves out.

| State | Adds |
|---|---|
| Default | A "mystery meat" control that only reveals itself on hover fails the recognizable-at-rest test. |
| Hover | Never the sole carrier of an affordance *or* of information. |
| Pressed | `scale(0.98)` or an inset shadow — the briefest state there is. |
| Focus | WCAG 2.2 sets a minimum size *and* contrast for the indicator, not just its presence. |
| Disabled | Prefer inline validation naming what unlocks it over a mute control with no story. |
| Loading | Spinner when the duration is unknown, progress bar when it's measurable. |
| Success | A checkmark plus a fill change, not a fill change alone. |
| Error | The inline message names what went wrong, not that something did. |
| Selected | `aria-pressed` for toggles — and use it for filters and segmented controls too. |

## Motion

- Motion is a hierarchy channel, not decoration — a transition orders attention the same way size does.
- Animation has a load cost. Scroll-driven animation and view transitions have native APIs now; prefer them over scripted equivalents, which also gets you the accessibility behavior for free.
- Respect `prefers-reduced-motion`.

## UX laws that change code decisions

**Fitts' law** — `MT = A + B × log₂(2D/W)`. Movement time rises with distance and falls with target size. Practically:

- Grow the target with **padding**, not font size.
- The **prime pixel** is wherever the cursor already is — screen center, or the control just clicked. Put the next likely action near it, so CTA placement follows the previous interaction rather than page geometry alone.
- Frequently used controls get more size and less distance than rare ones. Primary menu items larger than secondary.
- Spacing cuts both ways: group related controls to shorten travel, but keep enough gap that a miss doesn't fire the wrong action.
- On phones, keep primary actions in the **thumb zone** — toward the center and bottom, not the top corners. Moving search and menu bars to the bottom of the screen is a real one-handed-reach fix.
- On **corners**: Figma's "magic pixel" framing treats the four corners as the hardest targets, since they're furthest from the prime pixel. The older Tognazzini reading treats a screen edge as an effectively infinite target and therefore the easiest. Both are right in their context — the edge is infinite only when the window is fullscreen and the OS pins the control to it. In a browser page, treat corners as expensive.

**Hick's law** — decision time rises with the number and complexity of choices. Cut options, or group them so the first decision is between few things.

**Gestalt grouping** — the perceptual rules the whole hierarchy toolkit rests on. The ones that earn their place in an interface:

| Principle | Interface consequence |
|---|---|
| Proximity | Spacing is the primary grouping signal — cheaper and stronger than borders |
| Similarity | Shared shape, color, or size reads as "same kind of thing"; break it and users assume a difference exists |
| Common region | A closed boundary groups regardless of distance — the mechanism behind cards, sidebars, tabs, accordions |
| Continuity | Items on a line or curve read as a sequence; alignment is what makes a scan work |
| Closure | Incomplete shapes read as complete, so a partially visible row is a scroll affordance |
| Focal point | The one element that differs takes attention — spend it on the primary action |
| Common fate | Things moving together read as related; use it to show what a filter or a drag affects |

## Forms

- Inline validation beats a submit-time error list. Say what's wrong next to the thing that's wrong.
- A disabled submit button with no explanation is the most common form dead-end. Either enable it and validate on submit, or say what's missing.
- Real-world input breaks forms first: long names, non-Latin characters, pasted values with whitespace, autofill.
- Label every field visibly. A placeholder is not a label — it vanishes exactly when the user needs it.

## Anti-patterns

- ❌ A hover-only affordance
  ✅ Visible in the default state; hover only enriches it
- ❌ `outline: none` to clean up the focus ring
  ✅ `:focus-visible` with a 3px ring at 3px offset
- ❌ Color as the only difference between two states
  ✅ Color plus an icon, a border-weight change, or an underline
- ❌ A grayed-out control with no reason given
  ✅ Disabled plus an adjacent message naming what unlocks it
- ❌ Primary and secondary buttons that differ by one shade
  ✅ A clear weight difference — filled versus outlined
- ❌ Side-scrolling with no arrows
  ✅ Explicit affordances, because vertical scroll is the expectation
- ❌ Dark patterns — a hidden unsubscribe, a preselected upsell, a decline link styled as body text
  ✅ Make the reversible path as easy to find as the committing one
