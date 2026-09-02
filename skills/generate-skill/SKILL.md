---
name: generate-skill
description: Interactive SKILL.md builder. Use this skill whenever the user asks to "create a skill", "generate a skill", "scaffold a SKILL.md", "write a SKILL.md", or "turn this workflow into a skill" — even if they don't say "skill" and only describe wanting to make a repeatable agent workflow or convention. Do NOT use for grading an existing SKILL.md (see rate-skill) or project roadmaps (see track-roadmap).
license: MIT
argument-hint: "[skill-topic]"
metadata:
  author: Antonin Januska
  version: "6.0.1"
---

# Generate Skill

## Overview

Produces one ready-to-ship `SKILL.md` (plus optional `references/`, `scripts/`, `assets/`) on the conventions from the agentskills.io skill-creation pages, Anthropic's skill-creator, the platform prompting guides, and empirical activation research. The Phase 4 calibration list is tuned for the Claude 5 generation; re-check it against the current model's prompting guide when the generation changes.

**One skill, one job.** This skill's job is the SKILL.md and its frontmatter — not docs, releases, or auxiliary files.

Two principles drive every phase below:

- **The description is the product.** It is the only thing Claude reads to decide whether to invoke the skill. Tune it like a prompt.
- **Add what the agent lacks, omit what it knows.** For every instruction ask: *would the agent get this wrong without it?* If no, cut it. Encode only non-inferable, procedural, skill-specific knowledge.

## Navigation

| Load | When |
|---|---|
| **[references/PATTERNS.md](references/PATTERNS.md)** | Phase 4 — body template for the chosen type |
| **[references/FRONTMATTER.md](references/FRONTMATTER.md)** | Phase 3 — optional fields, anti-patterns, three-tier portability |
| **[references/EXAMPLES.md](references/EXAMPLES.md)** | ✅/❌ pairs for descriptions and body steps |
| **[references/SOURCES.md](references/SOURCES.md)** | A user disputes a rule and you need to cite the spec |

## Workflow

Use AskUserQuestion, one question at a time — never bulk-dump the questionnaire. After each phase show the artifact and confirm before moving on.

### Phase 1 — Discovery

1. **Purpose.** One sentence: what job does this skill do?
2. **Type**, which drives the body template: `methodology` (multi-step workflow — code-review, track-session) · `technical` (an API, format, or tool — docx, semantic-release) · `auditing` (grades an artifact — rate-skill, security-review) · `reference` (schemas, conventions, lookup tables — bigquery) · `automation` (a script or external command — screenshot-local).
3. **Trigger phrases.** 5+ verbatim phrases a real user would say. Push for naturalese: "create a skill", not "scaffold skill artifact".
4. **Negative scope.** Which near-neighbors should this not steal from? Drives the `Do NOT use…` clause and the should-not-trigger half of the Phase 8 eval set.
5. **Enforcement level.** Suggestion, guided (checklists), or strict (gated phases). Defaults: methodology and auditing = guided, technical/reference/automation = suggestion.

### Phase 2 — Description drafting

Official sizing is "a few sentences to a short paragraph," hard cap 1024 chars. Shape:

```
<Third-person noun phrase>. Use whenever the user <wants/asks to> <trigger 1>, "<trigger 2>", or <trigger 3> — even if they don't explicitly mention <domain term>. Do NOT use this skill for <near-neighbor> — see <other-skill>.
```

Show the draft, measure it (`python3 scripts/measure.py <path/to/SKILL.md>` reports description chars, body lines and estimated body tokens against their caps), iterate.

- ✅ Distinctive noun in the first 50 chars
- ✅ Imperative third person addressed to the agent — the skill, not "I"
- ✅ At least one literal quoted user phrase
- ✅ Coverage clause for indirect asks ("even if they don't explicitly mention X") — officially recommended
- ✅ `Do NOT use this skill for …` when a near-neighbor exists
- ❌ First person ("I help you create skills") — degrades activation (Seleznov n=650)
- ❌ Vague ("A skill for creating skills"), or a bullet-list description — no surveyed top skill uses that format
- ❌ Intensity escalation ("CRITICAL: you MUST invoke this") — the model overtriggers on aggressive language, and the official fix is normal register. Raise recall with *more literal triggers and a coverage clause*, never with volume.

### Phase 3 — Frontmatter

Emit these fields, in this order, and nothing else unless the skill needs it:

```yaml
---
name: <kebab-case, ≤64 chars, no "anthropic"/"claude" reserved words>
description: <string from Phase 2>
license: MIT
argument-hint: "[<short-token>]"    # top-level, not nested — and QUOTED: bare [x] is a YAML list, not a string
effort: high                        # optional Claude Code key; overrides the session level while the skill runs
metadata:
  author: <user-supplied>
  version: "1.0.0"
---
```

