---
name: generate-skill
description: Interactive SKILL.md builder. Use whenever the user asks to "create a skill", "generate a skill", "scaffold a SKILL.md", "write a SKILL.md", or "turn this workflow into a skill". Do NOT use for grading existing skills (see rate-skill).
license: MIT
argument-hint: "[skill-topic]"
metadata:
  author: Antonin Januska
  version: "4.0.0"
---

# Generate Skill

## Overview

Produces a single, ready-to-ship `SKILL.md` (plus optional `references/`, `scripts/`, `assets/`) following the current conventions distilled from the agentskills.io skill-creation pages, Anthropic's skill-creator, and empirical activation research.

One skill, one job. This skill's job is the SKILL.md and its frontmatter — not docs, releases, or auxiliary files.

## Core principles

- **The description is the product.** It is the only thing Claude reads to decide whether to invoke the skill. Tune it like a prompt.
- **Imperative third person.** "Use this skill when…" activates reliably; err on the side of being pushy about when it applies.
- **Front-load distinctive triggers.** The first ~50 chars must contain the noun phrase that makes this skill unique; listing budgets truncate at high skill counts (least-invoked skills lose their text first).
- **One skill, one job.** Bundling unrelated workflows is the most-cited mega-skill failure mode; focused skills empirically outperform bundles (SkillsBench).
- **Add what the agent lacks, omit what it knows.** For every instruction ask: *would the agent get this wrong without it?* If no, cut it. Encode only non-inferable, procedural, skill-specific knowledge.
- **Calibrate control per section.** Give the agent freedom where multiple approaches are valid; be prescriptive where operations are fragile or a sequence must be followed. Explain the why — "Do X because Y tends to cause Z" outperforms "ALWAYS X / NEVER Y".

## Workflow

Use AskUserQuestion to ask one question at a time. Never bulk-dump the discovery questionnaire. After each phase, show the artifact and confirm before moving on.

### Phase 1 — Discovery

Ask these in order, one per turn:

1. **Skill purpose.** One sentence: what job does this skill do?
2. **Skill type.** Pick one — drives the body template:
   - `methodology` — enforces a multi-step workflow (e.g., code-review, track-session)
   - `technical` — wraps an API, format, or tool (e.g., docx, pdf, semantic-release)
   - `auditing` — grades or inspects an artifact (e.g., rate-skill, security-review)
   - `reference` — domain schemas, conventions, lookup tables (e.g., bigquery)
   - `automation` — wraps a script or external command (e.g., screenshot-local)
3. **Trigger phrases.** Collect 5+ verbatim phrases a real user would say. Push for naturalese, not jargon ("create a skill", not "scaffold skill artifact").
4. **Negative scope.** Which near-neighbor skills exist that this should *not* steal from? Drives the `Do NOT use…` clause — and the should-not-trigger half of the Phase 8 eval set.
5. **Enforcement level.** Suggestion, guided (checklists), or strict (verification checkpoints). Defaults: methodology=guided, technical/reference=suggestion, auditing=guided, automation=suggestion.

### Phase 2 — Description drafting

Compose the description — official sizing is "a few sentences to a short paragraph," hard cap 1024 chars (spec). Shape:

```
<Third-person noun phrase>. Use whenever the user <wants/asks to> <trigger 1>, "<trigger 2>", or <trigger 3> — even if they don't explicitly mention <domain term>. Do NOT use this skill for <near-neighbor> — see <other-skill>.
```

Show the draft, count chars (`python3 -c "import yaml; print(len(yaml.safe_load(open('SKILL.md').read().split('---',2)[1])['description']))"`), iterate.

Quality signals:

- ✅ Distinctive noun in first 50 chars
- ✅ Imperative third person addressed to the agent (the skill, not "I")
- ✅ At least one literal quoted user phrase
- ✅ "even if they don't explicitly mention X" coverage clause for indirect asks (officially recommended pattern)
- ✅ `Do NOT use this skill for …` clause when a near-neighbor exists
- ✅ A few sentences to a short paragraph; under the 1024-char hard cap

Anti-patterns:

- ❌ First person: "I help you create skills" — degrades activation (Seleznov n=650)
- ❌ Vague: "A skill for creating skills"
- ❌ Bullet-list description — no surveyed top skill uses this format
- ❌ ALL-CAPS verb spam — officially discouraged in favor of explained reasoning

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
| `model` / `effort` | Skill needs a specific model tier or thinking budget |
| `paths` | Skill should only auto-trigger inside specific repo paths |
| `when_to_use` | Extra listing-time routing text beyond the description (Claude Code; shares a combined 1,536-char listing cap with `description`) |

Anti-patterns:

