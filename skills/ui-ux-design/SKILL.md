---
name: ui-ux-design
description: UI/UX design — interaction states, accessibility contracts, information architecture, visual hierarchy, and design tokens. Use this skill whenever the user wants to design or critique an interface, asks to "design this screen", "what states does this button need", "what ARIA does this menu need", "make this accessible", "how should I structure the navigation", "is this UI any good", "set up design tokens", "review my UX", or "make this convert better" — even if they never say design and only describe a cluttered screen, a flow users abandon, or a component that breaks on real data. Covers type and color as applied to a UI; send pure type-scale, line-height, or palette-contrast questions to typography and color-system. Deceptive patterns too — route signups, conversion, retention, and pricing-presentation asks here. Do NOT use for chart and encoding design (see dataviz), React file structure and hooks (see ideal-react-component), or copywriting and A/B testing.
license: MIT
argument-hint: "[screen | flow | states | components | tokens | ethics | audit]"
metadata:
  author: Antonin Januska
  version: "2.0.0"
  tags: [ux, ui, interaction-design, information-architecture, design-tokens, accessibility, usability, deceptive-patterns, aria]
---

# UI/UX Design

## Overview

An interface is judged on whether a person can accomplish their goal, not on whether it looks finished. Most defects an agent ships are not ugly — they are the states nobody drew, the flow that assumed the happy path, and the label that broke when the data got long.

Two rules generate most of what follows. **Design the states, not the screen** — a screen is the union of its loading, empty, error, and success renderings, and whichever one goes unspecified gets invented during implementation. **Name things for their role, not their appearance** — a name that survives a value change is the difference between a rebrand taking minutes and taking days.

## Navigation

| Load | When |
|---|---|
| **[references/INTERACTION.md](references/INTERACTION.md)** | Building or reviewing a control — full state specs, CSS, UX laws, motion, forms |
| **[references/COMPONENTS.md](references/COMPONENTS.md)** | Building a named component — the ARIA, keyboard, and focus contract for tabs, menus, tables, tooltips, cards, and five more |
| **[references/PROCESS.md](references/PROCESS.md)** | Planning research, wireframes, prototypes, usability tests, or a launch checklist |
| **[references/LAYOUT.md](references/LAYOUT.md)** | Grids, responsive behavior, and the section recipes for landing, pricing, and portfolio pages |
| **[references/SYSTEMS.md](references/SYSTEMS.md)** | Design tokens, design systems, and design-to-code handoff |
| **[references/VISUAL.md](references/VISUAL.md)** | Applying type and color to a UI, plus the brand style guide as a governed artifact |
| **[references/ETHICS.md](references/ETHICS.md)** | Anything about conversion, signups, retention, or pricing presentation — the deceptive-pattern catalogue and where the persuasion line sits |
| **[references/SOURCES.md](references/SOURCES.md)** | Citing a rule, or checking which claims were corrected against their source |

## Audit mode

`audit` reviews an app that already exists rather than designing a surface that doesn't. Five phases, each gated on something outside this file.

1. **Scope from the repo, not from the brief.** Read the project's own agent doc, then enumerate every route and the components each one renders. A brief that describes the wrong app still yields the right audit when the surface list comes from the code.
2. **Build the state matrix before judging anything.** One row per surface, one column per state from the four below. A cell you can't fill by reading the code is itself a finding — that state doesn't exist.
3. **Split into lanes only when the surface count justifies it** — three or four read-only lanes by surface family (lists, forms, chrome, accessibility), each carrying the four-states table and the floor inline so a lane doesn't depend on loading this file. Always fewer lanes than surfaces; never one per route.
4. **Publish one report, ranked by consequence, and stop.** Every visual change gets a **rendered before and after** — real markup at real sizes, side by side, with the difference named underneath. A description of a change is not a before and after. Size the report to the finding count; one longer than the fix list it produces goes unread.
5. **Get approval per finding before implementing.** Present the ranked list and let the user accept, cut, or reorder it — audits reliably surface items the user considers not worth the pixels, and shipping those spends the credibility the real findings earned. Record what was approved, and what was cut, where the project already tracks work.

