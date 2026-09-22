# Changelog

All notable changes to SkillBox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- **track-roadmap** (2.6.4 → 2.7.0): items can carry quoted notes (`  > ` lines under the item) for research, open questions and rejected alternatives, which cc-dash now parses, displays and preserves; notes are kept to about five lines with longer research moved to `docs/`, and trimmed when an item completes. Brainstorm keeps its Deepen output as notes instead of leaving it in chat. From a usage audit of 15 activations: the description adds "put these in the roadmap", "update the roadmap" and "work through the roadmap" after 11 of 16 roadmap-edit asks went unrouted; working through the whole roadmap is a documented Resume pattern; the format rules list the full status set (`deferred`, `dropped`, `skipped`, `rejected`, `cancelled`), `depends:`, the accepted id shape and a duplicate check (53 duplicate ids were live), and say that `at:` and `done_date:` are dropped by cc-dash. Eval set 19 → 22 queries.
- **color-system** (1.5.1 → 1.6.0): Carbon moves out of the 711-line `palettes.md` into a self-contained `references/carbon.md` (roles, dashboard kit and triads, both modes), with a Navigation row routing artifact builds straight to it. A usage audit found Carbon was the skill's main job and that agents pulled it out with 16 different grep and awk ranges, often sweeping in neighbouring palettes. The description's coverage clause now reaches terse unreadable-on-background and can't-tell-apart complaints, which missed in real use, while leaving too-small text to typography; the eval set grew from 18 to 24 queries.
- **typography** (1.6.0 → 1.7.0): "verify computed, not authored" now ships a tested `shot-scraper javascript` check that returns every visible text node under 14px, because agents fell back to grepping authored `font-size`. New gotcha: bespoke faces on a one-off page or artifact ship under the floor, so run the check before publishing.
- **ui-ux-design** (2.1.2 → 2.2.0): an approved design is now filed as its own task in the tracked plan, after an approved redesign went unbuilt while a later session reported every plan task done. New "Presenting concept options" section (full screens in the app's own chrome, fewest elements), a length cap on audit lane reports, the narrowest real container added to the break-it-with-real-data list, a line to read the project's own pattern library first, and copywriting added to the negative scope.
- **track-session** (6.2.3 → 6.3.0): fixes from a usage audit of 52 activations over 2026-08-21 → 09-22. Timestamps now come from a `date` command, because 553 of 569 real stamps ended in `:00` and about half of the checkable ones were off by more than 15 minutes, up to five hours. Routing gains a branch for a `completed` file (hand off to `/track-roadmap resume`) and says a missing file means Start, not a reconstruction; six of 25 resumes had improvised both. Ticking the last task now closes the session in the same write, after 22 of 30 files were found left `completed` or `in-progress` with every task done. New gotchas: `save` with subagents still running, invented headings kept on disk but never shown (`## Notes` was the most common), one file per repo at the root, and writing through Edit/Write because `recover` cannot replay Bash heredocs (which made up most real writes). Verify notes that cc-dash renders its section; Integration sends lasting findings to the roadmap item.

### Fixed

- **track-session** (6.2.2 → 6.2.3): the id rule and its gotcha now match what cc-dash parses. The skill said the dashboard read ids leniently; it validated every session file against 5-char ids and hid the whole file on one mismatch, which on 2026-09-22 blacked out 21 of 30 live session files. cc-dash now accepts `t_`/`f_` plus 1–20 `[a-z0-9_-]` chars and drops a bad entry with a warning instead of the file; the skill states that shape, that `task:`, `ref:` and `roadmap_ref` take exactly one id, and where to name a session's other features.
- **track-roadmap** (2.6.3 → 2.6.4): the gotcha saying `roadmap_ref` could be a comma list is reversed. A list is dropped by cc-dash, unlinking the session; link one feature and name the rest in the session's Current Status.

## [10.1.0] - 2026-09-22

The AI features release. One new skill, **`ai-features`** (1.0.1): it reads an existing app, proposes the AI features its data can support from a catalog of ninety features real products shipped, mocks the strongest ones as static screens on example data, and, once the user picks, builds only the shared plumbing — runtime detection for Ollama, LM Studio, in-process models and hosted keys, one runtime interface, configuration in the app's own store, a feature gate off by default. It carries a dated model roster and the rules the withdrawn features taught (opt-in for anything that indexes everything, an off switch on every AI surface, generate-then-edit for anything published under the user's name). A fresh-grader rate-skill pass graded it A (94.5) and its patches shipped as 1.0.1 the same day. **`track-qa` is removed**, as v10.0.0 announced. CLAUDE.md collapsed from 291 to 216 lines. 16 skills.

### Removed

