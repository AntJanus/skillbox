---
name: generate-skill
description: Interactive SKILL.md builder. Use whenever the user asks to "create a skill", "generate a skill", "scaffold a SKILL.md", "write a SKILL.md", or "turn this workflow into a skill". Do NOT use for grading existing skills (see rate-skill).
license: MIT
argument-hint: "[skill-topic]"
metadata:
  author: Antonin Januska
  version: "3.1.0"
---

# Generate Skill

## Overview

Produces a single, ready-to-ship `SKILL.md` (plus optional `references/`, `scripts/`, `assets/`) following 2026-05 conventions distilled from Anthropic's skill-creator, the agentskills.io spec, and empirical activation research.

One skill, one job. This skill's job is the SKILL.md and its frontmatter — not docs, releases, or auxiliary files.

## Core principles

- **The description is the product.** It is the only thing Claude reads to decide whether to invoke the skill. Tune it like a prompt.
- **Soft directive, third person.** "Use this skill whenever the user…" activates reliably without the brittleness of ALL-CAPS commands.
- **Front-load distinctive triggers.** The first ~50 chars must contain the noun phrase that makes this skill unique; listing budgets silently truncate at high skill counts.
- **One skill, one job.** Bundling unrelated workflows is the most-cited mega-skill failure mode.
- **Claude is already smart.** Encode only non-inferable, procedural, skill-specific knowledge. No tutorials.

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
4. **Negative scope.** Which near-neighbor skills exist that this should *not* steal from? Drives the `Do NOT use…` clause.
5. **Enforcement level.** Suggestion, guided (checklists), or strict (verification checkpoints). Defaults: methodology=guided, technical/reference=suggestion, auditing=guided, automation=suggestion.

### Phase 2 — Description drafting

Compose a single-line YAML string, target ≤230 chars (soft cap — listing-budget safe; no penalty up to 500), shape:

```
<Third-person noun phrase>. Use whenever the user <wants/asks to> <trigger 1>, "<trigger 2>", or <trigger 3>. <Optional scope note.> Do NOT use this skill for <near-neighbor 1> — see <other-skill>.
```

Show the draft, count chars (`python3 -c "import yaml; print(len(yaml.safe_load(open('SKILL.md').read().split('---',2)[1])['description']))"`), iterate.

Quality signals:

- ✅ Distinctive noun in first 50 chars
- ✅ Third person (the skill, not "I")
- ✅ Single line — no `|` or `>` block scalars (silently breaks discovery, anthropics/skills #9817)
- ✅ At least one literal quoted user phrase
- ✅ `Do NOT use this skill for …` clause when a near-neighbor exists
- ✅ ≤230 chars (soft target — safe against listing-budget pressure)

Anti-patterns:

- ❌ First person: "I help you create skills" — degrades activation
- ❌ Vague: "A skill for creating skills"
- ❌ Multi-line: any `description: |` block — silent discovery failure
- ❌ Bullet-list description — no surveyed top skill uses this format
- ❌ ALL-CAPS verb spam — Anthropic flags as a yellow flag

### Phase 3 — Frontmatter

Emit only these fields, in this order:

```yaml
---
name: <kebab-case, ≤64 chars, no "anthropic" or "claude" reserved words>
description: <single-line string from Phase 2>
license: MIT
argument-hint: [<short-token>]      # top-level, not nested
metadata:
  author: <user-supplied>
  version: "1.0.0"
---
```

Add these optional fields only when the skill genuinely needs them:

| Field | When to add |
|---|---|
| `allowed-tools` | Skill must restrict which tools the agent uses (Experimental) |
| `compatibility` | Cross-agent (Cursor, Cline, etc.) compatibility note, ≤500 chars |
| `disable-model-invocation: true` | Skill is slash-only, must not auto-trigger |
| `user-invocable: false` | Skill is only callable by subagents or other skills |
| `model` / `effort` | Skill needs a specific model tier or thinking budget |
| `paths` | Skill should only auto-trigger inside specific repo paths |

Anti-patterns:

- ❌ Top-level `version`, `author`, `tags`, `category`, `hooks` — produce "unexpected key" errors (anthropics/skills #37). They live under `metadata`.
- ❌ Nested `argument-hint` under `metadata` — Claude Code reads it at top level.
- ❌ Reserved-word names containing `anthropic` or `claude`.
- ❌ Consecutive hyphens or uppercase in `name`.

### Phase 4 — Body content

Pick the template that matches the skill type. Full templates live in [references/PATTERNS.md](references/PATTERNS.md) — load only when generating the body.

Compact summary:

- **methodology** — Overview, Core principles, Phased workflow (numbered, one task per phase), Examples (✅ first, ❌ last), Gotchas, optional Verification checklist.
- **technical** — Overview, Quick start (one minimal code block), How it works, Quick reference tables, Examples, Gotchas. Move long API surface to `references/API.md`.
- **auditing** — Overview, Scoring rubric (table: signal → weight → check), Output format, Examples of high/low-quality artifacts, Gotchas.
- **reference** — Overview + navigation, then one `references/<domain>.md` per domain. SKILL.md stays a router; don't inline the data.
- **automation** — Overview, Command surface table, Sample invocation, Failure modes, Gotchas. Put the actual script in `scripts/`.

Always include a `## Gotchas` section — Anthropic engineers cite it as the highest-signal section in a skill body.

Length budget: aim <300 lines in SKILL.md, hard cap 500. The ETH Zurich AGENTS.md study (arXiv 2602.11988) found verbose context files reduce task success ~3% and inflate step count >20%.

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

Count lines in the body. If SKILL.md exceeds 300 lines:

1. List candidate sections to extract, largest first.
2. Propose `references/<TOPIC>.md` files (plural directory — `reference/` singular is a non-canonical anti-pattern).
3. Keep extracted files exactly one level deep from SKILL.md. Deeply nested references silently get truncated by Claude's preview reads.
4. Add a one-line pointer in SKILL.md for each extracted file: when to load it, what's in it.

### Phase 8 — Eval set (required before finalize)

Anthropic's skill-creator now ships an A/B description optimizer with 60/40 train/test eval sets. Generate-skill emits an eval set for every skill before completing.

Generate 20 candidate queries:

- 10 **should-trigger** — phrases that should fire the skill
- 10 **should-not-trigger** — phrases for adjacent skills or unrelated work (especially near-neighbor skills from Phase 1 negative scope)

Save as `references/EVAL.md`. Ask the user to spot-check 3–5 in a fresh Claude session before finalizing. If activation is unreliable, return to Phase 2 and rework the description.

## Output layout

```
<skill-name>/
├── SKILL.md                       # <300 lines, one job
├── references/                    # plural — load on demand
│   ├── PATTERNS.md                # optional: body templates by type
│   └── EVAL.md                    # 20-query eval set (Phase 8)
├── scripts/                       # optional: deterministic helpers
└── assets/                        # optional: templates copied into output
```

## Examples

Worked description examples (methodology ✅, technical ✅, multi-line counter-example ❌): **[references/EXAMPLES.md](references/EXAMPLES.md)**.

## Gotchas

- **Symptom:** New skill never auto-invokes. **Cause:** Description used vague prose without specific triggers. **Fix:** Rewrite with the "Use whenever the user wants to…" form plus 3+ quoted trigger phrases.
- **Symptom:** Skill works in isolation, breaks once user has >20 skills installed. **Cause:** Distinctive trigger is past char 50; listing budget truncated it. **Fix:** Move the distinctive noun to the start of `description`.
- **Symptom:** YAML parses but skill never appears in `/skills`. **Cause:** Multi-line `description: |`. **Fix:** Collapse to a single line; move long context into the body's first paragraph.
- **Symptom:** "Unexpected key" warning on load. **Cause:** Top-level `version`, `author`, `tags`, or `hooks`. **Fix:** Move them under `metadata` (except `argument-hint`, which stays top-level).
- **Symptom:** Two skills both fire on the same prompt. **Cause:** Overlapping triggers, no negative scope. **Fix:** Add `Do NOT use this skill for X — see Y` to whichever skill is the wrong fit.
- **Symptom:** SKILL.md is 700 lines, agent quotes the wrong section. **Cause:** Single-file overflow; Claude reads the head, misses the tail. **Fix:** Extract to `references/` (plural), one level deep, with explicit "load when…" pointers.

## Integration

- **rate-skill** — Run after generating to grade the new SKILL.md against current standards. `generate-skill` produces; `rate-skill` audits.
- **references/PATTERNS.md** — body templates by skill type; loaded on demand during Phase 4.

## References

- agentskills.io spec: https://agentskills.io/specification
- Anthropic skill best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- Claude Code skills docs: https://code.claude.com/docs/en/skills
- Anthropic skill-creator: https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- Anthropic skill-creator eval pipeline (May 2026): https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills
- Description activation study (Seleznov n=650): https://medium.com/@ivan.seleznov1/why-claude-code-skills-dont-activate-and-how-to-fix-it-86f679409af1
- Skill listing budget: https://claudefa.st/blog/guide/mechanics/skill-listing-budget
- ETH Zurich AGENTS.md study: https://arxiv.org/abs/2602.11988
- Negation handling: https://arxiv.org/abs/2503.22395
- anthropics/skills #9817 (multiline description bug): https://github.com/anthropics/claude-code/issues/9817
- anthropics/skills #37 (unsupported frontmatter fields): https://github.com/anthropics/skills/issues/37
