<div align="center">
  <img src="./logo.png" alt="SkillBox Logo" width="200" />
</div>

# SkillBox

A curated collection of utility skills for Claude Code and AI agents. SkillBox provides reusable, battle-tested skills that enhance agent capabilities for common development workflows.

**Compatible with:** Claude Code, Cursor, Cline, GitHub Copilot, and 40+ other AI agents via [Vercel Skills](https://skills.sh)

**Install with:** `npx skills add antjanus/skillbox`

## What are Skills?

Skills are specialized instructions that teach Claude Code how to handle specific tasks or workflows. They activate automatically when relevant or can be invoked explicitly using `/skill-name`. Skills help enforce best practices, automate complex workflows, and provide consistent approaches to common development challenges.

## Available Skills

### 🔄 track-session

Track, stop, resume, and save progress on long-running development sessions.

**Use when:**
- Working on multi-step implementations
- Planning complex features
- Need to pause and resume work
- Want checkpoint-based recovery

**Triggers:** Automatically activates on long-running collaborative work

[View Documentation](./skills/track-session/SKILL.md)

---

### 🌳 git-worktree

Manage multiple branches simultaneously using git worktrees for parallel Claude Code development.

**Use when:**
- Working on multiple features in parallel
- Emergency hotfix needed during feature work
- Reviewing PRs without switching branches
- Running parallel Claude Code sessions

**Triggers:** When asked to work on parallel branches, emergency fixes, or PR reviews

[View Documentation](./skills/git-worktree/SKILL.md)

---

### ⚙️ generate-skill

Interactive skill builder that generates high-quality SKILL.md files using proven patterns.

**Use when:**
- Asked to "create a skill"
- Need to capture team workflows
- Want to extend Claude Code capabilities
- Building custom development methodologies

**Triggers:** When asked to "create a skill", "generate a SKILL.md", "make me a skill"

[View Documentation](./skills/generate-skill/SKILL.md)

---

### ⚛️ ideal-react-component

Battle-tested React component structure pattern for building maintainable, consistent components.

**Use when:**
- Creating new React components
- Refactoring existing components
- Debugging React hooks issues
- Reviewing component structure
- Organizing component code

**Triggers:** When asked to "create a React component", "structure this component", "review component structure", "refactor this component", "fix infinite loop", "useEffect not working"

[View Documentation](./skills/ideal-react-component/SKILL.md)

---

### 📊 rate-skill

Evaluate skill quality against best practices with letter grades (A-F) and actionable recommendations.

**Use when:**
- Reviewing skills before publishing
- Validating skill structure and formatting
- Checking if skill meets quality standards
- Auditing skill repositories

**Triggers:** When asked to "rate this skill", "review skill quality", "check skill formatting", "evaluate SKILL.md", "grade this skill"

[View Documentation](./skills/rate-skill/SKILL.md)

---

### 🗺️ track-roadmap

Plan, update, and audit a high-level project roadmap with interactive feature discovery.

**Use when:**
- Starting a new project and need to map out features
- Want to review what's been built vs. what's planned
- Need to audit and reprioritize the roadmap
- Capturing feature ideas before they're lost

**Triggers:** When asked to "create a roadmap", "plan features", "what should we build next", "update the roadmap", "audit the roadmap"

[View Documentation](./skills/track-roadmap/SKILL.md)

---

### 📦 setup-semantic-release

Set up a fully automated versioning and release pipeline using conventional commits, commitlint, husky, and semantic-release.

**Use when:**
- Setting up automated versioning for a new project
- Adding conventional commits to an existing repo
- Migrating from manual versioning to automated releases
- Need commitlint, husky hooks, and CI/CD release workflow

**Triggers:** When asked to "set up semantic release", "add conventional commits", "configure automated versioning", "set up commitlint", "add husky hooks"

[View Documentation](./skills/setup-semantic-release/SKILL.md)

---

## Installation

### Using Vercel Skills CLI (Recommended)

The easiest way to install SkillBox skills using the [Vercel Skills](https://skills.sh) ecosystem:

```bash
# Install all skills
npx skills add antjanus/skillbox

# Install specific skills
npx skills add antjanus/skillbox@track-session
npx skills add antjanus/skillbox@git-worktree
npx skills add antjanus/skillbox@ideal-react-component

# Install globally (available in all projects)
npx skills add antjanus/skillbox -g

# List installed skills
npx skills list

# Check for updates
npx skills check
```

The skills CLI automatically detects your agent (Claude Code, Cursor, Cline, etc.) and installs skills to the correct location.

### Alternative Installation Methods

<details>
<summary>Manual Global Installation</summary>

```bash
# Clone the repository
git clone https://github.com/antjanus/skillbox.git ~/.claude/skillbox

# Symlink skills to Claude Code's global skills directory
mkdir -p ~/.claude/skills
ln -s ~/.claude/skillbox/skills/* ~/.claude/skills/
```
</details>

<details>
<summary>Project-Specific Installation</summary>

```bash
# Add as git submodule
git submodule add https://github.com/antjanus/skillbox.git .claude/skillbox

# Or clone directly
git clone https://github.com/antjanus/skillbox.git .claude/skillbox

# Symlink desired skills
mkdir -p .claude/skills
ln -s ../.claude/skillbox/skills/track-session .claude/skills/track-session
ln -s ../.claude/skillbox/skills/git-worktree .claude/skills/git-worktree
```
</details>

<details>
<summary>Individual Skill Installation (curl)</summary>

```bash
# Copy specific skill to your project
mkdir -p .claude/skills/track-session
curl -o .claude/skills/track-session/SKILL.md \
  https://raw.githubusercontent.com/antjanus/skillbox/main/skills/track-session/SKILL.md
```
</details>

## Usage

### Automatic Activation

Skills activate automatically when Claude detects relevant triggers:

```
user: I need to work on multiple features at the same time
assistant: [Automatically activates git-worktree skill]
```

### Explicit Invocation

Call skills directly using slash commands:

```
user: /git-worktree feature-auth main
user: /track-session
user: /generate-skill database-migration
```

### Session-Specific Skills

Load skills for the current session only:

```
user: Load the track-session skill for this session
```

## Creating Custom Skills

Use the `generate-skill` skill to create your own:

```
user: /generate-skill my-workflow
```

Or use the Vercel Skills CLI to scaffold a new skill:

```bash
npx skills init my-workflow
```

Manually create following the [skill specification](https://agentskills.io/specification).

## Skill Structure

Each skill follows this standard structure:

```
skill-name/
├── SKILL.md              # Core skill documentation
├── reference/            # Optional: Extended documentation
│   ├── STANDARDS.md      # Detailed rules
│   └── EXAMPLES.md       # Code examples
├── scripts/              # Optional: Automation scripts
│   ├── setup.sh
│   └── execute.sh
└── lib/                  # Optional: Helper libraries
    └── helpers.js
```

## Contributing

We welcome contributions! Here's how:

1. **Propose a New Skill**: Open an issue describing the workflow or problem
2. **Fork & Create**: Use `/generate-skill` to scaffold your skill
3. **Test Thoroughly**: Ensure activation triggers work correctly
4. **Document Well**: Follow existing skill documentation patterns
5. **Submit PR**: Include examples and use cases

### Skill Quality Standards

- **Trigger-rich descriptions**: Include 3-5 specific activation phrases
- **Clear examples**: Show good/bad code comparisons
- **Troubleshooting**: Address common issues
- **Progressive disclosure**: Keep SKILL.md under 500 lines, use reference/ for extensive content
- **Verification checklists**: For methodology enforcement skills

See [generate-skill documentation](./skills/generate-skill/SKILL.md) for detailed guidelines.

## Best Practices

### For Skill Users

1. **Trust the activation**: Skills activate when needed - no need to force them
2. **Use explicit invocation for clarity**: `/skill-name` when you want specific behavior
3. **Read the documentation**: Each skill has comprehensive usage examples
4. **Combine skills**: Many skills work well together (e.g., git-worktree + track-session)

### For Skill Creators

1. **Clear triggers**: Write specific, recognizable activation phrases
2. **Enforce when needed**: Use "Iron Laws" for critical workflows
3. **Guide by default**: Provide recommendations, not just rules
4. **Test activation**: Ensure your skill triggers reliably
5. **Version properly**: Use semantic versioning in metadata

## Philosophy

SkillBox skills follow these principles:

- **Activation over configuration**: Skills should activate when relevant
- **Enforcement over suggestion**: Critical workflows get mandatory phases
- **Examples over explanation**: Show, don't just tell
- **Progressive disclosure**: Start simple, reveal complexity when needed
- **Human and AI friendly**: Documentation that works for both

## Resources

- **Skills Directory**: https://skills.sh (discover and track SkillBox installations)
- **Vercel Skills CLI**: https://github.com/vercel-labs/skills (official CLI tool)
- **Claude Code Documentation**: https://code.claude.com/docs/
- **Skill Specification**: https://agentskills.io/specification
- **Best Practices Article**: https://antjanus.com/ai/claude-code-best-practices
- **CLAUDE.md Guide**: See [CLAUDE.md](./CLAUDE.md) in this repository
- **Agent Patterns**: See [AGENTS.md](./AGENTS.md) in this repository

## License

MIT License - see individual skills for specific licensing

## Acknowledgments

- Inspired by [obra/superpowers](https://github.com/obra/superpowers)
- Built on patterns from [Anthropic Skills](https://github.com/anthropics/skills)
- Follows [Vercel's agent patterns](https://github.com/vercel-labs/agent-skills)

---

**Skill Count**: 7 | **Made for**: Claude Code 2025+