- **track-qa** (1.4.0): deleted, as announced in v10.0.0. QA.md manual-QA checklists were retired portfolio-wide on 2026-08-24, the skill was deprecated on 2026-09-01, and nothing in the repo or the fleet references it live any more (the remaining mentions are historical rows in other skills' eval tables). The `cc-dash/qa@1` schema it documented lives on in the v10.0.0 tag. Hands-on verification is filed as ordinary `track-roadmap` items.

### Changed

- **CLAUDE.md** rewritten (the 2026-09-08 audit restructure, which had never been committed, plus the 2026-09-22 analysis). The roster gained `ai-features` and a verification date; the singular-`reference/` count corrected from nine to seven; the stale-branch sentence dropped after `feat/ui-ux-design-2.0.0` was merged (a no-op — main was 63 commits ahead) and deleted. Five sections that restated the meta-skills' spec three to six times each (Approved patterns, Forbidden patterns, Writing descriptions, Writing bodies, Design Philosophy) collapsed into one House Conventions section that keeps only the house choices and points at `generate-skill` Phase 2, 4, 7 and 8 and `rate-skill` §6–§7 for the rest; the Validation checklist stays as the one intentional duplicate, because it is used as a gate without opening the meta-skills. "Creating a new skill" gained the README three-place sync and the CHANGELOG step; `/publish-check` is now required before every commit rather than "when in doubt". 291 → 216 lines.

- **ai-features** (1.0.0 → 1.0.1): the fresh-grader rate-skill pass (A, 94.5) applied. P1: Phase 4 now names the mock medium — one self-contained HTML page per proposal in the scratchpad, on the app's own tokens, day/night toggle, published as a tabbed artifact — where it previously left the agent to choose between ASCII, an in-repo component and a page. P2: four rules stated both in SKILL.md and a reference now live once, in the symptom-keyed gotcha (enum-not-prose, key location, the spend-cap 429 shape, the Whisper voice-activity gate); the tag-suggestion example gained its ❌ pair. P3: a dated-tags line above the examples, "see update-config" and "see mcp-server-dev" pointers on the two negative-scope exclusions that had none, and the OpenAI-script eval query re-annotated to plain coding. The eval set is still unmeasured.

### Added

- **ai-features** (1.0.0): a methodology skill that audits an existing app and proposes the AI features its data can support, then wires the initial AI setup. Six phases gated on external state: inventory the machine (Ollama, LM Studio, in-process model files, hosted key names, all probed with timeouts), read the app's schema and search implementation, cross a catalog of shipped AI features with the app's real columns and score on usefulness, fit, cost tier and risk, mock the top proposals as static screens on example data, present as an artifact or a written list, and build only the shared plumbing once the user picks. `references/CATALOG.md` holds the feature catalog by app category with the ones users rejected; `references/MODELS.md` a dated roster (which local model for embeddings, tagging, typed decisions, summaries, natural-language filters, vision, speech; hosted prices; local-vs-hosted rules; memory and context limits); `references/SETUP.md` the runtime interface, configuration keys, structured output per provider, vectors in SQLite, packaging and hygiene. Ten gotchas from reproduced failures: prose-stated vocabularies invent tags where a schema enum invents none, Ollama's memory-scaled context default truncates silently and the OpenAI-compatible route ignores `num_ctx`, an uncalibrated distance ceiling reports the candidate pool as the match count, embeddings outlive deleted rows because `node:sqlite` opens with foreign keys off, and a hosted spend cap returns 429 with no `retry-after`. Configuration storage is deliberately not prescribed: the app's existing convention for external-service credentials wins. `references/EVAL.md` ships a 20-query set at 60/40, unmeasured.

## [10.0.0] - 2026-09-03

The Fable 5.1 release. The two meta-skills went major — `generate-skill` and `rate-skill` 5.1.0 → 6.2.0 — after a doctrine sync against the Claude Fable 5.1 prompting guide narrowed the verification rule for the second time in six weeks, added `effort` to the frontmatter template, and named two new anti-patterns (narration suppressors, anti-formatting rules) plus a deduction for restating text the Claude Code harness already injects. Everything else followed from grading the fleet against that rubric: a **ratings pass** on 2026-09-02 patched all fourteen active skills (every one graded A), and a **`/claude-api prompt-audit`** on 2026-09-03 removed fourteen dated instructions the ratings pass did not reach — most of them from the January 2026 CLAUDE.md skeleton and the February verify guide — and gave `local-first-app` (4.5.0 → 4.7.0) the Gotchas section and eval set it lacked. `code-review` reached 2.4.3 with a two-tier complexity check and a verifier prompt that states its drop rule once; `typography` 1.6.0 fixed a caption-floor contradiction to a 14px hard floor; `track-session` 6.2.2 cut its verify guide to the goal, constraints, and gates. **Breaking:** `track-qa` is deprecated (1.4.0) and is removed in the next release; `rate-skill` grades differently than 5.x on verification scaffolding and harness duplication, so a 5.x A is not a 6.x A. 16 skills, 57 files, every skill except `color-system` and `screenshot-local` at a new version since v9.6.0.

### Deprecated

- **track-qa** (1.3.0 → 1.4.0): marked deprecated. Every `QA.md` in the portfolio was deleted by decision on 2026-08-24 and the cc-dash `/qa` views read empty by design, so a skill whose only job is to generate, audit, migrate, or resume a `QA.md` has nothing left to act on. The description now opens with the deprecation and tells the model not to activate for any QA phrasing; the body carries the same banner above the (unchanged) schema reference, which stays for one release so `cc-dash/qa@1` remains documented. Hands-on verification is filed as an ordinary roadmap item (playthrough, parity gate, release sign-off) with `track-roadmap`. The skill is removed in the release after this one.

### Changed

- **local-first-app** (4.6.1 → 4.7.0): the two rate-skill gaps the 2026-09-03 audit flagged. A `## Gotchas` section (six entries, all from reproduced failures in the true* fleet: foreign keys off per connection so cascade-to-trash silently does nothing; a mid-session migration skipped by the `globalThis` cache; snapshots wiped by the reset they existed for, or pruned newest-first by a lexical sort; pre-migration-only snapshots leaving a month-old backup; a checkbox inside a card-wide link desyncing from its state; a roll-up that counts one entity type). `references/EVAL.md` rebuilt from the 2026-07-28 set with the two 3.x-architecture train queries replaced by 4.x feature asks (trash view, saved filter); its Results table records that the 4.7.0 description is unmeasured, so the standing P1 stays until a run is logged. PACKAGING.md's Deno 2.9+ floor now carries a verification date against docs.deno.com.

- **local-first-app** (4.6.0 → 4.6.1): prompt-audit pass on the one skill the 2026-09-02 fleet passes did not cover. The scope paragraph's first sentence ("Build what the task asks for, completely, and nothing beside it") restated the harness's delivering-work block, so the model reconciled two wordings of one rule; dropped, keeping the follow-up and test-sizing sentences the Fable 5.1 guide adds. PACKAGING.md stated the tsc/eslint/gitignore exclusion twice; the Data-dir paragraph keeps only the path rule. Flagged, not changed: the Deno 2.9+ floor carries no verification date, SKILL.md has no `## Gotchas` (PACKAGING.md's are the only ones), and `references/EVAL.md` was deleted in the 2026-07-29 rewrite and never rebuilt — both rate-skill items for the next pass.

- **Prompt-audit pass, 2026-09-03** (`/claude-api prompt-audit` over the whole repo, target Claude Fable 5.1). The surface came back clean of pressure language, thinking scaffolds, narration suppressors, anti-formatting rules, and stale model IDs; twelve medium findings were applied, most of them text the 2026-09-02 cleanup did not reach. **CLAUDE.md:** the seven-line `DO NOT` list (every item already had a positive twin; the one that did not became a `DO` line), the four-step "if skill doesn't activate" list ending in "add more trigger variations" (now one sentence pointing at generate-skill's Gotchas and the coverage clause), and the generic-virtues "Integration with Other Skills" section — all three dated to the 2026-01-29 skeleton. **track-session** (6.2.1 → 6.2.2): VERIFICATION.md drops its preamble, the three general-knowledge scenarios (run the tests, try null inputs, check a dependency chain) and the verify-after-every-phase cadence advice, all from 2026-02-04; 158 → 94 lines. **deep-research** (2.4.1 → 2.4.2): the PLAYBOOK "tempted to call it done after 1-2 searches" entry reframed without the laziness frame, keeping the reason and pointing at `quick` mode. **code-review** (2.4.2 → 2.4.3): the verifier's drop rule was stated three times in eight lines, including a "(Not demote — drop.)" aside against the retired 1.x design a fresh subagent never saw — now once; the Haiku "full skeleton verbatim" clause dropped because Phase 2 already passes skeletons verbatim to every model. **rate-skill** (6.1.0 → 6.2.0): the verification gotcha loses its flip history and keeps the per-model re-check rule; workflow step 5 now runs `measure.py score` for the weighted table and letter instead of having the model multiply and sum, with `Bash(python3 *)` added to `allowed-tools`. **generate-skill** (6.1.0 → 6.2.0): `scripts/measure.py` gains that `score` mode (seven category scores in rubric order → weighted table + letter; default mode unchanged). **discuss** (1.1.0 → 1.1.1): the banned-opener list ("Great question", "Let me...", "Hope that helps") became the positive form (first line is the position, last line is the hook), and the ASD-STE100 word counts (20/25 words per sentence, 6 sentences, 3-word noun clusters) became qualitative one-idea-per-sentence rules, with EVAL.md's pass condition and the counter-example verdict updated to match — the skill's own gotcha recorded the caps making replies read cold. Flagged and left alone: the discuss ❌ transcript's older-model idiom, local-first-app's harness-overlapping scope sentence (the skill ships cross-platform), generation-relative wording in CLAUDE.md, and the deprecated track-qa stub.

- **generate-skill** (5.1.1 → 6.0.0), **rate-skill** (5.1.0 → 6.0.0): doctrine sync against the [Prompting Claude Fable 5.1 guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1), the meta-pair's second reversal on one rule in six weeks, hence the majors.

  **The verification deduction narrowed.** 5.0.0 penalized any "verify your work" instruction on the Opus 5 guidance that current models verify unprompted. The Fable 5.1 migration guidance says to keep test-or-check-before-reporting instructions, that fresh-context verifier agents outperform self-critique, and that auditing progress claims against tool results nearly eliminated fabricated status reports — marked tentative there. rate-skill §7 and generate-skill Phase 4 now deduct only for generic re-checks with no external referent, and name three carve-outs that score fine: external-state gates, a writer-verifier pattern, and an evidence audit before a progress report. Both EXAMPLES.md files gained a ✅ for the evidence audit; rate-skill's retired-rules entry records the narrowing; a new rate-skill gotcha notes the rule is per-model and has flipped twice.

  **`effort` joins the frontmatter template.** Verified live on 2026-09-02 with the `${CLAUDE_EFFORT}` substitution: a control skill reported `high`, a skill with `effort: low` reported `low`, so the key overrides the session level on invocation. generate-skill Phase 3 emits it with defaults by type (automation and reference `low`, technical `medium`, auditing and methodology `high`, multi-source synthesis and agentic coding `xhigh`) and the two 5.1 effort behaviors that motivate them — less searching at `low`, double-drafted long deliverables at `xhigh`/`max`. FRONTMATTER.md's row records the probe.

  **Two new §7 anti-patterns and one §6 item.** Narration suppressors ("hold all findings for the final response") and anti-formatting rules ("never use bullets") were written against models that over-narrated and over-formatted; Fable 5.1 does the opposite, so the lines produce silence and flat prose. A fleet grep found zero of either — these are guards. rate-skill §6 now deducts for restating the seven snippets the Claude Code harness injects itself (autonomy block, delivering-work scope, progress-update line, overplanning nudge, hidden-tool-output note, batch nudge, readability rules), and generate-skill's calibration list says not to emit them.

  **Delegation wording, scope-and-tests line, template shape, model unpin.** "Cap delegation" became "scope delegation": the cap stays (it is the global cost rule), and the guide's non-blocking half is added — dispatch independent agents in one message and keep working. Code-producing skills get a template line for unrequested fixes and scratch tests, which the guide reports cuts both substantially with no change in task success. PATTERNS.md's methodology skeleton now leads with goal, constraints, and gates, with phases only where the order is load-bearing. "Fable 5" is unpinned to "current Fable-tier models" in the reasoning-echo rule in both skills. Both SOURCES.md files cite the 5.1 guide and the Claude Code frontmatter reference. CLAUDE.md's forbidden-patterns list, validation checklist, and Learnings carry the same changes.

- **Fleet ratings pass, 2026-09-02.** Thirteen fresh subagents each ran rate-skill 6.0.1 on one skill; the graders' findings and rubric complaints were applied in the same day. Every skill graded A (92.3 to 98.5). Four defects repeated across the fleet and were fixed everywhere they appeared: eval variant tables saying "not yet run" under a paragraph that recorded a real 2026-07-28 measurement (12 of 13 skills); payload duplicated between SKILL.md and its references (11 of 13); references to the deprecated track-qa still standing in eval sets and Integration lines (4); examples ending on a ❌ or carrying an unpaired ✅ (7). The four skills the user asked to be thorough on — code-review, deep-research, track-session, ui-ux-design — also got a `/claude-api prompt-audit` pass over every file in their directories.

- **rate-skill** (6.0.1 → 6.1.0): eight rubric clarifications collected from what thirteen graders said was hard to apply. §5 now counts *situations*, not blocks or pairs, gives −5 for one unpaired ✅ in a paired set, and says "ends on a desired example" means the last example, not the last section. The eval check now has a priority for every state: missing (P1), shipped description unmeasured (P1), never run or protocol inverted (P1), other gaps (P2), and a `disable-model-invocation` exemption. Type tie-breaks are decided by which profile's sections the body already names, never by a heading name. §6 states its counting rules (one rule copied N times is one occurrence; intra-file counts; a symptom index is not a duplicate; one deliberate gotcha reinforcement is allowed). §4's written-deliverable rule now covers chat deliverables a handoff writes to disk, scripts the agent writes, and templates in load-on-demand references (−5). §1 takes −5 for a recorded validation miss. §7's rot list gains references to skills scheduled for deletion, model-tier cost comparisons, and verbatim harness quotes — which is the grader's own P1 on itself: the 6.0.1 harness-string list was moved out of §6 into `references/EXAMPLES.md` under a dated heading. Also: workflow step 7 folded into step 5, the duplicated re-check sentence dropped from the Overview, "give my skill a letter grade" added as a trigger to close the V2 miss open since July, T6/N6 added for a 20-query 60/40 set, T2 retargeted off track-qa.

- **generate-skill** (6.0.1 → 6.1.0): the second grader's P1 — the eval loop ran inverted, train never run, 6.0.0 "selected" by scope match — is answered with a 20-query set at 60/40 (T6/N6) and a harness rule: deictic queries get a `CHECKLIST.md` fixture in the empty directory so a miss measures the description rather than the absence of the thing the query points at. "checklist" returns to the coverage clause now that track-qa is gone. The skill sets `effort: high` on itself, the effort defaults live once (FRONTMATTER.md keeps only the probe note), the length budget line that appeared three times is gone, "never instruct the agent not to think" gained its positive pair, and the duplicate docx example became an automation-type example.

- **code-review** (2.4.1 → 2.4.2): `reference/TROUBLESHOOTING.md` contradicted SKILL.md on who may orchestrate `--background` ("must be the MAIN thread") — rewritten to the 2.3.0 correction, and its "three inline entries" claim fixed to one. The "Effort and model" paragraph added in 2.4.1 was unactionable (the Agent tool has no effort parameter) and is replaced by an executable line: pass `model: "sonnet"` on every lane unless the user names one. Dispatch mechanics that appeared three times now live once (Background mode points at Gotchas; the AGENTS.md background paragraph is one sentence). The maintainer note left Integration for EVAL.md, which also gained the lane-quality check and a two-row variant table. From the audit: six migration-relative sentences ("retired in 2.0", "no `[Unverified]` tier anymore") rewritten as current rules, and the shouted emphasis through the five lane prompts and the verifier (ONLY, WRONG ANSWER, NOT, BOTH, CONCRETE BAD OUTCOME) brought to normal case with every reason kept; output-format tokens stay as they were.

- **deep-research** (2.4.0 → 2.4.1): the synthesis template gained a Length rule (roughly one screen of prose plus sources; cut unfilled sections rather than pad); the in-body htmx example, which duplicated EXAMPLES.md, became a quick-mode Bun example; the re-anchor rule stated three times now lives in step 7 with the drift gotcha saying only what step 7 does not; the Overview no longer repeats the cite rule; PLAYBOOK's too-long entry points at the Length rule; the eval table records the 2026-07-28 baseline and the re-measure condition.

- **track-session** (6.2.0 → 6.2.1): work-summary added to the negative scope (it already scoped against track-session; this side did not reciprocate); a ✅/❌ Failed Attempts pair, since the most-repeated rule in the body had no example; "save stops work" and the archive rule, each stated three times, trimmed to one home; the verification report gained a length bound; N2 retargeted from track-qa to work-summary and V9 added, with a pending 6.2.1 row. From the audit: TROUBLESHOOTING.md's step-scripted "before trying a new approach" list and its generic "verification should include" virtues list became one-sentence rules tied to the Failed Attempts and evidence conventions.

- **ui-ux-design** (2.1.1 → 2.1.2): frontend-design was named in Integration but absent from the negative scope while also claiming "design this screen" — added, with two fragments trimmed to stay under 1,000 characters; the Integration bullet naming track-qa replaced with the durable track-roadmap sign-off line; the "approved mockup is the spec" rule collapsed from three statements to one paragraph plus its gotcha; the Overview's second paragraph cut to one sentence; token rules duplicated in SYSTEMS.md replaced with a pointer; one ✅ appended so the examples no longer end on ❌; EVAL.md logs the 2.1.x and 2.1.2 variants and quotes the live N5 clause.

- **typography** (1.5.0 → 1.6.0): the caption floor contradicted itself — 12px in the floor table, readability.md and systems.md, "under the 14px hard minimum" in the table-header example. Resolved to 14px as the hard floor for any text (the house artifacts rule) across all four files; systems.md's Product UI caption and Compact variant follow. Also: the fluid-heading example gained its `4vw` ❌ half; three passages duplicated between SKILL.md and references trimmed on the references side; two "Why it fails" lines folded into the CSS comments; EVAL.md relabelled to the current version.

- **track-roadmap** (2.6.2 → 2.6.3): two eval should-nots (N2, V6) marked track-qa-owned asks as out of scope, but those asks now route *to* track-roadmap — retargeted to work-summary and ticket-description, T6 "add the release sign-off checks to the roadmap" added. MODES.md's Generate step 2 carried a self-review checklist ("features grouped logically, each has a clear description, no duplicates"); only the user-confirmation gate remains. The description gained a trigger for release sign-off asks; the duplicated generate example, the ASCII flow block, and the TROUBLESHOOTING mid-session entry are gone; the Integration line no longer names track-qa.

- **ideal-react-component** (1.8.1 → 1.8.2): `reference/HOOKS-ANTIPATTERNS.md` labelled effect-sync (`useEffect(() => setUserName(initialName), [initialName])`) as ✅ Good, the exact pattern SKILL.md marks ❌ — Antipattern 2 is now desired-first (no state copy, then `key` reset) with effect-sync as the ❌, and the summary table row matches. `styled` is now imported in the master block and both COMPLETE-EXAMPLES files; the section order is stated once; the Best Practices Summary keeps only its table; SECTIONS.md no longer says "strict order"; EVAL.md has 20 queries and attributes the July run to the pre-coverage-clause description.

- **discuss** (1.0.0 → 1.1.0): `references/EVAL.md` created — slash-only skills get a behavioral set instead of a trigger-rate set: the should-trigger half runs `/discuss` queries against a pass condition (position-first, no `Write`/`Edit`, one hook, sentences ≤25 words), the should-not half checks that `disable-model-invocation` holds, plus three persistence probes. A five-step "Each turn" section gives the methodology its workflow. The description is rewritten in house form addressed to the agent (611 → 534 chars), Gotchas trimmed from nine to the four with a non-obvious cause, the STE scope paragraph cut to two sentences, and the counter-example moved so the section ends on ✅.

- **setup-semantic-release** (1.4.0 → 1.4.1): the per-phase verification table lived in REFERENCE.md behind "load when a phase fails", so the agent could never know a phase had failed — six one-line `Check:` gates now sit inline at the end of each phase and the table is gone. A commitlint `module.exports` vs `export default` ✅/❌ pair covers the config side, which the examples had never exercised. REFERENCE.md's commit-type cheat sheet became a "No release produced" note and its smoke test a dry-run block; EVAL.md records the partial July measurement.

- **color-system** (1.5.0 → 1.5.1): the dashboard and chart examples gained ❌ halves (ad-hoc Coolors hexes with dark mode by inversion; twelve series from UI status roles with red/green profit-loss); the dark-mode base and APCA rules, stated three times, now live in Gotchas and contrast.md with one pointer line in Core Concepts; EVAL.md's variant table matches its measured 8/8 and notes train has never run.

- **record-tui** (1.6.0 → 1.6.1): the tape the agent writes now has a duration bound (one workflow in 10–30 seconds, three to five states held 2–3 seconds); the dropped-`Set` rule lives once, in Gotchas, with the per-line `Type@100ms` workaround folded in; build-tui joins the negative scope; the eval variant row records the measured 8/8.

- **screenshot-local** (1.5.1 → 1.5.2): the full-page docs example gained its ❌ half (a fixed `-h 800` clipping the page); the separate-install note lives once; TEMPLATES.md's SPA template says it extends the SKILL.md pair; the eval row records the July 7/8 measurement as provisional.

- **CLAUDE.md** prompt-audit cleanup (`/claude-api prompt-audit`, target Claude Fable 5.1). The skill bodies came back clean — every dated-pattern grep hit inside `skills/` was a meta-skill quoting an anti-pattern as an example. The cruft was in CLAUDE.md, written in January and patched in place five times since: a 1000-line cap that contradicted the 500-line cap three sections away; "troubleshooting sections required" and "never remove troubleshooting sections" against a spec that requires Gotchas and makes Troubleshooting optional; a second SKILL.md section template that listed Integration as required and omitted Workflow; a Documentation Style block still prescribing the Phase-1-with-checkboxes skeleton the meta-pair dropped in 6.0.0; six rules written as diffs against earlier versions ("the old ≤230 soft target was dropped 2026-07-27", "previously a yellow flag"); and the same authoring rules restated in Standards, Common Tasks, Quick Reference, Anti-Patterns, and Troubleshooting. All resolved: the two disagreeing caps and section specs now defer to the shared table in generate-skill Phase 4, the style block shows the goal/constraints/gates lead, migration-relative phrasing is rewritten as current rules, Common Tasks and Quick Reference are gone, Troubleshooting keeps only the one item generate-skill's Gotchas don't cover, and the 9,000-character Learnings section moved verbatim to `reference/LEARNINGS.md` behind a one-line pointer. The file went from 539 lines and roughly 8,000 tokens loaded every session to 361 lines and roughly 4,800.

- **track-session** (6.1.1 → 6.2.0): SESSION_PROGRESS.md is a client-side compaction summary, and the Fable 5.1 guide's six-item retention list now sits under the file-format Length rule — problems and how they were resolved, options set aside and why, user-stated constraints kept close to their own words, where things stand, what is open, and hard-to-reconstruct details kept exact, with the agent's own reasoning condensed to what it concluded. `reference/VERIFICATION.md` was the one place in the fleet the prompt audit flagged for step choreography on a judgment task: its six-step script with generic sub-bullets ("Are quality standards satisfied?") is now a goal, constraints, and gates lead plus the two mechanical checks that were always the real content (orphaned and cyclic `dep:` chains, scope gaps); the report format and the concrete scenarios are unchanged, and the three generic checklists ("Edge cases handled", "Code quality improved") are removed.

- **deep-research** (2.3.0 → 2.4.0): two Fable 5.1 behaviors. At low effort the model recognizes a product or tool name and answers from stale memory instead of searching, so step 3 now says the name itself is the thing to verify and to include it as the user wrote it in at least one query, and the skill sets `effort: high`. When summarizing, it reproduces source passages without marking them as quotations; the guide's fix is one complete worked example with a rationale rather than a rule, so `references/EXAMPLES.md` carries it, and a new gotcha points there.

- **code-review** (2.4.0 → 2.4.1): "Model tier: Opus or Sonnet for the agents" was a pinned-model line that 5.1 made wrong in the direction that discourages the cheapest good option — lanes now get effort guidance (`high`, or `medium`/`low` on a Fable-tier model, which is often competitive with Opus and Sonnet on cost per task); the Haiku caveat stays because Haiku has no effort control. The ui-ux lane prompt in `reference/AGENTS.md` dropped five capitalised emphasis words in ten lines (FLOOR, READ, NOT, NEVER, "#1 recurring defect") for normal case with the reasons kept — the prompt audit's pressure-language finding.

- **track-roadmap** (2.6.1 → 2.6.2): Update and Audit edit items in place rather than regenerating the file; only Generate writes from scratch. Fable 5.1 rewrites whole files for small changes more often than Fable 5, and roadmap ids and ordering have to survive.

- **local-first-app** (4.5.0 → 4.6.0): the blueprint drives multi-file implementation and had no line on unrequested fixes or scratch tests. Added under the Overview: build what the task asks for completely and nothing beside it; pre-existing bugs and unmentioned behavior are follow-ups; commit tests only where the task asks or the repo already keeps them, sized like the neighbors. The 5.1 guide reports this cuts unrequested additions and committed test code substantially with no change in task success.

- **ideal-react-component** (1.8.0 → 1.8.1): refactor the component the user named; a sibling or parent with the same problem is a follow-up, not a file to touch in the same change.

- **screenshot-local** (1.5.0 → 1.5.1): new gotcha — a full-page capture hides small defects, so capture the region with `-s` and `-p` or crop the PNG before judging a 12px label or a contrast problem. Fable 5.1 does its best visual work on a region it can look at up close.

- **track-session** (6.1.0 → 6.1.1), **generate-skill** (5.1.0 → 5.1.1), **track-roadmap** (2.6.0 → 2.6.1), **ui-ux-design** (2.1.0 → 2.1.1): dropped their cross-references to the deprecated `track-qa`. track-roadmap's Integration section and ui-ux-design's hand-off list now route manual checks to roadmap sign-off items instead of a `QA.md` entry. No behavior change otherwise.

- **code-review** (2.3.0 → 2.4.0): cyclomatic complexity is now reviewed, split across two tiers so the 2.0 impact floor stays intact. **Egregious complexity blocks via the architecture lane** — a changed function with 4+ nesting levels or roughly cyclomatic complexity above 10 (counting if/else, loops, boolean operators, case arms) where the structure genuinely conceals behavior; the finding must name the trap (which path a future editor misses and what breaks), which is what carries it past the verifier's "genuine reader-trap" clause. **Moderate complexity is a hygiene `[Nit]`** — roughly complexity 6–10 or nesting at 3 levels, where an early return, extracted helper, or lookup table would flatten the function; suppressed unless `--nits`, like the rest of the readability tail. The architecture lane's out-of-scope line now routes moderate complexity to hygiene instead of excluding readability wholesale, and a new gotcha documents the tier boundary plus the fact that a complexity finding with no named trap failing the impact floor is the floor working, not a lost finding.

- **code-review** (2.2.0 → 2.3.0): three corrections from a usage audit of the month since the 2.0 rebuild — 26 invocations, 13 July to 13 August 2026, mined from local transcripts. The pipeline itself needed nothing: lanes dispatched in a single message in every run checked, the verifier ran, REVIEW.md was written. What was wrong was the documentation of where the skill can run, and it was wrong in the direction that discouraged the workflow the skill is now most used for.

  **The "a subagent cannot spawn the reviewers" claim was false and is removed.** SKILL.md and `AGENTS.md` both stated that delegating the skill produces zero reviewers and no error. Eight delegated PR reviews on 10 August each spawned four or five lanes plus a verifier and wrote REVIEW.md — subagents spawn subagents up to three levels deep. `--background` is delegable; the sections now say so and refer to "the orchestrating thread" rather than assuming the main one.

  **The real delegation failure is `name`, and it is now documented.** Seven of those eight runs had their entire first dispatch batch rejected with `Teammates cannot spawn other teammates — the team roster is flat`, because the lanes were dispatched with a `name` set. It self-recovers on retry, so the cost is one wasted round-trip per lane rather than duplicated review work, which is why it never surfaced as a complaint. New gotcha plus a rule in the dispatch pattern: lanes are never addressed by name, so omit the parameter and the call works at any depth.

  **The PR-review carve-out.** The description disowned PR review outright ("Do NOT use this skill for an open PR by number — use /review") while the dominant power-use had become exactly that: PRs checked out into per-PR worktrees, reviewed with `--branch origin/dev`, one delegated agent each, run across 8 PRs in 5 repos in a single session. The distinction that matters is *fetching* a PR by number from GitHub, which is still `/review`'s job, versus reviewing a diff already on disk, which is an ordinary local review. The description now carries the local-worktree trigger and scopes the negative to the fetch case; Integration documents the worktree-per-PR pattern. Eval gains **V9**, paired with the existing N1 so the boundary is scored from both sides — an edit that wins V9 by dropping the by-number negative and regressing N1 has not passed.

  Also recorded from the audit, no change made: usage is 100% slash-invoked with no organic auto-activation, and 100% inside work repositories, none in the portfolio that owns the skill.

## [9.6.0] - 2026-08-12

One new skill, and one existing skill corrected by production evidence rather than by research. `discuss` ships at 1.0.0 — a slash-only conversation mode that takes a position and defends it under pushback, in condensed Simplified Technical English. `ui-ux-design` moves to 2.1.0 after a **usage audit of its first eight days in production**: 27 invocations across 24 sessions and 15 repositories, mined from local transcripts. That evidence changed what the skill documents rather than what it believes — the 159-line body was deliberately left alone, and the five changes fill a missing mode, a missing gate, and a color procedure that generated where it should have imitated. Two skills touched; 15 skills at v9.5.0, 16 now. **No breaking changes** — every `ui-ux-design` change is additive or a tightened floor.

### Added

- **discuss** (new, 1.0.0): conversation mode — think a topic through with Claude instead of issuing commands. Covers repository architecture, "how does X work", design tradeoffs, and open questions. Claude takes a position and defends it under pushback, asks back with `AskUserQuestion` at genuine forks, delegates research to capped subagents and compresses the result before it reaches the conversation, and publishes an artifact when the point is structural. Two constraints shape every turn: **read-only** (no `Write`, `Edit`, or commits unless the user names the file — artifacts are the deliberate exception, since they are private by default and the alternative was a permission prompt on every diagram), and **condensed** output in a practical subset of ASD-STE100 Simplified Technical English.

  The STE subset is the structural half of the specification — 20-word instruction sentences, 25-word descriptive sentences, six-sentence paragraphs, active voice, present tense, one term per concept with no synonym variation, three-word noun clusters, mandatory articles, no idioms. The skill **states its own scope limit rather than overclaiming**: full ASD-STE100 also mandates an approved-words dictionary of roughly 900 entries, each with one permitted meaning and part of speech, which cannot be checked at write time. Formatting layers the `i-have-adhd` rules on top — position first, one idea per block, lists capped at five, no preamble or closers, exactly one hook per turn.

  Three design decisions worth recording. It is **slash-only** (`disable-model-invocation: true`), because a skill named "discuss" with open-ended triggers would hijack ordinary questions the user wanted answered in one line; there is no `references/EVAL.md` for the same reason, since trigger evals do not apply to a skill that never auto-activates. It is **sticky** — the rules hold across topic changes until the user says "stop discuss", and a real work request mid-discussion is executed and then returns to discussion shape rather than requiring re-invocation. And the stance rule is deliberately two-sided: take a position when a defensible answer exists, ask when the answer turns on the user's constraints, and treat **agreement as a valid turn** — the skill explicitly forbids manufacturing disagreement to seem engaged, which is the failure mode a "debate with me" instruction produces on its own.

  Also carries an opening-move table keyed to topic shape (repository question, general-knowledge question, decision, yes-or-no, teach-me), a delegation cap of one agent per open question and two in parallel, a one-artifact-per-thread rule with in-place updates so the URL survives, and nine gotchas — the load-bearing one being that condensed is not the same as cold: the word caps apply to the padding, not to the personality.

### Changed

- **ui-ux-design** (2.0.0 → 2.1.0): five changes driven by a usage audit of the skill's first eight days in production — 27 invocations across 24 sessions and 15 repos, 5–12 August 2026. The evidence changed what the skill documents rather than what it believes: the 159-line body was left alone because it was the part working (it propagated into subagent briefs as an inline rubric, produced data-loss findings rather than taste findings, and produced correct findings in a repo whose brief described a different app). The gaps were a missing mode, a missing gate, and a color procedure that generated when it should have imitated.

  **`audit` mode is now documented.** Eighteen of the 27 runs were whole-app audits, and the workflow for them lived in twelve hand-copied per-repo prompt files rather than in the skill — while `argument-hint` had advertised an `audit` mode with no body section behind it since 2.0.0. Five phases, each gated on external state: scope the surface list from the code rather than the brief, build the per-surface state matrix before judging anything (an unfillable cell *is* the finding), split into three or four read-only lanes only when the surface count justifies it and always fewer lanes than surfaces, publish one consequence-ranked report where every visual change carries a **rendered** before and after at real sizes, then take approval per finding before implementing and record what was cut as well as what was accepted. Closes with the rule the transcripts showed missing: **a passing verdict is a legitimate outcome** — one run's brief explicitly permitted "this design is good" and got a findings list anyway.

  **An approved mockup is now the spec.** New section plus a paired gotcha. The costliest repeat failure was an implementation reported done, verified against a live dev server with 1,070 passing tests, that drew "the Saves UI looks nothing like we agreed to" and then a second complaint after the fix. The 2.0.0 gotcha named this drift and stopped at advice; the gate now names the check — open the approved artifact and the running screen side by side, list every element that differs, then fix it or say which differences you're keeping. It also names where drift concentrates: sections further down the page, the second posture of a two-mode screen, whatever was specified last.

  **Sample the named source before generating a palette** (`VISUAL.md`). The one outright rejection in the whole set was theme work that produced three consecutive dismissals ending in an instruction to abandon the method: "everything is green or purple. This is horrible… DO NOT use any special computations, remove that color-theory stuff." Every OKLCH rule in the file is individually defensible and the composite output was still rejected on sight, because the file had a generation procedure and no instruction to look at the thing being imitated. The mechanics are now explicitly framed as tools for *adjusting* a sampled source — brand values, the product's own stylesheet or theme files, a screenshot read for real hexes — not for inventing one, with the note that borrowing a product's name sets a fidelity expectation the output has to meet. A run in the same period proved the method works by parsing Bear's actual theme plists.

  **The contrast floor now spans both color schemes.** It required 4.5:1 "in every state" and named hover, pressed and disabled as the three that silently break, but never named the second color scheme — and dark mode kept arriving as a follow-up correction ("fix the dark theme but this is perfect otherwise"). A dark scheme built after the light one breaks all three states at once, so it ships with the surface or the surface isn't done.

  **`ETHICS.md` and `PROCESS.md` demoted to one shared navigation row.** Only 3 of 27 runs opened any reference file at all, and these two were opened zero times — nothing in the portfolio has signups, pricing presentation, or usability tests to run. Both files stay; they no longer spend two of eight nav rows advertising themselves. Body is 180 lines, still inside the 300-line aim.

## [9.5.0] - 2026-08-06

One new skill and one palette expansion. `ui-ux-design` ships for the first time, at 2.0.0 — rebuilt from a single-vendor source base onto 20 practitioner and research sources, and carrying two subject areas the drafts didn't cover: per-component accessibility contracts, and deceptive patterns with a rule for what to do when a conversion request is satisfiable by one. `color-system` moves palette roles from a single hex to a fill/subtle/emphasis triad and adds three OKLCH-generated palettes. Two skills touched; 14 skills at v9.4.0, 15 now. **No breaking changes for existing users** — `ui-ux-design` has never been released, so its 2.0.0 is a debut rather than a migration.

### Added

- **color-system** (1.5.0): three new web-app UI palettes generated from 12-step OKLCH scales rather than authored as flat roles — **Dusk** (indigo primary, turquoise accent, near-neutral cool greys), **Driftwood** (deep marine primary on warm sand neutrals with a clay accent), and **Meadow** (muted sage primary, old-gold accent, warm bone neutrals). Seed hues were lifted from the Color Hunt 30-day popular feed and then run through the scale recipe, which is the point: the seeds themselves top out at 2.5–13.8:1 internally, and the palettes built from them carry body text at 11.7–13.6:1. Each ships its generator parameters (hue + peak chroma per scale) and its neutral/primary/accent 12-step ramps alongside the role table, so they can be extended or re-derived. Driftwood swings its neutral hue from 64 in light mode to 224 in dark; Meadow holds one hue for both. `build-your-own.md` gains a solve-then-verify phase covering which four values need moving and in which direction, plus a second worked example tracing Driftwood end to end.
- **ui-ux-design** (new, 2.0.0): comprehensive UI/UX skill — designing and critiquing interfaces, interaction states, per-component accessibility contracts, information architecture, visual hierarchy, design tokens, and deceptive patterns. Two rules generate most of it: design the *states*, not the screen, because whichever rendering goes unspecified gets invented during implementation; and name things for their role, not their appearance. SKILL.md (149 body lines) carries what must be read before acting — an accessibility floor that holds in every state, the four states every surface ships varied by permission and then broken with real data, the response-time ladder, the nine interaction states with the behavioral rule each carries, six hierarchy levers including time, the three IA structures, and the three-tier token model with its no-alias-chaining rule. Eight reference files carry depth behind a load-when table: `INTERACTION.md` (state CSS, error-message rubric, Fitts/Hick/Gestalt, locality, depth geometry, forms), `COMPONENTS.md` (ARIA, keyboard, and focus contracts for eight components plus the labeling hierarchy), `PROCESS.md` (artifact fidelity, usability testing vs UX validation, accessibility personas, pre-launch), `LAYOUT.md` (grids, vertical rhythm, measurable geometry, build order, responsive, page recipes), `SYSTEMS.md` (tokens, component tiers, machine-readable systems, handoff failure modes), `VISUAL.md` (type and color applied to UI, OKLCH authoring, ramp construction, cultural constraints), `ETHICS.md` (deceptive patterns), `SOURCES.md` (provenance and currency). Scope deliberately overlaps `typography` and `color-system`, which remain the depth references for type scales and palette construction. **Debuts at 2.0.0 rather than 1.0.0**: it was developed through three internal iterations before first release, and the last one reversed a rule rather than extending it, so the version reflects that a reader of the earlier drafts needs to re-read rather than skim.

  Built from **20 practitioner and research sources** — Hobday, Butterick, Rutter, Roselli, Pickering, Kennedy, Ström-Awn, Evil Martians, Argyle, Frost, NN/g, Baymard, Laws of UX, Brignull, and the edited design magazines. The earlier drafts had been built from a single crawl of Figma's Resource Library, which the skill was already overriding in six places; `SOURCES.md` records the rebuild, which claims rest on paywalled or partial reads, and what was deliberately excluded (Refactoring UI rules available only through third-party summaries; Growth.Design's uncited metrics; Better Web Type, whose site returned 403 on a third consecutive research attempt). It also carries a **currency table for three claims that look stale and are not** — most importantly that **4.5:1 / 3:1 remains the required contrast floor**, because APCA was removed from the WCAG 3 draft in July 2023 and WCAG 3 contrast is undetermined with finalization expected 2030 or later, making "modernize this to APCA" the plausible-sounding wrong edit.

  Notable content the single-source drafts lacked: **`aria-disabled` rather than the native `disabled` attribute**, since a natively disabled control leaves the tab order and is exempt from contrast requirements, so the control *and* any explanation beside it become unreachable for exactly the users who needed the explanation (Roselli, updated Jul 2026); the response-time ladder (100ms / 400ms Doherty / 1s / 10s, each attributed to what it measures, with a note that Nielsen's figures predate mobile networks); NN/g's error-message rubric condensed to six checks including *preserve what the user typed*; message severity scaling the container rather than the reverse; Kennedy's three laws of locality; Hobday's measurable geometry (shadow blur = 2× distance, nested radius = outer − gap, button padding 2:1, stacked-surface brightness within 12% dark / 7% light — light interfaces need the *tighter* control); Thomas's build order, which defers identity until after the readability floor is set; OKLCH authoring with relative-color state derivation, the P3 chroma bump, and `stylelint-gamut` enforcement because browsers clip out-of-gamut colors in a way that shifts hue; Ström-Awn's exponential lightness distribution and Bezold–Brücke hue shift, plus the correction that colorblind verification is a matrix transformation and re-measurement rather than a filter over a screenshot; Atomic Design's tier vocabulary, kept for the templates-to-pages step that exists to expose content variation; Ferreira's Consistent/Opinionated/Flexible component tiers; and Friedman's three-layer machine-readable system (spec files, closed token set, audit scripts), directly load-bearing because an open token set is what lets a generating agent invent values. Two rulings settled ranges rather than adding a number: measure is 45–75 targeting 66, with `max-width: 33em` as the implementation since character counts aren't a CSS unit; and line-height is inversely proportional to font size (≥1.5 body, toward 1.0–1.2 for display), which re-scopes rather than rejects the 1.125–1.2 figure the earlier drafts had thrown out, since that value is correct for headlines. `LAYOUT.md` splits the baseline-grid question: pixel-perfect alignment is unachievable on the web, but vertical spacing as multiples of the base leading unit is not optional. One reported source conflict was checked directly and dismissed — NN/g's Heuristic 5 does not recommend disabling submit buttons; it reads "eliminate error-prone conditions, or check for them and present users with a confirmation option," which is error prevention, not control disabling. Graded **A (93.8/100)** by `rate-skill`; three findings applied before release, including a state hook named in SKILL.md that the reference CSS no longer defined. Description 974 chars against the 1024 cap. **Motion and animation remain the largest gap** — none of the 20 sources covers it well, and `SOURCES.md` says so explicitly rather than leaving the silence ambiguous.

- **ui-ux-design** — the two reference files worth calling out separately. `ETHICS.md` covers deceptive patterns — Brignull's 18-type catalogue with the UI shape and honest alternative for each, the four an agent produces by default while faithfully executing an ordinary instruction (preselection, hidden costs, nagging, addictive design), and a behavioral rule for the case the source doesn't address: when a request like "increase signups" is satisfiable by a catalogued pattern, name the pattern, price the honest alternative, and let the user choose — don't silently pick either, and don't refuse the task. Also records where the line is genuinely contested (countdown timers are prohibited in the EU and not uniformly in the US; no formal boundary separates infinite scroll from addictive design). `COMPONENTS.md` carries per-component ARIA, keyboard, and focus contracts for the eight components agents build most — tabs, disclosures, notifications, data tables, menu buttons, toggle buttons, tooltips vs toggletips, and cards — plus the four-step labeling hierarchy that puts `aria-label` last, and the two hard stops from Roselli (never `aria-label` on a link, since text-to-speech ignores it and it fails WCAG 2.5.3; never `aria-description` for content). Notes that Pickering's articles predate native `<dialog>` and `popover`, so his contracts hold but his build-it-yourself framing doesn't.

### Changed

- **color-system** (1.4.0 → 1.5.0): the unit of a palette role is now a **triad**, not a single hex. Research across Bootstrap 5.3, Material 3, Radix, Tailwind and Foundation found four systems converging independently on the same structure — a solid `fill` with a guaranteed `on-fill` label, a `subtle` background with a paired `emphasis` label, and a `subtle-border` between them (Bootstrap's `-bg-subtle`/`-border-subtle`/`-text-emphasis`, Material 3's `container`/`on-` quads, Radix's steps 9/3/6/11). `palettes.md` now ships the full triad for all nine UI palettes in both modes; every `on-fill`, `emphasis` and link value clears 4.5:1 against its own ground. Three additions to the guidance: `fill` and `link` are separate roles because a hue authored to be sat on is not automatically legible as text (Evergreen light is the library's one divergence — `#059669` carries a button label at 4.70:1 but reaches 3.77:1 as a link, so its link steps to `#00875b`, and Bootstrap is making the same split in v6); a 12-step scale is not a contrast guarantee, since Radix guarantees only steps 11–12 against step 2 and raw step 9 cleared just 2.9–3.7:1 against white across the new palettes; and neutral hue is a **per-mode** decision, because a warm tint that reads as paper at high lightness reads as mud at low lightness. Five gotchas added, including that gallery palettes are seed material rather than interfaces — 16 of the 30 most-liked Color Hunt palettes cannot carry 4.5:1 body text with any pair of their four colors.

## [9.4.0] - 2026-08-01

One feature added to `local-first-app`: saved filters as a first-class record. v9.3.0 covered what happens to a record after the user is done with it; this covers the views a user builds up over a growing dataset, which until now the skill left entirely to taste. One skill touched, no breaking changes.

### Added

- **local-first-app** (4.4.0 → 4.5.0): dynamic collections — named, saved filter sets over a single entity list, re-run against current data on every open rather than frozen as a list of IDs at save time. What gets stored is the query string (filters, sort, and render shape together), in the same form the entity list's own URL parameters already take, so saving a filtered list and building one from scratch converge on the same record. A collection is itself an entity: four entity routes, add and edit as one form, trash and restore like anything else. A filter referencing a field that no longer exists names the field on screen and returns nothing, because a silent zero-row result can't be told apart from a collection that legitimately matches nothing. Two ✅/❌ pairs added.

## [9.3.0] - 2026-07-31

Two data-lifecycle rules in `local-first-app`, both filling gaps the earlier versions left to taste. v9.1.0 and v9.2.0 specified what a local-first app has and what it looks like; this covers what happens to a record after the user is done with it. One skill touched, no breaking changes.

### Added

- **local-first-app** (4.3.0 → 4.4.0): soft delete and export. Deleting now moves a record to trash instead of out of the file, and cascaded children go to trash with the parent and restore with it — a restore that leaves orphans is the failure mode the rule exists to prevent. Recovery is surfaced as a `/trash` top-level route beside `/search` and `/settings` rather than a per-entity tab, so there is one place to look when you don't remember which entity a record came from. The delete confirm now names what goes to trash, and purging is called out as the irreversible action that needs its own confirm. Export is a one-line capability statement in `## Data` — the format and surface are the app's call. Two ✅/❌ pairs added, one reworded.

## [9.2.1] - 2026-07-31

Documentation-consistency pass over the repo, prompted by an audit after v9.2.0. No skill content changed and no skill version moved — all 14 skills' frontmatter versions were already logged in this changelog, and every README trigger line already matched its SKILL.md description. What was wrong was repo-level: one reference doc nothing pointed at, and two docs describing a repo layout that no longer existed.

### Removed

- **`reference/local-app-hub-contract.md`** (225 lines) — a cross-app HTTP contract for running a family of local-first apps behind an aggregating hub, added in `f94d9aa` and never linked from anywhere: not `local-first-app/SKILL.md`, not CLAUDE.md, not the README. The root `reference/` directory ships with the repo but not with any skill package, so an installed `local-first-app` could not have reached it in any case.

### Fixed

- **CLAUDE.md**: the file-structure block listed `reference/` as holding only `VERSION-CONTROL.md` and omitted `SESSION_PROGRESS.md`, `SESSION_ARCHIVE_*.md`, and `test-skills.sh`. It now lists all four and states what `reference/` is for — repo-level docs, not skill content — which is the distinction the orphaned hub contract had blurred.
- **`test-skills.sh`**: the post-run "next steps" pointed at `PUBLISHING.md`, which has never existed in this repo. Now points at `reference/VERSION-CONTROL.md`, the actual release process.

## [9.2.0] - 2026-07-31

Presentation-layer follow-up to v9.1.0, all in `local-first-app`. v9.1.0 specified what a local-first app *has*; this specifies what it *looks like* — the shape a list takes from the records in it, real-world entities rendered as the objects they stand in for, and themes drawn from the app's own domain rather than a bare light/dark pair. One skill touched, no breaking changes.

### Added

- **local-first-app** (4.2.0 → 4.3.0): a **Themes** rule under `## Chrome`. A neutral light/dark pair is the floor, not the whole set — apps ship named themes drawn from the domain they cover (a console-era palette for a game tracker, a ledger palette for expenses), each clearing the same contrast floor. This is the app-wide counterpart to the per-entity skeuomorphism added in 4.2.0. `## Chrome` already owned theming (the top-nav switcher and the Settings selection line), so the rule lives beside them rather than in `## Integration`, which lists which skills to reach for and carries no app requirements. One ✅/❌ pair added.
- **local-first-app** (4.1.0 → 4.2.0): four presentation rules the 4.1.0 UI-pattern list left to taste, all additive.
  - **A list renders in the shape its records have** — table by default, cards when records carry images worth previewing, skeuomorphic when the entity is a real-world object. 4.1.0 had the skeuomorphic case as a standalone bullet with no default to deviate from; the shapes are now one rule, and a table view stays reachable whatever a list defaults to.
  - **A `## Skeuomorphism` section**, promoted out of that bullet's parenthetical, mapping six entities to the object they render as — payment method to a credit card, contact to a business card, album to a disc, game to a cartridge, book to a spine, purchase to a receipt. Two rules bound it: the object is presentation only (the record stays sortable, filterable, and reachable as a table row), and a treatment that only works at detail size stays on the detail screen.
  - **Tables sort, filter, and explain themselves** — a legend keying the status colors or icons the rows use, and expand-in-place rows for detail the columns can't hold.
  - **Icons pair with text labels** on sidebar sections, entity types, and statuses, alongside the label rather than replacing it.
  - **Where the bulk editor goes**: past one selected row it takes over the sidebar column until the selection clears. 4.1.0 said bulk edit existed but not where it lived.
  - Sidebar sections are named for what they hold ("Library", not "Other"), and three ✅/❌ pairs cover list shape, the legend, and the icon.

### Changed

- **README**: the `local-first-app` entry caught up to 4.3.0 — its "Covers" list was written against 4.0.0 and omitted the app-level routes, the shared UI patterns, scheduled snapshots, non-entity sidebar views, and API keys in Settings. Skill count (14) and the summary line are unchanged.

## [9.1.0] - 2026-07-29

Additive follow-up to v9.0.0, filling the app-level surface that release's cut left implicit. v9.0.0 reduced `local-first-app` to a description of what an app *has*, specified per entity; this adds what every one of these apps has at the *app* level — its own routes, a backup schedule rather than only a migration hook, and the UI patterns that keep a multi-entity app feeling like one app instead of several CRUD screens sharing a sidebar. The framing is unchanged: still a description of the feature set, not a code spec. No other skill changes, no breaking changes.

### Added

- **local-first-app** (4.0.0 → 4.1.0): the app-level surface the 4.0.0 cut left out, plus the UI patterns that make a multi-entity app feel like one app rather than several CRUD screens sharing a sidebar. Additive — nothing in 4.0.0 is retracted, and the "describes what the app has, not how to build it" framing is unchanged.
  - **An app-routes table alongside the per-entity one.** Every app has an overview home, a cross-entity `/search?q=`, and `/settings`, plus `/calendar` when its data carries dates. 4.0.0 specified the four routes each *entity* gets and left the app's own routes implicit.
  - **Backups are a schedule, not only a migration hook.** 4.0.0 said to snapshot before a migration; that protects nothing during a month with no schema change but daily writes. Snapshots now run on a schedule as well, keeping the last few.
  - **Sorting and filtering are server-side and URL-driven** — the client never sorts or filters a full result set. Paired with a new ✅/❌ line, since the tempting shape is to fetch every row and sort in the browser.
  - **Tabs on two axes**: on a list view to cut the same records different ways, and on an entity view to reach its related entities.
  - Four smaller additions: consistent placement for add/save/delete/cancel across screens; virtualization or pagination where a list can grow unbounded; bulk selection and edit where per-row editing gets tedious; and skeuomorphic treatment where the entity is a real-world object (a credit card rendered as a card).
  - Chrome gains non-entity sidebar views (an "insights" view) and external API keys in Settings.

### Changed

- **local-first-app**: `## Examples` moved below `## Chrome` so the ✅/❌ block no longer interrupts the UI-pattern sections, and the top-nav bullet no longer restates the `/search?q=` route that the app-routes table declares and the Examples pair already argues for.

## [9.0.0] - 2026-07-29

Breaking release, and a deliberate reversal of direction for `local-first-app`. Eight releases of accumulated detail had turned a blueprint into a code spec that constrained apps into one shape; this cuts it to a one-page description of what the app *has* and hands the implementation back to the agent. No other skill changes.

### Changed

- **local-first-app** (3.2.0 → **4.0.0**, breaking): rewritten as a one-page description of the app's feature set, from 1,520 lines across 8 files to 69 lines plus `references/PACKAGING.md`. The blueprint had grown into a code spec — pinned libraries with rationale columns, a five-directory architecture contract, worked loader and form code, four verification gates, and 15 gotchas — and was constraining apps into one shape instead of describing what they need.
  - **Describes features, not implementation.** Entities and their relationships (FKs for one-to-many, join tables for many-to-many), four addressable routes per entity (list / add / view / edit), a top nav carrying cross-entity search and a theme switcher, collapsible sidebar sections, and settings covering theme, data location, and backup/restore.
  - **The stack is a plain list, not a table of load-bearing warnings**: Next.js App Router, React, TypeScript, SQLite in one local file, environment variables for config. UI library, forms, validation, charts, and test runner are each app's own choice.
  - **Removed:** `ARCHITECTURE.md`, `CHROME.md`, `UI.md`, `RELATIONSHIPS.md`, `EXAMPLES.md`, and `EVAL.md`. `PACKAGING.md` stays — `deno compile` / `deno desktop` steps are external knowledge an agent can't infer. Examples survive as five one-line ✅/❌ scope pairs.
  - **Migration:** nothing in the existing True\* fleet needs to change. The removed material described one valid way to build these apps, not a contract those apps violate.

## [8.2.0] - 2026-07-29

Operational-surface release for `local-first-app`, from a gap audit measuring one app built to the blueprint against its ten siblings. The blueprint specified the data layer thoroughly and the operations around it loosely, and the audit found the seam: one rule contradicted another file in the same skill, and the rest were absent rather than wrong. No breaking changes.

### Added

- **local-first-app** (3.1.0 → 3.2.0): six rules from a gap audit measuring one app built to the blueprint against its ten siblings — the operational surface around a local-first app, which the blueprint specified less thoroughly than the data layer it wraps.
  - **Restore is a UI surface once the app ships a binary.** `references/ARCHITECTURE.md` previously ended its backup section with "recovery is a file copy, document it in the app's README" — advice that contradicts `PACKAGING.md` in the same skill, since a bundle recipient has no checkout, no README and no terminal. Restore now lists snapshots, restores in place, and clears the cached handle so the next `getDb()` reopens without a restart.
  - **The snapshot directory resolves two ways for one reason** — outside whatever a routine reset removes: a sibling of the data dir in a checkout, the OS per-user data dir in a packaged build, where the whole app directory is disposable.
  - **Pre-migration snapshots are not a backup schedule.** They fire only when a migration is pending, so a month with no schema change protects a month-old copy of data that changed daily. A periodic snapshot goes through the same writer with the opposite failure policy — it logs and lets the app start, because nothing destructive is about to happen.
  - **A search route comes before a search shortcut.** `mod+K` is a shortcut to a destination, so `/search?q=` has to exist and be addressable first — a corollary of the skill's own "the URL is the state". The palette-first order ships a keyboard-only feature with no URL to link or refresh into, plus a query path that drifts from the per-list `?q=` filter.
  - **Soft-delete what the user authored; hard-delete what you can re-fetch.** Once an app has a provider sync, the obvious delete gets this backwards — dropping the rating, notes and progress while leaving the re-fetchable cached row in place. The read-path trap is named: `deleted_at IS NULL` belongs in the store's queries, not repeated at each call site.
  - **`loading.tsx` on the routes that actually wait**, not every route — the topology block said only "(optional)". `force-dynamic` is what makes the omission bite; adding it everywhere trades a blank page for a skeleton flash where the render was already instant.
  - Two smaller amendments: export serialization is pure logic, so it lives in `src/<domain>/` and is fixture-tested rather than route-tested; and `references/CHROME.md` gains collapsible nav *sections* as a second axis independent of the sidebar flag, with the two traps — the 72px rail must ignore section state (a section collapsed there has no visible header left to reopen it), and persisted ids must be filtered against the sections that currently exist.

## [8.1.0] - 2026-07-29

Follow-up to the v8.0.0 platform-guide release, driven by rescoring all 14 skills against the new 5.0.0 rubric. The rescore moved almost nothing — nine skills scored 100.0 and the new §7 agentic rules caught **zero** violations across the fleet — but it surfaced one defect in the rubric itself: §7 would have penalized `code-review` for the writer-verifier pattern the same Opus 5 guide endorses. Also lands the compression pass that reverses v8.0.0's token growth in the meta-pair, and the §5 rule that stops referenced examples from reading as missing. No breaking changes; every 5.0.0 grade remains valid.

### Fixed

- **rate-skill** (5.0.0 → 5.1.0) and **generate-skill** (5.0.0 → 5.1.0): **§7's verification-scaffolding rule listed "use a subagent to verify" as a flat deduction, which would have penalized `code-review` for its central design.** code-review's Phase 2.5 dispatches a verifier agent that judges findings produced by five *other* agents — a writer-verifier pattern the Opus 5 guide explicitly endorses ("coordinates teams of subagents well, with effective writer-verifier patterns") in the same document that prohibits delegating verification of *your own* work. The 5.0.0 rescore scored code-review 98.0 only because the pipeline was read in full rather than phrase-matched. The rule now names two carve-outs — checks against external state, and one agent judging another agent's output — and states the actual defect: an agent re-checking work it produced itself. MINOR rather than MAJOR because the rubric only gets more permissive, so 5.0.0 grades remain valid. `references/PATTERNS.md` needed no matching edit; the compression pass had already replaced its copy of the rule with a pointer.
- **track-session** (6.0.0 → 6.1.0): `SESSION_PROGRESS.md` had no length bound, the §4 written-deliverable gap the rescore surfaced. Adds the rule track-roadmap already carried — one line per task, 1–2 sentences per Decision or Failed Attempt, and an explicit "state record, not a narrative" with no recap of what Completed Work already lists.

### Added

- **code-review** (2.1.0 → 2.2.0), **screenshot-local** (1.4.0 → 1.5.0), **typography** (1.4.0 → 1.5.0): example sets expanded to clear §5's diversity rule, which caps a skill at 80 when its examples all exercise one situation. Each skill gains examples covering the parts that actually fail rather than restating the happy path — code-review adds scope detection on a backend-only diff and a verifier DROP that is working correctly; screenshot-local adds the fixed-dimension OG capture, the `--retina` multiplier trap, and a deliberate full-page capture; typography adds table headers and captions, where the readability floor breaks first.

### Changed

- **rate-skill** and **generate-skill** (both 5.0.0): compression pass on the `local-first-app` model, applied after v8.0.0 was tagged. Headings carry the claim, rationale folds into the rule as an em-dash aside instead of a following sentence, both bodies gain a `## Navigation` load-when table, and all ✅/❌ payload moves behind a one-line pointer naming what's in the file. `generate-skill`'s optional-field table, frontmatter anti-patterns and three-tier portability rules move to `references/FRONTMATTER.md`; `references/PATTERNS.md` drops its duplicate section-spec table (a third copy of what already lives in both SKILL.md files) and its placeholder-heavy skeletons, keeping the per-type shape guidance that isn't stated elsewhere. No rule was deleted — verified by grepping every distinctive rule token from the pre-compression tree against the new one. Net: **v8.0.0's token growth is reversed and then some** — rate-skill 239 → 187 lines (~4,220 → ~3,530 tokens), generate-skill 246 → 191 lines (~4,360 → ~3,620 tokens), PATTERNS.md 316 → 207 lines. Both bodies now sit below where they were *before* v8.0.0 added its rules.
- **rate-skill** §5: **examples living in `references/EXAMPLES.md` behind a pointer now count in full.** The rule never said where examples had to live, so a grader reading only SKILL.md would score a pointer as an omission — marking down every skill built the way `local-first-app` is built, including both meta-skills after this compression pass. §6 still penalizes keeping them in both places.

## [8.0.0] - 2026-07-28

Platform-guide release. The meta-pair (`rate-skill`, `generate-skill`) and `local-first-app` are all re-anchored on Anthropic's [Prompting Claude Opus 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5) and [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices) guides. The through-line is **removing verification scaffolding rather than rewording it**: Opus 5 verifies its own work, so carried-over "double-check your answer" instructions compound with behavior the model already performs. Separately, `local-first-app` absorbs the findings from measuring eleven apps built to the blueprint — three of its rules reversed prescriptions those apps were built against.

### Breaking Changes

- **rate-skill** (4.0.0 → 5.0.0) and **generate-skill** (4.0.0 → 5.0.0): the meta-pair is now anchored on the platform prompting guides ([Prompting Claude Opus 5](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5), [Prompting best practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices)) in addition to the agentskills.io pages it already tracked. Grades under the 4.0.0 rubric are not comparable.
  - **`## Verification Checklist` is dropped from the shared section spec for every type**, in both skills and in `references/PATTERNS.md`. The Opus 5 guidance is unambiguous that carried-over verification instructions should be *removed* rather than reworded — they compound with behavior the model already performs and cost tokens with no quality gain. Presence is no longer credited and absence is no longer noted.
  - **New rate-skill §7 deductions, each also emitting a finding:** verification scaffolding ("double-check your answer", "re-verify before responding", "use a subagent to verify"); "do not think" / "do not reason" instructions, which increase internal-XML-tag leakage into visible output; uncapped subagent delegation; unbounded scope on a narrow-job skill. §7 is split into *authoring anti-patterns* and *agentic over-prompting* so the two families read separately.
  - **The domain-verification carve-out is explicit throughout.** "Run the test suite", "confirm the file parses", "validate against the schema" check external state, were never the target, and score fine. Checklists remain one of the six official instruction patterns; only self-re-check content is penalized.
  - **New §4 check — written-deliverable length.** A skill whose output is a file the agent writes must bound that file's length in its output template; −10 when it doesn't. Written deliverables run long by default. Both skills now apply this to themselves.
  - **§5 Examples now grades diversity, not just presence.** Fewer than 3 examples, or 3+ that all exercise the same situation, caps the category at 80 (official guidance is 3–5, relevant and diverse). The `<Good>`/`<Bad>` deduction is narrowed to the *labels* — `<example>` / `<examples>` as structural delimiters are officially recommended and score fine, a distinction the 4.0.0 rule blurred.
  - **generate-skill Phase 2 gains an intensity-escalation anti-pattern.** "CRITICAL: you MUST invoke this" now reads as a defect rather than emphasis: the platform guidance names skills specifically as prone to overtriggering on aggressive language and prescribes normal register. Recall comes from more literal triggers and a coverage clause, never from volume. A new rate-skill gotcha reconciles the two source families on this point (coverage up, intensity down).
  - **generate-skill Phase 3** gives concrete `model` / `effort` guidance instead of "needs a specific model tier": `low`/`medium` for mechanical well-specified work, `xhigh` reserved for demanding agentic work, omit to inherit.
  - Bodies were tightened in the same pass and `generate-skill`'s source list was extracted to `references/SOURCES.md`, mirroring rate-skill. Net token change is still up — rate-skill ~3,490 → ~4,180, generate-skill ~4,160 → ~4,360 — because the new rules cost more than the compression saved. Both remain under the ~5,000-token and 500-line caps. *(Reversed after v8.0.0 shipped — see the compression entry under Unreleased.)*

- **local-first-app** (2.2.1 → 3.0.0): corrections from measuring eleven apps built to this blueprint. Three rules reverse prescriptions apps were built against, and one states a requirement an existing conforming app can fail.
  - **`BASE_SCHEMA` is now migration v1 — the fresh-DB fast path is deleted.** The old rule had a fresh database run `BASE_SCHEMA` and jump `user_version` to the max, which made `BASE_SCHEMA` and the migration chain two definitions that must agree forever. The failure is asymmetric and that's what made it dangerous: dev machines replay migrations and stay green while every new install and every packaged binary takes the other path. Eight of eleven apps had independently converged on the safe shape; of the three following the skill, one threw `no such column: parent_id` out of `RootLayout`, taking down every route. The **schema-drift gate was dropped entirely** rather than made conditional — the skill documents one construction path, so there is no second path to diff against.
  - **A pre-migration snapshot is now a stated requirement of the database layer**, not something the restore gate happens to test. 4 of 11 apps had no backup of any kind, including the ledger app, because the skill described the backup as machinery and never as a requirement — so an app could conform, pass every gate it could run, and have no protection at the moment the blueprint itself calls the scariest. The snapshot directory is a **sibling** of the data dir so `rm -rf data/` spares it (the shipped code sample wrote inside it).
  - **Snapshot filenames stamp to milliseconds *and* break ties with a counter.** Reverses "let `VACUUM INTO` throw if the target exists" — ISO-8601 bottoms out at the millisecond and two programmatic calls really do land inside one. Relying on the throw yields two bad outcomes both present in the family: the app that catches it migrates with no backup, and apps treating it as fatal refuse to start.
  - **Snapshot and rotation are two calls with opposite failure policies** — a failed snapshot is fatal, a failed rotation must not be, since the snapshot already exists and dying in cleanup blocks the migration it just protected. The shipped `backupBeforeMigrate()` fused both and could not express it.

### Changed

- **local-first-app** (3.0.0 → 3.1.0): Opus 5 tuning plus a prose-density pass across all seven files. Adds a **`## Build scope`** section addressing the two documented Opus 5 behaviors this blueprint invites — scope expansion (no speculative tables, no unrequested configurability, deferrables stay deferred) and longer written deliverables (match document length to the task). It also states that the four gates are **shipped artifacts, not a per-change ritual**, since the same guidance says explicit verification instructions cause over-verification. Audited for the two hard Opus 5 failure modes and found clean: no reasoning-echo instructions, and no severity-limiting phrasing. The `re-check`/`re-verify` occurrences that remain describe app behavior (re-run migrations on module load, re-verify a contrast ratio against your own surfaces), not the model checking its own work.
- **local-first-app**: prose rewritten on the `i-have-adhd` rules — lead with the rule, cut section preambles and "why this matters" narration longer than the rule it precedes, one idea per bullet, gotchas compressed toward symptom → cause → fix. Combined with dropping cross-file duplication (the CRUD prose ARCHITECTURE.md restated from SKILL.md, the shell and theming points UI.md restated from CHROME.md, the navbar-overflow rule CHROME.md stated twice), the skill totals **~22,700 tokens across seven files, down from ~32,800** — SKILL.md 6,801 → 5,003 body tokens, ARCHITECTURE.md 8,553 → 5,831, CHROME.md 6,166 → 5,118, UI.md 3,491 → 2,628. **SKILL.md is now at the ~5,000-token cap**, from ~30% over at the start of the pass. Every code sample and every documented failure mode is retained.
  - The final cut removed only content already stated elsewhere: the `## Troubleshooting` section (all three items live in PACKAGING.md and CHROME.md, both linked from Navigation) and four gotchas duplicated in `RELATIONSHIPS.md`, `ARCHITECTURE.md`, or SKILL.md's own architecture section (manual cascade delete, wizard/tab state, compound Mantine components client-only).
- **local-first-app**: **every verification gate now asserts a positive property rather than the absence of a loud failure.** This was one root cause with four instances, each found and patched separately: restore asserted a file appeared, route smoke asserted `< 500`, legibility asserted zero issues, rotation asserted a snapshot exists. Each passes whenever the failure is quiet — a server component passing a function across the client boundary makes React drop the element and serialise the error into the flight payload with the response still a 200. The principle now sits above the gate list with a cheap test for new gates (describe the failure, ask whether it could occur quietly), and the four remaining gates are worded in those terms. Route discovery gained real rules: recurse into `(groups)` leaving the URL prefix unchanged (skipping the subtree found *zero* routes in an app keeping all 67 pages under `(app)`/`(auth)`), skip `[dynamic]` subtrees and `api`, assert the discovery found something, and skip loudly with no server up. Retention rules are now stated rather than implicit in a sample: prune by timestamp not filename (a lexical sort deletes the *newer* snapshot past v9), and "keep 20" means 20 backups, not 20 per schema version.
- **local-first-app**: standards pass against generate-skill/rate-skill 4.0.0 — body trimmed from ~9,500 to ~6,500 tokens (Examples extracted to `references/EXAMPLES.md`, the UI/chrome sections collapsed onto `UI.md` and `CHROME.md` they duplicated, bulk-edit rules consolidated into `UI.md`); a Navigation load-when table added (required for the `reference` type); the description rewritten with quoted trigger phrases, a coverage clause and four-way negative scoping; and `references/EVAL.md` rebuilt on the official loop with a fixed 60/40 train/validation split and the 3-run/0.5-threshold protocol. The body remains over the ~5,000-token guidance — the residual is 18 gotchas each encoding a distinct shipped bug, which are canonically kept in SKILL.md.

## [7.0.0] - 2026-07-28

Fleet-wide standards release. The rate-skill + generate-skill meta-pair was rebuilt to 4.0.0 around the official agentskills.io eval loop, dogfooded through three fresh-grader rounds to the pass bar (A ≥90, zero P0/P1), then 11 parallel agents applied the same standards to every other skill except local-first-app (excluded by user directive), and a fresh-grader eval loop verified each one. Final grades: ideal-react-component and track-roadmap 100.0; color-system, track-qa, setup-semantic-release, deep-research, record-tui 99.0; track-session, screenshot-local, typography 98.0; code-review 97.0. Every skill now ships an official-format eval set (train/validation split, 3-run/0.5 trigger-rate protocol, select-by-validation). The pass bar's live trigger-rate half was measured for 7 skills (146 headless sessions; aborted by a usage limit) and then dropped by user decision in favor of organic-use data — the measured rates and a methodology-bias note live in each EVAL.md.

### Breaking Changes

- **track-session** (5.2.0 → 6.0.0): breaking changes to the output contract, all driven by measured usage (49 real invocations over 30 days):
  - **Deleted the Resume-mode `State:`/`Next:` opener contract** (3/50 compliance — inert). Replaced with a soft principle with its reason: lead with current state, not narration.
  - **Cut the `verify` and `recover` modes to one-line load-on-demand pointers** (0 uses in 49 invocations). VERIFICATION.md and RECOVERY.md remain intact.
  - **Bare `/track-session` routing is now deterministic** — first-match ladder with an explicit tiebreak (prefer checkpoint: a near-empty delta costs one turn; resuming over unrecorded work drops it), replacing conditions that resolved as a measured coin-flip.
  - **Start-mode collision policy is gitignore-aware** — `git ls-files --error-unmatch` gates replacement; untracked/gitignored files are archived first because replacing them destroys history permanently (the old "history lives in git" assumption was false in exactly the repos that gitignore the file).
  - Plus the standards pass: imperative description with coverage clause and negative scoping, Gotchas section (six non-inferable entries), official-format EVAL.md.

- **rate-skill** (3.2.0 → 4.0.0): rubric re-anchored to the official agentskills.io skill-creation pages (best-practices, optimizing-descriptions, evaluating-skills) and the Claude Fable 5 prompting guidance. Grades under the old rubric are not comparable.
  - **Eval sets are now a requirement, not a bonus.** The +5 for shipping one is gone; a missing set is a standing P1 finding. Present sets are verified against the official description-optimization loop: ~20 queries (8–10 each direction), 60/40 train/validation split with proportional mix, 3-runs-per-query trigger-rate protocol against the 0.5 default threshold, select-by-validation-score.
  - **Dropped scoring:** the multiline-`description:` automatic 0 (#9817 is not reproducible on Claude Code 2.1.220 — verified empirically 2026-07-27; scalar style is no longer policed at all) and the ≤230-char soft-target ladder (no official basis; official sizing is "a few sentences to a short paragraph" plus the 1024 hard cap).
  - **New checks:** miscalibrated control in either direction (official rule is "match specificity to fragility" — prescription itself is not a defect); reasoning-echo instructions (always a P0 — `reasoning_extraction` refusal risk on Fable 5); instruction-pattern fit (the six official patterns, rewarded by fit, not presence); the ~5,000-token joint body cap alongside 500 lines; `compatibility` ≤500 chars; the context-economy cut test ("would the agent get this wrong without this instruction?").
  - Category 4's table is now the **shared section spec** with generate-skill, with Gotchas required for every type (canonical per agentskills.io).
  - Corrections baked in: the skill-creator eval announcement is dated 2026-03-03 (not "May 2026"); the validator to recommend is `skills-ref validate` (agentskills/agentskills) — `npx skills lint`/`validate` does not exist.
- **generate-skill** (3.2.1 → 4.0.0): Phase 8 is replaced by the official agentskills.io description-optimization loop — train/validation split, fixed across iterations, trigger-rate measurement, iterate-on-train-only, select-by-validation (overfitting guard), with a pointer to the with/without-skill output-quality loop for methodology/auditing bodies. Phase 2 drops the ≤230 target and all block-scalar prohibitions and adds the officially recommended "even if they don't explicitly mention X" coverage clause. Phase 4's section lists are now the shared spec with rate-skill and add calibrate-control-per-section, the six official instruction patterns, defaults-not-menus, procedures-over-declarations, and the reasoning-echo prohibition. Core principles gain the add-what-the-agent-lacks cut test. Both meta-skills now ship their own `references/EVAL.md` in the new format. Dogfooded to the pass bar over three fresh-grader rounds (B 88/89 → A 93+ → rate-skill A 97.5, generate-skill A 100.0), including a live 48-session trigger-rate measurement of both validation splits (7/8 each; failures analyzed, deliberately not worded against the holdout).

### Changed

All ten remaining skills received the same standards pass (imperative third-person descriptions with front-loaded distinctive nouns, coverage clauses for indirect asks, negative scoping against near-neighbors; calibrated control — "Do X because Y" with prescription only where operations are fragile; required Gotchas sections; reasoning-echo audit; official-format EVAL.md; cut-test trimming):

- **code-review** (2.0.0 → 2.1.0): conservative pass — lanes/verifier/report untouched. Front-loaded description with four-way negative scoping (adds rate-skill, simplify), new Overview + Gotchas (7 non-inferable entries: background-mode subagent limits, worktree diff traps, `--repo` lane behavior), two `MANDATORY:` labels rewritten as reasoned directives, two near-miss reasoning-echo phrasings reframed to conclusions-plus-evidence.
- **color-system** (1.3.1 → 1.4.0): imperative description with a no-color-word coverage clause ("theme this app", "these status badges look wrong") and three-way scoping (typography, frontend-design, dataviz); Navigation load-when table; concrete Integration section with the color-vs-size handoff rule; defaults marked where real (Carbon, Viridis) and explicitly declined where they'd be fabricated (marketing, TUI).
- **deep-research** (2.2.1 → 2.3.0): **removed a real reasoning-echo instruction** — the "Reflect" step's "answer 'what would change my conclusion?'" (a `reasoning_extraction` refusal trigger on Fable 5), replaced with a metrics-only sufficiency gate; Gotchas section (fabricated-citation, paywalled-WebFetch, re-index-date traps); fixed phase-number drift across SKILL.md and both references.
- **ideal-react-component** (1.7.3 → 1.8.0): coverage clause (".tsx/.jsx or the code calls hooks" without naming React) and three-way negative scoping; 8-entry Gotchas (hook-count invariants, Server Component traps, dep-array literals); examples flipped ✅-first; library claims source-verified (TanStack v5 migration, React 19 upgrade guide).
- **record-tui** (1.5.1 → 1.6.0): **two documented VHS claims empirically disproved and corrected** against VHS 0.11.0 — a late `Set` never errors (it's silently discarded with `vhs validate` exiting 0), and the documented `TypingSpeed` ordering exception does not exist. Examples replaced with real render-validated tape code; eight Gotchas; COMMAND-REFERENCE gains the missing `Wait@timeout`/`Escape`/scroll/clipboard commands.
- **screenshot-local** (1.3.1 → 1.4.0): restructured to the automation section spec; **fixed a demonstrably broken auth template** — per-shot `auth:` in shots.yml is silently ignored (verified live; shots succeed logged-out), corrected to `shot-scraper multi shots.yml -a auth.json`; Gotchas verified against shot-scraper 1.9.1 (JPEG-in-.png, retina doubling).
- **setup-semantic-release** (1.3.0 → 1.4.0): **new load-bearing gotcha, doc-cited** — an explicit `plugins` array *replaces* semantic-release's defaults rather than merging, silently disabling npm publish; pre-commit hook selection changed from a 5-row menu to a derived default; symptomatic coverage clause ("version bumps, tags, or a changelog"); version pins unchanged.
- **track-qa** (1.2.3 → 1.3.0): overwrite guard (bare `/track-qa` defers to update when QA.md exists — regenerating discards verified history); calibration zoning stated explicitly (schema markers exact because machine-parsed, everything else adaptive); six Gotchas; reference-file fixes (broken rendering, a nonexistent validate script reference, wrong marker name). cc-dash `qa@1` schema byte-identical.
- **track-roadmap** (2.5.4 → 2.6.0): ROADMAP.md front-loaded description with coverage clause and three-way scoping; Gotchas (id permanence, comma-separated `roadmap_ref`, resume-clobber warning); Troubleshooting deduplicated into Gotchas. Two eval-loop catches fixed post-pass: a duplicate `r_k8x2m` in the flagship generate exemplar, and the update-mode example (≈80% of real use) carrying no cc-dash markers at all — both would have propagated parser-breaking files through agents copying the examples. cc-dash `roadmap@1` schema byte-identical.
- **typography** (1.3.1 → 1.4.0): imperative description with a symptom-based coverage clause ("text that looks cramped, thin, or washed out"); Navigation load-when table replacing four duplicate reference-link lists; two mega-gotchas condensed to symptom/cause/fix; the invalid-CSS `line-height: clamp()` trap promoted into SKILL.md. The readability floor is byte-identical.

### Added

- Every skill now ships `EVAL.md` (in its existing reference dir) in the official agentskills.io format: ~18 queries split train/validation with a 1:1 positive/negative mix per half, a 3-run/0.5-threshold trigger-rate protocol, iterate-on-train-only, select-by-validation. Seven skills carry measured 2026-07-28 rates with an explicit methodology-bias note (48% of harness runs truncated at max-turns while exploring — rates are a lower bound; per user decision, live measurement is not a release gate).
- generate-skill bundles `scripts/measure.py` (description chars / body lines / body tokens against their caps).

## [6.1.1] - 2026-07-27

Follow-up to v6.1.0: the eval pass rewrote the SKILL.md body but left `references/` on pre-audit advice, so the progressive-disclosure links pointed at guidance the body had just reversed — including one outright contradiction.

### Fixed

- **local-first-app** (2.2.0 → 2.2.1): reconciled `references/` with the v6.1.0 body changes — the progressive-disclosure links were serving pre-audit advice, so an agent that followed them landed on guidance the SKILL.md had just reversed.
  - **`UI.md` contradicted the `/docs` demotion outright.** It read "a pure CRUD tracker … **still ships the in-app `/docs` concept area**" and mandated the area unconditionally — exactly what 2.2.0 demoted. Both spots now carry the same conditional test (ship it only for a concept a new user would get wrong).
  - **`UI.md` legibility framed insufficiency as a source-level problem** ("you might still land `xs` at 14px"). Added the actual reason the theme can't be trusted: line-height resolves against the computed font-size and contrast against the painted background, so **two of the floor's four values don't exist until a page renders**. Points at the legibility gate, and picks up the 65–85ch line-length cap and the measurably-distinct-swatch rule.
  - **`ARCHITECTURE.md` had the same three-vs-five defect** the SKILL.md heading rename fixed — "The three layers are:" followed by five directories. Now leads with import purity.
  - **`ARCHITECTURE.md` backup section documented recovery but never verified it.** Added the restore gate (open the copy, read a row back out) and sub-second filename stamping, next to the `VACUUM INTO` snapshot code it applies to.
  - **`UI.md` bulk-selection section** picked up the deferability note from the body.

## [6.1.0] - 2026-07-27

Eval-driven pass on **local-first-app**, from a browser audit of the app family built to this blueprint. The theme runs through all four changes: a rule can be followed exactly and still produce a broken app, so the fix is a gate that fails rather than a stronger instruction.

### Changed

- **local-first-app** (2.1.0 → 2.2.0): eval-driven pass from a browser audit of the app family built to this blueprint. Four changes:
  - **New section: "The five gates a green test suite does not give you."** Route smoke, restore-not-backup, schema-drift, hydration, and legibility — the failure classes a typecheck, a full vitest suite, and a clean production build all pass through. Each was paid for in real debugging: a backup routine calling a `.backup()` method that doesn't exist on `node:sqlite` (test only checked a file appeared); a table added to the migrations but not `BASE_SCHEMA`, breaking 100% of new installs while 100% of dev machines stayed green; a server component rendering a client-only compound component, which 500s in the browser with no component name in the stack. Closes with fixture realism — a five-row fixture passed while a missing SQL predicate made a 5,000-row library report zero results, because `LIMIT` truncated before the pure filter ran.
  - **Legibility promoted from a quality signal to a gate.** Across ten apps audited in a real browser, **nine shipped text under 4.5:1** — including a wordmark at **1.00:1** (text color identical to its background) on five separate routes — and *every one of them had overridden the `fontSizes` scale correctly*. The instruction was followed and the outcome was still unreadable, because only two of the floor's four parts are visible in source: line-height resolves against the computed font-size and contrast depends on the painted background. Also added: a line-length cap (65–85ch) and a rule that swatches/status dots/category chips must be *measurably* distinct, after a theme picker shipped five swatches that render as five identical black squares (every pair between 1.00:1 and 1.10:1).
  - **Two rules demoted from unconditional, both cases of "fully satisfiable and still wrong."** `/docs` is now conditional on the app having a concept a new user would get wrong — of eleven apps, eight skipped it and were right to; mandating it in a domain with no such concept (a music library) produces a stub nobody reads. **Bulk edit** is now explicitly deferrable — six of eleven shipped without it despite plainly batchable fields, and its absence is a scheduling decision, not non-conformance. Where it was built it was built well, so its rules are unchanged.
  - **"Architecture — three hard layers" renamed to "one hard rule, five directories."** The heading promised three layers and then listed five directories, so "is this app's architecture correct?" was unanswerable. The testable claim was always import purity: `src/<domain>/` may not import React, Next, or the DB.
  - **All audit census data removed from the skill body** (including two pre-existing mentions). Counts like "nine of ten apps" or "across a five-app blueprint family" are provenance for *why* a rule exists, not knowledge an agent building an app can act on — they go stale as the family grows and cost context on every load. The evidence lives here; the skill states the failure mode.

## [6.0.0] - 2026-07-23

Major: **code-review is rebuilt as 2.0** with breaking changes to its lanes, verifier, default output, and flags — anyone using the old lane names or expecting the always-visible nit list gets different behavior. The rebuild was driven by a six-agent audit of why the skill had gone unused and validated end-to-end (planted-bug fixture + verifier impact-floor test) before shipping.

### Breaking Changes

- **code-review (1.6.1 → 2.0.0)** — rebuilt around correctness and signal, from a 6-agent diagnosis of why the skill went unused (slow, nitpicky, architecture suggestions that didn't land). Anyone relying on the old lane names or the always-visible nit list gets different behavior:
  - **Lanes changed.** `basics` is replaced by a **correctness** lane (data-flow tracing for wrong answers: boundary/off-by-one, DST/tz bucketing, money/rate math, swallowed errors, non-atomic writes, unterminated loops, discarded async results). `architecture` is **re-aimed from sibling-consistency to intent-conformance** (flags a real consequence, never "a peer does it differently"; blueprint-aware). A new conditional **ui-ux** lane (dispatched only when the diff touches UI) is briefed against the typography + color-system floors. `clarity` and `repo-hygiene` are folded into a single **non-blocking hygiene sweep** — its findings are suppressed unless `--nits`, except a real `[Secret]`, which always surfaces.
  - **Verifier is now a signal filter, not just a false-positive filter.** It enforces an **impact floor**: a kept finding must name a concrete bad outcome (wrong result, data loss, security, real regression, reader-trap); anything whose worst realistic outcome is cosmetic/stylistic/doc-only is dropped or held as a nit. The old "when in doubt, demote rather than drop" rule (which produced the noise) is retired, along with the `[Unverified]` demote-and-keep tier.
  - **Report output changed.** Nits are hidden by default (`--nits` to show). A new `## What the repo does well` (verifier-confirmed strengths) leads the report. New summary line: `kept N blocking of M; dropped J (W wrong-evidence, L low-impact); H nits held`.
  - **New modes.** `--repo [--blueprint <skill>]` for a whole-repo/blueprint conformance pass, and `--background` for a detached, git-worktree-isolated run (orchestrated from the main thread, since subagents can't fan out) so review doesn't block editing.
  - Validated end-to-end before shipping: the correctness lane returned clean on correct code (no false positives) and caught 3/3 planted + 2 unplanted real bugs on a buggy fixture while ignoring nit-bait; the verifier kept all 5 bugs and held both nits.

## [5.1.0] - 2026-07-22

Evidence-driven pass on the three heaviest-used skills, from 20 days of real activation data across 1,912 transcripts rather than a fresh read of the prose.

### Changed

- **track-session** (5.1.2 → 5.2.0): added a **Start mode** with a collision policy for when a `SESSION_PROGRESS.md` already exists (6 of 31 real invocations were "create a new file" with no documented procedure; on disk, files were stacking four sessions under invented headings that the dashboard can't parse). Added an official `## Decisions` section (16 of 36 files had already invented one). Gave **Resume** a required 2-3 line opening template (status + tasks-done + last commit + next) so handoffs stop burying state under fresh analysis. Added a re-check-frontmatter step to Resume (`project:` was silently stale in real files). Carved out an **environment-scoped exception** to "never retry a failed approach" (an MCP-not-connected block was correctly logged, then wrongly refused after the environment changed). Relaxed the task-id rule to allow stable mnemonic slugs (`t_authfix`) — verified the cc-dash parser accepts `[a-z0-9-]+` on the read path, so the old `{5}`-random rule was fighting a sensible instinct for no gain.
- **track-roadmap** (2.5.3 → 2.5.4): front-loaded the **Update** triggers the description omitted ("add an item to the roadmap", "mark a feature done", "log the work I shipped") — Update is ~80% of real use but was invisible in the trigger surface, while `audit` (advertised) had zero uses. Documented that there is no `save` mode (it means Update) and that `roadmap_ref` may be a comma-separated list. No schema changes — the skill is structurally healthy (100% ROADMAP.md schema compliance, live `roadmap_ref` links in 11 session files).

### Fixed

- **code-review** (1.6.0 → 1.6.1): renamed the subagent tool from the removed `Task` to `Agent` throughout SKILL.md and reference/AGENTS.md (9 occurrences, incl. `allowed-tools`). Every real run already dispatched via `Agent`; the stale name was a latent break waiting on `allowed-tools` enforcement. The pipeline itself is healthy (verified: exactly 6 Agent dispatches per run) — the fix is de-rot only.
- **CLAUDE.md**: corrected the multiline-`description:` bug citation from `anthropics/skills #9817` to `anthropics/claude-code #9817` (4 occurrences). Re-verified the issue: it and its three duplicates were closed without a fix, so the single-line rule stands unchanged.

## [5.0.0] - 2026-07-22

Major cut: **local-first-app v2.0.0 reverses two rules the blueprint previously stated**, so anyone who built against v1.7.0 gets different instructions on re-read. The release also carries a full 72-file manual audit of the repo (every tracked file read end to end) and the 22 fixes it produced — including several regressions introduced by the local-first-app rewrite itself and caught before they shipped.

### Breaking Changes

- **local-first-app**: the sanctioned delete-confirm changes from `@mantine/modals`' `openConfirmModal` to a hand-rolled controlled `<Modal>` (`ConfirmDeleteButton`). `@mantine/modals` and `<ModalsProvider>` leave the stack entirely.
- **local-first-app**: tests move from colocated `*.test.ts` to a top-level `tests/` directory with a shared `tests/shims/` set (`next-cache`, `next-navigation`, `node-sqlite`, `server-only`).
- **rate-skill**: the type taxonomy changes from `methodology`/`reference`/`generator`/`auditor` to `generate-skill`'s five (`methodology`/`technical`/`auditing`/`reference`/`automation`). Reports emit different type names, and the §3 length rubric produces different scores for skills over 300 lines.

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

[Unreleased]: https://github.com/antjanus/skillbox/compare/v10.1.0...HEAD
[10.1.0]: https://github.com/antjanus/skillbox/compare/v10.0.0...v10.1.0
[10.0.0]: https://github.com/antjanus/skillbox/compare/v9.6.0...v10.0.0
[9.6.0]: https://github.com/antjanus/skillbox/compare/v9.5.0...v9.6.0
[9.5.0]: https://github.com/antjanus/skillbox/compare/v9.4.0...v9.5.0
[9.4.0]: https://github.com/antjanus/skillbox/compare/v9.3.0...v9.4.0
[9.3.0]: https://github.com/antjanus/skillbox/compare/v9.2.1...v9.3.0
[9.2.1]: https://github.com/antjanus/skillbox/compare/v9.2.0...v9.2.1
[9.2.0]: https://github.com/antjanus/skillbox/compare/v9.1.0...v9.2.0
[9.1.0]: https://github.com/antjanus/skillbox/compare/v9.0.0...v9.1.0
[9.0.0]: https://github.com/antjanus/skillbox/compare/v8.2.0...v9.0.0
[5.0.0]: https://github.com/antjanus/skillbox/compare/v4.10.0...v5.0.0
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
