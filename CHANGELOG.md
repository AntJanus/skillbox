# Changelog

All notable changes to SkillBox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

From a full manual read-through of all 72 tracked files (13,150 lines) — every file read end to end rather than grepped, with each numeric and behavioral claim re-verified by execution. Privacy scan came back clean across the whole repo.

- **ideal-react-component** (v1.7.2 → **v1.7.3**, patch): `reference/HOOKS-ANTIPATTERNS.md` stated React's lazy-initializer semantics **backwards** — "function initializers (`useState(() => expensive())`) also run every render but discard results after first render". The opposite is true: the lazy form runs once, the *eager* form `useState(expensive())` re-evaluates every render. It also contradicted a correct line two bullets above it in the same list.
- **color-system** (v1.3.0 → **v1.3.1**, patch): `references/palettes.md` warned that Terracotta `primary #c2410c` is "≈3.4:1 on white — use as a fill or step to `#9a3412` for text". Recomputed: **5.18:1**, which clears AA for body text; the 3.56:1 figure belongs to the lighter `#ea580c`, a different shade. The watch-out now names the right hex and keeps `#9a3412` (7.31:1) as an AAA option. Gold corrected 7.9 → **7.69:1**. `references/theory.md` dropped the unsourced "red text reports the highest visual fatigue; yellow the lowest" claim — nothing in the file's own Sources block supports it, and it was the one unhedged assertion in a section explicitly framed as weak heuristics; replaced with why hue-fatigue claims resolve to saturation and contrast.
- **typography** (v1.3.0 → **v1.3.1**, patch): `references/scale.md` recommended `line-height: clamp(1.3, 0.9rem + 0.4vw, 1.6)` — **invalid CSS**, since `clamp()` cannot mix `<number>` bounds with a `<length>` preferred value, so the declaration is dropped and the inherited leading silently applies. There is no unitless fix (`vw` is a length); the section now gives the all-length form with its inheritance caveat and a unitless breakpoint alternative. Also: the "worked example — base 16, ratio 1.2" listed `12 · 14 · 16 · 20 · 24 · 30 · 36 · 48` and claimed "each step is the prior × 1.2" — false for **5 of its 7** steps (ratios run 1.14–1.33). Now shows the real ×1.2 derivation, and keeps the hand-tuned scale as an explicitly-labelled alternative.
- **generate-skill** (v3.2.0 → **v3.2.1**, patch): the Phase 3 template emitted `argument-hint: [<short-token>]`, which YAML parses as a **sequence**, not a string — so every generated skill received the wrong type, while generate-skill's own frontmatter correctly quoted it. Now quoted, with a new ❌ anti-pattern so it can't recur. Removed `hooks` from the "Unexpected key" cause list, which contradicted the same file's own three-tier note listing it as a valid Claude Code key. Dropped the time-bound "following 2026-05 conventions" label — already rotted past the 2026-07-02 re-validation, and `rate-skill` penalizes exactly that pattern. Moved the portability note below the anti-pattern bullets it was splitting.
- **rate-skill** (v3.1.1 → **v3.2.0**, minor): **length rubric was inverted** — `−20 per 50 lines over 300` scored a 500-line skill at 20, while `>500 lines without references/: cap at 40` scored a longer, worse-structured skill at 40. Rebuilt as `−10 per 50` plus an additional `−30`/`−20` past the hard cap, verified monotonic (`100 → 90 → 70 → 60 → 30 → 10`). **Type taxonomy realigned** to generate-skill's five (`methodology`/`technical`/`auditing`/`reference`/`automation`); the previous four (`methodology`/`reference`/`generator`/`auditor`) shared only two names, so a skill generated as `technical` or `automation` had no structure profile and §4 was undefined for it — the Output Format template was carrying the stale list too. Stopped endorsing `"ALWAYS invoke when…"` as "a stronger" register in §1 while §7 deducted 20 for that framing. Verification Checklist downgraded from a −20 requirement to a noted recommendation, matching both `generate-skill`'s optional marking and the repo's own 3-of-5 practice. `references/EXAMPLES.md` no longer shows top-level `hooks` in a ❌ block that the rubric explicitly says not to penalize.

### Changed

- **local-first-app** (v1.7.0 → **v2.0.0**, major): closes the **identity gap** found by auditing eight sibling apps against one built from the skill alone. The blueprint specified architecture but not identity — shell, logo, fonts, type-scale values, theming mechanism, empty-state recipe, and delete-confirm pattern lived only in sibling repos and propagated by hand-copying, so a fresh build complied with every stated rule and still came out visually unrelated. New **`references/CHROME.md`** makes that layer canonical with copyable implementations: the `AppShell layout="alt"` recipe (64px header, 264↔72px collapsible sidebar persisted to `localStorage`, mobile burger drawer), a two-weight wordmark `Logo`, `@tabler/icons-react` as the pinned icon library, the theme base with actual `fontSizes` values, and four shared shells — `PageShell`, `EditorShell` (7/5 split with a sticky preview at `top: 80`), `StatTile`, `EmptyState`.
  **Two breaking rule reversals.** (1) The "one sanctioned modal is `openConfirmModal`" rule is replaced by a hand-rolled controlled `<Modal>` (`ConfirmDeleteButton`) covering both plain confirms and option-carrying ones (cascade counts, an "also delete the source file" checkbox); `@mantine/modals` and `<ModalsProvider>` leave the stack entirely. (2) Tests move from colocated `*.test.ts` to a top-level `tests/` directory with a shared `tests/shims/` set (`next-cache`, `next-navigation`, `node-sqlite`, `server-only`) — the shims are the real payload, since anything touching the DB or a `server-only` module is unimportable under vitest without them.
  **Theming is now specified, and server-side.** Both axes — the named theme *and* the light/dark scheme — persist in the settings table and render into `<html data-theme>` + `forceColorScheme`, so there is no pre-paint script, no flash, and no hydration mismatch to design around. A consequence worth the choice: the header toggle renders the correct icon directly instead of rendering both and hiding one.
  **The `fontSizes` instruction was satisfiable and still wrong** — "override the entire scale explicitly" names no values, and a fully-compliant app landed `xs` at 14px, under the readability floor. Now stated as floor-is-the-rule (smallest token ≥1rem, line-height ≥1.5, weight ≥400, contrast ≥4.5:1) with a known-good scale (xs 1rem → xl 1.5rem) as the default implementation, plus the `Badge --badge-fz` / `textTransform` workarounds the scale alone doesn't reach. The font stack is pinned as a swappable default (IBM Plex Sans / Space Grotesk / IBM Plex Mono) with the three roles and variable names held fixed.
  **Two live bugs promoted to Gotchas.** (1) A **new migration never applies while the dev server runs** — the `globalThis.__db` cache correctly survives HMR, but migrations only run inside `openDatabase()`, which the cache skips; queries against new columns 500 while tests and fresh boots pass, so it reads as broken code rather than a stale schema. Fix: re-run migrations once per *module* load, since module state resets on HMR while the `globalThis` cache doesn't, gated on `user_version`. (2) **`lightHidden`/`darkHidden` lose to an inline `display` style** — Mantine's visibility props work through a class with no `!important`, so `<Box lightHidden display="inline-flex">` renders anyway and a dark/light toggle shows both sun and moon; it spread across an app family by copy-porting before manual QA caught it.
  **DB hardening backported** into `references/ARCHITECTURE.md`: a pre-migration `VACUUM INTO` snapshot with 20-file rotation (gated on pending migrations — local-first means there is no server-side copy of a user's data), `PRAGMA optimize` moved to run **after** `migrate()` rather than before (running it first analyzes a schema the migration then replaces), and boot-time force-resolution of background-job rows left `running` by a dead process. Also documents an MCP endpoint at `app/api/mcp/route.ts` wrapping the existing `lib/` loaders as read tools.

- **color-system** (v1.2.1 → **v1.3.0**, minor): added the **Teal Slate** web-app UI palette — deep teal on cool slate with a single warm amber accent (doubling as `accent`/`warning`), full 13-role light+dark tables plus the shipped extended tokens (hue-wash soft fills, faint ink, strong lines, shadow recipe). Pairs with a mono face for labels/figures. Contrast-verified: text 7–17:1, primary-as-text 6.0/7.2, faint ink clears the 3:1 UI floor by design. Listed in the SKILL.md quick index under Web App UI.

## [4.10.0] - 2026-07-14

### Changed

- **local-first-app** (v1.6.0 → **v1.7.0**, minor): documented **bulk edit as a selection *mode*** — a new UI pattern in the "CRUD as screens" section, built and verified live in a five-library tracker app. A non-empty selection takes over the app chrome (the sidebar nav slot becomes a batch bar: "N selected", one control per batchable field, an ✕ to deselect); it is the one place the blueprint's "URL is the state" rule does not apply, since a selection is ephemeral mode state rather than a navigable location. Four load-bearing rules: a **sparse patch** (absent key = leave alone, explicit `null` = clear — different writes, and a `.strict()` zod schema so a typo'd field errors instead of stripping into a successful no-op); **all-or-nothing** writes (validate every id before writing any, one transaction); **selection prunes to the visible rows** (or the bar says "3 selected" while writing to a fourth row the user can't see — and the prune must return the same array reference when nothing changed, or the sync effect loops forever); and **`uniform` vs `mixed` per field**, where a *shared absent* value is `uniform: null`, not `mixed`. Selection state hoists into a context provider above the app shell (the bar renders into the chrome, the checkboxes render inside the page — siblings), keyed by pathname with liveness **derived** from the current path, because child effects run before parent ones and a provider-level "clear on navigate" effect would wipe the registration the page just made. `references/UI.md` gains the full anatomy (chrome takeover, the collapsed-rail and mobile-drawer consequences, reusing single-item setters inside the batch transaction so batch and per-item edits can't drift apart, header select-all meaning post-filter rows only).
  Two new Gotchas, both found live and both of which read exactly like real bugs in the wrong layer: (1) **a checkbox nested inside a card-wide `<Link>` silently desyncs** — `preventDefault()` (needed to stop the anchor navigating) also cancels the checkbox's activation behavior, but React's input value-tracker already recorded the intermediate `checked`, so the re-render sees no diff and never writes it back, leaving the box unchecked while the row is genuinely selected; it's racy (one of two clicked cards broke), so it survives a casual click-test, and the real fix is structural — link the cover and title, not the whole card, since interactive content inside an `<a>` is invalid HTML. (2) **a `globalThis`-cached store *object* pins its methods across HMR** — the dev server throws `db.newMethod is not a function` from provably correct, fully-tested code until it's restarted (impossible in production: one process, built once). The blueprint's own shape is immune, and `references/ARCHITECTURE.md` now says why as a first-class rule — **cache the handle, not the query API**: `globalThis.__db` holds the bare `DatabaseSync` while the query functions stay free functions taking `db`, which is both the injection seam that lets a unit test pass an in-memory DB and the reason a re-evaluated module re-exports its new functions. Caching an object of methods forfeits both.

## [4.9.0] - 2026-07-05

### Changed

