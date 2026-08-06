# Sources, currency, and corrections

Load when citing a rule, checking how well-evidenced a claim is, or deciding whether something here has gone stale.

Two source generations sit behind this skill. **v1.0** was built from a crawl of Figma's Resource Library "Design basics" section, roughly 50 articles, August 2026. **v2.0** rebuilt it against 20 practitioner and research sources, August 2026 — named authors and research organizations rather than a design-tool vendor's marketing library. Where the two disagree, the practitioner source wins, and the specific overrides are listed at the bottom.

## Read this before "modernizing" a number

Three claims here look dated and are not. Each was verified against a first-party source with the date recorded.

| Claim | Status | Verified against |
|---|---|---|
| **4.5:1 normal text / 3:1 large text and UI components** | **Current.** Do not replace with APCA. APCA was removed from the WCAG 3 draft in July 2023 after failing to reach working-group support; WCAG 3's contrast algorithm is undetermined, with finalization expected 2030 or later. If a project experiments with APCA, colors must still pass WCAG 2 or the non-compliance gets documented | adrianroselli.com, "WCAG3 Contrast as of April 2026" (10 Apr 2026) |
| **Nielsen's ten heuristics, unchanged since 1994** | **Current by design.** Published April 1994, last reviewed January 2024. The stability is the point for heuristics, and the limitation for anything touching current platform conventions | nngroup.com/articles/ten-usability-heuristics/ |
| **Response times 0.1s / 1s / 10s** | **Current but pre-mobile.** Published 1993, updated 2014 for web applications. No constrained-connection variant exists, so treat them as floors rather than as targets measured on cellular | nngroup.com/articles/response-times-3-important-limits/ |

## Primary sources by topic

**UI craft and visual rules**
- https://anthonyhobday.com/sideprojects/saferules/ — 28 concrete visual rules; the densest measurable-geometry source here. His own framing is that these are scaffolding you may break once you understand them, not universal law
- https://www.refactoringui.com/previews/building-your-color-palette · `/line-height-is-proportional` · `/labels-are-a-last-resort` — the three publicly readable chapters
- https://www.learnui.design/blog/the-3-laws-of-locality.html · `/3-pro-tips-on-alignment.html` · `/7-rules-for-creating-gorgeous-ui-part-1.html` (and part 2) — Erik Kennedy
- https://jgthms.com/web-design-in-4-minutes/ — Jeremy Thomas; the build-order sequence
- https://bradfrost.com/blog/post/atomic-web-design/ — Brad Frost, June 2013

**UX research and usability**
- https://www.nngroup.com/articles/ten-usability-heuristics/ · `/response-times-3-important-limits/` · `/error-message-guidelines/` (May 2023, 12-item rubric)
- https://baymard.com/blog — the only source here publishing sample sizes; see the caveat below
- https://lawsofux.com/ — Jon Yablonski; see the evidence split below

**Accessibility**
- https://inclusive-components.design/ — Heydon Pickering; eight component contracts in `COMPONENTS.md`
- https://adrianroselli.com/2024/02/dont-disable-form-controls (Feb 2024, updated 22 Jul 2026) · `/2026/04/wcag3-contrast-as-of-april-2026`

**Color**
- https://evilmartians.com/chronicles/oklch-in-css-why-quit-rgb-hsl — Andrey Sitnik, Travis Turner
- https://mattstromawn.com/writing/how-to-pick-the-least-wrong-colors/ (May 2022) · `/writing/generating-color-palettes/` (Apr 2024) — Matt Ström-Awn
- https://developer.chrome.com/docs/css-ui/high-definition-css-color-guide — Adam Argyle (last updated 2 Feb 2023)

**Typography** — this skill defers depth to the `typography` skill; these back the type claims that appear here
- https://practicaltypography.com/typography-in-ten-minutes.html — Matthew Butterick
- https://webtypography.net/ — Richard Rutter; measure at 45–75 characters, 66 optimal, `1em ≈ 2 characters`

**Ethics**
- https://www.deceptive.design/ — Harry Brignull; 18 pattern types, 60 indexed enforcement actions

**Practice and process**
- https://alistapart.com/article/good-designers-bad-websites-a-proposal/ — Alan Dalton, Apr 2026 (accessibility personas)
- https://www.smashingmagazine.com/2026/06/how-make-design-system-ai-ready/ — Vitaly Friedman, Jun 2026
- https://www.smashingmagazine.com/2026/07/designing-distressed-users-mental-health-apps-ui/ — Kat Homan, Jul 2026
- https://alistapart.com/article/design-dialects-breaking-the-rules-not-the-system/ — Michel Ferreira, Sep 2025 (component flexibility tiers)

## How well-evidenced each thing is

**Baymard is the strongest evidence here, and it is all e-commerce.** 150+ mobile sites and 71,000+ manually reviewed elements behind the mobile findings; 340+ sites behind the filtering findings. The figures encoded in this skill are the form-validation gap (93% of mobile sites lack adaptive validation messaging) and the navigation-scope gap (94%). Product-page and swatch findings were deliberately left out as too domain-specific. No confidence intervals are published, so a 28% and a 27% cannot be treated as different, and checkout findings do not generalize to non-payment forms.

