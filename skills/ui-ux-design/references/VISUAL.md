# Type, color, and brand applied to a UI

Load when applying type and color inside an interface, or when producing brand guidelines. For type scale construction and font pairing depth see the **typography** skill; for palette construction and contrast math see **color-system**. This file covers the decisions those skills don't: proportion, ordering, governance, and the cultural constraints that can veto an otherwise valid palette.

## Type in an interface

- **Build the scale up from body size, not down from the headline.** Body is `1em` and everything else is a multiple or fraction of it, which is how it gets implemented — starting at the H1 produces a scale that needs rework at handoff.
- **Button text is its own role**, alongside heading and body. It's usually the role that gets left out of a type spec and then invented per-component.
- **Vary within one family before reaching for a second.** Multiple weights and widths of one typeface give variation with guaranteed cohesion; a variable font collapses that into a single file.
- **Size, leading, and measure are one system, not three settings.** Change any of the three and rebalance the other two. Keep body lines in the **45–75 character range, targeting 66** — and the implementable form of that, since character counts aren't a CSS unit: roughly `1em ≈ 2 characters`, so `max-width: 33em` lands near 66 characters at any font size.
- **Line-height is inversely proportional to font size.** Body text at **1.5 or more**; narrow columns near 1.5 and wide ones up to 2; large display type down toward 1.0–1.2. Small text needs more leading, not less. Guidance quoting 1.125–1.2 as *the* optimal range is quoting a display figure — correct for headlines, cramped and hard to read applied to body copy.
- Screen legibility comes from a **tall x-height, open apertures, and moderate stroke contrast**. Fonts drawn for interfaces say so.
- ALL CAPS for short labels, buttons, and wordmarks only. Without ascenders and descenders it stops being scannable at paragraph length.
- Script and display faces never carry body text — headlines, pull quotes, and signatures only.
- **The same element sits in the same place on every screen.** If a title is 100px from the top on one screen, it's 100px from the top on all of them. Positional consistency for a semantic role is a system rule, not a per-screen judgment.

## Color in an interface

- **60-30-10 allocates surface area, not harmony.** 60% dominant carrying identity, 30% secondary providing interest and making controls stand out, 10% accent reserved for what genuinely needs emphasis. It's a distribution constraint on top of whatever palette you picked.
- **Grayscale first.** Get the layout and hierarchy working with no color at all, then add it. If hierarchy only reads once color is applied, the hierarchy isn't working — and that failure is invisible to anyone who can't distinguish the hues.
- **Saturation carries accidental meaning.** A fully saturated red reads as an alert whether or not you meant one. Adjust saturation and value rather than switching hue — but not so far that it fails contrast.
- **Per-hue dosage rules**, distinct from what a hue *means*: red sparingly, or everything feels urgent · orange with restraint, or the product reads as unserious · purple lightly · large fields of black read heavy · brown needs a complement or it goes drab. **Yellow is disqualified as a text color** — put it on a dark background, use it as an accent, or use it as a fill behind dark text.
- **A four-hue palette needs neutrals to hold it down**, or it overwhelms.
- **Contrast is a ratio of relative luminance**, `(L1 + 0.05) / (L2 + 0.05)` — not "one color is 4.5× lighter". Thresholds are 4.5:1 for normal text, 3:1 for large text and UI components. These are still current in 2026 — see the currency note in [SOURCES.md](SOURCES.md) before reaching for APCA.
- Colors shift across displays and ambient light. Check on more than the machine it was designed on.
- **User state can outrank brand palette.** For products used under distress, muted and darker palettes outperform bright cheerful ones — users read cheerfulness as dismissal of what they're dealing with. One of the few cases where a palette's emotional register is a functional requirement rather than brand expression.

## Building the palette in code

- **Author in OKLCH, not HSL.** `oklch(L C H)` or `oklch(L C H / a)`. Its lightness is *perceived* lightness and holds consistent across hues, which is precisely what HSL gets wrong — `hsl(220 80% 50%)` looks markedly darker than `hsl(60 80% 50%)` at the same stated lightness, so an HSL-built ramp has invisible brightness cliffs in it.
- **Chroma maxes out around 0.37 and the ceiling is hue-dependent.** There is no single safe value. Browsers clip out-of-gamut colors by fast RGB clipping, which shifts hue unpredictably, so enforce it — `stylelint-gamut` with `gamut/color-no-out-gamut-range`.
- **Derive states rather than hand-picking them**, with relative color syntax:

```css
--button: oklch(0.5 0.2 260);
--button-hover: oklch(from var(--button) calc(l + 0.1) c h);
```

  Decimals inside `calc()`, never percentages — `calc(l + 10%)` fails.

- **Raise chroma on wide-gamut displays**, since the same value renders duller on P3:

```css
.accent { background: oklch(0.62 0.19 145); }
@media (color-gamut: p3) { .accent { background: oklch(0.62 0.26 145); } }
```

- **Space and gamut are different things.** A gamut is the *range* of colors available; a space is the *coordinate system* for reaching them. sRGB covers roughly 30% of what the eye perceives. The two words are used interchangeably almost everywhere, and the distinction is what makes the rest of this section make sense.

## Building a ramp

- **Distribute lightness exponentially, not linearly.** Even steps produce perceptual cliffs; the target is equal *contrast ratios* between steps.
- **Shift hue as lightness changes** to account for the Bezold–Brücke effect — shadows read more purple, highlights more yellow. A ramp at fixed hue looks subtly dead at the ends.
- **Build in OKHsl** (via `colorjs.io` or `culori`), which stays in gamut. It is not HSL or HSV with a different name.
- **Verify colorblind safety by transformation, not by filter.** Apply the Brettel et al. matrix for protanopia, deuteranopia, and tritanopia, then *re-measure* perceptual distance (CIE ΔE\*) in the transformed space, weighted by each type's population prevalence. Laying a simulation filter over a screenshot and eyeballing it is why palettes pass this check and still fail in use. There is no magic ΔE\* threshold — it's comparative, not a gate.

## Culture is a constraint, not a footnote

Audience research **precedes** palette selection, because meaning is regional and it can veto a choice that's otherwise accessible and on-brand:

- White signifies mourning in Japan, Korea, China, and India — wrong for a celebratory product in those markets.
- Red reads as luck and prosperity in Chinese contexts, not only as danger.
- Indigo signals wealth and status in parts of West Africa.

## Narrative ordering

A product surface is a sequence, and the ordering principle is **what the user is asking right now**. Early: *is this the right place for me, and where do I go?* Later, near commitment: *can I trust this, what happens if it goes wrong, how do I undo it?* Answering the second set on the landing screen is noise; withholding it at checkout is a lost sale.

Progressive disclosure is the pacing mechanism — reveal shipping terms, security details, and edge-case policy at the moment they become relevant, rather than fitting everything onto one screen. What you leave out shapes the story as much as what you include.

## The brand style guide as a governed artifact

If asked to produce brand guidelines, these are the parameters that keep it from becoming a shapeless document:

**Five sections, in order:** brand story (vision, mission, values, stated as answers to customer problems) · target audience (research-backed personas) · visual identity (typography and sizes, logo usage, imagery, iconography, and the palette in **RGB, HEX, and CMYK** — digital-only documentation strands anyone doing print) · brand voice (captured as an **adjective set** — "modern, clever, and brave, yet caring" — with tone varying per channel while voice stays fixed) · writing guidelines (readability level, grammar rules, an approved and forbidden word list).

**Bound it to 25–35 pages**, linking out to deeper resources rather than inlining them.

**Ship v1 early**, as soon as a few brand assets exist — this is not a document to wait on for completeness. Then **revise it every six to twelve months**, not only at a rebrand.

**Make it interactive**, so people can ask questions and submit requests against it. A static PDF goes stale silently.

**Include real contextual dos and don'ts** — examples of the brand behaving correctly in specific situations beat abstract rules. And scope distribution to contractors and freelancers, not just staff.

## Logo

- **The app-icon test**: at the size of a phone icon, are the details still legible? Most logo failures are discovered here.
- **The monochrome test**: strip the color. If it goes flat, the form isn't doing enough work.
- **A logo is a family, not a file** — full lockup for wide spaces, mark alone for tight ones.
- **SVG for screens** because it scales cleanly; raster formats for print.
- Simplicity, timelessness over trend, and readability — an unreadable mark is an unmemorable one.
