# generate-skill — Sources

Load only when a user disputes a rule and you need to cite the spec.

## Official skill-authoring spec

- agentskills.io spec: https://agentskills.io/specification
- Description-optimization loop (eval sets, trigger rates, splits): https://agentskills.io/skill-creation/optimizing-descriptions.md
- Output-quality eval loop (with/without baselines): https://agentskills.io/skill-creation/evaluating-skills.md
- Authoring best practices (instruction patterns, calibrating control): https://agentskills.io/skill-creation/best-practices.md
- Claude Code skills docs: https://code.claude.com/docs/en/skills
- Anthropic skill-creator: https://github.com/anthropics/skills/blob/main/skills/skill-creator/SKILL.md
- skill-creator eval announcement (2026-03-03): https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills

## Platform prompting guides

Source of the Phase 4 "agentic calibration" rules and the Phase 2 intensity-escalation anti-pattern.

- Prompting Claude Opus 5 — over-verification, written-deliverable length, subagent caps, scope creep, thinking-disabled tag leakage: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5
- Prompting best practices, all current models — positive-directive framing, example count and diversity, XML structuring, dialing back aggressive language: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
- Prompting Claude Fable 5 — prescriptiveness, `reasoning_extraction` refusal category: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5
- Prompting Claude Fable 5.1 — narration suppressors, anti-formatting rules, non-blocking delegation, scope and test coverage, effort as the primary control: https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-fable-5-1. The keep-verification-instructions guidance is in the migration section of the claude-api skill bundled with Claude Code 2.1.258 (`shared/model-migration.md`, "Migrating to Claude Fable 5.1 from Claude Fable 5"), marked tentative there.
- Claude Code skill frontmatter reference (`effort`, `model`, `context`, `${CLAUDE_EFFORT}`): https://code.claude.com/docs/en/skills

## Empirical

- Description activation study (Seleznov n=650): https://medium.com/@ivan.seleznov1/why-claude-code-skills-dont-activate-and-how-to-fix-it-86f679409af1
- Skill listing budget: https://claudefa.st/blog/guide/mechanics/skill-listing-budget
- ETH Zurich AGENTS.md study (context files cost >20% inference with no task-success gain): https://arxiv.org/abs/2602.11988
- SkillsBench (focused skills of ≤3 modules outperform larger bundles): https://arxiv.org/abs/2602.12670
- Negation handling: https://arxiv.org/abs/2503.22395
- anthropics/skills #37 (unsupported frontmatter fields): https://github.com/anthropics/skills/issues/37
