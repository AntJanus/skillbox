# Design systems, tokens, and handoff

Load when building or extending a design system, writing a token file, or setting up how design reaches code.

## What a design system is made of

Four parts, and the third is the one people leave out:

- **UI kit** — the reusable building blocks: buttons, fields, icons.
- **Design tokens** — the values: color, spacing, type.
- **Patterns** — how elements *behave*. A navigation bar or a modal is a pattern, not a component: it specifies dismissal, focus trapping, and what happens on a small screen. Behavior is the axis that separates a pattern from a UI kit entry.
- **Documentation** — covering *when* to use each thing, not only how. A component with no usage guidance gets used wrong.

## Tokens

Three tiers:

```json
{
  "blue-500":              "#4F46E5",           // primitive — raw value, no context
  "color/action/primary":  "{blue-500}",        // semantic  — the role it plays
  "button/background":     "{color/action/primary}"  // component — bound to one element
}
```

- **Naming: `category/role/variant`.** `color/action/primary`, `color/text/disabled`, `space/inset/sm`.
- **Name for what it does, not what it is.** `text-secondary`, never `gray-text` — the second name is a lie the moment the brand changes.
- **Semantic tokens point at primitives. Never at other semantic tokens.** Alias chaining is the specific thing that makes token systems unmaintainable, and it's the mistake a generator makes by default.
- **Themes are modes on one token set.** `text-primary` resolves per mode. A parallel `.dark .button {}` override tree is the failure mode — it doubles maintenance and drifts within a release.
- Cover **text, background, border, and action** first; those four roles carry most of an interface.
- Skipping the semantic tier means every primitive change becomes a hunt through every component.
- Store as JSON name/value pairs — machine-readable, portable across web, iOS, and Android, and the shape the W3C Design Tokens format is converging on. In CSS they surface as custom properties (`--color-action-primary`).
- **Spacing scale: 4 → 96px, perceptually distributed.** `4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96` — steps sit close together at the small end and widen at the large end, because that's where a difference is still visible. An evenly-spaced scale wastes half its steps on distinctions nobody sees. Even values only, to avoid sub-pixel rendering; a 2px floor invites decisions below the perceptual threshold.

## Component tiers and how much may change

**Atomic Design's vocabulary** (Frost, 2013) is still the shared language most systems use: **atoms** (HTML primitives and abstract values — a label, an input, a color), **molecules** (a few atoms bonded into something that does one job — label + input + button = a search form), **organisms** (distinct interface sections — a masthead, a product grid), **templates** (organisms arranged, showing structure), **pages** (templates filled with real content).

The tier that earns its place is the last one. **Templates-to-pages exists specifically to expose variation** — text lengths, data volumes, missing values — which is the same job as "break it with real data" in SKILL.md, with a name and a citation. A component-only model has nowhere for that step to happen.

**State how much each component may be changed**, because a token hierarchy answers what values exist and not who may deviate:

| Tier | Contract |
|---|---|
| **Consistent** | Adopt unchanged. Deviation is a bug |
| **Opinionated** | Adapt within stated bounds |
| **Flexible** | Extend freely |

Document every deviation, promote the ones that prove out into the system, and deprecate with the reason attached.

## Making the system machine-readable

The consumer of a design system is now often an agent, and an agent fills gaps by inventing values. Three layers close them:

1. **Spec files** — the rules and their priorities as structured Markdown, not tribal knowledge. What isn't written down gets guessed.
2. **A closed token set** — no arbitrary values permitted. An open set is exactly the affordance that lets a generator emit `#3a7bd5` next to your `--color-action-primary`.
3. **Audit scripts** — fail the build on hard-coded values and detached instances. This is the external gate; the other two layers are only documentation without it.

A side effect worth expecting: writing the spec files surfaces undocumented decisions that were never actually agreed.

## Systems worth reading before building your own

| System | Notable for |
|---|---|
| Material Design 3 | Dynamic color adapting to user preference; the most complete public spec |
| IBM Carbon | Documents design *and* front-end code together, with strong accessibility standards |
| Shopify Polaris | Content and voice guidelines alongside the components |
| Atlassian | Cross-product consistency across separately branded products |
| Apple HIG | The definitive reference for Apple platforms |
| Uber Base | One framework under services with distinct user-facing identities |

The pattern to copy: the systems that hold up ship **content guidelines and accessibility standards as part of the system**, not as a separate document nobody opens.

## Handoff

Six ways design-to-code handoff breaks, all of them recognizable:

1. **Version drift** — the design moves while implementation is mid-flight.
2. **Naming mismatch** — `Button/Primary/Large` in the design file, `PrimaryButton` in the repo. Every lookup costs a translation.
3. **Structural mismatch** — one side sees a visual layout, the other sees a conditional, responsive component tree. Same file, different objects.
4. **Reverse engineering** — the implementer infers intent instead of reading it.
5. **Late engineering involvement** — whoever arrives last finds the structural problems, and by then they cost rework.
6. **Gatekeeping** — work blocks on one person packaging it up.

What an implementer should actually receive: component properties and variants, real measurements and spacing values, the token values behind them, prop names matching the design's variant axes, and — where the tooling supports it — the import path of the existing component in their own repository, so the answer to "build this button" is "use the one you already have."

Rules that hold regardless of tooling:

- **Automation is not documentation.** Generated specs remove the back-and-forth on measurements; they capture nothing about intent. Intent still has to be written down somewhere findable.
- **Structure precedes automation.** Inconsistent naming produces inconsistently generated output. Fix the naming first.
- **Mappings rot.** What was accurate six months ago may not describe production now; treat the mapping as maintained, not configured once.
- **Validate before handing off**, so nobody implements a design that hasn't survived its own edge cases.
- Start with the lightweight option. Add generation and repo mapping once the system is stable enough that the mapping is worth maintaining.

## Working with generated code

- Nothing generated ships without review. Require tests covering functionality, accessibility, and security, and require the comments and README that make it maintainable six months out.
- Generated UI reaches for ARIA and utility soup by default. Check that the native element wasn't available, and that the token exists before a raw hex appears in a component.