**A passing verdict is a legitimate outcome.** If the surfaces hold up, say so and name what was checked. An audit that always finds ten things isn't measuring.

## An approved mockup is the spec

This applies to any implementation of a design the user signed off on, whether it came out of an audit or a single-screen redesign.

Before reporting the implementation done, **put the approved artifact and the running screen side by side and list every element that differs.** Name each one — the hero that isn't full-bleed, the strip that stopped short of the edge, the card layout that got simplified, the data that landed in a different section than agreed. Then either fix it or say which differences you're keeping and why.

"Tests pass and it renders against the dev server" answers a different question than "it matches what we agreed to," and the second one is the one that was approved. Drift concentrates in whatever nobody thought to re-open: the sections further down the page, the second posture of a two-mode screen, the component that was specified last.

## The floor

Non-negotiable, and cheap to get right at build time rather than in an audit later.

- **4.5:1 contrast for normal text, 3:1 for large — in every state, in both color schemes.** Hover, pressed, and disabled fills are where this silently breaks; nobody rechecks them. A dark scheme built after the light one breaks all three at once, so it isn't a follow-up task — it ships with the surface or the surface isn't done. Low-contrast text is the most common accessibility failure on the web, present on 79.1% of homepages.
- **44×44px minimum touch target.** Grow it with padding, not font size.
- **Never let color alone carry meaning.** Pair every color shift with an icon, a border-weight change, or an underline, or the state is invisible to the 1-in-12 men with a color vision deficiency.
- **Visible focus, via `:focus-visible`.** Never `outline: none` without a replacement ring — that cuts off keyboard and assistive-tech users entirely.
- **Native semantic HTML before ARIA.** Pages using ARIA average *twice* as many accessibility errors as pages without it. `<header>`, `<nav>`, `<main>`, `<footer>`, and native `dialog`/`popover` carry accessibility for free.
- **`aria-disabled` rather than the `disabled` attribute.** A natively disabled control leaves the tab order and is exempt from contrast requirements — so the control *and* any explanation next to it become unreachable for exactly the people who needed the explanation. Set `aria-disabled="true"`, block the action in the handler, and keep the text contrast-passing.
- **Every interactive element is reachable and operable without a mouse**, in a tab order that matches reading order.

## Every surface ships four states

The single highest-value habit in this file. For each screen, list, and control, decide what renders when:

| State | What it must do |
|---|---|
| **Loading** | Report progress — a spinner when the duration is unknown, a progress bar when it's measurable. The triggering control disables so the action can't be submitted twice. |
| **Empty** | Explain why it's empty and offer the action that fills it. A first-run empty list and a filtered-to-zero list are different screens with different copy. |
| **Error** | Say what failed and what to do about it, inline. The control **returns to clickable** so the user can retry — never lock it in the error state. |
| **Success** | Confirm immediately and unambiguously, then get out of the way. |

**Latency decides whether a loading state is needed at all.** Four thresholds, and they don't conflict — each measures something different:

| Budget | Governs | What the UI owes |
|---|---|---|
| **100ms** | Perceived instantaneity | Nothing. Render the result |
| **400ms** | Sustained productivity on a repeated action (Doherty, IBM 1982) | Stay under it for anything in an inner loop |
| **1s** | Thought flow | Optional subtle feedback — the delay registers without breaking concentration |
| **10s** | Attention | Progress indicator *and* a cancel affordance; assume the user leaves and returns |

Nielsen's 0.1/1/10 figures predate mobile networks and have no constrained-connection variant. Treat them as floors, not as targets measured on a phone over cellular.

Then vary those by **permission and user type** — an admin, a read-only viewer, and a signed-out visitor see three different renderings of the same route.

**Then break it with real data**, because placeholder content hides the failures: a label three times longer than the mock, a list with 10,000 rows, a list with one row, an image that 404s, a name with diacritics, a translated string that runs 40% longer than the English. If a component collapses when the list is empty or overflows when the label runs long, that is worth knowing before it ships.

