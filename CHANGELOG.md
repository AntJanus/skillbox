# Changelog

All notable changes to SkillBox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

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

[Unreleased]: https://github.com/antjanus/skillbox/compare/v2.11.0...HEAD
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
