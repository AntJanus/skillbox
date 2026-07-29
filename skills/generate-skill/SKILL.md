---
name: generate-skill
description: Interactive SKILL.md builder. Use this skill whenever the user asks to "create a skill", "generate a skill", "scaffold a SKILL.md", "write a SKILL.md", or "turn this workflow into a skill" — even if they don't say "skill" and only describe wanting to make a repeatable agent workflow or convention. Do NOT use for grading an existing SKILL.md (see rate-skill), project roadmaps (see track-roadmap), or manual-QA checklists (see track-qa).
license: MIT
argument-hint: "[skill-topic]"
metadata:
  author: Antonin Januska
  version: "5.0.0"
---

# Generate Skill

## Overview

Produces one ready-to-ship `SKILL.md` (plus optional `references/`, `scripts/`, `assets/`) following the conventions distilled from the agentskills.io skill-creation pages, Anthropic's skill-creator, the platform prompting guides, and empirical activation research.

One skill, one job. This skill's job is the SKILL.md and its frontmatter — not docs, releases, or auxiliary files.

## Core principles

- **The description is the product.** It is the only thing Claude reads to decide whether to invoke the skill. Tune it like a prompt.
- **Add what the agent lacks, omit what it knows.** For every instruction ask: *would the agent get this wrong without it?* If no, cut it. Encode only non-inferable, procedural, skill-specific knowledge.

## Workflow

Use AskUserQuestion to ask one question at a time. Never bulk-dump the discovery questionnaire. After each phase, show the artifact and confirm before moving on.

### Phase 1 — Discovery

Ask these in order, one per turn:

1. **Skill purpose.** One sentence: what job does this skill do?
2. **Skill type.** Pick one — drives the body template:
   - `methodology` — enforces a multi-step workflow (code-review, track-session)
   - `technical` — wraps an API, format, or tool (docx, pdf, semantic-release)
   - `auditing` — grades or inspects an artifact (rate-skill, security-review)
   - `reference` — domain schemas, conventions, lookup tables (bigquery)
   - `automation` — wraps a script or external command (screenshot-local)
3. **Trigger phrases.** Collect 5+ verbatim phrases a real user would say. Push for naturalese, not jargon ("create a skill", not "scaffold skill artifact").
4. **Negative scope.** Which near-neighbor skills should this not steal from? Drives the `Do NOT use…` clause and the should-not-trigger half of the Phase 8 eval set.
5. **Enforcement level.** Suggestion, guided (checklists), or strict (gated phases). Defaults: methodology=guided, technical/reference=suggestion, auditing=guided, automation=suggestion.

### Phase 2 — Description drafting

Compose the description — official sizing is "a few sentences to a short paragraph," hard cap 1024 chars (spec). Shape:

```
<Third-person noun phrase>. Use whenever the user <wants/asks to> <trigger 1>, "<trigger 2>", or <trigger 3> — even if they don't explicitly mention <domain term>. Do NOT use this skill for <near-neighbor> — see <other-skill>.
```

Show the draft, measure it (`python3 scripts/measure.py <path/to/SKILL.md>` reports description chars, body lines, and estimated body tokens against their caps), iterate.

Quality signals:

- ✅ Distinctive noun in first 50 chars
- ✅ Imperative third person addressed to the agent (the skill, not "I")
- ✅ At least one literal quoted user phrase
- ✅ "even if they don't explicitly mention X" coverage clause for indirect asks (officially recommended)
- ✅ `Do NOT use this skill for …` clause when a near-neighbor exists
- ✅ A few sentences to a short paragraph, under the 1024-char cap

Anti-patterns:

- ❌ First person: "I help you create skills" — degrades activation (Seleznov n=650)
- ❌ Vague: "A skill for creating skills"
- ❌ Bullet-list description — no surveyed top skill uses this format
- ❌ Intensity escalation: "CRITICAL: you MUST invoke this" — current models overtrigger on it, and the official fix is normal prompting ("Use this skill when…"). Raise recall with *more triggers and a coverage clause*, never with volume.

### Phase 3 — Frontmatter

Emit only these fields, in this order:

