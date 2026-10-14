# Design exploration

Load when generating many design options for someone to choose between — a site redesign, a new screen with no settled direction, a set of concept demos built in parallel. "Presenting concept options" in SKILL.md covers how to show a single option; this file covers producing dozens and narrowing them to one.

The shape that works is a funnel: **wide range, then hybrids, then a few finalists on a locked system, then assembly.** Something like 100 → 25 → 6 → 3 → 1 suits a full site. Each round's brief is written from the previous round's verdicts, so the verdicts are the real product of every round.

## Writing the brief for parallel builders

- **Assign each builder its direction; don't let it choose.** Left to pick, agents converge on the same few looks, and fifty options become five options repeated. Give each one a named direction up front, such as a design movement paired with a research angle, from a list written before any building starts.
- **Fix the shell in the brief.** Hand every builder the real app shell, with its navigation, header, and theme hooks, as a file it must render inside, and forbid replacing app-level chrome. A permissive brief gets the shell replaced in nearly every demo, and each one needs a retrofit before it can be judged. This is the same rule as SKILL.md's "full screen in the app's own chrome," enforced where the work starts.
- **Use real content and real data volumes.** Long titles, missing images, and an empty collection go in the brief. An option that only works on placeholder data hasn't been evaluated.
- **Content is visible at rest.** No section held at opacity 0 waiting for a scroll observer, because thumbnails and screenshots capture it blank and the reviewer judges a hole.
- **Lead with the primary task.** If people come to a screen to browse and upload, those come first. Decorative stats placed ahead of the content get whole rounds rejected.

## Breaking the shared skeleton

Generated options converge on structure before style. Most come back as the same page under different styling: the same top nav, the same hero, the same three cards, whatever the app. Assigning a style per builder changes the surface. It doesn't change the skeleton.

- **Assign the structure too.** Each brief names its nav form, hero form and listing form, from a list that rules out the default set (top bar, centered hero, three-card row) for most builders.
- **Screen for the tells before review,** and send back options carrying several: a serif display on everything, many mixed faces, a wild range of sizes, rectangles on a strict grid with visible grid lines, purple, rounded bordered cards, a left border on every block, gradients everywhere.
- **Ask past the obvious directions.** Distinct options come once the obvious directions are used up and the brief asks for the ones beyond them.
- **Check the saved libraries before generating.** A new run tends to reproduce designs that already exist, so start from a kept design when one fits.
- **State the cost up front.** Expect several rounds. Iterating on generated options can take longer than sketching one concept by hand and having it built. Offer that path when the user already has an idea.

## Collecting verdicts

- **Use a fixed scale for each option, recorded as data**, such as Love / Promising / Meh / No, plus free-text notes, exported in a form the next round's brief can be built from. Expect most options to fail. A first round where two-thirds come back No is a working round, not a failed one.
- **Record feedback per element, not per option.** People rarely pick a whole option. They graft: "this nav, that hero, not its sidebar." A verdict format with only one score per option loses exactly the information the next round needs.
- **Write down the reasons behind each rejection as signals for the next brief.** "Sidebars and split panes read as busy" rules out a family of structures for the next round. A bare "No" teaches nothing, so the next round makes the same structural mistakes in new colors.

## Narrowing

1. **Range.** As many distinct directions as the review can absorb.
2. **Hybrids.** Combine the parts that earned Love or Promising, guided by the per-element notes.
3. **Finalists on a locked system.** Everything already agreed is written into the brief as "locked, do not reinterpret." Finalists vary only along named axes, such as the home scene, the nav indicator, and the card style, so the comparison isolates the open questions.
4. **Assembly.** Build the chosen parts as one system: one token set and one engine for each concern, such as motion, color, and images. Pages stapled together from different finalists don't count as assembly. Fidelity to the picks comes before invention in this round.

**When a whole round is rejected**, salvage before restarting. Pull every element any reviewer called out as good into a keep-list for each option, ask whether there's an existing product whose layout they'd point to, and rebuild the next round from that reference plus the keep-list. A total rejection is still a round of data about what *not* to build.

## Keeping what didn't win

- **Keep approved sections as records, not screenshots.** One record per section anyone approved: source option, page, selector, kind (nav, hero, listing, footer), verdict, and the reviewer's note verbatim. The next brief composes from records, so "that hero" has to resolve to code.
- **Save each kept design as one self-contained page plus a rebuild prompt.** The prompt lets an agent rebuild the page without the source: layout and grid, type, palette in both themes, each signature section in order, motion, and the phone collapse, all with concrete values. It names the one or two things that make the design work and what not to overdo, and says nothing about rounds or reviewers.
- **Keep a "good, but not for this" list.** Options rejected for this project but praised on their own go in a named list instead of being deleted. Those leftovers seed the pattern and page library.
- **Strip review-only tooling before anything ships or gets shown publicly:** effect on/off toggles, design switchers, grid overlays, and "back to gallery" links.
- **Gate publishing an exploration behind an explicit ready flag** tied to a content scrub, and mark published duplicates `noindex` so they don't compete with the real pages in search.

## Examples

- ✅ Forty builders each handed one named direction from a prewritten list — ❌ forty builders told "make it look modern," returning eight versions of the same glassy card grid
- ✅ "Keep: nav from 14, hero from 31. Drop: 31's sidebar, too busy" — ❌ "31: Promising"
- ✅ A round-3 brief listing the locked palette, type, and shell, then the three axes finalists may vary — ❌ a round-3 brief that says "refine the favorites"

## Gotchas

- **Symptom:** Thirty options and they all look alike. **Cause:** Each builder picked its own direction and converged on the safe default. **Fix:** Assign directions up front, one per builder.
- **Symptom:** Forty assigned directions still read as one site. **Cause:** The briefs varied style and left structure to the builder. **Fix:** Assign nav, hero and listing forms per brief.
- **Symptom:** Every demo has to be reworked before it can be compared. **Cause:** The brief let builders replace the app's chrome. **Fix:** Ship the shell as a fixed file in the brief and forbid app-level changes.
- **Symptom:** Round 2 repeats round 1's rejected structures in new colors. **Cause:** Verdicts were recorded as scores without reasons. **Fix:** Capture why each rejected option failed, and write those reasons into the next brief as rules.
- **Symptom:** The assembled design feels like several sites. **Cause:** Pages were taken whole from different finalists, each with its own tokens and motion. **Fix:** Rebuild the chosen parts on one token set and one engine for each concern.
- **Symptom:** A palette retune leaves stray off-brand color in glows, SVG fills, and focus rings. **Cause:** Only the main tokens were changed, and hard-coded color values hide everywhere else. **Fix:** Scan for the banned hue range until it reports zero; the full method is in [VISUAL.md](VISUAL.md).
