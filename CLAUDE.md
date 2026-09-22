# SkillBox — Claude Code Agent Guide

## Repository Visibility: PUBLIC

**This repo is PUBLIC on GitHub (`AntJanus/skillbox`).** Everything committed here is world-readable and permanent.

- Before every commit, scrub PII and secrets: no API keys, tokens, `.env` values, real emails (beyond intended author attribution), internal/employer identifiers, or absolute paths containing a username (`/Users/<user>/...`).
- Run the `/publish-check` privacy scan over the diff before every commit, not only when in doubt.

## Project Overview

SkillBox is a collection of utility skills for Claude Code and AI agents. Each skill is a specialized instruction set that teaches agents how to handle a specific development workflow.

| | |
|---|---|
| Current release | **v10.0.0** (2026-09-03, the Fable 5.1 release) |
| Skills | **16** (see roster below) |
| Install | `npx skills add antjanus/skillbox` |
| Compatible with | Claude Code, Cursor, Cline, GitHub Copilot, and 40+ agents via [Vercel Skills](https://skills.sh) |
| License | MIT (per-skill `license: MIT` in frontmatter) |

**This is NOT a code project with a build.** It is a documentation repository. There is no `package.json`, no dependency install, and no unit-test framework — "tests" are two shell validators plus per-skill eval sets.

**No `ROADMAP.md`, deliberately.** By decision 2026-07-27 this repo tracks work through `CHANGELOG.md` + semver git tags instead. It is the only repo in the portfolio without a roadmap. Do not add one.

## Skill Roster

Verified against `skills/` on 2026-09-22. Versions come from each SKILL.md's `metadata.version`.

| Skill | Version | Covers |
|---|---|---|
| `ai-features` | 1.0.1 | Propose, mock and set up AI features for an existing app (local or hosted models) |
| `code-review` | 2.4.3 | Multi-agent review of local changes, writes REVIEW.md |
| `color-system` | 1.5.1 | Palettes, dark mode, contrast, chart and TUI color |
| `deep-research` | 2.4.2 | Multi-source web research with cited synthesis |
| `discuss` | 1.1.1 | Slash-only conversation mode (`disable-model-invocation: true`) |
| `generate-skill` | 6.2.0 | Interactive SKILL.md builder — the authoring spec |
| `ideal-react-component` | 1.8.2 | React file layout and hooks antipatterns |
| `local-first-app` | 4.7.0 | Single-user SQLite app, no accounts, no backend |
| `rate-skill` | 6.2.0 | Grades a SKILL.md A–F — the grading rubric |
| `record-tui` | 1.6.1 | VHS terminal/TUI demo recording |
| `screenshot-local` | 1.5.2 | shot-scraper screenshots of local pages |
| `setup-semantic-release` | 1.4.1 | semantic-release + conventional commits + commitlint |
| `track-roadmap` | 2.6.4 | ROADMAP.md generate/update/audit/brainstorm/resume |
| `track-session` | 6.2.3 | SESSION_PROGRESS.md across multi-session work |
| `typography` | 1.6.0 | Type scale, line-height, font pairing |
| `ui-ux-design` | 2.1.2 | Interaction states, a11y contracts, IA, tokens |

**`track-qa` was removed in v10.1.0 (2026-09-22)** after its 2026-09-01 deprecation; QA.md manual-QA checklists were retired portfolio-wide on 2026-08-24. Do not restore it or refile its items — hands-on verification is filed as ordinary `track-roadmap` items. Its last version, 1.4.0, is in the v10.0.0 tag if the `cc-dash/qa@1` schema is ever needed again.

`generate-skill` and `rate-skill` are the two meta-skills and are the source of truth for the authoring spec and the grading rubric respectively. When this file and one of those disagree, they win — fix this file.

## Development Commands

```bash
./test-skills.sh                          # local structure check + Vercel Skills CLI discovery
.github/scripts/validate-skills.sh skills/ # the CI validator (also runs locally)
python3 skills/generate-skill/scripts/measure.py <path/to/SKILL.md>   # description chars, body lines, tokens
python3 skills/generate-skill/scripts/measure.py score <7 category scores>  # rate-skill weighted grade
```

There is no lint or build step.

| Validator | Where it runs | Checks |
|---|---|---|
| `test-skills.sh` | Local, pre-publish | Frontmatter present, `name` matches directory, `description` present, 500-line warning, `npx skills add . -l` discovery |
| `.github/scripts/validate-skills.sh` | GitHub Actions (`validate-skills.yml`) on push/PR to `main` touching `skills/**` | Required frontmatter fields; Overview + Examples + Troubleshooting present (heading or progressive-disclosure equivalent); under 500 lines unless a `reference/` or `references/` dir exists; no broken internal links |

The CI validator treats "When to Use" and workflow-step headings as **soft warnings, not failures** — house style folds triggers into the description and lets main content be pattern-specific per skill type.

## Architecture

```
skillbox/
├── README.md                 # User-facing documentation
├── CLAUDE.md                 # This file
├── CHANGELOG.md              # Version history — the tracking doc, in place of a ROADMAP
├── test-skills.sh            # Local structure + CLI discovery check
├── logo.png
├── .github/
│   ├── scripts/validate-skills.sh
│   ├── workflows/validate-skills.yml
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── reference/
│   └── VERSION-CONTROL.md    # Repo-level release workflow (not shipped with any skill)
└── skills/<skill-name>/
    ├── SKILL.md              # Required
    ├── references/           # Optional; plural is canonical per Anthropic spec
    │   └── EVAL.md           # House convention: every skill has one
    ├── scripts/              # Optional (only generate-skill has one: measure.py)
    └── assets/               # Optional
```

`SESSION_PROGRESS.md` and `SESSION_ARCHIVE_*.md` are **gitignored** here — they carry cross-repo paths and project names that must not reach a public repo. Writing one locally is fine; it will never be committed.

### Directory naming

`references/` (plural) is canonical and is what new skills use. Six existing skills use the singular `reference/` — that is fine and is not worth churning; nothing validates directory names, and the CI validator accepts both.

### EVAL.md convention

Every skill carries an eval set at `reference(s)/EVAL.md`: should-trigger and should-not-trigger queries split train/validation, with a stated pass condition. A new skill is not done without one. `discuss` shows the variant for a slash-only skill — the should-not-trigger set becomes a regression check on `disable-model-invocation`.

### SKILL.md format

Frontmatter: `name`, `description`, `license`, `argument-hint` (top-level, quoted), `effort` when the job warrants a level other than the session's, and `metadata.author` / `metadata.version`. Required body sections depend on the skill type — the one shared spec is the table in `skills/generate-skill/SKILL.md` Phase 4, graded by `skills/rate-skill/SKILL.md` Category 4. Every type requires `## Gotchas`; `## Integration` is optional and is a deduction when it holds nothing concrete. When-to-use lives in the description, not a body section — the body only loads after triggering.

## House Conventions

The authoring spec lives in the meta-skills and is not restated here. What this section adds is the house choice where the spec leaves one open, and the pointer for everything else.

- **Descriptions:** the form, the trigger count, the coverage clause, the negative-scope clause, the 1024-char cap and the coverage-vs-intensity reading are `generate-skill` Phase 2. House choice: third-person directive register, distinctive noun in the first ~50 chars.
- **Bodies:** required sections by type are `generate-skill` Phase 4; the agentic-calibration list (no self-re-check scaffolding, no reasoning-echo or don't-think rules, no narration suppressors or anti-formatting rules, scoped non-blocking delegation, bounded written deliverables, no restatement of harness-injected text) is the same phase and is graded by `rate-skill` §6–§7. House choices: gates check external state only; ✅ / ❌ are the example labels, ✅ first, never `<Good>` / `<Bad>` tags; every ❌ carries a paired ✅; "Do X because Y" over ALL-CAPS mandates.
- **Length:** under 300 lines aimed, 500 hard cap, overflow to `references/` one level deep (`generate-skill` Phase 7).
- **Eval sets:** `generate-skill` Phase 8 and the EVAL.md convention above.

### Git and versioning

**Work goes straight to `main` — no feature branches** (decision 2026-09-02).

- **Conventional commits**: `type(scope): description`, scope being the skill name — e.g. `fix(track-session): collapse multiline description`.
- **Dual versioning**: each skill carries its own `metadata.version`; SkillBox releases are git tags.
- **CHANGELOG.md** records every change by release.

```bash
# Update a skill: edit SKILL.md, bump metadata.version, then
git commit -m "fix(skill-name): description"

# Cut a release
# 1. Update CHANGELOG.md with version and date
git commit -m "docs(changelog): prepare v10.1.0 release"
git tag -a v10.1.0 -m "Release v10.1.0 - summary"
git push && git push origin v10.1.0
```

Semver applies to both skills and releases: MAJOR for breaking changes, MINOR for backward-compatible additions, PATCH for fixes and typos.

Full workflow — commit conventions, when to increment, the 4-phase release process, CHANGELOG structure, release checklist, troubleshooting — is in **[reference/VERSION-CONTROL.md](./reference/VERSION-CONTROL.md)**. Load it only when needed, to save context.

## Workflows

### Creating a new skill

1. Run `/generate-skill skill-name`.
2. Answer its questions: purpose, triggers, enforcement level.
3. Review the generated SKILL.md against the checklist below.
4. Write `references/EVAL.md` — the skill is not done without one.
5. Test activation with real trigger phrases in a fresh session.
6. Run `./test-skills.sh` and `.github/scripts/validate-skills.sh skills/`.
7. Sync the three README inventories: the skill-count line, the skills table row, and the per-skill `<details>` block. Add the row to the roster above.
8. Record the addition under `[Unreleased]` in CHANGELOG.md.

### Editing an existing skill

1. Read the entire SKILL.md first.
2. Identify the pattern (methodology / technical / auditing) — sections differ by type.
3. Preserve existing sections and the frontmatter shape.
4. Bump `metadata.version`, and the roster row above.
5. Update `references/EVAL.md` if the description changed.
6. Record the change in CHANGELOG.md.

### Validation checklist

- [ ] Valid YAML frontmatter; `name` matches the directory
- [ ] Description in third-person directive form
- [ ] 3-5 trigger phrases, distinctive noun in the first ~50 chars
- [ ] Description ≤1024 chars
- [ ] Negative scoping ("Do NOT use this skill for X — see Y") for collision-prone domains
- [ ] Examples show ✅ / ❌ comparisons, ✅ first
- [ ] `## Gotchas` present
- [ ] Integration points documented when concrete; dropped if filler
- [ ] Under 300 lines (cap 500); overflow in `references/`
- [ ] `references/EVAL.md` present and current
- [ ] No generic self-re-check scaffolding, reasoning-echo, don't-think rules, narration suppressors, anti-formatting rules, unscoped or blocking delegation, or unbounded deliverable length (rate-skill §7); no restatement of harness-injected text (rate-skill §6)
- [ ] `effort` set when the skill's job warrants a level other than the session's (rate-skill §2 accepts it; generate-skill Phase 3 has the defaults by type)
- [ ] Code blocks specify a language
- [ ] No top-level `version`, `author`, `tags`, `category` — they live under `metadata`; `argument-hint`, `hooks` and `disable-model-invocation` are valid top-level Claude Code keys
- [ ] `metadata.version` bumped and CHANGELOG.md updated

### Testing activation

Test by saying the trigger phrase in a fresh session, not by reading the file:

```
user: I need to track progress on this long task     → track-session
user: Review my changes before I commit              → code-review
user: Create a skill for running database migrations → generate-skill
```

If a skill doesn't activate, work through generate-skill's Gotchas: a coverage clause for the indirect ask ("even if they don't explicitly mention X") beats another synonym in the trigger list, and the distinctive noun belongs in the first 50 characters.

**Activation conflicts** happen when two skills share triggers. Add `Do NOT use this skill for X — see Y` to whichever is the wrong fit, and make the remaining triggers mutually exclusive.

## Do Not

- Do not add a `ROADMAP.md` — CHANGELOG + semver replaced it by decision 2026-07-27.
- Do not open a feature branch; commit to `main` (decision 2026-09-02).
- Do not restore `track-qa` (removed in v10.1.0) or recreate any `QA.md` (retired 2026-08-24).
- Do not delete or modify a skill you weren't asked to touch.
- Do not rename a skill — names are stable references; rename only in a documented major version.
- Do not remove a skill's `## Gotchas` or examples sections.
- Do not commit `SESSION_PROGRESS.md` or anything else carrying cross-repo paths, employer identifiers, or `/Users/<user>/` paths — this repo is public.
- Do not tag a release without updating CHANGELOG.md first.
- Do not tag for a single skill bump — tags mark releases that bundle several.
- Do not edit a SKILL.md without bumping `metadata.version`.

Treat every issue working with SkillBox as an opportunity to update this file. The history of how each rule was arrived at lives in CHANGELOG.md, not here.

---

**Last Updated:** 2026-09-22
**Applies To:** Claude Code 2.1.258+
**Source:** https://antjanus.com/ai/claude-code-best-practices