```yaml
---
name: <kebab-case, ≤64 chars, no "anthropic" or "claude" reserved words>
description: <string from Phase 2>
license: MIT
argument-hint: "[<short-token>]"    # top-level, not nested — and QUOTED: bare [x] is a YAML list, not a string
metadata:
  author: <user-supplied>
  version: "1.0.0"
---
```

Add these optional fields only when the skill genuinely needs them:

| Field | When to add |
|---|---|
| `allowed-tools` | Skill must restrict which tools the agent uses (Experimental) |
| `compatibility` | Cross-agent (Cursor, Cline, etc.) compatibility note, ≤500 chars (spec cap) |
| `disable-model-invocation: true` | Skill is slash-only, must not auto-trigger |
| `user-invocable: false` | Skill is only callable by subagents or other skills |
| `model` | Skill needs a specific tier. Otherwise inherit — a pin outlives the model it names. |
| `effort` | Set `low`/`medium` for mechanical, well-specified work where quality holds; reserve `xhigh` for demanding coding and agentic work. Omit to inherit the session setting. |
| `paths` | Skill should only auto-trigger inside specific repo paths |
| `when_to_use` | Extra listing-time routing text beyond the description (Claude Code; shares a combined 1,536-char listing cap with `description`) |

Anti-patterns:

