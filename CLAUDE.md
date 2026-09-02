# SkillBox - Claude Code Agent Guide

## Repository Visibility: PUBLIC

**This repo is PUBLIC on GitHub (`AntJanus/skillbox`).** Everything committed here is world-readable and permanent.

- Before every commit, scrub PII and secrets: no API keys, tokens, `.env` values, real emails (beyond intended author attribution), internal/employer identifiers, or absolute paths containing a username (`/Users/<user>/...`).
- When in doubt, run the `/publish-check` privacy scan over the diff before pushing.


This file helps Claude Code understand how to work with the SkillBox project effectively.

## Project Description

SkillBox is a collection of utility skills for Claude Code and AI agents. Each skill is a specialized instruction set that teaches agents how to handle specific development workflows.

**Core purpose:** Provide reusable, battle-tested skills that enhance AI agent capabilities across multiple platforms.

**Compatible with:** Claude Code, Cursor, Cline, GitHub Copilot, and 40+ other AI agents via the [Vercel Skills](https://skills.sh) ecosystem.

**Installation:** `npx skills add antjanus/skillbox`

**This is NOT:** A code project with tests and builds. This is a documentation and skill repository.

## File Structure and Patterns

```
skillbox/
├── README.md              # User-facing documentation
├── CLAUDE.md             # This file - AI onboarding doc
├── CHANGELOG.md          # Version history and release notes
├── SESSION_PROGRESS.md   # Active/most-recent work session (cc-dash/session@1)
├── SESSION_ARCHIVE_*.md  # Retired session files, kept for history
├── test-skills.sh        # Structure + Vercel Skills CLI discovery check
├── reference/            # Repo-level docs (not shipped with any skill)
│   └── VERSION-CONTROL.md # Complete versioning workflow
├── skills/               # All skills live here
│   ├── track-session/
│   │   └── SKILL.md      # Skill definition
│   ├── code-review/
│   │   └── SKILL.md
│   └── generate-skill/
│       └── SKILL.md
└── logo.png              # Project branding
```

### Skill Directory Pattern

Each skill MUST follow this structure:

```
skill-name/
├── SKILL.md              # Required: Core skill documentation
├── references/           # Optional: Extended docs loaded on demand (plural — canonical per Anthropic spec)
│   ├── STANDARDS.md
│   └── EXAMPLES.md
├── scripts/              # Optional: Automation scripts
└── assets/               # Optional: Templates / resources used in output
```

### SKILL.md Format

Frontmatter: `name`, `description`, `license`, `argument-hint` (top-level, quoted), `effort` when the job warrants a level other than the session's, and `metadata.author` / `metadata.version`. Required body sections depend on the skill type — the one shared spec is the table in `skills/generate-skill/SKILL.md` Phase 4, graded by `skills/rate-skill/SKILL.md` Category 4. Every type requires `## Gotchas`; `## Integration` is optional and is a deduction when it holds nothing concrete. When-to-use lives in the description, not a body section — the body only loads after triggering.

## Libraries and Deprecated Code

### Approved Patterns

**DO use these patterns:**

- Workflows that lead with the goal, the constraints, and gates on **external state** — a test run, a file that exists, a command that exits 0 — with numbered phases only where the order is load-bearing. Never a gate on the agent re-reading its own output.
- "Quality Signals" sections listing what good looks like
- "Anti-Patterns" sections with paired ✅ alternative for every ❌ item (negation handling in LLMs is empirically weak — pair `do not X` with `do Y instead`)
- ✅ / ❌ markdown emoji for example comparisons (community convention per Anthropic skill-creator + docx)
- Progressive disclosure (SKILL.md < 300 lines preferred, hard cap 500; extended docs in `references/` — plural is canonical)
- Trigger-rich descriptions in directive third-person form ("Use this skill whenever the user wants to…")

### Forbidden Patterns

**DO NOT use these patterns:**

- Vague descriptions like "A skill for testing" or "Helps with React"
- Single-sentence descriptions without specific triggers
- First-person POV ("I'll help you…") — empirically degrades activation reliability
- Descriptions over 1024 chars — the spec hard cap and the only length rule. Listing eviction is least-invoked-first, so workhorse skills keep their full text.
- Skills over 500 lines without progressive disclosure (aim under 300)
- Examples without ✅ / ❌ comparisons
- `<Good>` / `<Bad>` XML tag wrappers — non-canonical (zero of 8 surveyed top community skills use them); recommend ✅ / ❌ instead
- ALL-CAPS "IRON LAW" / "NEVER" / "ALWAYS" framing without explained reasoning — "Do X because Y" outperforms a bare "ALWAYS X" (Claude 5 prompting guidance)
- Top-level `version`, `author`, `tags`, `category` in frontmatter — produce "unexpected key" errors (anthropics/skills #37). They live under `metadata` (except `argument-hint`, which is top-level; `hooks` is a valid Claude Code runtime key — see the three-tier note in Learnings).
- Generic self-re-check scaffolding: "double-check your answer", "re-verify before responding", "include a final verification step for any non-trivial task". Current models re-read their own output unprompted, so these compound with behavior that already happens and cost tokens with no quality gain — the fix is deletion, not rewording. Three things are not this and stay: checks against external state ("run the test suite", "confirm the file parses"), a fresh-context verifier agent judging *another* agent's output, and an evidence audit before a progress report ("only report work you can point to a tool result for"). The Fable 5.1 guidance recommends the last two for long-running work.
- Instructing the agent not to think or not to reason — increases leakage of internal XML tags into visible output.
- Narration suppressors ("hold all findings for the final response", "don't narrate") and anti-formatting rules ("never use bullets", "no bold") — written against models that over-narrated and over-formatted; current Fable-tier models do the opposite, so these lines produce silence and flat prose. Say when a specific update or format is wanted instead.
- Subagent instructions with no scope, or that block the orchestrator on each agent: name which scenarios warrant delegation and the cap, dispatch independent agents in one message, and keep working while they run.
- An output template for a file the agent writes that doesn't bound the file's length — written deliverables run long by default.
- Restating text the Claude Code harness already injects every session (the autonomy block, the delivering-work scope block, the progress-update line, the overplanning nudge, the hidden-tool-output note, the batch-tool-calls nudge, the readability rules) — the model then reconciles two wordings of one rule.

## Standards and Expectations

### DO: Creating and Editing Skills

- **DO** use the `generate-skill` skill when creating new skills
- **DO** include 3-5 specific trigger phrases in the description field
- **DO** keep the `description` field within the **1024-char spec hard cap** (agentskills.io) — the only length rule; listing eviction is least-invoked-first, so workhorse skills keep their full text. agentskills.io says "err on the side of being pushy"; platform.claude.com says models "may now overtrigger" on skills and to "dial back any aggressive language." Read as **coverage vs. intensity** and they agree: more literal triggers and a coverage clause raise recall, ALL-CAPS and "CRITICAL: you MUST" raise nothing. Be pushy about coverage, normal in register. Still front-load the distinctive trigger noun in the first ~50 chars.
- **DO** write descriptions in third person ("Use this skill whenever the user wants to…", not "I help you…"). First-person POV empirically degrades activation.
- **DO** use directive register: "Use this skill whenever the user wants to…" with a "Do NOT use this skill for…" negative scope clause for collision-prone domains
- **DO** provide ✅ / ❌ example comparisons (community convention per Anthropic skill-creator + docx)
- **DO** include a `## Gotchas` section — concrete edge cases and failure modes are the body content agents can't infer (agentskills.io recommends them)
- **DO** keep SKILL.md under 300 lines (house aim) / 500 (canonical hard cap — Claude Code docs, spec, and skill-creator all state it). Use `references/` (plural) for extended content in new skills; existing singular `reference/` dirs are fine — nothing validates directory names. ETH Zurich arXiv 2602.11988 found context files generally don't improve task success while adding >20% inference cost.
- **DO** gate methodology phases on external state when a gate is warranted (a passing test, a file on disk); a closing self-verification section is not a spec section for any type
- **DO** use clear, imperative language (short sentences, bullet points)
- **DO** fold "When to Use" content into the description, not a body section (Anthropic skill-creator guidance: "Include all when-to-use information in the description, not the body — the body only loads after triggering.")
- **DO** document integration points with other skills

### DO NOT: Anti-Patterns

- **DO NOT** create vague or generic skills without specific use cases
- **DO NOT** skip examples - always show ✅ / ❌ comparisons (✅ first; if room, also last — recency bias)
- **DO NOT** ship a skill without a `## Gotchas` section — concrete failure modes are the body content the agent can't infer
- **DO NOT** use abstract language - be concrete and specific
- **DO NOT** skip the frontmatter metadata
- **DO NOT** create skills that duplicate existing functionality
- **DO NOT** write skills without testing activation triggers

### File Operations

**DO:**
- Read existing SKILL.md files before modifying them
- Preserve the YAML frontmatter exactly
- Keep examples in ✅ / ❌ format with desired pattern shown first
- Update version numbers when making changes

**DO NOT:**
- Delete or modify other skills without explicit request
- Change skill names (breaks existing references)
- Remove Gotchas or Examples sections
- Break markdown formatting

### Documentation Style

**DO use this style:**
```markdown
## Workflow

**Goal:** the file parses and the test suite passes on the new schema.
**Constraints:** touch only the migration and its test; report anything else as a follow-up.
**Gates:** `npm test` exits 0 before tagging.

Prose on how to approach the class of problem. Numbered phases only where the
order is load-bearing — install before config, scope before dispatch — with the
reason the order matters.

**Anti-Patterns:**
- ❌ Skipping a gate "just this once" — the next step assumes it passed
  ✅ Run the gate; if it fails, go back
```

**DO NOT use this style:**
```markdown
## Setup

Maybe you should do these things:
- Thing 1
- Thing 2

Run some commands to set up.
```

## Version Control & Changelog

SkillBox uses:
- **Conventional commits**: `type(scope): description` format
- **Dual versioning**: Individual skills (in frontmatter) + SkillBox releases (git tags)
- **CHANGELOG.md**: Tracks all changes by release

### Essential Workflow

**Update a skill:**
```bash
# Edit SKILL.md, bump version in frontmatter
git commit -m "fix(skill-name): description"
```

**Create a release:**
```bash
# 1. Update CHANGELOG.md with version and date
# 2. Commit changelog
git commit -m "docs(changelog): prepare v1.2.0 release"

# 3. Create and push annotated tag
git tag -a v1.2.0 -m "Release v1.2.0 - summary"
git push && git push origin v1.2.0
```

**Semantic versioning (skills and releases):**
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes and typos

### Deep Reference

For complete workflow details:

**[📋 Version Control & Changelog Guide](./reference/VERSION-CONTROL.md)**

Includes:
- Commit message conventions and examples
- When to increment skill versions
- Step-by-step release process (4 phases)
- CHANGELOG.md structure and guidelines
- Release checklist
- Git commands for viewing history
- Troubleshooting version issues

**Load reference/ docs only when specifically needed to save context.**

## Workflow and Testing

### Creating a New Skill

1. **Use generate-skill**: `/generate-skill skill-name`
2. **Answer questions**: Skill purpose, triggers, enforcement level
3. **Review generated SKILL.md**: Verify all sections present
4. **Test activation**: Ensure trigger phrases work
5. **Document integration**: How it works with existing skills

### Editing Existing Skills

1. **Read the skill first**: `Read` the entire SKILL.md
2. **Understand the pattern**: Methodology? Technical? Auditing?
3. **Preserve structure**: Keep all existing sections
4. **Update version**: Increment metadata.version
5. **Test changes**: Verify triggers still work

### Validation Checklist

Before marking skill work complete:

- [ ] SKILL.md has valid YAML frontmatter
- [ ] Description in third-person directive form ("Use this skill whenever the user wants to…")
- [ ] Description includes 3-5 trigger phrases front-loaded in first ~50 chars
- [ ] Description ≤1024 chars (spec hard cap — the only length rule)
- [ ] Negative scoping ("Do NOT use this skill for X — see Y") for collision-prone domains
- [ ] Examples show ✅ / ❌ comparisons (✅ first)
- [ ] Gotchas section present (canonical per agentskills.io — concrete edge cases agents can't infer)
- [ ] Integration points documented (when concrete; drop if filler)
- [ ] SKILL.md aim under 300 lines, hard cap 500. Use `references/` (plural) for overflow.
- [ ] No generic self-re-check scaffolding, reasoning-echo, don't-think rules, narration suppressors, anti-formatting rules, unscoped or blocking delegation, or unbounded deliverable length (rate-skill §7); no restatement of harness-injected text (rate-skill §6)
- [ ] `effort` set when the skill's job warrants a level other than the session's (rate-skill §2 accepts it; generate-skill Phase 3 has the defaults by type)
- [ ] Markdown formatting is correct
- [ ] Code blocks specify language
- [ ] No top-level `version`, `author`, `tags`, `category` (use `metadata.*` instead; CC extension keys like `argument-hint`/`hooks` stay top-level)

### Testing Skills

**Test activation by trying trigger phrases:**

```
user: I need to track progress on this long task
[Should activate track-session]

user: Review my changes before I commit
[Should activate code-review]

user: Create a skill for running database migrations
[Should activate generate-skill]
```

**If skill doesn't activate:**
1. Check description field has specific triggers
2. Verify frontmatter is valid YAML
3. Ensure triggers match user's natural language
4. Add more trigger variations

## Anti-Patterns

If you catch yourself doing any of these, reconsider — each has a paired ✅ alternative:

- ❌ Creating skill without reading existing skills first
  ✅ Read 2-3 existing SKILL.md files to learn the house patterns first
- ❌ Vague description ("A skill for testing")
  ✅ Directive third-person form with 3-5 concrete user-language triggers and a `Do NOT use for…` scope clause
- ❌ First-person POV in description ("I help you…")
  ✅ Third-person ("Use this skill whenever the user wants to…")
- ❌ Skipping examples section
  ✅ At least one ✅ / ❌ comparison, desired pattern shown first
- ❌ Changing skill names mid-release
  ✅ Names are stable references — only rename in a documented major version
- ❌ Over 500 lines without progressive disclosure
  ✅ Move overflow to `references/` (plural), one level deep
- ❌ Telling the agent to double-check or re-verify its own output with nothing external to check against
  ✅ Gate on something outside the agent — a test that runs, a file that exists, a command that exits 0, a fresh-context verifier agent, a tool result each progress claim points to
- ❌ Testing by reading code instead of trigger phrases
  ✅ Test activation by saying the actual trigger phrase in a fresh Claude session
- ❌ Creating git tag without updating CHANGELOG.md
  ✅ Update CHANGELOG first, commit, then tag
- ❌ Non-conventional commit messages
  ✅ `type(scope): description` (e.g., `fix(track-session): collapse multiline description`)
- ❌ Forgetting to increment `metadata.version`
  ✅ Every skill edit bumps the version (PATCH for fixes, MINOR for additions, MAJOR for breaks)
- ❌ Creating tag for individual skill update
  ✅ Tags mark SkillBox releases that bundle multiple skill bumps
- ❌ ALL-CAPS "IRON LAW" / "NEVER" / "ALWAYS" framing
  ✅ "Quality Signals" and "Anti-Patterns" with explained reasoning ("Do X because Y", Claude 5 prompting guidance)

## Troubleshooting

### Problem: Skill activation conflicts

**Cause:** Two skills share triggers.

**Solution:** Add `Do NOT use this skill for X — see Y` to whichever is the wrong fit, and make the remaining triggers mutually exclusive. Activation misses and oversized bodies are covered by generate-skill's Gotchas.

## Integration with Other Skills

### generate-skill + existing skills

When creating new skills:
- Read existing skills for patterns
- Use similar structure for consistency
- Reference existing skills in "Integration" section
- Maintain consistent quality standards

## Skill Development Philosophy

**Activation over configuration:**
Skills should activate automatically when relevant context appears. The description field is the only signal Claude reads pre-trigger — tune it like a prompt.

**Quality Signals over Red Flags:**
Frame requirements as "what good looks like" first. LLMs follow positive directives more reliably than negations (negation handling is empirically weak — arXiv 2503.22395). Pair every `Do NOT X` with a paired `Do Y instead`.

**Examples over explanation:**
Show concrete ✅ / ❌ comparisons, not just abstract rules. ✅ shown first; if room, also last (recency bias).

**Progressive disclosure:**
Start with essentials in SKILL.md, reveal complexity in `references/` (plural for new dirs) when needed. Aim under 300 lines (ETH Zurich arXiv 2602.11988: context files add >20% inference cost without improving task success).

**Gate on external state, never on self-review:**
Where a methodology phase needs a gate, it checks something outside the agent. Instructions to re-check its own work are removed, not reworded — the model already does that, so restating it compounds the behavior and burns tokens.

## Meta

This CLAUDE.md follows its own advice:
- Short, imperative sentences
- Do/Don't lists clearly marked
- Concrete examples with code
- Checklists that gate on something checkable
- Anti-Patterns section with paired ✅ alternatives
- A single Anti-Patterns recap, with the provenance archive kept out of the per-session load

Treat every issue working with SkillBox as an opportunity to update this file.

## Learnings

The dated record of how each rule above was arrived at, including the entries that were later overturned, lives in **[reference/LEARNINGS.md](./reference/LEARNINGS.md)**. Load it when a rule looks wrong and you need its provenance before changing it. New learnings go there; the rule they produce goes in the section above that it belongs to.

---

**Last Updated:** 2026-09-02
**Applies To:** Claude Code 2.1.258+
**Source:** https://antjanus.com/ai/claude-code-best-practices
