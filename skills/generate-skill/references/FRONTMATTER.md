# Frontmatter Reference

Load during Phase 3, when the skill needs a field beyond the canonical five or you're resolving a portability question.

## Optional fields — add only when the skill genuinely needs one

| Field | When to add |
|---|---|
| `allowed-tools` | Restrict which tools the agent may use (Experimental) |
| `compatibility` | Cross-agent note (Cursor, Cline, etc.), ≤500 chars — spec cap |
| `disable-model-invocation: true` | Slash-only; must not auto-trigger |
| `user-invocable: false` | Callable only by subagents or other skills |
| `model` | The skill needs a specific tier. Otherwise inherit — a pin outlives the model it names. |
| `effort` | Overrides the session level while the skill runs — verified live 2026-09-02 with `${CLAUDE_EFFORT}` (control `high`, skill with `effort: low` reported `low`). Per-type defaults are in SKILL.md Phase 3. Level names don't carry across models; sweep on real tasks. Omit to inherit. |
| `paths` | Auto-trigger only inside specific repo paths |
| `when_to_use` | Extra listing-time routing text beyond the description (Claude Code; shares a combined 1,536-char listing cap with `description`) |

## Anti-patterns

- ❌ Top-level `version`, `author`, `tags`, `category` — "unexpected key" errors (anthropics/skills #37). They live under `metadata`.
- ❌ `argument-hint` nested under `metadata` — Claude Code reads it at top level.
- ❌ Unquoted `argument-hint: [a|b]` — bare brackets are a YAML **sequence**, not a string. Always quote it.
- ❌ `name` containing the reserved words `anthropic` or `claude`.
- ❌ Consecutive hyphens or uppercase in `name`.

## Portability — three tiers

| Tier | Accepts |
|---|---|
| Universal spec (agentskills.io) | `name`, `description`, `license`, `compatibility`, `allowed-tools`, `metadata` |
| Claude Code runtime | The above plus `argument-hint`, `when_to_use`, `hooks`, `paths`, `arguments`, `disable-model-invocation`, `user-invocable`, `model`, `effort`, `context`, `agent`, `shell`, `disallowed-tools` |
| Anthropic repo packaging validator (`quick_validate.py`) | Spec set only — rejects every Claude Code extension key |

The Vercel `npx skills add` channel tolerates the extensions (verified 2026-07-02), so keep them unless the skill targets submission to anthropics/skills. Lint against the spec with `skills-ref validate <skill-dir>` (agentskills/agentskills); vercel-labs/skills ships no validation command.