- ❌ Top-level `version`, `author`, `tags`, `category` — produce "unexpected key" errors (anthropics/skills #37). They live under `metadata`.
- ❌ Nested `argument-hint` under `metadata` — Claude Code reads it at top level.
- ❌ Unquoted `argument-hint: [a|b]` — bare brackets are a YAML **sequence**, not a string. Always quote it.
- ❌ Reserved-word names containing `anthropic` or `claude`.
- ❌ Consecutive hyphens or uppercase in `name`.

Portability, three tiers: the universal spec allows only `name`, `description`, `license`, `compatibility`, `allowed-tools`, `metadata`. Claude Code adds its extension keys (`argument-hint`, `when_to_use`, `hooks`, `paths`, `arguments`, `disable-model-invocation`, `user-invocable`, `model`, `effort`, `context`, `agent`, `shell`, `disallowed-tools`). Anthropic's repo packaging validator (`quick_validate.py`) rejects everything outside the spec set. The Vercel `npx skills add` channel tolerates the extensions (verified 2026-07-02) — keep them unless the skill targets anthropics/skills. Lint against the spec with `skills-ref validate <skill-dir>`.

### Phase 4 — Body content

Pick the template matching the skill type. Full templates live in [references/PATTERNS.md](references/PATTERNS.md) — load only when generating the body.

Compact summary — this is the **shared section spec** graded by `rate-skill` Category 4; keep the two skills in sync:

- **methodology** — Overview, Workflow (phased, one task per phase), Examples, Gotchas. Optional: Quality Signals / Anti-Patterns.
- **technical** — Overview, Quick Start / Setup (one minimal code block), Quick Reference or API surface, Examples, Gotchas. Optional: Troubleshooting. Move long API surface to `references/API.md`.
- **auditing** — Overview, Workflow, Rubric (table: signal → weight → check), Output Format, Examples of high/low-quality artifacts, Gotchas.
- **reference** — Overview, Navigation (load-when table), Gotchas; optional short Core Concepts. SKILL.md stays a router; don't inline the data.
- **automation** — Overview, Command Surface table, Sample Invocation, Failure Modes, Gotchas. Optional: Troubleshooting. Put the actual script in `scripts/`.

**Content rules for every type:**

- Always include `## Gotchas` — canonical: "the highest-value content in many skills is a list of gotchas" (agentskills.io). Keep them in SKILL.md, not a reference file — the agent must read them *before* hitting the situation. When the deployed skill's agent makes a mistake you have to correct, the correction becomes a new gotcha.
- Beyond gotchas, five more official instruction patterns: output-format **templates** (agents pattern-match against concrete structures better than prose descriptions of a format), **checklists** for multi-step workflows, **validation loops** (do → validate → fix → repeat), **plan-validate-execute** for batch or destructive operations, and **bundled scripts** when the agent would reinvent the same logic each run. Use the ones that fit — not all of them.
- Provide defaults, not menus: pick one approach, mention alternatives briefly.
- Favor procedures over declarations: teach how to approach the class of problem, not what to output for one instance.
- Pair every "do not X" with a positive directive. Official: "Tell Claude what to do instead of what not to do."

**Agentic calibration — what to leave out.** Current models already do these; instructing them again compounds the behavior and burns tokens with no quality gain.

- **No self-re-check steps.** Cut "double-check your answer", "re-verify before responding", "add a final verification step for any non-trivial task", "use a subagent to verify". The official fix is deletion, not rewording. Verification that checks *external* state — "run the test suite", "confirm the file parses", "validate against the schema" — is a real step and stays.
- **Never instruct the agent to echo its reasoning** ("show your thinking", "explain your reasoning in the response"). This can trigger the `reasoning_extraction` refusal category on Claude Fable 5 and causes model fallbacks. Ask for conclusions and evidence instead.
- **Never instruct the agent not to think or not to reason.** That kind of rule increases leakage of internal XML tags into visible output.
- **Cap delegation when the skill uses subagents.** State which scenarios warrant one and keep spawn counts low; open-ended delegation multiplies cost on small tasks.
- **Bound the deliverable when the skill writes a file.** Add a line to the output template: match length to the task, don't pad with filler sections, redundant summaries, or boilerplate. Written deliverables run long by default.
- **State where a narrow skill stops.** Models expand scope on their own, adding steps that weren't requested.

Length budget: aim <300 lines (house aim); the canonical cap is joint — **under 500 lines and ~5,000 tokens**. A dense, code-heavy body breaches tokens while passing lines.

### Phase 5 — Examples

Produce 3–5 examples covering **distinct situations**, not the same situation restated — vary them enough that the agent doesn't pattern-match an unintended regularity. At least one is a ❌ counter-example. Show ✅ first; if room, end on ✅ (recency bias).

Format:

```markdown
### Example: <one-line task>

✅ Desired

<short code or transcript>

Why it works: <one sentence>.
```

```markdown
### Counter-example

❌ Anti-pattern

<short code or transcript>

Why it fails: <one sentence>.
```

Use ✅ / ❌ markdown markers for the quality labels — the `<Good>` / `<Bad>` XML form appears in zero of the 8 surveyed top community skills. This is about the labels, not XML: `<example>` / `<examples>` as structural delimiters are officially recommended and fine to use.

### Phase 6 — Gotchas

Concrete failure modes specific to *this* skill, not generic skill-authoring advice. Each entry: one-line symptom, one-line cause, one-line fix.

### Phase 7 — Progressive disclosure check

Measure with `scripts/measure.py`. Extract once SKILL.md exceeds 300 lines; treat the joint 500-line / ~5,000-token cap as the hard ceiling either way:

1. List candidate sections to extract, largest first.
2. Propose `references/<TOPIC>.md` files. Plural is the spec-documented name; nothing validates directory names, so never rename an existing singular `reference/` dir just for style.
3. Keep extracted files exactly one level deep. Deeply nested references get silently truncated by preview reads.
4. Add a one-line pointer in SKILL.md per extracted file: when to load it, what's in it. Exception: gotchas stay in SKILL.md.

### Phase 8 — Eval set (required before finalize)

Build the eval set the official description-optimization loop consumes (agentskills.io):

1. **Generate ~20 queries**: 8–10 **should-trigger** (Phase 1 trigger phrases plus paraphrases and indirect asks) and 8–10 **should-not-trigger** (Phase 1 near-neighbors plus unrelated work).
2. **Split 60% train / 40% validation**, proportional mix of should/should-not in both halves. Shuffle once; keep the split fixed across iterations.
3. **Save as `references/EVAL.md`** with the split marked and the protocol stated: run each query in a fresh session ~3 times; trigger rate = fraction of runs that invoked the skill; should-trigger passes above 0.5, should-not-trigger below 0.5 (official default threshold).
4. **Iterate on train failures only** — rework the Phase 2 description, never peek at validation to choose wording. Check validation after; **select the description with the best validation score** (an earlier draft can beat the last one — later iterations overfit). "Five iterations is usually enough" (official guidance).
5. Ask the user to spot-check 3–5 queries in a fresh Claude session before finalizing.

Caveat (official): agents consult skills for tasks beyond what they can handle alone, so a trivially simple query may not trigger even a perfectly described skill. Don't churn the description over those.

To measure whether the **body** improves output rather than just triggering, run the official output-quality loop: 2–3 test cases with and without the skill, graded with evidence-required assertions written *after* the first run, dropping any assertion that passes in both configurations. Worth it for methodology and auditing skills, overkill for small reference skills.

## Output layout

```
<skill-name>/
├── SKILL.md                       # <300 lines, one job
├── references/                    # plural — load on demand
│   ├── PATTERNS.md                # optional: body templates by type
│   └── EVAL.md                    # train/validation eval set (Phase 8)
├── scripts/                       # optional: deterministic helpers (this skill bundles measure.py)
└── assets/                        # optional: templates copied into output
```

## Examples

✅ Distinctive token first, literal triggers, coverage clause, negative scope:

```yaml
description: docx authoring toolkit. Use whenever the user asks to "create a Word doc", "edit a .docx", or "add tracked changes" — even if they only say "this report" and name a .docx file. Do NOT use for PDF — see the pdf skill.
```

❌ First person, buried noun, no triggers, no scope:

```yaml
description: I help you work with Word documents. Use when you need to edit files.
```

✅ A body step that checks external state:

```markdown
Run `skills-ref validate <skill-dir>` and confirm it exits 0 before finalizing.
```

❌ A body step that re-checks the agent's own work — cut it, the model already does this:

```markdown
Before you finish, double-check your work and use a subagent to verify the output.
```

Full worked set (methodology ✅, technical ✅, counter-example ❌, repaired ✅): **[references/EXAMPLES.md](references/EXAMPLES.md)**.

## Gotchas

- **Symptom:** New skill never auto-invokes. **Cause:** Description used vague prose without specific triggers. **Fix:** Rewrite with the "Use whenever the user wants to…" form plus 3+ quoted trigger phrases.
- **Symptom:** Skill works in isolation, breaks once the user has >20 skills installed. **Cause:** Distinctive trigger is past char 50; listing budget truncated it. **Fix:** Move the distinctive noun to the start of `description`.
- **Symptom:** Skill fires on exact trigger phrases but misses indirect asks ("clean up this data file" for a CSV skill). **Cause:** No coverage clause. **Fix:** Add "even if they don't explicitly mention X" to the description.
- **Symptom:** Skill fires on prompts it has nothing to do with. **Cause:** Intensity escalation ("CRITICAL: you MUST use this") — current models overtrigger on aggressive language. **Fix:** Drop to normal register; widen recall with more literal triggers instead.
- **Symptom:** Description scores well on train queries, regresses on validation. **Cause:** Overfitting — wording tuned against the same queries each round. **Fix:** Select by validation score; keep the split fixed; an earlier iteration may be the winner.
- **Symptom:** Generated skill causes refusals or model fallbacks on Fable 5. **Cause:** Body instructs the agent to echo its reasoning. **Fix:** Delete reasoning-echo instructions; ask for conclusions and evidence instead.
- **Symptom:** Generated skill burns tokens and latency on short tasks with no quality gain. **Cause:** Body carries verification scaffolding ("double-check", "verify with a subagent") the model performs unprompted. **Fix:** Delete those steps; keep only checks against external state.
- **Symptom:** "Unexpected key" warning on load. **Cause:** Top-level `version`, `author`, or `tags`. **Fix:** Move them under `metadata`. `argument-hint` and `hooks` are **valid** Claude Code top-level keys and stay put — only Anthropic's repo packaging validator rejects them.
- **Symptom:** Two skills both fire on the same prompt. **Cause:** Overlapping triggers, no negative scope. **Fix:** Add `Do NOT use this skill for X — see Y` to whichever skill is the wrong fit.
- **Symptom:** SKILL.md is 700 lines, agent quotes the wrong section. **Cause:** Single-file overflow; Claude reads the head, misses the tail. **Fix:** Extract to `references/`, one level deep, with explicit "load when…" pointers.

## Integration

- **rate-skill** — run after generating to grade the new SKILL.md. `generate-skill` produces, `rate-skill` audits. The Phase 4 section list and rate-skill's Category 4 table are one shared spec.
- **references/PATTERNS.md** — body templates by skill type; loaded on demand during Phase 4.

## References

Full source list with URLs: **[references/SOURCES.md](references/SOURCES.md)** — load only when a user disputes a rule and you need to cite the spec.