- **typography** (v1.1.0 → **v1.3.0**, minor): from a live, multi-agent cross-repo audit of five Next.js + Mantine apps (all sharing one blueprint) that kept rendering "too small / low-contrast / ugly serif" despite the v1.1.0 fixes. Two new Gotchas (v1.2.0): a `next/font` `.variable` class scoped to `<body>` while the UI library injects its font-family at `:root` (Mantine's `:root, :host { --mantine-font-family: var(--font-body) } ` pattern) makes the variable reference guaranteed-invalid — CSS custom properties don't inherit upward — silently collapsing every styled element to the browser's default serif, invisible from source review (confirmed live via `getComputedStyle`, reproduced in 4 of 5 audited apps); and several Mantine components (Table, NavLink, Tooltip, Menu, Alert, Notification, Tabs, Input label/description) default to sub-16px sizes internally even when the app author writes no `size` prop at all — grepping for `size="xs"/"sm"` misses this class entirely. `references/fonts.md` (v1.3.0): the audited apps' serif fallback rendered badly everywhere it leaked past the page-level heading, matching a common editorial-typography preference — serif reads well on a title, not on the rest of the hierarchy. Added an explicit "scope a serif accent to the single largest page-level heading — nowhere else" rule (never on h2-h6, chrome, or tracked ALL-CAPS labels — small/letter-spaced serif reads as broken, not editorial) plus a curated low-risk pairing list for exactly that pattern: IBM Plex Serif → IBM Plex Sans (superfamily), Newsreader → Inter, Fraunces → Inter.
- **local-first-app** (v1.4.0 → **v1.6.0**, minor): added the same next/font+Mantine wiring gotcha to the Conventions list and expanded `references/UI.md`'s Legibility section with it plus the "component defaults ship sub-floor even when unstyled" gotcha (v1.5.0) — this blueprint pins the exact Next.js+Mantine+next/font stack where the bug reproduces, so the guidance belongs here as a first-class convention, not just a typography-skill footnote. Also (v1.6.0): documented the Mantine-vs-headless-alternative tradeoff directly in the stack table — sub-floor component defaults are a known weakness, not a reason to swap the library (a shadcn/Radix/Base UI migration would cost a real rebuild of AppShell/Table/dates/charts this blueprint leans on) — the fix is overriding the full `fontSizes` scale explicitly and treating bare small/dimmed props as needing justification.
- **color-system** (v1.2.0 → **v1.2.1**, patch): the "dimmed lands ~3.4:1" gotcha now also calls out re-verifying contrast on tinted/elevated surfaces (cards, striped rows), not just the flat canvas — a ratio that passes against the base background can still fail once the same text sits on a lighter/darker surface, found during the same cross-repo audit.

## [4.8.0] - 2026-07-03

### Changed

- **typography** (v1.0.1 → **v1.1.0**, minor): added a "Verify computed, not authored" callout after the readability-floor table, plus two new Gotchas, from a cross-repo audit of typography complaints across three Mantine-based apps (all three independently hit "everything's too small" despite source-level fixes). New Gotcha 1: size-token names lie (Mantine `size="sm"`/`"xs"` compute to 14px/12px, Tailwind `text-sm`/`text-xs` likewise, both under the 16px floor) and nested `em` units compound multiplicatively per level — fix by reading the *computed* font-size in devtools rather than the source class/token, and preferring `rem` for font-size. New Gotcha 2: chart/graph text (Recharts, Mantine charts) renders as SVG with its own inline `font-size`/`fill` that bypasses the CSS type scale and color tokens entirely — fix by targeting the library's text elements directly and re-verifying the computed size/color.

- **color-system** (v1.1.1 → **v1.2.0**, minor): added two Gotchas from the same cross-repo transcript audit, this time confirmed across all four apps. New Gotcha 1: component-library "dimmed"/muted-text tokens (e.g. Mantine's `dimmed`) ship tuned for visual hierarchy, not contrast, commonly landing around ~3.4:1 against the 4.5:1 AA floor (one app measured exactly this, then fixed it to 6.8:1 light / 6.9–7.6:1 dark across 139 usages) — fix by verifying your own `text-secondary` hex per theme rather than trusting the library default. New Gotcha 2: chart/SVG text carries its own inline `fill` that bypasses your color tokens entirely (the color-domain counterpart to typography's new chart-text gotcha) — fix by targeting the library's text elements directly.

## [4.7.0] - 2026-07-02

### Changed

- **setup-semantic-release** (v1.2.1 → **v1.3.0**, minor): modernized the taught package set to current majors — `semantic-release@^25.0.0` (v25.0.0's only breaking change is the Node floor: `^22.14.0 || ≥24.10.0`, dropping Node 20/21/23; no config or plugin API changes, so the `.releaserc.json` as taught remains valid) and `@commitlint/cli` + `@commitlint/config-conventional` `@^21.0.0` (v21 requires Node ≥22 and changes CLI output formatting only; v20's sole break — `body-max-line-length` ignoring URL lines — is moot since the skill disables that rule). Prerequisite line updated to the new Node floor. Live-verified on Node 24.11.1: clean install of the exact pinned set, the skill's `commitlint.config.js` accepted verbatim (`feat: test message` → exit 0, `bad message` → exit 1 with subject/type errors), semantic-release 25.0.5 resolved with all bundled default plugins.

- **Convention re-validation corrections** (from a 2026-07-02 research pass against the current Anthropic skill-creator + packaging validator, code.claude.com skill docs, and the agentskills.io spec): **generate-skill** (v3.1.1 → **v3.2.0**, minor) — Phase 3 now documents the verified three-tier frontmatter reality (universal spec keys vs Claude Code extension keys vs Anthropic's repo packaging validator, with the note that the Vercel `npx skills add` channel tolerates the CC extensions — verified live), adds `when_to_use` and the ~1,536-char combined CC listing cap to the optional-fields table, removes `hooks` from the "unexpected key" error list (it's a valid CC runtime key; only the packager rejects it), reframes the `## Gotchas` mandate and ✅/❌+230-char guidance as house convention rather than spec, softens the singular-`reference/` "anti-pattern" language to "plural for new dirs, never rename for style", and aligns the arXiv 2602.11988 summary with the paper's abstract (verified real — "context files generally don't improve task success while adding >20% inference cost"). **rate-skill** (v3.1.0 → **v3.1.1**, patch) — Seleznov claim corrected to "~20× higher activation odds (CMH OR 20.6)" (it's an odds ratio, not a reliability multiplier), the singular-`reference/` −10 deduction downgraded to a no-point style note, and a new gotcha stops the rater from penalizing CC extension keys (`argument-hint`, `hooks`, `paths`, `when_to_use`). **CLAUDE.md** updated in the same pass (three-tier learning entry, convention-tier table, corrected attributions; the "Gotchas is highest-signal per Anthropic engineer" claim dropped as uncitable). Deliberately **not** done: the repo-wide `reference/`→`references/` rename — no validator checks directory names; plural applies to new dirs only.

- **Directive-register description sweep** (all patch bumps): converted the last eight skill descriptions still using the passive "Use when asked to…" / "Use whenever…" register to the directive third-person form "Use this skill whenever the user wants to…" — deep-research (v2.2.1), track-session (v5.1.2), track-roadmap (v2.5.3), track-qa (v1.2.3), record-tui (v1.5.1), color-system (v1.1.1), screenshot-local (v1.3.1), ideal-react-component (v1.7.2). Trigger phrases unchanged. Basis: the Seleznov activation study (n=650, CMH odds ratio 20.6, p<0.0001 — directive register raised absolute activation from 77% to 100%); a 2026-07-02 convention re-validation confirmed the directive/trigger-rich/third-person principle is canonical in current Anthropic guidance, while the exact phrasing remains a house choice.

### Fixed

- **typography** (v1.0.0 → **v1.0.1**, patch): `references/readability.md`'s fluid-clamp() rule 3 claimed "MAX ≤ ~2.5× MIN (and ≥ 2× MIN) so text can still double" — a floor every authored example in the skill violates (ratios run 1.14–1.71×) and whose justification was wrong: with both bounds in `rem`, zoom and text-size preferences scale the whole range, so 200%-zoom compliance doesn't depend on the MAX/MIN ratio. Softened to "MAX ≈ 1.25–2.5× MIN — a design choice, not a compliance requirement." Also canonicalized the fluid-h1 snippet: SKILL.md's example (`clamp(2rem, …)`) diverged from readability.md's (`clamp(1.75rem, …)`) with an identical preferred term; standardized both on the 1.75rem MIN, whose crossover starts scaling at ~325px viewport instead of leaving small phones stuck at the floor until ~450px.

- **track-roadmap** (v2.5.1 → **v2.5.2**, patch) and **track-qa** (v1.2.1 → **v1.2.2**, patch): converted the last remaining deprecated `<Good>`/`<Bad>` XML example tags to ✅/❌ labels in `track-roadmap/reference/EXAMPLES.md` (5 pairs) and `track-qa/reference/EXAMPLES.md` (8 tags) — both files were missed by the 2026-05-14 repo-wide tag migration. Content unchanged. The repo is now fully tag-free outside the two SKILL.md bodies (generate-skill, rate-skill) that legitimately name the tags as anti-patterns to detect.

- **track-session** (v5.1.0 → **v5.1.1**, patch): `reference/VERIFICATION.md` still showed task lines in the pre-cc-dash format (`- [x] Phase 1: Setup [dependency: none] ✅`) in both its dependency-validation and incomplete-dependency examples — an agent following the verify guide would emit files the dashboard can't parse. Both examples now use the live schema markers SKILL.md teaches (`- [x] <!-- id:t_a1b2c dep:none --> …`). Also trimmed the file from 320 to 241 lines: deleted the "Troubleshooting Verification" section (all four problems duplicated `reference/TROUBLESHOOTING.md`, now pointed to instead; its one non-duplicated idea — define acceptance criteria when "done" is ambiguous — folded into Step 5's common gaps), deleted the generic 10-item "Best Practices" list, compressed the three-code-block "Integration with Development Workflow" section to two sentences, and dropped the "Related: Systematic debugging, TDD…" filler reference. The three per-work-type verification checklists were deliberately kept.

- **setup-semantic-release** (v1.2.0 → **v1.2.1**, patch): corrected the prerequisite Node floor from "Node ≥18" to "Node ≥20.8.1" — the skill pins `semantic-release@^24.0.0`, whose engines field (verified against the npm registry) requires ≥20.8.1, so the setup as taught failed to install on Node 18. Renumbered `references/REFERENCE.md`'s per-step verification table, which still used a stale phase numbering ("5. Prepare", "7. CI") from before the workflow was consolidated to 6 phases — the prepare-script check folded into Phase 4 (Husky, where `husky init` adds it), and a Phase 5 Changelog row was added. Restored one inline ✅/❌ commit-message pair under Phase 2's type→bump table (the v4.0.0 condensation had left the body with no inline example comparison). Deliberately kept the `^24` pin rather than bumping to the new semantic-release v25 (engines `^22.14.0 || ≥24.10.0`) — v24 remains a correct, working setup; a v25/commitlint-v21 modernization is a follow-up if the skill sees real use.

- **ideal-react-component** (v1.7.0 → **v1.7.1**, patch): modernized the taught data-layer API — `react-query` imports became `@tanstack/react-query` and all `useQuery`/`useMutation` call sites moved from the removed positional signature to the v5 object form (`{ queryKey, queryFn }` / `{ mutationFn }`) across SKILL.md, `reference/SECTIONS.md`, `reference/COMPLETE-EXAMPLES.md`, and `reference/REFACTORING.md`; return-type annotations updated from the React-19-removed global `JSX.Element` to `React.JSX.Element` (6 sites); and the last two files missed by the v3.0.0 tag migration — `reference/HOOKS-ANTIPATTERNS.md` (3 pairs) and `reference/REFACTORING.md` (1) — converted from `<Good>`/`<Bad>` XML tags to ✅/❌ labels. Antipattern sections intentionally keep ❌→✅ (failure-then-fix) ordering, matching the house paired-anti-pattern format; `isLoading` destructures kept (still valid v5 API).