- ❌ Top-level `version`, `author`, `tags`, `category` — produce "unexpected key" errors (anthropics/skills #37). They live under `metadata`.
- ❌ Nested `argument-hint` under `metadata` — Claude Code reads it at top level.
- ❌ An unquoted `argument-hint: [a|b]` — bare brackets are a YAML **sequence**, not a string. Always quote it.
- ❌ Reserved-word names containing `anthropic` or `claude`.
- ❌ Consecutive hyphens or uppercase in `name`.

Portability note (three-tier reality): the universal spec allows only `name`, `description`, `license`, `compatibility`, `allowed-tools`, `metadata`; Claude Code additionally accepts its extension keys (`argument-hint`, `when_to_use`, `hooks`, `paths`, `arguments`, `disable-model-invocation`, `user-invocable`, `model`, `effort`, `context`, `agent`, `shell`, `disallowed-tools`); Anthropic's repo packaging validator (`quick_validate.py`) rejects everything outside the spec set. The Vercel `npx skills add` channel tolerates the extensions (verified 2026-07-02) — keep them unless the skill targets submission to anthropics/skills. To lint against the spec itself, use `skills-ref validate <skill-dir>` (agentskills/agentskills).

### Phase 4 — Body content

Pick the template that matches the skill type. Full templates live in [references/PATTERNS.md](references/PATTERNS.md) — load only when generating the body.

Compact summary — this is the **shared section spec** graded by `rate-skill` Category 4; keep the two skills in sync:

- **methodology** — Overview, Workflow (phased, one task per phase), Examples (✅ first, ❌ last), Gotchas. Optional: Verification Checklist, Quality Signals / Anti-Patterns.
- **technical** — Overview, Quick Start / Setup (one minimal code block), Quick Reference or API surface, Examples, Gotchas. Move long API surface to `references/API.md`.
- **auditing** — Overview, Workflow, Rubric (table: signal → weight → check), Output Format, Examples of high/low-quality artifacts, Gotchas.
- **reference** — Overview, Navigation (load-when table), Gotchas; optional short Core Concepts. SKILL.md stays a router; don't inline the data.
- **automation** — Overview, Command Surface table, Sample Invocation, Failure Modes, Gotchas. Put the actual script in `scripts/`.

Body rules that apply to every type:

- Always include a `## Gotchas` section — canonical: "the highest-value content in many skills is a list of gotchas" (agentskills.io). Keep gotchas in SKILL.md, not a reference file — the agent must read them *before* hitting the situation. When the deployed skill's agent makes a mistake you have to correct, the correction becomes a new gotcha.
- Beyond gotchas, five more official instruction patterns: output-format **templates** ("agents pattern-match well against concrete structures" — beat prose descriptions of formats), **checklists** for multi-step workflows, **validation loops** (do → validate → fix → repeat), **plan-validate-execute** for batch or destructive operations, and **bundled scripts** when the agent would reinvent the same logic each run. Use the ones that fit — not all of them.
- Provide defaults, not menus: pick one approach, mention alternatives briefly.
- Favor procedures over declarations: teach how to approach the class of problem, not what to output for one instance.
- **Never instruct the agent to echo its reasoning** ("show your thinking", "explain your reasoning in the response") — this can trigger the `reasoning_extraction` refusal category on Claude Fable 5 and causes model fallbacks.

Length budget: aim <300 lines in SKILL.md (house aim); the canonical cap is joint — **under 500 lines and ~5,000 tokens** (a dense code-heavy body can breach tokens while passing lines). The ETH Zurich AGENTS.md study (arXiv 2602.11988) found context files generally don't improve task success while adding >20% inference cost.

### Phase 5 — Examples

Produce 2–3 ✅ desired examples and 1 ❌ counter-example. Show ✅ first; if room, end on ✅ (recency bias).

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

Do not use `<Good>` / `<Bad>` XML tags — they appear in zero of the 8 surveyed top community skills.

### Phase 6 — Gotchas

Concrete failure modes specific to *this* skill — not generic skill-authoring advice. Each entry: one-line symptom, one-line cause, one-line fix.

Pair every "do not X" with a positive directive — negation handling in LLMs is empirically weak (arXiv 2503.22395).

### Phase 7 — Progressive disclosure check

Count lines and estimate tokens (chars/4). If SKILL.md exceeds 300 lines or ~3,000 tokens:

1. List candidate sections to extract, largest first.
2. Propose `references/<TOPIC>.md` files (plural — the spec-documented name; nothing validates directory names, so never rename an existing singular `reference/` dir just for style).
3. Keep extracted files exactly one level deep from SKILL.md. Deeply nested references silently get truncated by Claude's preview reads.
4. Add a one-line pointer in SKILL.md for each extracted file: when to load it, what's in it. Exception: gotchas stay in SKILL.md.

### Phase 8 — Eval set (required before finalize)

Build the eval set the official description-optimization loop consumes (agentskills.io):

1. **Generate ~20 queries**: 8–10 **should-trigger** (from the Phase 1 trigger phrases, plus paraphrases and indirect asks) and 8–10 **should-not-trigger** (near-neighbor skills from the Phase 1 negative scope, plus unrelated work).
2. **Split 60% train / 40% validation**, with a proportional mix of should/should-not in both halves. Shuffle once; keep the split fixed across iterations.
3. **Save as `references/EVAL.md`** with the split marked and the measurement protocol stated: run each query in a fresh session ~3 times; trigger rate = fraction of runs that invoked the skill; should-trigger passes above 0.5, should-not-trigger below 0.5 (official default threshold).
4. **Iterate on train failures only** — rework the Phase 2 description, never peek at validation to choose wording. Check validation after; **select the description with the best validation score** (an earlier draft can beat the last one — later iterations overfit). Five iterations is usually enough.
5. Ask the user to spot-check 3–5 queries in a fresh Claude session before finalizing.

Caveat (official): agents consult skills for tasks beyond what they can handle alone — a trivially simple query may not trigger even a perfectly described skill. Don't churn the description over those.

For measuring whether the **body** actually improves output (not just triggering): the official output-quality loop runs 2–3 test cases with and without the skill (or against a snapshot of the previous version), grades with evidence-required assertions written *after* the first run, and drops assertions that pass in both configurations. See https://agentskills.io/skill-creation/evaluating-skills.md — worth running for methodology and auditing skills; overkill for small reference skills.

## Output layout

```
<skill-name>/
├── SKILL.md                       # <300 lines, one job
├── references/                    # plural — load on demand
│   ├── PATTERNS.md                # optional: body templates by type
│   └── EVAL.md                    # train/validation eval set (Phase 8)
├── scripts/                       # optional: deterministic helpers
└── assets/                        # optional: templates copied into output
```

## Examples

Worked description examples (methodology ✅, technical ✅, counter-example ❌): **[references/EXAMPLES.md](references/EXAMPLES.md)**.

## Gotchas

- **Symptom:** New skill never auto-invokes. **Cause:** Description used vague prose without specific triggers. **Fix:** Rewrite with the "Use whenever the user wants to…" form plus 3+ quoted trigger phrases.
- **Symptom:** Skill works in isolation, breaks once user has >20 skills installed. **Cause:** Distinctive trigger is past char 50; listing budget truncated it. **Fix:** Move the distinctive noun to the start of `description`.
- **Symptom:** Skill fires on exact trigger phrases but misses indirect asks ("clean up this data file" for a CSV skill). **Cause:** No coverage clause. **Fix:** Add "even if they don't explicitly mention X" enumeration to the description.
- **Symptom:** Description scores well on train queries, regresses on validation. **Cause:** Overfitting — wording tuned against the same queries each round. **Fix:** Select by validation score; keep the split fixed; an earlier iteration may be the winner.
- **Symptom:** Generated skill causes refusals or model fallbacks on Fable 5. **Cause:** Body instructs the agent to echo its reasoning ("show your thinking"). **Fix:** Delete reasoning-echo instructions; ask for conclusions and evidence instead.
- **Symptom:** "Unexpected key" warning on load. **Cause:** Top-level `version`, `author`, or `tags`. **Fix:** Move them under `metadata`. Note `argument-hint` and `hooks` are **valid** Claude Code top-level keys and stay put — only Anthropic's repo packaging validator rejects them (see the three-tier note above).
- **Symptom:** Two skills both fire on the same prompt. **Cause:** Overlapping triggers, no negative scope. **Fix:** Add `Do NOT use this skill for X — see Y` to whichever skill is the wrong fit.
- **Symptom:** SKILL.md is 700 lines, agent quotes the wrong section. **Cause:** Single-file overflow; Claude reads the head, misses the tail. **Fix:** Extract to `references/` (plural), one level deep, with explicit "load when…" pointers.

## Integration

- **rate-skill** — Run after generating to grade the new SKILL.md against current standards. `generate-skill` produces; `rate-skill` audits. The Phase 4 section lists here and rate-skill's Category 4 table are the same shared spec.
- **references/PATTERNS.md** — body templates by skill type; loaded on demand during Phase 4.

## References

- agentskills.io spec: https://agentskills.io/specification
- Official description-optimization loop (eval sets, trigger rates, splits): https://agentskills.io/skill-creation/optimizing-descriptions.md
- Official output-quality eval loop (with/without baselines): https://agentskills.io/skill-creation/evaluating-skills.md
- Official authoring best practices (patterns, calibrating control): https://agentskills.io/skill-creation/best-practices.md
- Claude Code skills docs: https://code.claude.com/docs/en/skills
- Anthropic skill-creator: https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- skill-creator eval announcement (2026-03-03): https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills
- Claude Fable 5 prompting guidance (prescriptiveness, reasoning extraction): https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5
- Description activation study (Seleznov n=650): https://medium.com/@ivan.seleznov1/why-claude-code-skills-dont-activate-and-how-to-fix-it-86f679409af1
- Skill listing budget: https://claudefa.st/blog/guide/mechanics/skill-listing-budget
- ETH Zurich AGENTS.md study: https://arxiv.org/abs/2602.11988
- SkillsBench (focused-skill finding): https://arxiv.org/abs/2602.12670
- Negation handling: https://arxiv.org/abs/2503.22395
- anthropics/skills #37 (unsupported frontmatter fields): https://github.com/anthropics/skills/issues/37
