# Interaction

Load when building or reviewing a control, a route's loading, empty, error, and not-found states, how a save or delete reports back, or motion — or when explaining why a layout draws the eye where it does.

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

/* aria-disabled stays focusable and stays in contrast scope — so this text must pass 4.5:1 */
.btn[aria-disabled="true"] { background: var(--color-surface-disabled); color: var(--color-text-disabled-accessible); cursor: not-allowed; }

/* the native attribute exempts itself from contrast and drops out of the tab order — last resort */
.btn:disabled           { background: var(--color-surface-disabled); color: var(--color-text-disabled); cursor: not-allowed; }

.btn[aria-busy="true"]  { opacity: 0.75; cursor: progress; }
.btn.is-success         { background: var(--color-success); }
.btn.is-error           { background: var(--color-error); }
.btn[aria-pressed="true"] { background: var(--color-action-selected); }
```

Two things that block the click without breaking anything: guard the handler (`if (button.getAttribute('aria-disabled') === 'true') return;`) and validate on the server regardless. `pointer-events: none` looks like the shortcut and is not one — it suppresses the cursor you just set, kills hover, and removes the element from pointer targeting while leaving it in the tab order, so a keyboard user can still fire it.

Nine, not five. The last four are the ones that get skipped, and each carries a behavioral rule rather than just a style.

| State | Signals | Hook | Rule |
|---|---|---|---|
| Default | Interactive at rest | `.btn` | Recognizable as a control from shape, color, or label alone. A "mystery meat" control that only reveals itself on hover fails this |
| Hover | Interactivity, before commitment | `:hover` | **Does not exist on touch.** Never the sole carrier of an affordance *or* of information |
| Pressed | Input registered | `:active` | `scale(0.98)` or an inset shadow — the briefest state there is |
| Focus | Keyboard position | `:focus-visible` | 3px ring at 3px offset. WCAG 2.2 sets a minimum size *and* contrast for the indicator, not just its presence |
| Disabled | Unavailable, with a reason | `[aria-disabled="true"]` | Still focusable, so the reason is reachable. Better still, inline validation naming what unlocks it |
| Loading | Working | `[aria-busy="true"]` | Control blocked against duplicate submits. Below 100ms, show nothing |
| Success | Done | `.is-success` | A checkmark plus a fill change, not a fill change alone |
| Error | Failed | `.is-error` | Inline message names what went wrong, and the control is clickable again |
| Selected | Toggled on until turned off | `[aria-pressed]` | Use it for filters and segmented controls too |

**Disabled has three causes, and each takes a different mechanism:**

| Cause | Mechanism |
|---|---|
| A precondition the user can fix — a missing field, a permission | `aria-disabled="true"`, a guarded handler, and the reason next to the control |
| A write already in flight | Native `disabled` plus `aria-busy` — nothing to explain, and it lasts a moment |
| A server-rendered control whose handler isn't attached yet | `aria-disabled` until hydration finishes. Before then a click is silently swallowed; rendering it disabled makes the wait visible instead of making the control look broken |

## Latency budgets

Four thresholds, and they don't conflict — each measures something different:

| Budget | Governs | What the UI owes |
|---|---|---|
| **100ms** | Perceived instantaneity | Nothing. Render the result |
| **400ms** | Sustained productivity on a repeated action (Doherty, IBM 1982) | Stay under it for anything in an inner loop |
| **1s** | Thought flow | Optional subtle feedback — the delay registers without breaking concentration |
| **10s** | Attention | Progress indicator *and* a cancel affordance; assume the user leaves and returns |

Nielsen's 0.1/1/10 figures predate mobile networks and have no constrained-connection variant. Treat them as floors, not as targets measured on a phone over cellular.

## Route states in full

The contract behind the four-states table in SKILL.md, for every route that reads data.

- **Loading** — a skeleton in the page's real shape: the heading, the filter band, rows at their real height. Wrap it in a `role="status"` region whose text names what is loading ("Loading documents"). One shared spinner for every route tells the user nothing and makes the page jump when content arrives.
- **Empty** — resolve the cause before choosing the copy, in this precedence, and give each its own headline and primary action:

  | Cause | Headline says | Primary action |
  |---|---|---|
  | Failed to load | This is an error, not an empty list | Retry |
  | Filtered to zero | Nothing matches, out of N in total | Clear the filter |
  | Hidden by a setting | The items exist but a setting hides them | Open that setting |
  | Everything trashed | All of them are in the trash | Open the trash |
  | Never had any | What this list will hold | Create the first one |

  Collapsing these into one "No items yet" sends the person with forty trashed items to a create button.
- **Error** — log it, name what failed in the user's words, show an error id they can quote, and offer both a retry and a way out (up to the list, or home). Say whether their data is unchanged when that's true; it's the first thing a person fears after a failure.
- **Root-level failure** — the outermost error page must not depend on the theme, providers, or data layer that may be what failed. Make it self-contained, with inline styles and no shared components.
- **Not found** — on a detail route, name what wasn't found ("No document with that id") and link to its list. A generic 404 on a record route reads as a broken app.
- **A switched-off feature** — routes belonging to a feature the user has turned off answer not-found rather than rendering a dead screen.

## Save feedback

Pick the feedback by the shape of the write, not by whatever notification component is nearest:

| Write | Success | Failure |
|---|---|---|
| A button-shaped action — Save, Import, Send | Toast that closes on its own | Toast that **stays** until dismissed — it has to survive the user looking away |
| A per-field quick edit | Inline "Saved" in a fixed-size slot beside the field, so nothing shifts | A toast, plus the field keeps the typed value |
| An optimistic write | The UI already shows it | Roll back on a thrown error **and** on a returned error result — the second is the one that gets missed |
| A removal or batch change | Toast with Undo and a longer timeout | A sticky toast naming what didn't apply |

An auto-closing failure toast is a failure the user never learns about. Sticky failures, transient successes.

### Undo instead of confirm

For a reversible action people repeat — removing tracks, archiving rows, deleting photos — skip the dialog and offer undo:

1. **Remove the row immediately.** The toast is the only acknowledgement; holding the row until the timer ends is slower than the dialog you removed.
2. **Commit on expiry, never on interaction.** Not on dismiss, not on scroll-away, not when the next action starts. Wiring the commit to a dismissal turns an accidental swipe into the irreversible delete the pattern exists to prevent.
3. **Pause on hover and on focus, tracked as two flags, held while either is true.** With one flag, the pointer leaving releases a hold that keyboard focus still has, and the Undo button expires under a keyboard user. Show that it's held — a frozen countdown with no word reads as broken.
4. **Restore to the original index**, not the top. Undo means "as you were."
5. **Drive the countdown in script**, not a CSS animation — the remaining time is information, and a global reduced-motion rule would flatten it.

Walk away from undo when the action can't be deferred (a payment, a send, an outbound call) or when its result is invisible, since nobody reaches for Undo on a change they didn't see.

### Delete confirmations

Keep a confirm dialog only for a delete that is final when it runs. A dialog in front of every delete trains people to click through it, which is what makes the one that matters dangerous.

- **Name what goes with it.** "This also deletes 3 playlists and 142 play counts", with live counts; block the confirm button until the count arrives. Make "nothing cascades" an explicit input rather than an omitted one, and drop zero-count tallies from the sentence.
- **Match the copy and color to reversibility.** A move to trash says where it went and for how long, in a neutral color, and never says "cannot be undone." A permanent purge says it and gets the danger color. One false "cannot be undone" teaches people the phrase is decorative.
- **Undismissable while running** — no Escape, backdrop click, or close button mid-request, so nobody is left unsure whether it went through.
- **Reset its error and options on every open**, not on close. A checkbox left ticked from a cancelled run is a second destructive action riding along silently.
- **Name the thing on the button** — "Delete Moonlight Sessions", not "Delete". Errors stay on the dialog.
- **Delete sits in the same corner of every edit form**, so nobody hunts for it and nobody hits it by habit where Save usually is.

## Long-running work

- **Report states you actually know, never an invented percentage.** An upload is waiting, uploading, stored, already stored, or failed. A job with an unknown total gets an indeterminate bar plus a running count. A made-up percentage that stalls at 90% is worse than none.
- **A duplicate says where the existing copy lives** — "Already stored in Contracts" with a link — rather than failing or silently doubling.
- **A failed status poll is transient.** Retry it; don't end the job on the screen because one request dropped.
- **Background work stays visible in persistent chrome** — a job chip in the header, a count badge in the nav — so a long task is still visible after the user navigates away. The 10-second budget assumes they leave; this is where they find it again.
- **Uploads land where the user is looking** — the folder in view — and accept a drop anywhere on the page, not only on a small target.


## Error messages

Six checks, condensed from Nielsen Norman Group's 2023 twelve-item rubric. The first and the fourth are the ones that get skipped.

1. **Name the exact problem.** "An error occurred" and "Invalid input" fail this. The message says which value, and what about it.
2. **Put it next to its cause**, not in a summary at the top.
3. **Plain language.** No codes, no jargon, no internal identifiers.
4. **Preserve what the user typed.** Resetting a form on a failed submit is the most costly form defect there is, and the most common.
5. **Drop blame words.** "Illegal", "invalid", "you failed to" — frame it as the system not accepting something, and say what it will accept.
6. **Offer the fix, not only the diagnosis.** Where the mistake is predictable, suggest the corrected value rather than asking for re-entry.

**Severity scales the container**, and current practice tends to invert it: field-level problems go inline, minor issues go to a toast, and a modal is reserved for something genuinely blocking. A verbose toast for a typo and a terse line for a failed payment is the wrong way round.

Don't validate prematurely — real-time feedback earns its place on error-prone fields, not on every keystroke of every input.

## Where controls go

**The three laws of locality** (Kennedy). Users expect a control where its effect happens, so placement is a signal, not a layout preference:

- Put a control **where it takes effect**.
- A control governing a **larger region sits above that region** — recursive from app-level, to page-level, to section-level.
- A control placed **far from its effect must compensate with visual prominence**, because nothing else tells the user what it acts on.

## Depth and shadow

Hobday's geometry, which is checkable rather than a matter of taste:

- **Blur = 2× the distance value.** A 4px offset takes an 8px blur.
- **Reduce opacity as the shadow approaches the light source.**
- **Don't mix depth techniques** in one interface — soft shadows, hard shadows, or none, and pick one.
- **No shadows on dark grounds** unless the background is light enough to actually render them; on a near-black surface, use a lighter fill to signal elevation instead.
- **Lightness increases as an element comes toward the viewer**, in both light and dark modes.

## Motion

- Motion is a hierarchy channel, not decoration — a transition orders attention the same way size does.
- Animation has a load cost. Scroll-driven animation and view transitions have native APIs now; prefer them over scripted equivalents, which also gets you the accessibility behavior for free.
- Respect `prefers-reduced-motion`.
- **Budgets beyond a single control**, so "feels slow" becomes a number in the spec: UI state changes 150–250ms, page transitions 250–400ms, scroll reveals 300–450ms with no long staggers, a load animation under about 1.5s that plays once, and any ambient loop paused while the tab is hidden.
- **Content is visible at rest.** A reveal enhances a section that already renders; it never holds one at opacity 0 waiting for an observer that may not fire — in a screenshot, a print, or a slow device.

## UX laws that change code decisions

**Fitts' law** — `MT = A + B × log₂(2D/W)`. Movement time rises with distance and falls with target size. Practically:

- Grow the target with **padding**, not font size.
- The **prime pixel** is wherever the cursor already is — screen center, or the control just clicked. Put the next likely action near it, so CTA placement follows the previous interaction rather than page geometry alone.
- Frequently used controls get more size and less distance than rare ones. Primary menu items larger than secondary.
- Spacing cuts both ways: group related controls to shorten travel, but keep enough gap that a miss doesn't fire the wrong action.
- On phones, keep primary actions in the **thumb zone** — toward the center and bottom, not the top corners. Moving search and menu bars to the bottom of the screen is a real one-handed-reach fix.
- On **corners**: Figma's "magic pixel" framing treats the four corners as the hardest targets, since they're furthest from the prime pixel. The older Tognazzini reading treats a screen edge as an effectively infinite target and therefore the easiest. Both are right in their context — the edge is infinite only when the window is fullscreen and the OS pins the control to it. In a browser page, treat corners as expensive.

**Hick's law** — decision time rises with the number and complexity of choices. Cut options, or group them so the first decision is between few things. Don't simplify to the point of abstraction: a user who came specifically for a long ingredient list is not helped by a short one.

**Hick's law and choice overload are different phenomena.** Hick's measures decision *speed*; choice overload measures decision *quality* and the emotional paralysis of too many options. A fast decision the user regrets is a choice-overload failure that Hick's law scores as a success.

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
- **A disabled submit button is the most common form dead-end**, and a natively disabled one is worse than it looks: the user can't focus it to find out why. Enable it and validate on submit, or use `aria-disabled` with the missing requirement stated next to it.
- **Prevent the error rather than message it.** Nielsen's fifth heuristic is to eliminate error-prone conditions, or check for them and confirm before the user commits — constraints, good defaults, and a confirmation step outrank any error copy. Make the invalid state unreachable, which is not the same as making the button unclickable.
- Real-world input breaks forms first: long names, non-Latin characters, pasted values with whitespace, autofill.
- Label every field visibly. A placeholder is not a label — it vanishes exactly when the user needs it.

## Anti-patterns

- ❌ A hover-only affordance
  ✅ Visible in the default state; hover only enriches it
- ❌ `outline: none` to clean up the focus ring
  ✅ `:focus-visible` with a 3px ring at 3px offset
- ❌ Color as the only difference between two states
  ✅ Color plus an icon, a border-weight change, or an underline
- ❌ `disabled` on a control, or a grayed-out one with no reason given
  ✅ `aria-disabled="true"` plus a guarded handler and an adjacent message naming what unlocks it — it keeps focus, so the reason is reachable
- ❌ Primary and secondary buttons that differ by one shade
  ✅ A clear weight difference — filled versus outlined
- ❌ Side-scrolling with no arrows
  ✅ Explicit affordances, because vertical scroll is the expectation
- ❌ "Couldn't save" in a toast that vanishes after four seconds
  ✅ A failure toast that stays until dismissed; successes close on their own
- ❌ "This cannot be undone" on a move to trash
  ✅ "Moved to trash — kept for 30 days" in a neutral color; the danger copy reserved for the permanent purge
- ❌ An upload bar at 90% for a minute
  ✅ "Uploading 3 of 7 · 2 already stored"
- ❌ Deceptive patterns — a hidden unsubscribe, a preselected upsell, a decline link styled as body text
  ✅ Make the reversible path as easy to find as the committing one — full catalogue and the request-handling rule in [ETHICS.md](ETHICS.md)

## Gotchas

- **Symptom:** A keyboard user's undo toast expires while they're on the Undo button. **Cause:** Pause was tracked with one flag, and the pointer leaving cleared it. **Fix:** Separate hover and focus flags; hold while either is true.
- **Symptom:** Clicking a tab or button right after page load does nothing, intermittently. **Cause:** The server-rendered control was clickable before its handler hydrated. **Fix:** Render it `aria-disabled` until hydration completes.
- **Symptom:** An optimistic edit stays on screen after the save failed. **Cause:** Rollback was wired to thrown errors only, and the action returned an error result instead. **Fix:** Roll back on both.
- **Symptom:** Visual-regression screenshots show whole sections blank. **Cause:** Scroll-reveal content sits at opacity 0 until it enters the viewport, which a full-page capture never scrolls. **Fix:** Capture with reduced motion on, and make content visible at rest — reveals enhance an already-visible section.
