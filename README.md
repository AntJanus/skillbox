<div align="center">
  <img src="./logo.png" alt="SkillBox Logo" width="200" />
</div>

# SkillBox

> 🌐 **PUBLIC repository** — hosted publicly on GitHub. Scrub PII and secrets before every commit.

A curated collection of utility skills for Claude Code and AI agents. SkillBox provides reusable, battle-tested skills that enhance agent capabilities for common development workflows.

**Compatible with:** Claude Code, Cursor, Cline, GitHub Copilot, and 40+ other AI agents via [Vercel Skills](https://skills.sh)

**Install with:** `npx skills add antjanus/skillbox`

## What are Skills?

Skills are specialized instructions that teach Claude Code how to handle specific tasks or workflows. They activate automatically when relevant or can be invoked explicitly using `/skill-name`. Skills help enforce best practices, automate complex workflows, and provide consistent approaches to common development challenges.

## Installation

### Using Vercel Skills CLI (Recommended)

The easiest way to install SkillBox skills using the [Vercel Skills](https://skills.sh) ecosystem:

```bash
# Install all skills
npx skills add antjanus/skillbox

# Install specific skills
npx skills add antjanus/skillbox@track-session
npx skills add antjanus/skillbox@code-review
npx skills add antjanus/skillbox@ideal-react-component

# Install globally (available in all projects)
npx skills add antjanus/skillbox -g

# List installed skills
npx skills list

# Check for updates
npx skills check
```

The skills CLI automatically detects your agent (Claude Code, Cursor, Cline, etc.) and installs skills to the correct location.

### Alternative Installation Methods

<details>
<summary>Manual Global Installation</summary>

```bash
# Clone the repository
git clone https://github.com/antjanus/skillbox.git ~/.claude/skillbox

# Symlink skills to Claude Code's global skills directory
mkdir -p ~/.claude/skills
ln -s ~/.claude/skillbox/skills/* ~/.claude/skills/
```
</details>

<details>
<summary>Project-Specific Installation</summary>

```bash
# Add as git submodule
git submodule add https://github.com/antjanus/skillbox.git .claude/skillbox

# Or clone directly
git clone https://github.com/antjanus/skillbox.git .claude/skillbox

# Symlink desired skills
mkdir -p .claude/skills
ln -s ../.claude/skillbox/skills/track-session .claude/skills/track-session
ln -s ../.claude/skillbox/skills/code-review .claude/skills/code-review
```
</details>

<details>
<summary>Individual Skill Installation (curl)</summary>

```bash
# Copy specific skill to your project
mkdir -p .claude/skills/track-session
curl -o .claude/skills/track-session/SKILL.md \
  https://raw.githubusercontent.com/antjanus/skillbox/main/skills/track-session/SKILL.md
```
</details>

## Available Skills

17 skills. Click any name to jump to its use-cases and triggers; expand for details.

| Skill | What it does |
|-------|-------------|
| [🔄 track-session](#track-session) | Track, stop, resume, recover & verify long-running sessions |
| [⚙️ generate-skill](#generate-skill) | Interactive builder for high-quality `SKILL.md` files |
| [⚛️ ideal-react-component](#ideal-react-component) | React component structure + hooks antipatterns |
| [📊 rate-skill](#rate-skill) | Grade skill quality A–F with concrete fixes |
| [🗺️ track-roadmap](#track-roadmap) | Plan, update, audit & resume a project roadmap |
| [⚠️ track-qa](#track-qa) | **Deprecated 2026-09-01** — QA.md retired; file hands-on checks as roadmap items |
| [📦 setup-semantic-release](#setup-semantic-release) | Automated versioning via conventional commits |
| [📼 record-tui](#record-tui) | Polished terminal demo GIFs/MP4s with VHS |
| [📸 screenshot-local](#screenshot-local) | Screenshot local dev servers with shot-scraper |
| [🔍 code-review](#code-review) | Multi-agent local code review → `REVIEW.md` |
| [🔬 deep-research](#deep-research) | Multi-source web research with cited synthesis |
| [🎨 color-system](#color-system) | Curated color palettes + WCAG/APCA contrast guidance |
| [🔠 typography](#typography) | Type systems, scale, rhythm + a readability floor |
| [🧱 local-first-app](#local-first-app) | Local-first single-user app — feature set, not a code spec |
| [🖼️ ui-ux-design](#ui-ux-design) | Interaction states, component a11y contracts, IA, hierarchy, tokens, deceptive patterns, whole-app audits |
| [🤖 ai-features](#ai-features) | Propose, mock and set up AI features for an existing app — local models or hosted, the right model per job |
| [💬 discuss](#discuss) | Conversation mode — Claude debates back, in condensed Simplified Technical English |

### track-session

<details>
<summary><b>Track, save, resume, verify, and recover progress on long-running development sessions.</b></summary>

**Use when:**
- Working on multi-step implementations
- Planning complex features
- Need to pause and resume work
- Verifying completed tasks actually meet requirements before declaring done
- Recovering a lost or corrupted SESSION_PROGRESS.md

**Triggers:** When asked to "resume work", "pick up where I left off", "what was I doing", "save progress", "checkpoint before I lose context", "are we done", or "I lost my SESSION_PROGRESS"

[View Documentation](./skills/track-session/SKILL.md)
</details>

### generate-skill

<details>
<summary><b>Interactive skill builder that generates high-quality SKILL.md files using proven patterns.</b></summary>

Eight phases from discovery to finalize, including a required `references/EVAL.md` eval set built to the official description-optimization loop (~20 queries, train/validation split, 0.5 trigger-rate threshold).

**Use when:**
- Asked to "create a skill"
- Need to capture team workflows
- Want to extend Claude Code capabilities
- Building custom development methodologies

**Triggers:** When asked to "create a skill", "generate a skill", "scaffold a SKILL.md", "write a SKILL.md", or "turn this workflow into a skill"

[View Documentation](./skills/generate-skill/SKILL.md)
</details>

### ideal-react-component

<details>
<summary><b>A seven-section React component file layout plus the hooks antipatterns behind infinite loops and stale state.</b></summary>

**Use when:**
- Creating new React components
- Refactoring existing components
- Extracting a custom hook
- Debugging React hooks issues (infinite renders, stale state)
- Organizing component code

**Triggers:** When asked to "create a React component", "structure this component", "refactor this component", "extract a custom hook", "fix an infinite render loop", "my useEffect isn't working"

[View Documentation](./skills/ideal-react-component/SKILL.md)
</details>

### rate-skill

<details>
<summary><b>Grade a SKILL.md against current authoring practice — a letter grade A–F, weighted category scores, and prioritized paste-ready patches.</b></summary>

Seven weighted categories (description quality, frontmatter validity, length & progressive disclosure, structure fit for type, examples, conciseness, anti-patterns & calibration), plus an eval-set check against the official optimizing-descriptions loop.

**Use when:**
- Reviewing skills before publishing
- Validating skill structure and frontmatter
- Checking if a skill meets current quality standards
- Auditing skill repositories

**Triggers:** When asked to "rate this skill", "grade this skill", "audit my SKILL.md", "score this skill against best practices", "is this SKILL.md up to spec"

[View Documentation](./skills/rate-skill/SKILL.md)
</details>

### track-roadmap

<details>
<summary><b>Plan, update, and audit a high-level project roadmap with interactive feature discovery.</b></summary>

**Use when:**
- Starting a new project and need to map out features
- Want to review what's been built vs. what's planned
- Need to audit and reprioritize the roadmap
- Capturing feature ideas before they're lost

**Triggers:** When asked to "add an item to the roadmap", "mark a feature done", "log the work I shipped", "create a roadmap", "what should we build next", "brainstorm features", or "audit the roadmap"

[View Documentation](./skills/track-roadmap/SKILL.md)
</details>

### track-qa

<details>
<summary><b>Deprecated 2026-09-01 — QA.md manual-QA checklists were retired on 2026-08-24. Kept for one release so the cc-dash/qa@1 schema stays documented, then removed.</b></summary>

Do not run any of its modes. A behavior that needs a human to exercise it (a playthrough, a parity gate, a release sign-off) is filed as one ordinary roadmap item with `track-roadmap`; cross-session progress stays with `track-session`.

[View Documentation](./skills/track-qa/SKILL.md)
</details>

### setup-semantic-release

<details>
<summary><b>Set up a fully automated versioning and release pipeline using conventional commits, commitlint, husky, and semantic-release.</b></summary>

**Use when:**
- Setting up automated versioning for a new project
- Adding conventional commits to an existing repo
- Migrating from manual versioning to automated releases
- Need commitlint, husky hooks, and CI/CD release workflow

**Triggers:** When asked to "set up semantic release", "add conventional commits", "configure automated versioning", "set up commitlint", "add husky hooks", or "automate our changelog and GitHub releases"

[View Documentation](./skills/setup-semantic-release/SKILL.md)
</details>

### record-tui

<details>
<summary><b>Record polished terminal demos using Charmbracelet VHS — reproducible GIFs, MP4s, and WebMs, version-controlled and CI-friendly.</b></summary>

**Use when:**
- Recording a demo GIF for a README or docs
- Creating video walkthroughs of CLI/TUI applications
- Writing VHS `.tape` files
- Setting up automated demo recording in CI/CD

**Triggers:** When asked to "record a demo", "create a GIF of my CLI", "write a VHS tape", "make a terminal recording", or "add a demo GIF to the README"

[View Documentation](./skills/record-tui/SKILL.md)
</details>

### screenshot-local

<details>
<summary><b>Capture screenshots of local development projects using shot-scraper — localhost URLs and local HTML into PNGs, JPEGs, and PDFs.</b></summary>

**Use when:**
- Capturing screenshots of a local dev server for docs
- Batch screenshotting multiple pages/states via YAML config
- Documenting UI changes or new features visually
- Automating screenshot generation in CI/CD

**Triggers:** When asked to "screenshot my app", "take a screenshot of localhost", "generate screenshots for the README", "batch screenshot my pages", or "set up shot-scraper"

[View Documentation](./skills/screenshot-local/SKILL.md)
</details>

### code-review

<details>
<summary><b>Run a multi-agent code review over local changes — narrow-lane reviewers in parallel, then a verifier that keeps only findings with real impact, synthesized into a severity-tagged report.</b></summary>

The lanes: correctness, architecture, testing, ui-ux (dispatched only when the scope touches UI), and a non-blocking hygiene sweep. Nits are suppressed by default; `--nits` surfaces them. Flags cover whole-repo (`--repo`), blueprint conformance (`--blueprint <skill>`), and detached runs (`--background`).

**Use when:**
- Self-reviewing a change before committing
- Before opening a PR to flush issues you would fix anyway
- After a large refactor to catch structural drift
- Auditing a whole repo against a blueprint skill (`--repo --blueprint local-first-app`)
- Want to catch committed secrets, dead code, or doc/dep drift (hygiene)

**Triggers:** When asked to "review my code", "review these changes", "do a code review", "check my changes before I commit", "review the whole repo", or "review this in the background"

[View Documentation](./skills/code-review/SKILL.md)
</details>

### deep-research

<details>
<summary><b>Run multi-source web research and synthesize a comprehensive, well-sourced summary in the conversation.</b></summary>

Runs 5+ searches across five angles (at least 3 per run), WebFetches every source it cites substantively, prioritizes current and authoritative sources, and surfaces disagreements honestly. No files created unless explicitly requested.

**Use when:**
- Pre-implementation research (libraries, patterns, trade-offs)
- Comparative analysis (Tool A vs Tool B vs Tool C)
- Catching up on recent developments in a fast-moving space
- Sanity-checking assumptions against authoritative sources

**Triggers:** When asked to "research X", "deep research on Y", "deep dive on Z", "investigate this topic", "compare X and Y", "pros and cons of X", or "survey the landscape of Y"

[View Documentation](./skills/deep-research/SKILL.md)
</details>

### color-system

<details>
<summary><b>A curated library of ready-to-use color palettes (light + dark) across four domains, plus the methodology to build new palettes and verify accessibility.</b></summary>

Domains: web-app UI, marketing/landing, data visualization, and terminal/TUI. Every palette maps hexes to **semantic roles** so themes stay swappable and accessible by construction, and every colored role carries a **fill / subtle / emphasis triad** — the structure Bootstrap, Material 3 and Radix each arrived at independently.

**Use when:**
- Picking a ready-made palette for an app, brand, chart, or terminal
- Building a new palette from scratch (OKLCH scales, harmony schemes)
- Applying a palette to real components — buttons, badges, callouts, links, validation states
- Setting up light & dark mode (dark mode ≠ inversion; elevation = lighter; neutral hue is a per-mode decision)
- Checking WCAG/APCA contrast or colorblind-safety

**Triggers:** When asked "what colors should I use", "pick a palette for my dashboard", "set up dark mode", "does this pass WCAG contrast", "colorblind-safe chart colors", or "give me a terminal theme" — and it applies even when the user never says "color", as in "theme this app" or "this text is hard to read on the background"

[View Documentation](./skills/color-system/SKILL.md)
</details>

### typography

<details>
<summary><b>Ready-to-use type systems plus the methodology to size text, build scales, set vertical rhythm, and pick fonts — so generated UI is readable instead of tiny, thin, and low-contrast.</b></summary>

Four systems (Product UI, Editorial, Marketing, Docs/Technical). Size by **role on a scale**, never eyeballed pixels, and keep text above the four-number **readability floor** (size ≥16px · weight ≥400 · contrast ≥4.5:1 · line-height ≥1.5).

**Use when:**
- Choosing a ready-made type system for an app, article, landing page, or docs
- Building a custom type scale (base × ratio) and vertical rhythm on an 8px grid
- Fixing unreadable text — too small, too thin, too low-contrast, too cramped
- Picking or pairing fonts (system stacks, curated webfonts, superfamilies)

**Triggers:** When asked "what font size should I use", "set up a type scale", "this text is too small to read", "what line-height for paragraphs", or "pair a heading font with a body font" — even when the user never says "typography" and only describes text that looks cramped, thin, or washed out

[View Documentation](./skills/typography/SKILL.md)
</details>

### local-first-app

<details>
<summary><b>What a local-first, single-user app needs — trackers, dashboards, personal tools — persisting to a local SQLite file and shippable as a desktop binary. Describes the feature set and leaves the code to the agent.</b></summary>

A one-page description of what a single-purpose local app *has* — a game-backlog tracker, expense log, collection catalog, or habit tracker — leaving the implementation to the agent. Baseline stack: **Next.js (App Router) + React + TypeScript** with **SQLite** in one local file and config through **environment variables**. Everything else (UI library, forms, validation, charts, tests) is the app's own choice.

**Covers:**
- Entities with real relationships — FKs for one-to-many, join tables for many-to-many
- Four addressable routes per entity: list, add, view, edit — the URL is the state
- App-level routes: overview home, cross-entity `/search?q=`, `/trash`, `/settings`, `/dynamic-collections`, and `/calendar` when the data carries dates
- Dynamic collections — named saved filters over one entity list, re-run on open rather than frozen as a list of IDs, warning by name when a filter stops resolving
- Shared UI patterns: tabs to cut a list or reach an entity's relations, server-side URL-driven sort and filter, consistent action placement
- List shape follows the records — table, image cards, or a skeuomorphic object — with a table view always reachable, sortable/filterable, legended, and expandable per row
- Bulk selection and edit, taking over the sidebar column past one selected row
- Top nav with search and a theme switcher; named, collapsible sidebar sections that also expose non-entity views, each paired with an icon
- Themes beyond light/dark — named palettes drawn from the app's own domain, each clearing the contrast floor
- Settings: named theme + light/dark, data file location, restore-from-backup, external API keys
- Soft deletes — records move to trash with their cascaded children and restore together, never leaving orphans
- Migrations at startup, scheduled and pre-migration DB snapshots, data export to a file, and empty states for a zero-row install
- Packaging as a self-contained desktop binary (`deno compile` / `deno desktop`)

**Triggers:** When asked to "build a local app to track my X", "a tracker that saves to my machine", "an offline single-user app with no account", "add a persisted entity", or "package this as a desktop app"

Not for palette/contrast choices (see [color-system](#color-system)), font sizing (see [typography](#typography)), or pure visual layout (see frontend-design).

[View Documentation](./skills/local-first-app/SKILL.md)
</details>

### ui-ux-design

<details>
<summary><b>Comprehensive UI/UX: the states every surface has to ship, per-component accessibility contracts, information architecture, visual hierarchy, design tokens, deceptive patterns, an audit mode for apps that already exist, and the research process behind them. Built from 20 practitioner and research sources.</b></summary>

Covers designing and critiquing interfaces end to end. Two rules generate most of it: design the *states*, not the screen — whichever rendering goes unspecified gets invented at implementation time — and name things for their role, not their appearance.

**Covers:**
- An `audit` mode for reviewing an app that already exists — scope the surface list from the code rather than the brief, build the per-surface state matrix, publish one consequence-ranked report carrying a *rendered* before and after per visual change, then take approval finding by finding. A passing verdict is a legitimate outcome
- The approved mockup as the spec: before reporting an implementation done, put it beside the artifact the user signed off on and list every element that differs
- The four states every surface ships (loading, empty, error, success), varied by permission and user type, then broken deliberately with real data — long labels, empty lists, failed images, translated strings
- Nine interaction states with their CSS hooks and the behavioral rule each carries: loading disables, error returns to clickable, disabled explains itself — via `aria-disabled`, because the native attribute puts the explanation out of keyboard reach
- An accessibility floor that holds in *every* state — 4.5:1, 44×44px targets, `:focus-visible`, never color alone, native semantics before ARIA
- Per-component ARIA, keyboard, and focus contracts for tabs, disclosures, notifications, data tables, menus, toggles, tooltips vs toggletips, and cards, plus the labeling hierarchy that puts `aria-label` last
- The response-time ladder — 100ms, 400ms, 1s, 10s — and what the UI owes at each
- Deceptive patterns: the 18-pattern catalogue, the four an agent ships while doing as it was told, and what to do when a conversion request is satisfiable by one
- Six hierarchy levers including time, and proximity used defensively to keep destructive controls out of misclick range
- Information architecture — hierarchical, sequential, and matrix structures, with every route standing on its own because any page can be an entry point
- Design tokens in three tiers, the no-alias-chaining rule, and themes as modes rather than duplicate sets
- Process: choosing artifact fidelity by the question asked, usability testing versus UX validation, the Rule of Five, and a pre-launch checklist
- Layout: base-unit grids, soft over hard, responsive behavior, and section recipes for landing, pricing, and portfolio pages
- Type and color applied to a UI — 60-30-10 allocation, grayscale-first, cultural constraints on palette, and the brand style guide as a governed artifact

**Triggers:** When asked "what states does this button need", "what ARIA does this menu need", "make this accessible", "how should I structure the navigation", "design this screen", "set up design tokens", "review my UX", "make this convert better" — or when the description is a symptom: a cluttered screen, a flow users abandon, a component that breaks on real data

Depth on type scales lives in [typography](#typography) and on palettes in [color-system](#color-system). Not for chart design (see dataviz) or React file structure (see [ideal-react-component](#ideal-react-component)).

[View Documentation](./skills/ui-ux-design/SKILL.md)
</details>

### ai-features

<details>
<summary><b>Audit an existing app, propose the AI features its data can support, mock the strongest ones as screens, then wire the initial AI setup — Ollama or LM Studio locally, Anthropic or OpenAI hosted, and the right model for each job.</b></summary>

A six-phase methodology: inventory the machine (which runtimes, models and keys actually exist), read the app's schema and search implementation, cross a catalog of shipped AI features with the app's real columns, score the survivors on usefulness, fit, cost tier and risk, mock the top proposals as static screens on example data, and, once the user picks, build only the shared plumbing: runtime detection, one runtime interface, configuration keys, a feature gate off by default, and the model pull with progress.

**Covers:**
- A catalog of AI features real products shipped, by app category, with what the user sees, the data needed, and the model tier — plus the features users rejected
- A dated model roster: which local model for embeddings, tagging, typed decisions, summaries, natural-language filters, vision and speech; hosted prices; local-vs-hosted rules
- Scoring and a gimmick filter, so a chat box never fronts a working search
- Report template: what the user sees, model and runtime, plugs into, stores, degrades to, mock, estimate
- Setup reference: runtime probes with timeouts, structured output per provider, vectors in SQLite (BLOB vs sqlite-vec), packaging, spend caps, retention, prompt-injection hygiene
- Gotchas from real failures: prose vocabularies that invent tags, context defaults that truncate silently, uncalibrated distance ceilings, embeddings that outlive deleted rows

**Triggers:** When asked "what AI features could this app have", "add semantic search", "auto-tag these records", "summarize this with a local model", "set up Ollama for this project", or "should this use Claude or a local model"

Not for pointing Claude Code itself at a local model, building an MCP server, or a Claude API reference question alone (see claude-api).

[View Documentation](./skills/ai-features/SKILL.md)
</details>

### discuss

<details>
<summary><b>Conversation mode — think a topic through with Claude instead of issuing commands, in condensed Simplified Technical English.</b></summary>

Claude takes a position and defends it, asks back with `AskUserQuestion` at real forks, delegates research to capped subagents and compresses the result, and publishes an artifact when the point is structural. Read-only — no file writes unless you name the file. Slash-only (`disable-model-invocation`), and it stays on until you say "stop discuss".

Writes to a practical subset of ASD-STE100: 20-word instructions, 25-word descriptions, active voice, present tense, one term per concept, no idioms. The approved-words dictionary is out of reach at write time, and the skill says so rather than claiming full compliance. Formatting follows the `i-have-adhd` rules — answer first, one idea per block, lists capped at 5, no preamble or closers.

**Use when:**
- Understanding how something works — this repository's architecture, or a general concept
- Weighing a design decision before any code exists
- Arguing a tradeoff with someone who will push back and concede on evidence
- Learning a topic one concept per turn

**Triggers:** Type `/discuss [topic]`. It never auto-activates.

Not for implementing a change, reviewing a diff (see [code-review](#code-review)), or a cited report (see [deep-research](#deep-research)).

[View Documentation](./skills/discuss/SKILL.md)
</details>

## Usage

### Automatic Activation

Skills activate automatically when Claude detects relevant triggers:

```
user: Can you review my changes before I commit?
assistant: [Automatically activates code-review skill]
```

### Explicit Invocation

Call skills directly using slash commands:

```
user: /track-session
user: /code-review
user: /generate-skill database-migration
```

### Session-Specific Skills

Load skills for the current session only:

```
user: Load the track-session skill for this session
```

## Creating Custom Skills

Use the `generate-skill` skill to create your own:

```
user: /generate-skill my-workflow
```

Or use the Vercel Skills CLI to scaffold a new skill:

```bash
npx skills init my-workflow
```

Manually create following the [skill specification](https://agentskills.io/specification).

## Skill Structure

Each skill follows this standard structure:

```
skill-name/
├── SKILL.md              # Core skill documentation
├── references/           # Extended documentation (plural — canonical; existing singular reference/ dirs are fine)
│   ├── EVAL.md           # Activation eval set — every SkillBox skill ships one
│   ├── STANDARDS.md      # Detailed rules
│   └── EXAMPLES.md       # Code examples
├── scripts/              # Optional: Automation scripts
│   ├── setup.sh
│   └── execute.sh
└── assets/               # Optional: Templates / resources used in output
    └── template.md
```

Nothing validates directory names — plural `references/` for new skills, no renames of existing singular `reference/` dirs.

## Contributing

We welcome contributions! Here's how:

1. **Propose a New Skill**: Open an issue describing the workflow or problem
2. **Fork & Create**: Use `/generate-skill` to scaffold your skill
3. **Test Thoroughly**: Ensure activation triggers work correctly
4. **Document Well**: Follow existing skill documentation patterns
5. **Submit PR**: Include examples and use cases

### Skill Quality Standards

- **Trigger-rich descriptions**: Directive third person ("Use this skill whenever the user wants to…"), 3-5 specific activation phrases with the distinctive one front-loaded in the first ~50 chars, and a "Do NOT use this skill for…" clause where neighboring skills could collide. The only length rule is the 1024-char spec cap; scalar style (`|`, `>`, single-line) is not policed
- **Clear examples**: Show ✅/❌ code comparisons (desired pattern first)
- **Gotchas**: A `## Gotchas` section of concrete edge cases and failure modes — the highest-value content in most skills, and the part an agent can't infer
- **Troubleshooting**: Address common issues
- **Progressive disclosure**: Keep SKILL.md under 300 lines (hard cap 500); use `references/` for extensive content
- **Eval set**: An `EVAL.md` following the official optimizing-descriptions loop — ~20 queries split ~60/40 train/validation, each run ~3 times in fresh sessions, scored against a 0.5 trigger-rate threshold, picking the description with the best *validation* score
- **No agentic over-prompting**: Leave out what the model already does — self-re-check steps ("double-check your answer", "use a subagent to verify"), reasoning-echo, don't-think rules, uncapped delegation, and output templates that don't bound a written file's length. Gates that check *external* state — a test that runs, a file that exists — are a different thing and belong wherever a phase needs one

See [generate-skill documentation](./skills/generate-skill/SKILL.md) for detailed guidelines.

## Best Practices

### For Skill Users

1. **Trust the activation**: Skills activate when needed - no need to force them
2. **Use explicit invocation for clarity**: `/skill-name` when you want specific behavior
3. **Read the documentation**: Each skill has comprehensive usage examples
4. **Combine skills**: Many skills work well together (e.g., track-roadmap + track-session)

### For Skill Creators

1. **Clear triggers**: Write specific, recognizable activation phrases
2. **Explain, don't decree**: Enforce critical workflows with explained "Quality Signals" and gates that check something real — not ALL-CAPS "Iron Laws". Reasoning-based instructions ("Do X because Y tends to cause Z") outperform rigid directives ("ALWAYS do X, NEVER do Y")
3. **Guide by default**: Provide recommendations with reasoning, not just rules
4. **Test activation**: Ensure your skill triggers reliably
5. **Version properly**: Use semantic versioning in metadata

## Philosophy

SkillBox skills follow these principles:

- **Activation over configuration**: Skills should activate when relevant
- **Verification over assumption**: Critical workflows get verification checkpoints
- **Examples over explanation**: Show, don't just tell
- **Progressive disclosure**: Start simple, reveal complexity when needed
- **Human and AI friendly**: Documentation that works for both

## Resources

- **Skills Directory**: https://skills.sh (discover and track SkillBox installations)
- **Vercel Skills CLI**: https://github.com/vercel-labs/skills (official CLI tool)
- **Claude Code Documentation**: https://code.claude.com/docs/
- **Skill Specification**: https://agentskills.io/specification
- **Best Practices Article**: https://antjanus.com/ai/claude-code-best-practices
- **CLAUDE.md Guide**: See [CLAUDE.md](./CLAUDE.md) in this repository

## License

MIT License - see individual skills for specific licensing

---

**Skill Count**: 16 | **Made for**: Claude Code 2.1.220+