Catching a logic gap at design time costs minutes. Catching it during implementation costs days.

## Interactive element states

Nine, not five. The last four are the ones that get skipped, and each carries a behavioral rule rather than just a style.

| State | Signals | Hook |
|---|---|---|
| Default | Interactive at rest — recognizable as a control from shape, color, or label alone | `.btn` |
| Hover | Interactivity, before commitment. **Does not exist on touch** | `:hover` |
| Pressed | Input registered. Lasts only as long as the click | `:active` |
| Focus | Keyboard position. 3px ring plus 3px offset | `:focus-visible` |
| Disabled | Unavailable, paired with a message saying *why* — and still focusable, so that message can be reached | `[aria-disabled="true"]` |
| Loading | Working. Control blocked to stop duplicate submits | `[aria-busy="true"]` |
| Success | Done | `.is-success` |
| Error | Failed, with an inline reason, and clickable again | `.is-error` |
| Selected | Toggled on, persisting until turned off | `[aria-pressed]` |

- **Transitions run 100–200ms**, 150ms as the default — slower reads as sluggish, faster gets missed.
- **On touch, active and loading carry the whole feedback burden**, since hover never fires. An affordance that only appears on hover is invisible on a phone, and hover-triggered tooltips need a tap-triggered equivalent.
- **Primary and secondary actions must be distinguishable at a glance**, or users hesitate on every choice.

## Visual hierarchy has six levers

Size, weight, color and contrast, spacing, position, and **time**. The last one is the one that gets treated as decoration: a transition, a reveal, or a progressive disclosure sequence orders attention exactly the way size does.

- **Proximity works in both directions** — closeness asserts a relationship, and whitespace between groups asserts that there isn't one. Use it defensively: keep a destructive or exit control physically apart from the cluster it would be misclicked into.
- **Contrast is a consequence signal, not just an emphasis one.** A destructive action gets the high-contrast treatment so the weight of it registers; its safe sibling stays quiet.
- **When everything is emphasized, nothing is.** The common failure is too many competing levers, not too few.
- **Progressive disclosure requires an orientation cue.** Staging a long form across steps only works if each step says where the user is and how many remain — hiding steps without that is how people abandon.
- Users need **agency over text size**. A layout that breaks at 200% zoom fails the people who need it most.

## Information architecture

Three structures, chosen by how people actually look for the thing:

- **Hierarchical** — a tree with a main menu and subpages. The default for content that has a natural taxonomy.
- **Sequential** — one linear path, for checkout, onboarding, and tutorials. The user should not be able to wander off it.
- **Matrix** — navigate by attribute, filtering the same set by price, size, status, or date. The right answer when there is no single correct taxonomy.

A sitemap is one component of information architecture, not a synonym for it — IA is organization plus labeling plus navigation plus search.

**Any page can be the entry point.** Deep links, search results, and shared URLs mean every route has to stand on its own: it explains what it is, and offers a way up and out. Design for growth too — a category scheme that only works at today's content volume will need re-cutting.

**One goal per flow.** Map the entry point, the meaningful steps, the decision forks, and the endpoint — and stop there. Do not capture every click; model the moments where the user could go wrong.

## Design tokens

Three tiers, in this order:

1. **Primitive** — raw values with no usage context. `blue-500`, `gray-300`, `space-4`.
2. **Semantic** — the role a value plays. `action-color`, `text-primary`, `color/text/disabled`. A developer reading `action-color` knows its purpose without tracing it back to a hex.
3. **Component** — bound to one element. A primary button's background, a card's radius, an input's padding.

- **Semantic tokens point at primitives, never at other semantic tokens.** Chaining aliases is the thing that makes a token system unmaintainable.
- **Themes are modes on one token set, not a duplicate set per theme.** `text-primary` resolves differently in light and dark; a parallel `.dark .button {}` override tree is the failure mode.
- Name for what it does, not what it is — `text-secondary`, not `gray-text`. Cover text, background, border, and action first.
- Skipping the semantic tier means every primitive change turns into a hunt through every component.