- **generate-skill** (v3.1.0 → **v3.1.1**, patch): `references/PATTERNS.md` — the file SKILL.md's Phase 4 links to as the body-template source — had never been migrated in the v3.0.0 rewrite and still taught everything v3 banned: letter-coded patterns A–E (in an order contradicting SKILL.md's five named types), an "Iron Law"/"Red Flags - STOP" methodology template, `<Good>`/`<Bad>` XML example tags (directly contradicting SKILL.md's own Phase 5 prohibition), and a "You MUST select a pattern" ALL-CAPS gate. Rewrote it to the five named types (methodology/technical/auditing/reference/automation) in SKILL.md's order, with ✅/❌ example blocks (✅ first), a `## Gotchas` section in every template, paired ❌→✅ anti-patterns, and a plain selection sentence. Also deleted `references/ADVANCED.md` — a 297-line orphan linked from nowhere, still using the obsolete pre-v3 phase numbering ("Phase 4: Enhancement", "Phase 5: Scripts"); its salvageable content already lives in Phase 7's progressive-disclosure rules.

## [4.6.0] - 2026-07-01

### Changed

- **local-first-app** (v1.3.0 → **v1.4.0**, minor): incorporated feedback from an architecture audit comparing a mature real-world local-first app against the skill. **New pattern — review-deck triage**: for entity sets needing periodic re-verification (items due for follow-up, stale records) rather than one-off CRUD, added a fourth screen shape alongside list/detail/form — a pure core selector picks the working set, a dedicated screen shows one item at a time with 1-2 actions, a progress indicator, and explicit empty/done states (`SKILL.md`'s CRUD-as-screens section + a full `references/ARCHITECTURE.md` section). **New pattern — third row shape**: a metadata + opaque computed-data-blob row (`slug, name, note, data`), auto-seeded on first visit and rebuilt via a code-registered `build()` + "refresh" action, for a bespoke calculator/report bolted onto an otherwise-CRUD app — added alongside the existing list-row/detail-aggregate pair in `references/ARCHITECTURE.md`. **Softened**: "two row shapes, not one" now presents a sibling-props alternative (one shared mapper, children fetched separately and passed as props rather than folded into a merged aggregate type) as equally valid for shallow relationships, not a compromise. **Clarified**: an explicit application-level cascade delete alongside `ON DELETE CASCADE` is now framed as a defensible belt-and-suspenders (protects against a future connection opened without `foreign_keys = ON`), not redundant code to flag — noted in `SKILL.md`'s Gotchas and `references/RELATIONSHIPS.md`.

### Fixed

- **CI: `validate-skills.sh`** — the "Validate Skills" GitHub Actions workflow had failed on every release since v4.2.0 (2026-06-23) because the validator still checked for pre-2026-05-14 conventions: a mandatory `## When to Use` heading (now folded into the description), a rigid enumerated list of "workflow/steps" heading names, a plural-only `## Examples` heading with no ✅/❌ fallback, `reference/` (singular) only for the progressive-disclosure line-budget exception and internal-link checks, and a `## Troubleshooting` heading with no `## Gotchas` equivalent or reference-file-content fallback. Rewrote all four checks against the actual current skill bodies (verified across all 14 skills, not assumed): Overview now accepts intro prose under the title; When to Use and workflow/steps are soft warnings, not hard fails (both are legitimately pattern-specific or now live in the description); Examples accepts ✅/❌ pairs inline or in a `references/`/`reference/` file; Troubleshooting accepts `## Gotchas` and reference-file content by grep, not filename guessing; `reference/` and `references/` are both recognized everywhere. All 14 skills now pass with zero fails (7 informational warnings on the soft workflow/steps check).
- **track-qa** (v1.2.0 → **v1.2.1**, patch): added the `## Troubleshooting` section that `reference/TROUBLESHOOTING.md` referred to ("beyond the common issues covered in SKILL.md") but that had never actually existed in SKILL.md — only a bare unheaded pointer paragraph.
- **track-roadmap** (v2.5.0 → **v2.5.1**, patch): same fix — added the missing `## Troubleshooting` section that `reference/TROUBLESHOOTING.md` assumed existed.

## [4.5.0] - 2026-07-01

### Changed

- **local-first-app** (v1.2.0 → **v1.3.0**, minor): realigned against two real downstream builds (the skill's origin app and a from-scratch consumer app), audited via three parallel agents over both repos' code and chat history plus a rubric self-audit. **Description** trimmed 494 → 263 chars (was 2× the soft cap). **DB hardening** claim softened — the full pragma set (`WAL`+`synchronous`+`busy_timeout`+`optimize`+`globalThis` caching) is now framed as the recommended baseline rather than an already-verified pattern, since neither real app fully implements it yet. **New: `references/RELATIONSHIPS.md`** — the 1:N/N:N relationships section was extracted out of `ARCHITECTURE.md` (which had crept to 308 lines, over the 300-line aim) into its own reference, and the N:N example gained an "at scale" subsection (`json_group_array` read pre-aggregation + a shared `syncTags` attach/detach write path) reflecting a real production N:N migration. **`ARCHITECTURE.md`** gained two new sections: **Background jobs** (job-status table, detached-promise-in-a-module-`Set` pattern, client polling, boot-time stale-job reconciliation, auto-run gating — previously zero coverage despite being a common real subsystem) and **External APIs, caching, and dedup** (per-source throttling, cache-first with negative-result caching, per-item failure isolation, natural-key dedup on import, plus a carve-out to the "no server-side secrets" rule for locally-stored third-party API keys). Also added shared **detail-page chrome** (`PageShell`/`PageActions`) as the natural next promotion after the form shell, once an app has several entities. **`SKILL.md`** gained a short **empty-state / first-run UX** convention (a fresh local-first DB always starts empty — design the empty state before the first entity exists).
- **Removed** the `local-first-app-builder` Claude Code subagent (`~/.claude/agents/`) — it had drifted from the skill (missing the CRUD-as-screens and relationships sections added in v1.1.0/v1.2.0) and leaked two identifiers the skill's own history shows were deliberately scrubbed. The skill is now the single source of truth; no replacement subagent was created.

## [4.4.0] - 2026-06-29

### Changed

- **local-first-app** (v1.1.0 → **v1.2.0**, minor): review-driven correctness & architecture hardening from a three-lens multi-agent review (Next.js/React, data/SQLite, holistic architecture). **Forms:** the shared zod schema now uses `z.coerce.*` so it survives both `zodResolver` (client) and the server round-trip (the prior `Object.fromEntries(form)` example threw on numeric/boolean fields); submission is Mantine `useForm.onSubmit` → action with the typed values object (not FormData) inside `startTransition`, returning `fieldErrors` → `form.setErrors`. **DB:** `openDatabase()` hardened — WAL + `synchronous=NORMAL` + `busy_timeout=5000` + `foreign_keys=ON` + a `globalThis` `getDb()` singleton (survives Next HMR) + `PRAGMA optimize`; `runInTransaction` uses `BEGIN IMMEDIATE`; migrations run `up()`+`user_version` in one transaction with a fresh-install-jumps-to-max bootstrap; Node ≥22.5 floor stated. **Routes:** `params`/`searchParams` are async in Next 15 (await); `requireX` → `notFound()` (404 not 500); `error`/`not-found`/`loading` files added to the topology. **Delete:** `<ModalsProvider>` + `startTransition` requirements documented. **Relationships:** M:N reverse index (`idx_*_tag`), `SET NULL`-needs-nullable note, `IN(...)` variable-limit caveat. **Architecture:** drew the load-bearing rule that *all* derivation lives in the pure core (`lib/` only maps + calls it); named the home for DB-context business rules (pure predicates in `src/<domain>/rules.ts` + an action guard step); dropped the standalone-calculator framing (CRUD-only; computation stays a sub-capability); added an ordered "add an entity" checklist; clarified `force-dynamic`+`revalidatePath` are not redundant (server render vs client Router Cache); honest two-row-shape and `<RelatedList>` 1:N/N:N-mode wording. Plus minors (bigint `lastInsertRowid`, `.all()` read-path typing, parent-before-child table order, prepared-statement reuse). `<ModalsProvider>` added to UI.md's provider stack; a "your data is one file" backup/export + pagination-ceiling section added to ARCHITECTURE.md. **Reconciled against the reference implementation:** kept the justified upgrades (useForm+zodResolver — now lists `@mantine/form`; openConfirmModal — `@mantine/modals`; full DB-hardening block; unified save-action; join-table M:N; `<RelatedList>`), but **softened** three over-prescriptions to match what shipped — the screen-shell guidance is now a shared **form shell** (`FormScreen`/`EditorShell`) + per-entity list/detail rather than a forced `ListScreen`/`DetailScreen`/`FormScreen` triad; **`rules.ts` demoted** to an optional extraction from the default in-action guard step; and the **"no API routes" rule scoped** to allow external/integration route handlers (image proxy, scraping, third-party quotes — SSRF-guarded), which the reference app uses.
- **local-first-app** (v1.0.0 → **v1.1.0**, minor): added route-topology and entity-relationship architecture. New SKILL.md sections **CRUD as screens — never modals** (every list/view/create/edit is an addressable `app/<entity>/` route — `page.tsx` / `new` / `[id]` / `[id]/edit` — with the URL as state; edit is the create screen prefilled via one `<EntityForm mode>`; post/redirect/get; unified `<ListScreen>`/`<DetailScreen>`/`<FormScreen>` shells reused across every entity so projects and tasks share identical chrome) and **Relationships — FKs, assembled in loaders, cross-linked** (real foreign keys with declared delete intent; joins assembled in `lib/` loaders via a two-loader pattern — list+counts vs detail aggregate; the pure core stays relationship-agnostic; a reusable `<RelatedList>` cross-links parent↔child detail routes and prefills the FK on "+ New"). Flat top-level routes per entity (cross-link by FK, not nested paths). **Delete** is the one allowed modal carve-out — a Mantine `openConfirmModal` that shows the CASCADE blast radius (`also deletes 4 tasks`) from the detail loader before posting to `deleteEntity` → no delete *screen*. **Forms** use one zod schema in `lib/schemas/<entity>.ts` shared by both sides — `zodResolver` on the client for inline errors, the same schema `.parse()`d in the server action as the authority. Added a `PRAGMA foreign_keys = ON` gotcha (node:sqlite defaults FKs OFF per connection) and a ✅/❌ example pair (loader-assembled aggregate vs core-follows-relation/N+1). `references/ARCHITECTURE.md` gains a full worked **Project→Tasks** pattern (schema FK + index, scoped/batched store queries, the two loaders, server-action PRG with shared-schema validation, `openConfirmModal` delete, `<RelatedList>` cross-linking), a **many-to-many variant** (join table with composite PK, attach/detach actions, two-step batched loader), and the screen shells folded into component consolidation.

## [4.3.0] - 2026-06-28

### Added

- **local-first-app** (new skill, **v1.0.0**): a blueprint for building a single-purpose, single-user, local-first CRUD app (a game-backlog tracker, workout log, collection catalog, habit tracker, personal dashboard) that runs in the browser, persists to a local SQLite file, and can ship as a self-contained desktop binary. The specific function is the variable; the architecture is the constant. Pins the stack — **Next.js App Router + React + TypeScript**, **Mantine** UI, **`node:sqlite`** (built-in `DatabaseSync`, no native addon, so the app `deno compile`/`deno desktop`-packages into one file), a **pure framework-free domain core** (CRUD-derived state — rollups, filters, status counts — *and* any computation), **zod** at the server boundary, no client data-fetching layer, and a semantic-role, light/dark, colorblind-safe (Okabe-Ito blue-vs-orange + `+/−` glyph) chart palette. Encodes a three-hard-layer architecture (pure core / `server-only` store / glue+routes+UI), domain-conditional conventions (exact quantities as integer base units), schema-as-inlined-TS-string + `PRAGMA user_version` migrations + a `runInTransaction` wrapper, shared-derived-state hoisting for wizard/tab flows, and the recurring data-viz/legibility corrections (no different-unit axes, data labels, bar/line toggle, auto y-domain, one grouped table with parent-owned pills, theme-level readability floor). SKILL.md is ~155 lines (stack table + architecture + conventions + UI quality signals + ✅/❌ examples + 8-item Gotchas + Troubleshooting); depth lives in three one-level-deep references — `ARCHITECTURE.md` (data layer, migrations, view-models, shared state, component consolidation), `UI.md` (color/theme system, data-viz & tables, explainability, legibility), and `PACKAGING.md` (`deno compile`/`deno desktop`, standalone-server gotcha, signing). Integrates with color-system, typography, ideal-react-component, frontend-design, and track-roadmap/track-session.
- **color-system: Carbon palette** (new Web App UI entry, **color-system → v1.1.0**) — a dark-first, deep slate-blue sibling of Graphite, captured from a working pipeline-performance dashboard, and promoted to the **recommended top pick** for analytics dashboards / perf reports / dev tooling (Graphite stays the call when hand-tuned light-mode parity matters more than the kit). Bluer panels/borders (`surface-elevated #1c232d`, `border #2d3744`) and a brighter sky-blue primary (`#58a6ff`) than Graphite, with a derived GitHub-Primer-light companion so the 13 roles stay swappable. Distinguishing feature is a **dashboard kit** layered on the dark column: A–F grade pills (paired bg/fg badges), an ordered 4-step stage sequence (green→amber→red→violet), an inline-code tone (`#0c1f33`/`#9fd0ff`), and a "big win" success-highlight gradient. Reordered the SKILL.md quick index to lead with Carbon, updated the dashboard example recommendation, and added the full hex tables to `references/palettes.md`.

### Removed

- **QA.md and ROADMAP.md deleted** — removed the internal cc-dash tracking artifacts from the published skills repo; skillbox no longer surfaces in the cc-dash roadmap/QA dashboard views. No `SESSION_PROGRESS.md` existed. Verified no live references remain (README, CLAUDE.md, CI, PR/issue templates, and the VERSION-CONTROL reference are all clean; the `skills/track-qa` and `skills/track-roadmap` skill bodies still describe these file *types* generically, which is correct and untouched).
- **AGENTS.md deleted** — the root agent-workflow doc was retired; its content (imperative-language guidance, skill inventory, pattern taxonomy, rating rubric) duplicated CLAUDE.md, the README skill Index, and the `rate-skill` rubric. Cleaned up all references: README Resources link, CLAUDE.md file-structure map, the obsolete `q_sk003` QA item, the PR + feature-request templates, and the VERSION-CONTROL release step. (The unrelated `skills/code-review/reference/AGENTS.md` — the reviewer prompts — is untouched.)

### Changed

- **README restructured** — moved Installation above the skill list; added a 13-row **skill Index** (table of contents with in-page anchor links); collapsed every skill's use-cases/triggers into `<details>` blocks so the section is a short scannable table instead of ~210 lines; removed the Acknowledgments section.
- **Doc consistency audit (README + AGENTS.md + CLAUDE.md)** — fixed stale skill count (11 → 13), singular `reference/` → plural `references/`, `Good/Bad` → `✅/❌`, the "under 500 lines" target → "under 300 (hard cap 500)", and reframed the "use Iron Laws" creator advice to verification-checklist / "Quality Signals" framing (ALL-CAPS "Iron Law" is a skill-creator yellow flag). AGENTS.md pattern-recognition list updated to current "Quality Signals"/"Anti-Patterns" section names.

## [4.2.0] - 2026-06-26

### Added

- **typography** (new skill, **v1.0.0**): ready-to-use **type systems** plus type-scale, vertical-rhythm, and font methodology — built to stop the recurring failure of AI-generated UI shipping text that's tiny, thin, or low-contrast. Ships four role-mapped systems (paralleling color-system's four domains) — **Product UI** (system sans, 16px base, 1.2 ratio, tabular numerals, +14px compact variant), **Editorial/Long-form** (serif body 18px/1.6, 1.25 ratio, 66ch measure, space-before > space-after), **Marketing/Landing** (fluid `clamp()` display, 1.333 ratio, tight tracking, scrim guidance), and **Docs/Technical** (Product UI scale + first-class mono: ligatures-off, slashed-zero). Core principle: size text by **role on a scale** (base × ratio), never eyeballed pixels. The skill's headline contract is the **readability floor** — size ≥16px · weight ≥400 · contrast ≥4.5:1 · line-height ≥1.5 — framed as strong guidance with rationale (not ALL-CAPS mandates), since most unreadable output breaks at least one. Developed the same way as color-system: a four-stream multi-agent research pass (11 design systems' shipped tokens — Tailwind/Bootstrap/Material 3/Apple HIG/shadcn/Radix/Chakra/Primer/Atlassian/Carbon/Ant — plus type-scale/vertical-rhythm theory, WCAG/APCA readability, and font-stack/pairing research) feeding an **iterative visual-review loop** (live HTML mockup: type-scale ladder, long-form article, dense dashboard, marketing hero, and a before/after readability panel) to lock the cadence before writing. SKILL.md is 115 lines (readability-floor table + system index + methodology essentials + ✅/❌ examples + 8-item Gotchas); depth lives in four one-level-deep references — `systems.md` (full token tables, all four systems), `scale.md` (ratios, vertical rhythm, measure, tracking), `readability.md` (minimum sizes, WCAG 2 + APCA, fluid `clamp()`, AI-failure→fix table), and `fonts.md` (system stacks, curated webfonts, pairing, font-level CSS, loading). Single-line directive description with `Do NOT use for color palettes — see color-system; layout — see frontend-design` scope clause.

## [4.1.0] - 2026-06-23

### Added

- **color-system** (new skill, **v1.0.0**): a curated color-palette library plus palette-building and contrast methodology. Ships ready-to-use, role-mapped palettes (light + dark) across four domains — **web-app UI** (Graphite, Evergreen, Terracotta, Bloom), **marketing/landing** (Sunbloom, Tidewater, Obsidian & Gold, Paper & Ink), **data viz** (categorical Hearthstead/Vintage Warm/Glass Wall/Lunar Valley, sequential Viridis-family/Blues/YlOrRd, diverging Alien Sun/Orchard Dusk/Coffee & Coolant/Console & Window), and **terminal/TUI** (Solarized Dark, Nord, Catppuccin Mocha/Latte, Dracula, Tokyo Night). Core principle: choose by **semantic role**, not raw hue. Palettes were developed through an iterative visual-review loop (live HTML mockups: dashboards, landing heroes, charts, terminal windows) plus a multi-agent research+design pipeline; the two signature data-viz palettes (Lunar Valley, Console & Window) and several names are originals tuned to a warm-cozy-with-cool-edge aesthetic. SKILL.md is 145 lines (role contract + library index + methodology essentials + ✅/❌ examples + Gotchas); depth lives in four one-level-deep references — `palettes.md` (full hex tables, all four domains), `theory.md` (wheel, harmony, OKLCH, scales), `contrast.md` (WCAG/APCA thresholds, formulas, Okabe-Ito CVD set), and `build-your-own.md` (step-by-step). Single-line directive description with a `Do NOT use for UI layout — see frontend-design` scope clause.
- **track-session** (v5.0.0 → **v5.1.0**, minor): new **`recover` mode** (`/track-session recover`) that rebuilds a lost or deleted `SESSION_PROGRESS.md` from the Claude Code session transcript at `~/.claude/projects/<cwd-slug>/*.jsonl`. The mode interviews the user for branch/date/topic to narrow the transcript set, reconstructs the file, re-stamps `last_updated`, and hands off to `resume`; when no transcript content exists it falls back to `git reflog`/`git log` and labels the result partial rather than fabricating a plan. The reconstruction mechanics were verified against real transcripts, which corrected two wrong initial assumptions: (1) the file is updated almost entirely via incremental `Edit`s, **not** a single full `Write` — so recovery takes the latest full snapshot (a `Write`, else a `Read` tool-result with `cat -n` line-number prefixes stripped) and replays later `Edit`s; (2) `jq 1.7.1-apple` mis-parses the multi-step filter and dumps help text, so the reference ships a tested **Python** reconstructor instead. SKILL.md grows +13 lines (119 → 132, still well under cap); slug derivation, the Python script, and fallbacks live in the new `reference/RECOVERY.md`. Description + `argument-hint` extended with `recover` / "I lost my SESSION_PROGRESS" / "reconstruct my session" triggers.

## [4.0.0] - 2026-06-01

### Skill simplification pass — every SKILL.md pared to its core

A portfolio-wide simplification campaign cut **all 11 skills** down to their non-inferable core, moving worked examples, per-mode procedures, and troubleshooting into `references/` while keeping load-bearing schema/frontmatter/contracts inline. **Total SKILL.md weight: 4,478 → 1,458 lines (−67%)**; every skill now sits under the 300-line soft cap. The recipe, established skill-by-skill: identify the one thing the skill teaches that Claude can't infer, collapse sections that restate each other, cut duplicate examples to one ✅/❌ pair, and push depth to one-level-deep references. Research basis: the best community session/methodology skills (Anthropic skill-creator, obra/superpowers) run 70–152 lines.

Per-skill cuts: track-session 483→119, deep-research 486→120, ideal-react-component 470→117, screenshot-local 461→122, setup-semantic-release 444→156, record-tui 440→116, code-review 427→104, track-roadmap 421→105, track-qa 340→95, rate-skill 257→185, generate-skill 219. The cc-dash skills (track-session/roadmap/qa) keep their schema markers inline because the dashboard parses them on every run; setup-semantic-release keeps its config blocks inline as the deliverable; code-review keeps the v1.5.0 verifier contract verbatim (its `reference/AGENTS.md` prompts are byte-for-byte unchanged).

**Breaking:** `track-session` dropped its `start` mode (v5.0.0) and the `experimental/` lane + `evolve-skills` were removed — hence the major version bump. `code-review` net moves v1.4.1 → v1.6.0 (the v1.5.0 verifier rewrite never shipped a tag; both entries below land here).

### Changed

- **rate-skill** (v3.0.0 → **v3.1.0**, minor): light trim, **257 → 185 lines**. Moved the three worked examples (directive-description rewrite, frontmatter cleanup, report opener) to a new `references/EXAMPLES.md`, and dropped the `## Anti-Patterns` section — its four points were already covered by the Output Format notes ("every finding ships a concrete patch", "every report includes a strength") and Gotchas (XML-tag and length guidance). The 7-category rubric, length/frontmatter scoring rules, Output Format, and Gotchas stay inline (load-bearing audit logic).
- **generate-skill** (v3.0.0 → **v3.1.0**, minor): light trim, **249 → 219 lines**. Moved the three description examples (methodology ✅, technical ✅, multi-line counter-example ❌) to a new `references/EXAMPLES.md`. The 8-phase workflow, per-phase ✅/❌ guidance, frontmatter field table, output layout, and Gotchas stay inline.
- **code-review** (v1.5.0 → **v1.6.0**, minor): pared the body from **427 → 104 lines (−76%)** while preserving the just-shipped v1.5.0 verifier logic exactly. `reference/AGENTS.md` (the verbatim reviewer + verifier prompts) is untouched, so the inline Phase 2 lane descriptions — which duplicated AGENTS.md's exhaustive lists — collapse to a 5-row lane table (owns / out-of-scope) pointing at AGENTS.md. Kept the load-bearing contract verbatim: the verifier's Stage 1 (Holds/Thin/Drop) + Stage 2 (impact promote/demote, re-rated severity authoritative, `Verifier note:`), the distillation rule + `Nothing blocking — only polish remains.`, the `kept N of M; promoted P; demoted K; dropped J` summary line, and all Phase 3 render steps + Output Format section order. Dropped the big ASCII pipeline diagram (one-line pipeline retained), the triple-covered When-to-Use prose, two of three dispatch examples, and half the Quality Signals. EXAMPLE-REVIEW.md and TROUBLESHOOTING.md unchanged.
- **track-qa** (v1.1.1 → **v1.2.0**, minor): pared the body from **340 → 95 lines (−72%)**, all five modes preserved — same recipe as its siblings track-roadmap/track-session. Collapsed the five per-mode phase breakdowns (+ Update Rules / Audit Signals) into a one-line-essence Modes table inline, with detailed procedures moved to a new `reference/MODES.md`. Kept the cc-dash QA.md format block + compressed format rules + the "what makes a good QA item" guidance inline (dashboard-parsed deliverable). Folded When-to-Use/When-to-Update/When-to-Audit/Quality Signals into the intro and rules; one inline ✅/❌ + workflow diagram retained. EXAMPLES.md and TROUBLESHOOTING.md unchanged.
- **track-roadmap** (v2.4.1 → **v2.5.0**, minor): pared the body from **421 → 105 lines (−75%)**, all five modes preserved. Each mode previously carried a full phase breakdown + its own rules list (Brainstorm Rules, Resume Rules, Update Rules) — collapsed to a one-line-essence Modes table inline, with the detailed procedures (discovery questions, brainstorm question banks, audit categorization, resume steps) moved to a new `reference/MODES.md`. Kept the cc-dash ROADMAP.md format block + compressed format rules inline (dashboard-parsed, like track-session). Folded When-to-Use/Quality Signals into the intro and rules; kept one inline ✅/❌ + the workflow-pattern diagram; dropped the v1 migration section. EXAMPLES.md and TROUBLESHOOTING.md unchanged.
- **record-tui** (v1.4.2 → **v1.5.0**, minor): pared the body from **440 → 116 lines (−74%)** — same recipe as its sibling screenshot-local. Dropped the Phase 1-5 ceremony, the duplicate Examples section (three ✅/❌ blocks re-showing the tape structure), Quality Signals, and the Quick Reference (which carried a second copy of the commands table). Kept the tape-file master block, one merged commands table, the CLI cheat, the dimensions table, the "generate a tape for an app" intelligence, one condensed ✅/❌, and concise troubleshooting. The four reference files (COMMAND-REFERENCE, TEMPLATES, OPTIMIZATION, CI-INTEGRATION) carry the overflow.
- **setup-semantic-release** (v1.1.1 → **v1.2.0**, minor): pared the body from **444 → 156 lines (−65%)**. Lands above the ~120 target by design — the config blocks (commitlint, `.releaserc.json`, husky hooks, GitHub Actions workflow) are the non-inferable deliverable and stay inline; cutting them would break the skill. Moved the commit cheat sheet, multi-branch pre-release variant, per-phase verification checklist, the ✅/❌ commit-history examples, and all troubleshooting to a new `references/REFERENCE.md`. Dropped the per-phase verification checkboxes (consolidated into the reference) and the When-to-Use/Prerequisites prose (folded into one line). Renumbered 8 phases → 6.
- **screenshot-local** (v1.2.1 → **v1.3.0**, minor): pared the body from **461 → 122 lines (−74%)**. Dropped the Phase 1-5 ceremony (overkill for a CLI tool), the duplicate Examples section (four ✅/❌ blocks re-showing commands already in the capture section), Quality Signals, and the Quick Reference (a third copy of the same commands). Kept install/prereqs, a compact command set, the essential-flags table, the batch-YAML workflow + supported keys, the dimensions table, the "generate a config for a project" intelligence, one ✅/❌ YAML, and concise troubleshooting. The three reference files (COMMAND-REFERENCE, TEMPLATES, CI-INTEGRATION) carry the overflow.
- **ideal-react-component** (v1.6.1 → **v1.7.0**, minor): pared the body from **470 → 117 lines (−75%)**. The seven-section master code block already shows the full structure, but Sections 1-7 then each got a full ✅/❌ re-expansion (~260 lines) restating it — moved that per-section detail (import priority, styling-solution variants, naming, early-return rationale) plus troubleshooting to a new `reference/SECTIONS.md`. Kept the master structure block, the Quick Reference table (now the canonical per-section "why"), the Section-5 logic-flow order, and the top-3 hooks antipatterns (✅/❌) inline. The three existing reference files (COMPLETE-EXAMPLES, HOOKS-ANTIPATTERNS, REFACTORING) and external source links are unchanged.
- **deep-research** (v2.1.1 → **v2.2.0**, minor): pared the body from **486 → 120 lines (−75%)** with no loss of methodology. The phase gates, "Quality Signals," "Failure Modes," and "Troubleshooting" sections all restated the same defenses (sycophancy / fabricated citations / SEO bias) and modes appeared across three tables — collapsed to one Modes table, one condensed 7-phase Process, and one "Failure-mode defenses" block. Moved both ~115-line worked examples to `references/EXAMPLES.md` (one abbreviated ✅/❌ kept inline) and troubleshooting + multi-agent landscape sub-mode + save-as-note handoff to `references/PLAYBOOK.md`. Kept the Five Search Angles, the 5+ search floor, primary>secondary>tertiary, cross-reference-disagreements, the synthesis template, and cite-verify inline — that's the non-inferable core.
- **track-session** (v4.5.1 → **v5.0.0**, breaking): pared the body from **483 → 119 lines (−75%)** to reclaim context budget on the portfolio's single most-invoked skill (~80 local invocations/month). Dropped the `start` mode (explore→ask→plan→confirm→execute→test→commit ceremony — it overlapped plan mode + track-roadmap and saw the least standalone use) and its `reference/START.md`. Collapsed 6 worked examples (~240 lines) to one ✅/❌ resumability contrast. Folded the "When to Use / When to Update / When to Verify / Quality Signals / Rules / Format Rules" sections into terse inline lines and template comments. Kept the cc-dash schema frontmatter + `t_`/`f_`/`ref:`/`dep:` markers **inline** (not exiled to a reference) since the dashboard parses them on every run and a non-loaded reference would silently emit non-compliant files. Removed orphaned `reference/MIGRATION.md`. `argument-hint` now `[save|resume|verify]`. Research basis: best-in-class community session skills (obra/superpowers) run 70–152 lines with plain checkboxes and ≤3 modes ([best-practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), [executing-plans](https://github.com/obra/superpowers/blob/main/skills/executing-plans/SKILL.md)).
- **code-review** (v1.4.1 → **v1.5.0**, minor): the verifier pass gains two responsibilities beyond evidence-checking. **Stage 2 impact re-rating** — for findings whose evidence holds, the verifier re-rates severity by real blast radius on the change, promoting under-rated findings and demoting over-rated ones (each lane reviewer only saw its own lane); the re-rated severity is authoritative and carries a `Verifier note:` whenever it moves. **Distillation** — the verifier emits a 3-6 item "what to fix first" shortlist (or `Nothing blocking — only polish remains.`), rendered as a `## What to fix first` section at the top of REVIEW.md. **Nits regrouped** — replaced the cap-at-5 rule with grouping all nits under their file path in one `## Nit` block (terse one-liners, no cap). Verifier summary line gains a `promoted P` count. Synthesis stays mechanical — the verifier judges, the synthesizer renders. Updated `reference/AGENTS.md` verifier prompt, `reference/TROUBLESHOOTING.md`, the flow diagram, Phase 2.5/3, Output Format, and Quality Signals. Also: rewrote the `description` to directive third-person form with negative scoping (`Do NOT use for an open PR / security pass`); added `reference/EXAMPLE-REVIEW.md` (worked report, including an `[Unverified]` demotion); and tightened verifier-note consistency, the `demoted` count definition, and the THIN→Stage-2 control flow across SKILL.md and the prompt.

### Removed

- **`experimental/` folder + `evolve-skills`** — retired the entire `experimental/` lane (introduced in v3.0.0) and its sole skill `evolve-skills`. It was never promoted to a stable release; the friction-mining + patch-proposal pipeline is removed in full.

## [3.0.0] - 2026-05-14

### Major rewrite: directive descriptions, ✅/❌ examples, `references/` plural

Multi-agent research pass (Anthropic docs, 8 top community skill repos, LLM prompt-engineering papers, Claude Code release notes, criticism/failure-mode research) surfaced that several SkillBox conventions had drifted out of line with current (May 2026) Anthropic guidance and community practice. This release re-aligns. **Breaking** for downstream consumers of `<Good>/<Bad>` XML tags and `skills/generate-skill/reference/` deep links.

Key findings driving the rewrite:

- **Multiline `description: |` YAML block scalars silently break skill discovery** ([anthropics/skills #9817](https://github.com/anthropics/claude-code/issues/9817)). Found in 9 of 11 SkillBox skills — all migrated to single-line.
- **Directive third-person descriptions activate ~20× more reliably** than passive prose (Seleznov n=650, p<0.0001). New form: "Use this skill whenever the user wants to… Do NOT use this skill for…".
- **The 250-char display cap was a v2.1.86 regression, removed in v2.1.105+** (now 1,536 chars). The ≤230 SkillBox target is now a soft cap for listing-budget hygiene past ~15-25 installed skills, not a discovery requirement.
- **`<Good>`/`<Bad>` XML tags are SkillBox-only** — zero of 8 surveyed top community skills (Anthropic, Vercel, Superpowers) use them. Migrated to ✅/❌ markdown emoji.
- **`references/` (plural) is canonical** per Anthropic spec and skill-creator. SkillBox used `reference/` (singular) in generate-skill.
- **ALL-CAPS "IRON LAW" / "Red Flags - STOP" framing has no empirical support** (Anthropic skill-creator: yellow flag). Reframed as "Quality Signals" + "Anti-Patterns" with explained reasoning.

### Major skill rewrites

- **rate-skill** (v2.1.0 → **v3.0.0**, breaking): Complete rewrite. New rubric: Description quality (25%), Frontmatter validity (20%), Length & progressive disclosure (15%), Structure fit (15%), Examples (10%), Conciseness (10%), Anti-pattern avoidance (5%). Hard-fail rule: multiline `description: |` automatic 0. New length scoring: ≤230 full marks (soft target), 231-500 no penalty, 501-1024 −15, >1024 caps at 50. New Gotchas section (highest-signal per Anthropic engineer). Dropped `## Integration` and `## When to Use` body sections (folded into description per Anthropic guidance). Body 455 → 257 lines.
- **generate-skill** (v1.6.0 → **v3.0.0**, breaking): Complete rewrite. New 8-phase workflow: Discovery (AskUserQuestion, one question per turn), Description drafting (target ≤230 chars, soft-directive register), Frontmatter, Body content (type-driven templates), Examples (✅/❌), Gotchas, Progressive disclosure check, **Mandatory Phase 8 eval set** (20 queries: 10 should-trigger + 10 should-not-trigger, saved as `references/EVAL.md`, mirrors Anthropic's May 2026 A/B description optimizer). Dropped letter-coded patterns (A/B/C/D/E → methodology/technical/auditing/reference/automation). Renamed `reference/` → `references/`. Body 376 → 249 lines.

### Migrated skills (description fix + ✅/❌ migration, per-skill PATCH bump)

All 9 had `description: |` multiline block scalars (silent discovery break) AND used `<Good>/<Bad>` XML tags. Migrated in same pass:

- **code-review** (v1.4.0 → v1.4.1): single-line description (209 chars); 3 ✅/❌ pairs.
- **deep-research** (v2.1.0 → v2.1.1): single-line description (226 chars); 2 ✅/❌ pairs.
- **ideal-react-component** (v1.6.0 → v1.6.1): single-line description (199 chars); 4 ✅/❌ pairs.
- **screenshot-local** (v1.2.0 → v1.2.1): single-line description (220 chars); 2 ✅/❌ pairs.
- **setup-semantic-release** (v1.1.0 → v1.1.1): single-line description (224 chars); 1 ✅/❌ pair.
- **track-qa** (v1.1.0 → v1.1.1): single-line description (197 chars); 1 ✅/❌ pair.
- **track-roadmap** (v2.4.0 → v2.4.1): single-line description (177 chars); 1 ✅/❌ pair.
- **track-session** (v4.5.0 → v4.5.1): single-line description (211 chars); 4 ✅/❌ pairs.
- **record-tui** (v1.4.0 → v1.4.2): single-line description (197 chars); 3 ✅/❌ blocks.

### Directory renames (breaking for deep links)

- **skills/generate-skill/reference/** → **skills/generate-skill/references/** (plural, canonical). PATTERNS.md and ADVANCED.md preserved; internal links in ADVANCED.md updated (9 occurrences of `reference/` → `references/`).

### Documentation

- **CLAUDE.md**: Replaced "Iron Laws" / "Red Flags" framing with "Quality Signals" / "Anti-Patterns". Updated description-length rule from "≤230 hard ceiling" to soft target with no penalty up to 500. Replaced `<Good>/<Bad>` recommendation with ✅/❌. Added multiline-description silent-break warning. Added first-person POV anti-pattern. Updated all skill-internal `reference/` references to `references/` (plural). Repo-level `reference/VERSION-CONTROL.md` retained (repo docs dir, not a skill's references). Refreshed validation checklist with current rules. Last Updated → 2026-05-14.
- **memory/MEMORY.md** + **memory/description_length_rule.md**: Updated description-length rule to reflect v2.1.105+ removal of the 250-char display cap. Updated `<Good>/<Bad>` entry to note deprecation. Added entries on Anthropic's A/B description optimizer, `skillOverrides` v2.1.129 fix, and `skillListingBudgetFraction` budget pressure. Removed stale `hooks` non-functional claim (now supported per code.claude.com).

### Research bundle (in this session, not shipped)

Five parallel research subagents (Anthropic official docs, top community skill repos, LLM prompt-engineering papers, Claude Code release notes 2026-04-30 → 2026-05-14, criticism/failure-mode research) produced a synthesized brief. Drafts went through two iteration rounds (clean-slate, then cross-pollinated with community exemplars). A comparator agent diffed final drafts vs current production. User reviewed 12 decisions via AskUserQuestion before adoption.

## [2.12.0] - 2026-05-11

Three threads converge: (1) the **track-session start mode** for new multi-phase work, with phase gates and `reference/START.md`; (2) the new **`experimental/`** lane and its first inhabitant `evolve-skills`, a friction-mining + patch-proposal pipeline that always runs on a branch and surfaces decisions for human review; and (3) a **description-length pass** that brings every skill description under the 230-char target after research surfaced Claude Code 2.1.86's 250-character `/skills` display cap. Two skills (`generate-skill`, `rate-skill`) and `CLAUDE.md` now codify the rule so future authoring stays in compliance.

### Description-Length Pass (description ≤230 chars)

All 11 skill descriptions trimmed under the 230-character target (was 255–732). Claude Code 2.1.86 truncates the `/skills` listing at 250 characters — anything past that is invisible to auto-invocation logic ([anthropics/claude-code#40121](https://github.com/anthropics/claude-code/issues/40121), [#44780](https://github.com/anthropics/claude-code/issues/44780)). Anthropic's [authoring spec](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices) sets a hard 1024-char limit, but the 250 display cap is the practical ceiling.

- **deep-research** (v2.0.0 → v2.1.0): description 732 → 226 chars. Dropped 9 redundant trigger phrasings (kept research / deep research / deep dive / investigate / compare / pros and cons / survey the landscape); removed "No files are created" implementation detail (already covered in body).
- **generate-skill** (v1.5.0 → v1.6.0): description 619 → 201 chars. Added a new "Length self-check" sub-section under "Description field best practices" with the bash one-liner to count characters; tightened phase-3 frontmatter example to ≤230; added length to Phase 4 quality checklist.
- **track-session** (v4.4.0 → v4.5.0): description 478 → 211 chars. Dropped 7 redundant resume-variant phrases (kept resume work / pick up where I left off / what was I doing / start a session / track this work / save progress).
- **code-review** (v1.3.0 → v1.4.0): description 472 → 209 chars. Removed the 5-reviewer breakdown (belongs in body, not description); kept the highest-value triggers.
- **track-qa** (v1.0.0 → v1.1.0): description 463 → 197 chars. Removed the parenthetical scope list (visual rendering, multi-step flows, etc.) — already in `## When to Use` body.
- **ideal-react-component** (v1.5.0 → v1.6.0): description 400 → 199 chars. Kept the high-value debugging triggers ("fix infinite loop", "useEffect not working"); dropped redundant situational descriptors.
- **record-tui** (v1.3.0 → v1.4.0): description 398 → 196 chars. Dropped niche / generic triggers ("set up VHS for CI", "show what this app looks like", "document the UI").
- **track-roadmap** (v2.3.0 → v2.4.0): description 392 → 177 chars. Dropped "pick up where I left off" (overlaps with track-session) and one of three "generate a roadmap" variants.
- **screenshot-local** (v1.1.0 → v1.2.0): description 351 → 220 chars. Removed the descriptor block; kept distinctive shot-scraper trigger.
- **setup-semantic-release** (v1.0.0 → v1.1.0): description 303 → 224 chars. Light trim of redundant variants.
- **rate-skill** (v2.0.0 → v2.1.0): description 255 → 177 chars. Also gained scoring updates for description length in the Frontmatter (15%) category.

### Documentation

- **CLAUDE.md**: Added the ≤230-char rule to "DO: Creating and Editing Skills" and the >250-char anti-pattern to "Forbidden Patterns", with rationale linking the spec hard limit (1024) vs the practical display cap (250).
- **skills/rate-skill** (v2.1.0): Frontmatter category now checks description length. Letter-grade thresholds: A ≤230 / B 231–300 / C 301–500 / D 500–1024 / F >1024. "Watch for" section includes the bash one-liner for measuring length.
- **skills/generate-skill** (v1.6.0): New "Length self-check" sub-section under "Description field best practices" with measurement command; frontmatter example trimmed; Phase 4 quality checklist now includes the ≤230 check.

### Enhanced Skills

- **track-session** (v4.3.0 → v4.4.0): Added new `start` mode that codifies the explore → ask → plan → confirm → execute → test → commit pattern for new multi-phase work. Prevents the two most common failure modes of long sessions — starting execution before the plan is reviewed, and dumping a large synthesis when the user wants decisions one at a time. Six phases, each with a gate. Updates: `argument-hint` to include `start`, brief "Start Mode" pointer in SKILL.md with full workflow in new `reference/START.md` (progressive disclosure keeps SKILL.md at 491 lines / A-grade), new Scenario 0 in the Mode Selection examples.

### Added (experimental)

- **experimental/** folder: New top-level area for research-grade skills that always run on a branch, produce a report (never auto-merge), pass through `/publish-check`, and surface decisions via `AskUserQuestion`. See `experimental/README.md` for conventions and the graduation path. README.md updated with a brief reference between Available Skills and Installation.
- **experimental/evolve-skills** (v0.1.0): First experimental skill — friction-mining + patch-proposal pipeline that scans recent transcripts, clusters by active skill, proposes patches via parallel agents, validates via headless replay, scrubs through `/publish-check`, and presents `EVOLUTION_REPORT.md` for human review on a branch. Includes `reference/friction-patterns.md` (6 detection patterns) and `reference/replay-protocol.md` (validation rubric). Pre-deployment live-test through `/publish-check` correctly caught a real `/Users/<user>/projects/...` placeholder string inside Example 3 — fixed by generalizing to `<USER>` / `<repo>` placeholders.

## [2.11.0] - 2026-05-06

Skill audit follow-up to the v2.6.0 activation-tuning release. Transcript audit covering 2026-04-13 → 2026-05-06 (~448 transcripts) confirmed two skills had zero activations across the full window — `reflect` (third consecutive zero audit) and `git-worktree` (dropped from 1 to 0). Both removed entirely. The other zero-usage skills (`rate-skill`, `generate-skill`, `record-tui`, `setup-semantic-release`, `ideal-react-component`) cover narrow workflows and are kept on the watch list rather than removed. Skill count: 13 → 11. Also closes the v2.10.0 documentation gap by adding the missing `track-qa` entry to README.md.

### Removed

- **reflect** (v1.0.1): Removed — third consecutive zero-activation audit (v2.3.0, v2.6.0, this audit). The `/track-session resume` flow already covers cross-session learning capture; reflect's separate scan-and-categorize loop never surfaced. Use `/track-session` to capture decisions/learnings during work and `update` mode to save them to SESSION_PROGRESS.md.
- **git-worktree** (v2.0.2): Removed — zero activations across the full window despite occasional natural-language phrases ("create a worktree") in transcripts that didn't fire the trigger. The skill duplicated public `git worktree` documentation without adding skillbox-specific value. Users wanting parallel-branch workflows can read `git help worktree` directly.

### Documentation

- README.md: dropped both removed skill entries; added the missing `track-qa` entry (placed alongside `track-roadmap` since they share the `cc-dash/*@1` schema family); updated install/symlink examples and the activation-example block; skill count now matches the 11 actual skills
- AGENTS.md: dropped both rows from the skill inventory table; replaced the git-worktree Pattern B structural signature with screenshot-local; dropped reflect from the Pattern A example list; refreshed Last Updated to 2026-05-06
- CLAUDE.md: dropped `git-worktree/` from the directory tree, dropped the `git-worktree + track-session` integration section, and replaced the example trigger and example commit message
- reference/VERSION-CONTROL.md: refreshed the skill-name list (was missing 4 skills and still listed `remember`/`git-worktree`); replaced git-worktree from two example commit blocks
- skills/{track-session,track-roadmap,record-tui,screenshot-local,deep-research,generate-skill,rate-skill}: dropped git-worktree and/or reflect cross-references in their Integration sections
- .github/ISSUE_TEMPLATE/bug_report.md: replaced git-worktree example with code-review

## [2.10.0] - 2026-05-06

New skill release. Adds `track-qa` to formalize the manual-QA layer of the cc-dash schema family — pairs with `track-roadmap` (`cc-dash/roadmap@1`) and `track-session` (`cc-dash/session@1`). Tools that consume the schema can render `QA.md` files as a portfolio-wide queue, drive an inline approve/fail/skip/decision workflow, and run a focus mode with keyboard shortcuts; MCP servers built on the schema can expose tools for agent-driven QA.

### Added

- **track-qa** (v1.0.0): New skill for tracking manual QA — the things tests can't verify (visual rendering, multi-step flows, race conditions, integrations, accessibility, performance feel). Five modes mirroring `track-roadmap`: `generate` (interactive bootstrap), `update` (add/remove/edit), `audit` (relevance review), `migrate` (convert ad-hoc QA notes to compliant `QA.md`), `resume` (load and pick next pending item). Format follows `cc-dash/qa@1` schema: `q_xxxxx` IDs, five status values (`pending | passed | failed | needs-decision | skipped`), `at:` timestamps on transitions, `ref:r_xxxxx` cross-link to roadmap issues filed by failures, blockquote notes on each item. Two known sections: `## Setup` (free-form runnable command) and `## Checklist` (parsed). Triggers on phrases like "create a QA list", "set up QA for this project", "audit the QA list", "before I ship I need to QA", "what's left to QA". Detailed Good/Bad examples for all five modes live in `reference/EXAMPLES.md`; edge cases for migrate, audit, and dashboard integration in `reference/TROUBLESHOOTING.md`.

## [2.9.0] - 2026-05-02

`code-review` v1.3.0 — six refinements applied after a focused audit of the skill itself: transcript review across three projects, web research on Anthropic's official Code Review pipeline and skill-authoring docs, and the obra/superpowers and HAMY 9-agent precedents. The skill gains an always-on verifier pass, a Pre-existing severity bucket, a hard 5-Nit cap, evidence-bar prompts in three lanes, a model-tier note, and an evals follow-up. Personal-content audit found nothing to remove. SKILL.md stays under 500 lines via Troubleshooting extraction to `reference/TROUBLESHOOTING.md`.

### Enhanced Skills

- **code-review** (v1.3.0): Six refinements informed by transcript audit (`code-review` actually used in 3 projects since v1.2.0), web research on Anthropic's official Code Review pipeline + skill-authoring docs, and the obra/superpowers and HAMY 9-agent precedents. **Pre-existing severity tier**: clarity (and any agent that finds a same-scope issue) can now surface pre-existing problems into a separate `## Pre-existing` bucket at the bottom of REVIEW.md instead of suppressing them — preserves signal without crowding change-focused findings. **5-Nit cap promoted to primary rule**: Phase 3 synthesis now enforces a hard cap of 5 Nits, collapsing the rest into a single `_…plus N similar nits_` line; matches Anthropic's explicit recommendation. **Verifier pass added as Phase 2.5**: after the five reviewer agents return, a sixth verifier agent re-checks each finding against the actual code, demoting unsubstantiated ones one severity tier with `[Unverified]` tag and recording the verification summary in REVIEW.md; mirrors Anthropic's official two-stage filter pattern (Datadog reports 60%→13% false-positive reduction with this pattern). **Evidence bar in basics, architecture, repo-hygiene prompts**: each high-noise lane gets a positively-framed instruction to flag findings they can substantiate with concrete code citations, returning NO FINDINGS when evidence is thin. **Model-tier note in Overview**: explicit guidance that the skill is designed for Opus/Sonnet-tier models. **Evals follow-up note in Integration**: recommends maintainers create `evals/` with 3+ representative diff scenarios to catch agent-prompt regressions.

## [2.8.0] - 2026-05-02

`deep-research` v2.0.0 — major rewrite informed by transcript audit (220 sessions in `~/projects/notes`), web research on the four leading deep-research products (OpenAI / Perplexity / Gemini / Anthropic), and audit of skillbox skill-design conventions. The skill moves from advisory to enforcing: every phase has a `MUST` checkbox gate; output adopts a Tl;dr lead, per-section confidence labels, mandatory comparison matrix for 3+ items, and grouped-and-dated source lists.

### Enhanced Skills

- **deep-research** (v2.0.0): Major rewrite. **Process** — added Phase 0 (mandatory local-first check), Phase 2 disambiguation phase for ambiguous nouns, Phase 4 sufficiency-check reflection gate, and Phase 6 cite-verify pass; replaced prose phases with `[ ] you MUST` checkbox gates between every phase; kept the 5-search hard floor. **Output** — synthesis template now leads with `## Tl;dr`, includes per-section confidence labels (high/medium/low + why), mandatory `## Comparison Matrix` when comparing 3+ items, optional `## What we still don't know` when gaps are non-trivial, grouped References sub-headers when sources >5, publication dates on source citations. **Activation** — added comparative phrasings (`compare X and Y`, `pros and cons of X`, `should I use X or Y`), freshness phrasings (`what's new with X`, `is X still relevant`), pre-implementation phrasings (`before I build X`, `survey the landscape of Y`), natural research phrasings (`I'd like you to do some research on Z`, `do some research on Y`), and the literal `deep research` phrase. **Failure modes** — new section with named one-line defenses for Sycophancy, Anchoring, Source laundering / SEO bias, Fabricated citations, and Drift. **Modes** — top-of-skill mode table with `quick` / default / `comparison` / `landscape` modes; documented multi-agent / consensus sub-mode for landscape work; generic save-as-note handoff template. **Visual** — inline "The Five Search Angles" inventory near top (mirroring code-review's "Five Reviewers" pattern); ASCII pipeline diagram of the seven phases. **Quick-Answer-Before-Research** guidance to prevent over-launching deep-research on opinion-shaped questions.

## [2.7.0] - 2026-05-02

New skill release. Adds `deep-research` for multi-source web research synthesis — generalized from the `quick-research` command in the personal `notes/` repo into a portable, vault-agnostic skill.

### Added

- **deep-research** (v1.0.0): New skill for multi-source web research with structured synthesis. Runs 5-10+ web searches with diverse angles (official docs, comparative, criticism, community), cross-references claims, prioritizes current sources, and outputs a structured summary with an annotated source list. Defaults to in-conversation output — no files created unless explicitly requested. Triggers on "research X", "deep dive on Y", "look into Z", "investigate this topic", "what's the current state of X".

### Documentation

- README.md: added deep-research entry between code-review and Installation, bumped skill count to 12
- AGENTS.md skill inventory updated (if applicable — see commit)

## [2.6.0] - 2026-05-02

Activation tuning release. Transcript audit (854 prompts, 335 transcripts since 2026-04-13) revealed phrase-trigger gaps in three skills and a discoverability gap in `code-review`. All four patches address specific missed activations or user friction observed in real sessions.

### Enhanced Skills

- **track-session** (v4.3.0): Added four trigger phrases observed in transcripts but not firing — `"start a session"`, `"start a session together"`, `"save this in a session"`, `"save this plan in a session"`. Three of ten window activations were `/track-session` slash; phrase activations dropped to zero because session-start naturalese wasn't covered.
- **generate-skill** (v1.5.0): Added present-progressive trigger forms — `"we're creating a new skill"`, `"creating a new skill"`, `"build a new skill"`. Real prompt during code-review skill construction did not activate because the description had `"create a skill"` but not the conversational form actually used.
- **track-roadmap** (v2.3.0): Added `"generate a roadmap"` and `"let's generate a roadmap"`. Description had `"create a roadmap"` only; users said `"generate a roadmap"` instead.
- **code-review** (v1.2.0): Added `## The Five Reviewers` inventory directly below `## Overview` so the lane breakdown is visible at the top of the SKILL.md instead of buried in Phase 2. Triggered by mid-flow user question (`"wait what are the subagents offered by the skill?"`) caused by 480-line SKILL.md hiding the agent list.

### Documentation

- Memory file refreshed with 2026-05-01 audit state (track-session usage trend, code-review activation success, MEMORY.md note that `remember` was already removed in v2.3.0)

## [2.5.0] - 2026-04-28

Added `repo-hygiene` reviewer to `code-review` — fifth lane covering committed secrets, undocumented env vars, dependency/lockfile drift, and documentation alignment.

### Enhanced Skills

- **code-review** (v1.1.0): Added fifth reviewer `repo-hygiene` covering project-level hygiene the other four lanes miss — committed secrets/credentials, undocumented env vars, dependency/lockfile drift, and documentation alignment (README/CLAUDE.md/AGENTS.md/docstrings pointing at renamed or removed targets). Reads the project's package manifests, lockfiles, env templates, and project docs as a mandatory first step. Scope detection no longer filters lockfiles or manifests so this agent can see them; the other four still skip them by lane. Includes fixture-vs-real-secret distinction to suppress false positives in test files. Full prompt skeleton added to `reference/AGENTS.md`.

### Documentation

- Updated README.md and root AGENTS.md skill inventory to reflect five reviewers

## [2.4.0] - 2026-04-23

Added `code-review` skill — multi-agent local code review with four specialized reviewers dispatched in parallel, synthesized into a severity-tagged report at the repo root.

### Added

- **code-review** (v1.0.0): Multi-agent local code review skill. Four specialized reviewers in parallel lanes — basics (hygiene + orphaned-symbol detection), architecture (pattern consistency + structural holes, with a mandated sibling-read step), clarity (reader comprehension), testing (coverage + assertion strength). Writes `REVIEW.md` at the repo root; chat receives only a one-line summary. Language-agnostic — no framework, tool, or extension assumptions baked in. Security review deferred to built-in `/security-review`; PR review to built-in `/review`; design-health and simplification to `/simplify`. Progressive disclosure: full reviewer prompt skeletons live in `reference/AGENTS.md`.

### Documentation

- Added `code-review` to README.md Available Skills section; skill count 10 → 11
- Added `code-review` to AGENTS.md Skill Inventory table

## [2.3.0] - 2026-04-17

Full skill audit release. Removed deprecated `remember` skill (0 usage over 4 weeks). Tightened description fields based on activation analysis. Enforced 500-line progressive-disclosure cap across all skills.

### Removed

- **remember** (v1.1.0): Deleted — deprecated in v2.2.0 with no usage since. Use `/track-session resume` for context restoration.

### Enhanced Skills

- **track-session** (v4.2.0): Reordered Usage Modes table to put `resume` first (primary entry for returning users); rewrote description to front-load resume triggers ("pick up where I left off", "what was I doing", "where was I") after transcript analysis showed these phrases weren't firing reliably
- **track-roadmap** (v2.2.1): Trimmed description from 18+ triggers to 6 highest-signal phrases; expanded `reference/TROUBLESHOOTING.md` from 4 to 9 edge cases (ballooning features, scope drift, priority decisions, rename/merge flows)
- **generate-skill** (v1.4.0): Expanded description to meet its own 5+ triggers standard — added "turn this workflow into a skill", "capture this as a reusable pattern", "extract this into a skill"
- **ideal-react-component** (v1.5.0): Moved Refactoring section to `reference/REFACTORING.md` with expanded extraction criteria and hook composition patterns (511 → 474 lines, under 500 cap)
- **record-tui** (v1.3.0): Moved Phase 4 Optimization and Phase 5 CI/CD to `reference/OPTIMIZATION.md` and `reference/CI-INTEGRATION.md` (511 → 452 lines, under 500 cap)
- **screenshot-local** (v1.1.0): Added Quality Signals section; moved CI/CD guide to `reference/CI-INTEGRATION.md` (497 → 474 lines)

### Documentation

- Removed `remember` from README.md Available Skills section; updated skill count from 11 to 10
- Removed `remember` from AGENTS.md inventory table; removed "Using remember as an Agent" section
- Updated all skill versions in AGENTS.md inventory table

### Quality Coverage

Quality Signals coverage: 8/10 skills (added screenshot-local). Remaining 2 skills (git-worktree, setup-semantic-release) are procedural and use built-in verification checklists instead.

---

## [2.2.0] - 2026-04-13

### Enhanced Skills

- **generate-skill** (v1.3.0): Replaced "Red Flags" with "Quality Signals" section — positive framing of what good output looks like
- **track-session** (v4.1.0): Added Quality Signals section describing well-tracked session properties
- **track-roadmap** (v2.2.0): Added Quality Signals section describing well-maintained roadmap properties
- **reflect** (v1.0.1): Added Quality Signals section; fixed hardcoded memory path — now lets Claude Code discover its own memory directory
- **ideal-react-component** (v1.4.0): Added Quality Signals section; documented GSD workflow activation gap with workaround
- **record-tui** (v1.2.0): Added Quality Signals section; added README/documentation trigger phrases ("add a demo GIF to the README", "show what this app looks like", "document the UI")

### Deprecated

- **remember** (v1.1.0): Marked as deprecated — superseded by `/track-session resume` which got 23 uses vs 0 for remember over a 2-week period. Will be removed in a future release.

### Fixed

- **reflect** (v1.0.1): Removed hardcoded `~/.claude/projects/` memory path that failed on non-default installations
- **remember** (v1.1.0): Same memory path fix as reflect

---

## [2.1.0] - 2026-03-23

### New Skills

- **reflect** (v1.0.0): Extract learnings from today's Claude Code conversations — identifies corrections, discoveries, architecture decisions, debugging breakthroughs, and workflow insights. User chooses per learning whether to save to project CLAUDE.md, global CLAUDE.md, or auto-memory.

### Fixed

- **remember** (v1.0.0): Replaced personal path in example with generic path
- **reflect** (v1.0.0): Replaced personal path in example with generic path

### Enhanced Skills

- **rate-skill** (v2.0.0): Added frontmatter validation, skill type detection, spec compliance checks, and positive framing evaluation

### Documentation

- Added reflect to README.md Available Skills section
- Updated skill count from 10 to 11 in README.md
- Audited roadmap — cleared stale items, added recent completions
- Fixed `argument-hint` nesting across all skills (moved to top-level per Claude Code spec)
- Removed non-functional `tags` and `hooks` fields from frontmatter

---

## [2.0.0] - 2026-03-21

V2 schema format updates for cc-dash dashboard compatibility.

### Breaking Changes

- **track-roadmap** (v2.0.1): ROADMAP.md now requires `cc-dash/roadmap@1` YAML frontmatter, HTML comment IDs (`r_XXXXX`) on items, and `<!-- category:slug -->` comments on headings. See migration instructions in skill.
- **track-session** (v4.0.1): SESSION_PROGRESS.md now requires `cc-dash/session@1` YAML frontmatter, task IDs (`t_XXXXX`), dependency declarations (`dep:none`/`dep:t_XXXXX`), and structured failed attempt/completion references. See migration instructions in skill.

### New Features

- **track-roadmap** (v2.0.0 -> v2.1.0): Added `brainstorm` mode for exploratory ideation — divergent questioning adapted to project maturity, idea deepening (user journey, inspirations, requirements, open questions), user-driven filtering, and capture to "Future Ideas" with `status:idea`

### Enhanced Skills

- **track-roadmap** (v2.1.0): Added inline Good/Bad audit example with cc-dash ID references; condensed Resume and Audit modes for conciseness; moved 4 troubleshooting entries to reference/TROUBLESHOOTING.md; removed internal tool name references
- **track-session** (v4.0.0 -> v4.0.1): Moved 7 extended troubleshooting entries to reference/TROUBLESHOOTING.md (538 -> 474 lines); kept 4 most common issues inline with progressive disclosure link

### Documentation

- Updated all Good examples in both skills to use v2 format
- Updated track-roadmap reference/EXAMPLES.md to v2 format with brainstorm example
- Added track-session reference/TROUBLESHOOTING.md
- Added track-roadmap reference/TROUBLESHOOTING.md

---

## [1.6.0] - 2026-03-02

New skill for rebuilding context from previous Claude Code sessions.

### New Skills

- **remember** (v1.0.0): Rebuild context from previous Claude Code sessions by scanning conversation history, auto-memory, SESSION_PROGRESS.md, ROADMAP.md, and git state. Produces a structured summary of past work and suggested next steps, then offers to hand off to track-session or track-roadmap.

### Documentation

- Added remember to README.md Available Skills section
- Updated skill count from 9 to 10 in README.md

---

## [1.5.0] - 2026-03-01

New resume mode for track-roadmap — bridge the gap between roadmap planning and active session work.

### Enhanced Skills

- **track-roadmap** (v1.0.0 → v1.1.0): Add `resume` mode that checks session state, presents roadmap features for selection, and starts a tracked work session for the chosen feature

---

## [1.4.0] - 2026-02-23

Two new skills for visual project documentation — terminal recordings and web UI screenshots.

### New Skills

- **record-tui** (v1.0.0): Record polished terminal demos using Charmbracelet VHS. Write `.tape` scripts that produce reproducible GIFs, MP4s, and WebMs. Covers tape authoring, smart generation, optimization, and CI/CD integration
- **screenshot-local** (v1.0.0): Capture screenshots of local development projects using shot-scraper via pipx. Supports single shots, batch YAML configs, element selectors, and CI/CD integration

### Documentation

- Added record-tui and screenshot-local to README.md Available Skills section
- Updated skill count from 7 to 9 in README.md

---

## [1.3.0] - 2026-02-16

New skill for high-level project roadmap planning and tracking.

### New Skills

- **track-roadmap** (v1.0.0): Plan, update, and audit a high-level project roadmap with interactive feature discovery, codebase scanning, and progress/relevance auditing

### Documentation

- Added track-roadmap to README.md Available Skills section
- Updated skill count from 6 to 7 in README.md

---

## [1.2.0] - 2026-02-16

New skill addition and quality refinements across existing skills.

### New Skills

- **setup-semantic-release** (v1.0.0): Set up automated versioning and release pipeline using conventional commits, commitlint, husky git hooks, and semantic-release

### Enhancements

- **ideal-react-component** (v1.3.0): Modernized styling section with Tailwind CSS and CSS Modules alternatives; added inline hooks antipatterns quick reference; added React Server Components note; removed redundant Best Practices Summary section
- **git-worktree** (v2.0.2): Added user-language trigger phrases to description; added References section

### Fixes

- **track-session** (v3.3.2): Deduplicated Usage Modes and Workflow by Mode into single concise table; extracted Verification as standalone section
- **generate-skill** (v1.2.1): Fixed phase numbering (3 jumped to 6); removed duplicate Quality Standards Checklist; updated meta section references
- **rate-skill** (v1.0.2): Reframed examples from misleading Good/Bad tags to descriptive headers; trimmed verbose example output

### Documentation

- Added setup-semantic-release to README.md Available Skills section
- Updated skill count from 5 to 6 in README.md

---

## [1.1.0] - 2026-02-10

Quality review and progressive disclosure refactor across all skills.

### Enhancements

- **ideal-react-component** (v1.2.0): Refactored from 1418 → 499 lines with progressive disclosure; moved hooks antipatterns and complete examples to reference/; consolidated TS/JS duplication
- **generate-skill** (v1.2.0): Refactored from 1043 → 393 lines with progressive disclosure; moved pattern templates and advanced topics to reference/; removed redundant content
- **rate-skill** (v1.0.1): Added Good/Bad tags to examples; removed redundant scoring algorithm section; fixed duplicate section naming

### Fixes

- **git-worktree** (v2.0.1): Fixed author metadata inconsistency; removed incorrect `git check-ignore` advice; added Git 2.45+ note for `useRelativePaths`; fixed formatting
- **track-session** (v3.3.1): Renamed "Example 0" to descriptive title; removed hardcoded timestamps from examples

### Documentation

- Added rate-skill to README.md Available Skills section
- Updated skill count from 4 to 5 in README.md

---

## [1.0.0] - 2026-02-04

Initial stable release of SkillBox with 5 core skills.

### New Skills

- **track-session** (v3.3.0): Track, stop, resume, verify, and save progress on long-running work sessions
- **git-worktree** (v2.0.0): Manage multiple branches simultaneously using git worktrees for parallel development
- **generate-skill** (v2.0.0): Interactive skill builder that generates high-quality SKILL.md files
- **ideal-react-component** (v1.0.0): Battle-tested React component structure pattern
- **rate-skill** (v1.0.0): Evaluate skill quality against best practices

### Documentation

- Complete README.md with installation instructions
- CLAUDE.md with AI agent onboarding and development guidelines
- AGENTS.md with agent workflow patterns
- Installation support for Vercel Skills CLI
- Manual and project-specific installation methods

### Infrastructure

- Established file structure and patterns
- SKILL.md format specification
- Progressive disclosure pattern for long skills
- Trigger-rich description system

---

## Version History Notes

This is the first tagged release of SkillBox. Previous development history:

- 2026-01: Core skills developed (track-session, git-worktree, generate-skill)
- 2026-01: Added ideal-react-component and rate-skill
- 2026-01: Established documentation structure
- 2026-02: Stabilized for v1.0.0 release with version control workflow

---

## How to Use This Changelog

### For Skill Users

Check this file to see:
- What skills are available and their versions
- What changed between releases
- Breaking changes that affect your workflows

### For Contributors

When making changes:
1. Add your changes to the [Unreleased] section
2. Use the appropriate category (New Skills, Enhancements, Fixes, Documentation, Breaking Changes)
3. Include skill version numbers in parentheses
4. Follow the format: `**skill-name** (vX.Y.Z): Description of change`

### For Release Managers

When creating a release:
1. Rename [Unreleased] to the new version with date
2. Create a new empty [Unreleased] section
3. Review all changes for accuracy
4. Update skill version references
5. Create git tag matching the version
6. Push tag to remote

---

[Unreleased]: https://github.com/antjanus/skillbox/compare/v4.10.0...HEAD
[4.10.0]: https://github.com/antjanus/skillbox/compare/v4.9.0...v4.10.0
[4.9.0]: https://github.com/antjanus/skillbox/compare/v4.8.0...v4.9.0
[4.8.0]: https://github.com/antjanus/skillbox/compare/v4.7.0...v4.8.0
[4.7.0]: https://github.com/antjanus/skillbox/compare/v4.6.0...v4.7.0
[4.6.0]: https://github.com/antjanus/skillbox/compare/v4.5.0...v4.6.0
[4.5.0]: https://github.com/antjanus/skillbox/compare/v4.4.0...v4.5.0
[4.4.0]: https://github.com/antjanus/skillbox/compare/v4.3.0...v4.4.0
[4.3.0]: https://github.com/antjanus/skillbox/compare/v4.2.0...v4.3.0
[4.2.0]: https://github.com/antjanus/skillbox/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/antjanus/skillbox/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/antjanus/skillbox/compare/v3.0.0...v4.0.0
[3.0.0]: https://github.com/antjanus/skillbox/compare/v2.12.0...v3.0.0
[2.12.0]: https://github.com/antjanus/skillbox/compare/v2.11.0...v2.12.0
[2.11.0]: https://github.com/antjanus/skillbox/compare/v2.10.0...v2.11.0
[2.10.0]: https://github.com/antjanus/skillbox/compare/v2.9.0...v2.10.0
[2.9.0]: https://github.com/antjanus/skillbox/compare/v2.8.0...v2.9.0
[2.8.0]: https://github.com/antjanus/skillbox/compare/v2.7.0...v2.8.0
[2.7.0]: https://github.com/antjanus/skillbox/compare/v2.6.0...v2.7.0
[2.6.0]: https://github.com/antjanus/skillbox/compare/v2.5.0...v2.6.0
[2.5.0]: https://github.com/antjanus/skillbox/compare/v2.4.0...v2.5.0
[2.4.0]: https://github.com/antjanus/skillbox/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/antjanus/skillbox/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/antjanus/skillbox/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/antjanus/skillbox/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/antjanus/skillbox/compare/v1.6.0...v2.0.0
[1.6.0]: https://github.com/antjanus/skillbox/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/antjanus/skillbox/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/antjanus/skillbox/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/antjanus/skillbox/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/antjanus/skillbox/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/antjanus/skillbox/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/antjanus/skillbox/releases/tag/v1.0.0