**Laws of UX splits cleanly on citation quality.** Well-sourced, with the paper named: Fitts (1954), Doherty Threshold (Doherty & Thadani, IBM Systems Journal 1982), Miller (1956), Peak-End Rule (Kahneman et al. 1993). Weakly sourced, citing a blog or Wikipedia rather than research: Hick's Law, Jakob's Law, Postel's Law, Tesler's Law, Cognitive Load, Chunking. **Take the four numbered laws as rules and the rest as vocabulary.** The site warns against over-application on the Hick's page only, so that caution had to be stated in `INTERACTION.md` rather than inherited.

**Claims resting on partial reads**, flagged because the paywall matters:
- **Refactoring UI** — three preview chapters are public; the book is $99–149. Only rules from those three chapters are encoded. Third-party Medium and blog summaries of the paid book were reviewed and **deliberately excluded** as secondhand.
- **Practical UI** — the free blog was readable; the forms, buttons, and copywriting chapters are paid and were not. Its rules overlap Refactoring UI heavily and added no distinct thresholds.
- **Hobday's book** — table of contents only; chapter URLs 404. All 28 rules come from the free `saferules` page, which was fully readable.
- **Argyle's color guide** — the main page was readable; the function-by-function decision table lives on linked pages that were not retrieved. Only the space-vs-gamut distinction and the ~30% sRGB coverage figure are encoded from it.
- **betterwebtype.com** — HTTP 403 on every path, third consecutive research attempt to fail. Its numeric rules are **not encoded**; the one claim it corroborated (45–75 measure) is sourced to Rutter instead.
- **Growth.Design** — teardowns are illustrated and the visual argument sits inside images. Its metrics (+14% retention, 280% engagement) have no baseline or sample size and are **not cited anywhere in this skill**. Its one encoded contribution is the Duolingo exit-design finding in `ETHICS.md`, kept as a qualitative counterexample rather than a number.
- **Kennedy's color and data-viz articles** — five articles with no WCAG, no contrast ratios, and no colorblind-safe palettes; the data-viz piece is from April 2018 and his HSB material defers to experimentation instead of giving values. The Laws of Locality and the lighting model are encoded; the color framework is superseded by Ström-Awn and Evil Martians.

**One reported conflict that turned out not to exist.** A research pass reported NN/g's Heuristic 5 as recommending disabled submit buttons, which would have contradicted Roselli. Checked directly against the page: the heuristic reads "either eliminate error-prone conditions, or check for them and present users with a confirmation option before they commit to the action," and nowhere recommends disabling controls. There is no conflict — error *prevention* is not button disabling.

## Where this skill overrides a source

1. **Disabled controls — reversed in v2.0.** v1.0 said to disable a control and pair it with a message. A natively `disabled` control leaves the tab order and is exempt from contrast requirements, so both the control and the message become unreachable for the users who needed the message. Now: `aria-disabled="true"` with a guarded handler. Source: Roselli.

2. **Line-height — re-scoped, not rejected.** Figma gives 1.125–1.2 as the optimal leading range. That value is correct for *display* type; the error was presenting a headline figure as the body range. This skill uses ≥1.5 for body and states the inverse-to-size relationship, per Refactoring UI's "line-height is proportional" chapter and Hobday's rule 6.

3. **What a contrast ratio means.** Figma glosses 4.5:1 as "the lighter color is 4.5 times lighter than the darker color." The computation is `(L1 + 0.05) / (L2 + 0.05)` over relative luminance. The thresholds themselves are correct.

4. **Vision impairment prevalence.** Figma's UI-principles article says "more than one in four users worldwide"; its own accessibility article says 15% have any impairment (WHO). This skill cites the specific defensible figure — color vision deficiency at roughly 1 in 12 men and 1 in 200 women.

5. **Line length.** Figma gives 40–60 characters. This skill uses 45–75 targeting 66, with Rutter's `max-width: 33em` as the implementation. Figma's coupling rule — raise line-height when a line runs long — is kept and generalized into the size/leading/measure triangle.

6. **Baseline grids — split rather than dismissed.** v1.0 called hard grids "largely obsolete for screens" and dropped the whole idea. Rutter agrees pixel-perfect baseline *alignment* is unachievable on the web and not worth the cost, but holds that vertical spacing as *multiples of the base leading unit* is non-negotiable. `LAYOUT.md` now keeps the arithmetic and drops only the snapping.

7. **Spacing scale.** v1.0 said scales "start at 2px and run to about 64px." Refactoring UI's ladder is 4→96px and is perceptually distributed rather than evenly spaced. A 2px floor invites decisions below the perceptual threshold.

8. **Corner targeting.** Figma's "magic pixel" framing treats screen corners as the hardest targets; Tognazzini treats a screen edge as effectively infinite and therefore easiest. Both hold in context, and `INTERACTION.md` states which applies when rather than picking one.

9. **Golden ratio.** Present in Figma's library (Φ = 1.618, with 1000/618/382/236 as stops) and omitted here — it competes with the base-unit spacing scale that actually gets implemented, and Figma itself says to abandon it whenever it threatens usability. Kennedy independently rejects golden-ratio reasoning in favor of application over theory.

## Still not covered

Gaps that remain after the v2.0 rebuild, so nobody assumes silence means settled:

- **Motion and animation.** The single largest hole. `INTERACTION.md` has three bullets and the 100–200ms transition range; none of the 20 sources covers motion design well, and the research pass confirmed the gap rather than filling it.
- **Internationalization and RTL layout.** Mentioned only as "a translated string runs 40% longer."
- **Dense data UI** beyond the table contract in `COMPONENTS.md`.
- **Core Web Vitals numeric thresholds**, click-depth rules, card-sorting participant counts, and tree testing — inherited gaps from v1.0, unfilled.