`effort` defaults by type: automation and reference `low`, technical `medium`, auditing and methodology `high`, multi-source synthesis and agentic coding `xhigh`. A skill whose deliverable is a long file stays at `high` — at `xhigh`/`max` the model drafts it twice, once in reasoning and once as output. Omit the key to inherit; rationale and the live-verification note are in FRONTMATTER.md.

Other optional fields, frontmatter anti-patterns and the three-tier portability rules: **[references/FRONTMATTER.md](references/FRONTMATTER.md)**.

### Phase 4 — Body content

Full templates in [references/PATTERNS.md](references/PATTERNS.md) — load only when generating the body. This section list is the **shared spec** graded by `rate-skill` Category 4; keep the two skills in sync.

| Type | Required | Optional |
|---|---|---|
| methodology | Overview, Workflow (phased, one task per phase), Examples, Gotchas | Quality Signals / Anti-Patterns |
| technical | Overview, Quick Start / Setup (one minimal code block), Quick Reference or API surface, Examples, Gotchas | Troubleshooting — move long API surface to `references/API.md` |
| auditing | Overview, Workflow, Rubric (signal → weight → check), Output Format, Examples of high/low-quality artifacts, Gotchas | — |
| reference | Overview, Navigation (load-when table), Gotchas | Core Concepts — SKILL.md stays a router; don't inline the data |
| automation | Overview, Command Surface table, Sample Invocation, Failure Modes, Gotchas | Troubleshooting — the actual script lives in `scripts/` |

**Content rules, every type:**

- **Always include `## Gotchas`** — canonical: "the highest-value content in many skills is a list of gotchas." Keep them in SKILL.md, never a reference file, because the agent must read them *before* hitting the situation. Every correction you have to make to the deployed skill's agent becomes a new gotcha.
- Five more official instruction patterns beyond gotchas: output-format **templates** (agents pattern-match concrete structures better than prose descriptions of a format), **checklists** for multi-step workflows, **validation loops** (do → validate → fix → repeat), **plan-validate-execute** for batch or destructive operations, **bundled scripts** where the agent would otherwise reinvent the same logic each run. Use the ones that fit, not all of them.
- **Provide defaults, not menus** — pick one approach, mention alternatives briefly.
- **Favor procedures over declarations** — teach how to approach the class of problem, not what to output for one instance.
- **Pair every "do not X" with a positive directive.** Official: "Tell Claude what to do instead of what not to do."

**Agentic calibration — leave these out.** The model already does them, so restating the instruction compounds the behavior and burns tokens with no quality gain.

- **No generic self-re-check steps** — cut "double-check your answer", "re-verify before responding", "add a final verification step for any non-trivial task". The fix is deletion, not rewording. Three things stay, and the last two are recommended for long-running work: checks against *external* state (run the test suite, confirm the file parses, validate against the schema); a writer-verifier pattern where a fresh-context agent judges *another* agent's output; and an evidence audit before a progress report ("only report work you can point to a tool result for"). The defect is an agent re-reading work it produced itself with nothing external to check it against.
- **Never instruct the agent to echo its reasoning** ("show your thinking", "explain your reasoning in the response") — can trigger the `reasoning_extraction` refusal and a model fallback. Ask for conclusions and evidence instead.
- **Never instruct the agent not to think or not to reason** — increases leakage of internal XML tags into visible output.
- **No narration suppressors** ("hold all findings for the final response", "don't narrate", "no interim updates") and **no anti-formatting rules** ("never use bullets", "no headers", "no bold"). Both were written against models that over-narrated and over-formatted; the model does the opposite, so the lines produce silence and flat prose. Say *when* a specific update or format is wanted instead ("report scope before dispatch"; "use a table when comparing three or more items"). Shaping the final message — one chat line, the file is the deliverable — is fine.
- **Scope delegation** when the skill uses subagents: name the scenarios that warrant one and the cap, dispatch independent agents in one message, and keep working while they run instead of blocking on each. Open-ended delegation multiplies cost; blocking delegation multiplies wall-clock.
- **Bound the deliverable** when the skill writes a file — the output template needs a line like "match length to the task, no filler sections, redundant summaries or boilerplate." Written deliverables run long by default.
- **State where a narrow skill stops** — models expand scope on their own, adding steps nobody requested. When the skill produces code, add the code-side line too: "Report a pre-existing bug or behavior the task doesn't mention as a follow-up rather than fixing it here. Commit tests only where the task asks or the repo already keeps tests for this kind of change, sized like the neighboring test files; scratch checks are not test files." Unrequested additions and committed test code drop substantially with this line, with no change in task success.
- **Don't restate what the harness injects** — the autonomy block, the delivering-work scope block, the progress-update line, the overplanning nudge, the hidden-tool-output note, the batch-tool-calls nudge, the readability rules are already in every Claude Code session; a second wording makes the model reconcile the two.

Length budget: aim <300 lines; the canonical cap is joint — **under 500 lines and ~5,000 tokens**, since a dense code-heavy body breaches tokens while passing lines.

