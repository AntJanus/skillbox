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

14 skills. Click any name to jump to its use-cases and triggers; expand for details.

| Skill | What it does |
|-------|-------------|
| [🔄 track-session](#track-session) | Track, stop, resume, recover & verify long-running sessions |
| [⚙️ generate-skill](#generate-skill) | Interactive builder for high-quality `SKILL.md` files |
| [⚛️ ideal-react-component](#ideal-react-component) | React component structure + hooks antipatterns |
| [📊 rate-skill](#rate-skill) | Grade skill quality A–F with concrete fixes |
| [🗺️ track-roadmap](#track-roadmap) | Plan, update, audit & resume a project roadmap |
| [✅ track-qa](#track-qa) | Manual QA tracking — the things tests can't verify |
| [📦 setup-semantic-release](#setup-semantic-release) | Automated versioning via conventional commits |
| [📼 record-tui](#record-tui) | Polished terminal demo GIFs/MP4s with VHS |
| [📸 screenshot-local](#screenshot-local) | Screenshot local dev servers with shot-scraper |
| [🔍 code-review](#code-review) | Multi-agent local code review → `REVIEW.md` |
| [🔬 deep-research](#deep-research) | Multi-source web research with cited synthesis |
| [🎨 color-system](#color-system) | Curated color palettes + WCAG/APCA contrast guidance |
| [🔠 typography](#typography) | Type systems, scale, rhythm + a readability floor |
| [🧱 local-first-app](#local-first-app) | Local-first single-user app — feature set, not a code spec |

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
<summary><b>Plan, capture, and execute manual QA — the things tests can't verify (visual rendering, multi-step flows, race conditions, integrations, accessibility, performance feel).</b></summary>

Pairs with `track-roadmap` and `track-session` as the third member of the `cc-dash/*@1` schema family; failed items can file back to the roadmap as `r_xxxxx` issues.

**Use when:**
- Setting up a manual QA checklist before a release
- Auditing an existing QA list for relevance
- Migrating ad-hoc QA notes into the cc-dash schema
- Resuming a paused QA pass and picking the next pending item

**Triggers:** When asked to "create a QA list", "set up QA for this project", "what should I QA", "track manual QA", "audit the QA list", "start manual QA", or "what's left to check before release"

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

Domains: web-app UI, marketing/landing, data visualization, and terminal/TUI. Every palette maps hexes to **semantic roles** so themes stay swappable and accessible by construction.

**Use when:**
- Picking a ready-made palette for an app, brand, chart, or terminal
- Building a new palette from scratch (OKLCH scales, harmony schemes)
- Setting up light & dark mode (dark mode ≠ inversion; elevation = lighter)
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
- App-level routes: overview home, cross-entity `/search?q=`, `/trash`, `/settings`, and `/calendar` when the data carries dates
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

**Skill Count**: 14 | **Made for**: Claude Code 2.1.220+
