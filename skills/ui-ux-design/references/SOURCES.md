# Sources and corrections

This skill was built from a crawl of Figma's Resource Library "Design basics" section (https://www.figma.com/resource-library/design-basics/) across roughly 50 articles, August 2026. Load this file when citing a rule or checking why a claim here differs from its source.

## Primary sources

**Foundations**
- https://www.figma.com/resource-library/what-is-ux-design/
- https://www.figma.com/resource-library/what-is-ui-design/
- https://www.figma.com/resource-library/difference-between-ui-and-ux/
- https://www.figma.com/resource-library/ui-design-principles/
- https://www.figma.com/resource-library/what-is-product-design/
- https://www.figma.com/resource-library/what-is-design-thinking/

**Interaction**
- https://www.figma.com/resource-library/button-states/ — the densest and most directly codeable page in the library
- https://www.figma.com/resource-library/interaction-design/
- https://www.figma.com/resource-library/fitts-law/
- https://www.figma.com/resource-library/gestalt-principles/
- https://www.figma.com/resource-library/what-is-visual-hierarchy/
- https://www.figma.com/resource-library/golden-ratio/

**Process**
- https://www.figma.com/resource-library/ux-validation/
- https://www.figma.com/resource-library/usability-testing/
- https://www.figma.com/resource-library/user-centered-design-questions/
- https://www.figma.com/resource-library/what-is-wireframing/
- https://www.figma.com/resource-library/wireframe-vs-mockup/
- https://www.figma.com/resource-library/what-is-prototyping/
- https://www.figma.com/resource-library/low-fidelity-prototyping/
- https://www.figma.com/resource-library/high-fidelity-prototyping/
- https://www.figma.com/resource-library/what-is-rapid-prototyping/
- https://www.figma.com/resource-library/user-flow/
- https://www.figma.com/resource-library/what-is-information-architecture/
- https://www.figma.com/resource-library/user-journey-map/
- https://www.figma.com/resource-library/what-is-a-minimum-viable-product/
- https://www.figma.com/resource-library/how-to-design-an-app/

**Layout and web**
- https://www.figma.com/resource-library/web-design-grid-layout-examples/
- https://www.figma.com/resource-library/website-layout-ideas/
- https://www.figma.com/resource-library/responsive-website-design/
- https://www.figma.com/resource-library/graphic-design-principles/
- https://www.figma.com/resource-library/landing-page-examples/
- https://www.figma.com/resource-library/pricing-page-best-practices/
- https://www.figma.com/resource-library/portfolio-website-examples/
- https://www.figma.com/resource-library/what-is-web-design/
- https://www.figma.com/resource-library/web-design-and-development/
- https://www.figma.com/resource-library/web-development-trends/

**Systems**
- https://www.figma.com/resource-library/design-tokens/
- https://www.figma.com/resource-library/design-system-examples/
- https://www.figma.com/resource-library/automated-ui-handoff/
- https://www.figma.com/resource-library/ux-for-product-managers/

**Visual and brand**
- https://www.figma.com/resource-library/typography-in-design/
- https://www.figma.com/resource-library/types-of-color-palettes/
- https://www.figma.com/resource-library/color-symbolism/
- https://www.figma.com/resource-library/what-is-color-theory/
- https://www.figma.com/resource-library/what-is-a-style-guide/
- https://www.figma.com/resource-library/storytelling-in-design/
- https://www.figma.com/resource-library/types-of-logos/
- https://www.figma.com/resource-library/how-to-design-a-logo/

**Statistics** (all figures in this skill trace to these two pages and the studies they cite — WebAIM 2025, HTTP Archive 2025–26, Contentsquare, Baymard, Adobe, Statcounter)
- https://www.figma.com/resource-library/web-design-statistics/
- https://www.figma.com/resource-library/design-statistics/

## Where this skill deliberately diverges from its source

1. **Line-height.** Figma's typography article gives 1.125–1.2× as the optimal leading range. That is a display and print-headline figure; applied to screen body copy it produces cramped text. This skill uses **≥1.5 for body**, consistent with screen-readability guidance and with the `typography` skill's readability floor.

2. **What a contrast ratio means.** The color-palettes article glosses 4.5:1 as "the lighter color is 4.5 times lighter than the darker color." That is not how it's computed — the ratio is `(L1 + 0.05) / (L2 + 0.05)` over relative luminance. The 4.5:1 and 3:1 thresholds themselves are correct.

3. **Vision impairment prevalence.** The UI-principles article states "more than one in four users worldwide" have a vision impairment; the accessibility article on the same site says 15% of the global population has *any* impairment (WHO). The two are inconsistent. This skill cites the specific, defensible figure instead — color vision deficiency at roughly 1 in 12 men and 1 in 200 women.

4. **Corner targeting.** Figma's "magic pixel" framing treats screen corners as the hardest targets. Tognazzini's well-known reading treats a screen edge as an effectively infinite target and therefore the easiest. Both are correct in their own context; `INTERACTION.md` states which applies when rather than picking one.

5. **Line length.** Figma gives 40–60 characters. This skill uses the conventional **45–75**, but keeps Figma's genuinely useful coupling rule: if a line must run longer, raise line-height to compensate.

6. **Golden ratio.** Present in the source (Φ = 1.618, with 1000/618/382/236 as derived stops) but omitted from the skill body — it competes with the base-unit spacing scale, which is what actually gets implemented, and Figma itself says to abandon it whenever it threatens usability or readability.

## Gaps the source does not cover

Not present anywhere in the library, so anything this skill says about them comes from elsewhere (WCAG, platform HIGs, web.dev) rather than Figma: breakpoint pixel values and per-breakpoint column counts, Core Web Vitals numeric thresholds, form-field-count and menu-item-count guidance, click-depth rules, flowchart shape conventions (rectangle/diamond/oval), card-sorting participant counts, and tree testing. Nielsen's ten heuristics are referenced by the source as a method but never enumerated there.

## Figma-product mechanics, deliberately excluded

Dev Mode, Code Connect, the Figma MCP server, Variables and modes as a product feature, Auto Layout, component properties, Figma Make, and FigJam are the tooling through which the source expresses several of these ideas. The underlying principles are tool-agnostic and are stated that way here; the product mechanics are not reproduced.