### Phase 5 — Examples

Produce 3–5 covering **distinct situations**, not one situation restated — vary them enough that the agent doesn't pattern-match an unintended regularity. At least one is a ❌ counter-example. Show ✅ first; if room, end on ✅ (recency bias). Each gets a one-line verdict:

```markdown
### Example: <one-line task>

✅ Desired

<short code or transcript>

Why it works: <one sentence>.

### Counter-example

❌ Anti-pattern

<short code or transcript>

Why it fails: <one sentence>.
```

Use ✅/❌ for the quality labels — the `<Good>`/`<Bad>` XML form appears in zero of the 8 surveyed top community skills. This is about the labels, not XML: `<example>`/`<examples>` as structural delimiters are officially recommended and fine. Once the body passes 300 lines these move to `references/EXAMPLES.md` behind a pointer naming what's in it; that counts in full for grading.

### Phase 6 — Gotchas

Failure modes specific to *this* skill, not generic skill-authoring advice. Each entry: one-line symptom, one-line cause, one-line fix.

### Phase 7 — Progressive disclosure check

Measure with `scripts/measure.py`. Extract once SKILL.md passes 300 lines; the joint 500-line / ~5,000-token cap is the hard ceiling either way.

1. List candidate sections to extract, largest first.
2. Propose `references/<TOPIC>.md` files. Plural is the spec-documented name, but nothing validates directory names — never rename an existing singular `reference/` dir for style.
3. Keep extracted files exactly one level deep; deeper nesting gets silently truncated by preview reads.
4. Give each a one-line pointer in SKILL.md: when to load it, what's in it. Exception: gotchas stay.

### Phase 8 — Eval set (required before finalize)

Build the set the official description-optimization loop consumes:

1. **~20 queries** — 8–10 **should-trigger** (Phase 1 phrases plus paraphrases and indirect asks) and 8–10 **should-not-trigger** (Phase 1 near-neighbors plus unrelated work).
2. **Split 60/40 train/validation**, proportional mix in both halves. Shuffle once, then keep the split fixed across iterations.
3. **Save as `references/EVAL.md`** with the split marked and the protocol stated: each query run in a fresh session ~3 times; trigger rate = fraction of runs that invoked the skill; should-trigger passes above 0.5, should-not below.
4. **Iterate on train failures only** — never peek at validation to choose wording. Check validation after and **select the best validation score**, since later iterations overfit and an earlier draft can win. "Five iterations is usually enough."
5. Have the user spot-check 3–5 queries in a fresh Claude session before finalizing.

Caveat (official): agents consult skills for tasks beyond what they handle alone, so a trivially simple query may not trigger even a perfectly described skill. Don't churn the description over those.

To measure whether the **body** improves output rather than just triggering, run the official output-quality loop: 2–3 test cases with and without the skill, graded on evidence-required assertions written *after* the first run, dropping any assertion that passes in both configurations. Worth it for methodology and auditing skills, overkill for small reference skills.

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

✅/❌ pairs for methodology and technical descriptions, a counter-example with its four defects reversed, and body steps that check external state vs. re-check the agent's own work: **[references/EXAMPLES.md](references/EXAMPLES.md)**.

## Gotchas

- **Symptom:** New skill never auto-invokes. **Cause:** Vague prose, no specific triggers. **Fix:** Rewrite in the "Use whenever the user wants to…" form with 3+ quoted trigger phrases.
- **Symptom:** Works in isolation, breaks once the user has >20 skills installed. **Cause:** Distinctive trigger sits past char 50 and the listing budget truncated it. **Fix:** Move the distinctive noun to the start of `description`.
- **Symptom:** Fires on exact phrases but misses indirect asks ("clean up this data file" for a CSV skill). **Cause:** No coverage clause. **Fix:** Add "even if they don't explicitly mention X".
- **Symptom:** Description scores well on train, regresses on validation. **Cause:** Overfitting — wording tuned against the same queries each round. **Fix:** Select by validation score, keep the split fixed; an earlier iteration may win.
- **Symptom:** "Unexpected key" warning on load. **Cause:** Top-level `version`, `author`, or `tags`. **Fix:** Move under `metadata`. `argument-hint` and `hooks` are **valid** top-level Claude Code keys and stay put — only Anthropic's packaging validator rejects them.
- **Symptom:** Two skills both fire on one prompt. **Cause:** Overlapping triggers, no negative scope. **Fix:** Add `Do NOT use this skill for X — see Y` to whichever is the wrong fit.
- **Symptom:** SKILL.md is 700 lines and the agent quotes the wrong section. **Cause:** Single-file overflow — Claude reads the head and misses the tail. **Fix:** Extract to `references/`, one level deep, with explicit "load when…" pointers.

## Integration

- **rate-skill** — run after generating to grade the result. `generate-skill` produces, `rate-skill` audits; the Phase 4 table and rate-skill's Category 4 table are one shared spec.

