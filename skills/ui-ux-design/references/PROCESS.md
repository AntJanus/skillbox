# Process

Load when planning research, choosing an artifact fidelity, running a usability test, or assembling a pre-launch checklist.

## Pick the artifact by the question you're asking

Fidelity and interactivity are **independent axes**, and the common names conflate them. A high-fidelity wireframe and a mockup are both static; what earns the word *prototype* is interactivity, not polish.

| Artifact | What it is | Answers |
|---|---|---|
| Wireframe | Grayscale blueprint, placeholder content | Is the structure and flow right? |
| Mockup | Polished but static | Does the visual direction hold? |
| Prototype | Interactive, any fidelity | Does the interaction logic work? |
| MVP | A real shipped product, pared to core features | Does anyone want this? |

**Match fidelity to confidence, not to calendar position.** There is no mandatory low-to-high ladder — pick the cheapest artifact that answers the question in front of you. Medium fidelity is the practical default for fast iteration; low-fi cannot answer questions about pixel-precise interaction, animation, or functional stress, and high-fi is wasted before the flow is settled.

**Grayscale early, on purpose.** Unstyled elements keep review comments on structure. Polish reliably redirects feedback to color and copy, which is the wrong conversation while the flow is still moving.

**Wireframes are disposable.** Make them, get the input, let them go. Even a high-fidelity wireframe is a rough draft.

**Use real content sooner than feels natural.** For anything content-rich, lorem ipsum hides the layout's actual failure modes.

Canonical frame sizes for layout work: **mobile 393×852, tablet 834×1194, desktop 1440×1024.** The most common mobile viewport in the wild is 360×800 — a better small-screen target than the 375px iPhone width.

## Two different testing disciplines

They fail differently and are not substitutes.

**Usability testing** asks *can a person do this?* It needs users.

- **3–5 participants per group.** Five find roughly 85% of usability problems. Run several small batches rather than one large study.
- Seven steps: define the goal and audience → set evaluation criteria *before* testing → recruit → write the script (intro, consent, tasks, follow-up) → **run a pilot** to check the script and tooling → analyze → iterate.
- Four question types: background, task-based (neutral, outcome-worded, never leading), follow-up (the "why" when behavior surprises you), reflection.
- Measure: task completion rate, time on task, error rate, clicks to completion, drop-off point. SUS scores read as 80+ excellent, 68–79 above average, 60–68 average, 50–60 okay, below 50 poor.
- Test the prototype — don't wait for production code. Don't test whether people *like* the colors; test whether they can finish.
- Guerrilla and hallway testing surface obvious blockers only. Useful, bounded.

**UX validation** asks *does this hold up under real data, real states, and real engineering constraints?* It needs **zero users**, which makes it the cheap one an agent can actually run:

- **Heuristic evaluation** — audit against established usability heuristics.
- **Prototype stress-testing** — walk the flow hunting for where logic breaks: error states, edge cases, unexpected input, everything past the happy path.
- **Accessibility audit** — screen reader, keyboard-only, zoom to 200%.
- **Technical review** — walk it with engineers to catch infeasible or expensive assumptions early.

Its three named failure modes map straight onto code: ignoring real-world data behavior; leaving the in-between moments (hover, loading, dismissal, transitions) unspecified so implementation invents them; and deferring technical validation until handoff, when a minutes-to-fix logic gap becomes a days-to-fix one.

## Research and framing

The five-stage arc — empathize, define, ideate, prototype and test, implement — is explicitly non-linear. Loop back, repeat, run stages in parallel.

Evaluate any concept against three lenses: **desirability** (does it meet a real need), **feasibility** (can we build it), **viability** (does it work for the business long-term).

Questions worth asking at each stage:

- **Discovery** — Who is this for, and what do we *know* versus *assume*? What are they doing today instead? What's the context — device, environment, time pressure, emotional state?
- **Design** — Does this address the goal or a symptom? Are we designing for the happy path only? Which assumptions are still untested? What new friction does this add?
- **Testing** — Can they finish without instruction? Where do they hesitate or backtrack? Did what they expected match what happened?
- **After** — Where are they dropping off, and what does the pattern say? What's the single next most valuable improvement?

Four framing mistakes and their replacements: designing for the team → *would a first-time user understand this without help?* · treating generated output as validated → *what real evidence supports this direction?* · asking user questions only during a research phase → *what do we know that should influence this specific decision?* · recording what users did without why → *what were they trying to accomplish when they stopped?*

Hear past the requested solution to the underlying problem. And a product can be visually excellent and still fail completely — Apple Maps shipped beautiful and sent people to places that didn't exist.

## Scope

- **MoSCoW**: must-have, should-have, could-have, won't-have. The last bucket is a decision, not an omission — write it down.
- **Useful → Viable → Delightful**, in that order. Proving something works comes before proving it sustains, which comes before polish.
- **One goal per artifact.** Don't build the whole journey to test one feature.
- Connect every feature to the product's primary goal; a feature that doesn't support a user task doesn't ship in v1.

## Before launch

Five test types, all of them: **usability, accessibility, performance** (speed, load, battery under varied conditions), **compatibility** (devices and OS versions), and **QA**.

**Friction logging** — walk your own product as a user with a specific goal and write down every place you hesitate, backtrack, or squint. Cheap, and it catches things no test plan asked about.

Instrument the funnel: task success rate broken down **per feature** (a high overall number hides friction in one flow), time on task read *alongside* success rate (a slow finisher is still struggling), and satisfaction scores understood as lagging indicators that confirm what behavioral metrics already told you.

**Book the feedback slot before building the prototype.** Scheduling review after the work is done is the reliable way to prevent the feedback from happening at all.