## Examples

- ✅ A list route rendering first-run empty, filtered-to-zero, loading, error-with-retry, and populated — ❌ a list that renders rows and nothing else
- ✅ "Couldn't save — the title is already taken" with the button clickable again — ❌ a button stuck in a red error state
- ✅ Delete disabled with "You need admin access to delete this" beside it — ❌ a grayed-out button with no explanation
- ✅ Status shown as a colored dot **plus** a label — ❌ a red dot and a green dot as the only difference
- ✅ `--color-action-primary: var(--blue-500)` — ❌ `--button-bg: var(--action-color)` chaining through a second semantic token
- ✅ Checkout as a sequential flow with "Step 2 of 4" — ❌ a four-step form that hides where you are
- ✅ Padding raising a 20px icon button to a 44px target — ❌ bumping the icon to 44px to hit the number
- ✅ Testing the card with a 120-character title and a missing image — ❌ shipping against the 3-word mock title

## Gotchas

- **Symptom:** Layout is fine in review, broken in production. **Cause:** Designed against placeholder content. **Fix:** Re-render every component with a long label, an empty collection, a failed image, and a translated string before calling it done.
- **Symptom:** Feature works for the author, unusable on a phone. **Cause:** The affordance lives in a hover state. **Fix:** Move it into the default state; hover never fires on touch.
- **Symptom:** Accessibility audit fails after adding ARIA. **Cause:** ARIA layered onto non-semantic markup. **Fix:** Use the native element first — ARIA usage correlates with *more* errors, not fewer.
- **Symptom:** Contrast passes but the UI is still unreadable somewhere. **Cause:** Only the default state, in one color scheme, was checked. **Fix:** Measure hover, pressed, and disabled fills, in light and dark.
- **Symptom:** A control explains why it's unavailable, and users still ask why it's unavailable. **Cause:** The native `disabled` attribute took it out of the tab order, so keyboard and screen-reader users never reach the control or the explanation. **Fix:** `aria-disabled="true"` with a guarded handler.
- **Symptom:** A generated palette satisfies every color rule and is still rejected as ugly. **Cause:** It was derived from hue relationships instead of sampled from whatever it was named after. **Fix:** Read the real source first — brand values, the product's stylesheet or theme files, a screenshot — then adjust from there in OKLCH.
- **Symptom:** A rebrand or theme change turns into a multi-day sweep. **Cause:** Components reference primitives directly, or semantic tokens chain. **Fix:** Insert the semantic tier; point every semantic token straight at a primitive.
- **Symptom:** Users abandon a multi-step form midway. **Cause:** Progressive disclosure without orientation. **Fix:** Show current position and steps remaining on every step.
- **Symptom:** Stakeholder feedback is all about colors and copy when you needed structural input. **Cause:** The artifact was too polished for the question. **Fix:** Show it in grayscale with unstyled elements; visual polish hijacks the conversation.
- **Symptom:** Implementation drifts from the design in small ways nobody agreed to. **Cause:** The in-between moments — hover, loading, dismissal, transitions — were never specified, so they got invented at the keyboard. **Fix:** Specify them, or accept whatever the implementation chooses.
- **Symptom:** An implementation is reported done and the reply is that it looks nothing like what was agreed. **Cause:** It was checked against the running app rather than against the approved mockup. **Fix:** Open both side by side and list the differences before reporting done.
- **Symptom:** A deep link into the app lands somewhere confusing. **Cause:** The route was designed as step 3 of a flow. **Fix:** Every route explains itself and offers a way up — any page can be the entry point.

## Integration

- **typography** for type scales, line-height, and font pairing · **color-system** for palette construction and contrast math
- **frontend-design** for layout execution and visual polish · **dataviz** for charts
- **ideal-react-component** when the states land in React · **local-first-app** for the app-shaped feature set these patterns fill in
- **track-qa** for the manual checks — states, zoom, keyboard paths — that automated tests can't cover
