# Agent Workflow Guide for SkillBox

This file provides guidance on how to work effectively as an AI agent within the SkillBox project. It complements CLAUDE.md with workflow patterns and agent-specific best practices.

## Skill Inventory

SkillBox currently contains **10 skills**:

| Skill | Version | Pattern | Description |
|-------|---------|---------|-------------|
| **track-session** | v3.3.2 | A (Methodology) | Track, stop, resume, and verify progress on long-running sessions |
| **git-worktree** | v2.0.2 | B (Technical) | Manage multiple branches simultaneously using git worktrees |
| **generate-skill** | v1.2.1 | D (Automation) | Interactive skill builder that generates high-quality SKILL.md files |
| **ideal-react-component** | v1.3.0 | E (Reference) | Battle-tested React component structure pattern with hooks antipatterns |
| **rate-skill** | v1.0.2 | C (Auditing) | Evaluate skill quality against best practices with letter grades (A-F) |
| **setup-semantic-release** | v1.0.0 | D (Automation) | Set up automated versioning with conventional commits, husky, and semantic-release |
| **track-roadmap** | v1.1.0 | A (Methodology) | Plan, update, audit, and resume work from a high-level project roadmap |
| **record-tui** | v1.1.1 | B (Technical) | Record polished terminal demos using Charmbracelet VHS |
| **screenshot-local** | v1.0.0 | B (Technical) | Capture screenshots of local dev projects using shot-scraper |
| **remember** | v1.0.0 | B (Technical) | Rebuild context from previous Claude Code sessions |

## Core Agent Principles

### 1. Imperative Direct Language

Use short, clear, imperative sentences. Agents work best with direct commands.

**DO:**
```
Read the skill file.
Check the frontmatter.
Verify triggers are specific.
```

**DO NOT:**
```
You might want to consider reading the skill file, and then perhaps
checking if the frontmatter looks correct.
```

### 2. Repetition for Reinforcement

Repeat critical information liberally. Agents benefit from seeing important rules multiple times in different contexts.

**Example:**
- Description MUST have 3-5 triggers (stated in standards)
- Description MUST have 3-5 triggers (stated in validation)
- Description MUST have 3-5 triggers (stated in troubleshooting)

### 3. Text-Based Diagrams

Use ASCII diagrams and structured text instead of abstract descriptions.

**Good:**
```
Phase 1 -> Phase 2 -> Phase 3
   |          |          |
 Check     Verify    Complete
```

**Also Good:**
```
skill-name/
├── SKILL.md
├── reference/
│   └── STANDARDS.md
└── scripts/
    └── setup.sh
```

### 4. Explicit "Do Not Do" Lists

List forbidden actions explicitly with literal language.

**DO NOT:**
- Skip examples sections
- Write vague descriptions
- Create skills over 500 lines without progressive disclosure
- Modify skills without reading them first
- Change skill names

## Agent Workflows for SkillBox

### Workflow: Creating a New Skill

**Phase 1: Discovery**

**You MUST complete these before proceeding:**
- [ ] Read 2-3 existing skills to understand patterns
- [ ] Use `/generate-skill` or follow generate-skill SKILL.md process
- [ ] Gather: skill purpose, triggers, type, enforcement level
- [ ] Determine which pattern to follow (A/B/C/D/E)

**Phase 2: Generation**

**You MUST include all of these:**
- [ ] Valid YAML frontmatter with 3-5 trigger phrases
- [ ] Overview with core principle
- [ ] "When to Use" section
- [ ] Main content matching selected pattern
- [ ] Examples with Good/Bad comparisons
- [ ] Troubleshooting section
- [ ] Integration section

**Phase 3: Validation**

**You MUST verify:**
- [ ] SKILL.md under 500 lines (or uses progressive disclosure)
- [ ] Description has specific triggers, not vague statements
- [ ] All required sections present
- [ ] Code blocks specify language
- [ ] Markdown formatting correct

**Phase 4: Testing**

**You MUST test:**
- [ ] Try each trigger phrase from description
- [ ] Verify skill activates reliably
- [ ] Check for conflicts with existing skills
- [ ] Confirm examples are clear

**Cannot check all boxes? Do not proceed. Return to failed phase.**

### Workflow: Updating an Existing Skill

**Phase 1: Understanding**

**Before making ANY changes:**
- [ ] Read the entire SKILL.md file
- [ ] Identify the pattern type (A/B/C/D/E)
- [ ] Note all existing sections
- [ ] Check current version number
- [ ] Understand integration points

**Phase 2: Modification**

**You MUST preserve:**
- [ ] All existing sections (unless explicitly removing)
- [ ] YAML frontmatter structure
- [ ] Skill name (never change)
- [ ] Pattern type consistency
- [ ] Example format (`<Good>` and `<Bad>` tags)

**You MUST update:**
- [ ] Version number (increment appropriately)
- [ ] Last updated date (if present)
- [ ] Affected sections only

**Phase 3: Verification**

**After changes, verify:**
- [ ] No sections accidentally removed
- [ ] Markdown formatting still valid
- [ ] Triggers still specific
- [ ] Examples still present
- [ ] Troubleshooting still comprehensive

**Phase 4: Testing**

**Before marking complete:**
- [ ] Test activation with trigger phrases
- [ ] Verify no regressions
- [ ] Check integration points still valid

### Workflow: Debugging Skill Activation

**Phase 1: Investigation**

**Check these in order:**
1. [ ] Read SKILL.md description field
2. [ ] Verify YAML frontmatter is valid (no syntax errors)
3. [ ] Check if triggers are specific vs. vague
4. [ ] Test with exact phrases from description
5. [ ] Look for conflicting skills with similar triggers

**Phase 2: Diagnosis**

**Common causes:**

| Symptom | Cause | Fix |
|---------|-------|-----|
| Never activates | Vague description | Add 3-5 specific trigger phrases |
| Activates wrong skill | Overlapping triggers | Make triggers more specific |
| Intermittent activation | Inconsistent phrasing | Add trigger variations |
| YAML error on load | Invalid frontmatter | Validate YAML syntax |

**Phase 3: Resolution**

**Apply fixes:**
1. [ ] Edit description field with specific triggers
2. [ ] Include user's natural language
3. [ ] Add multiple phrasings of same intent
4. [ ] Test each trigger phrase individually
5. [ ] Verify no conflicts with other skills

**Phase 4: Validation**

**Confirm fix works:**
- [ ] Try all trigger phrases
- [ ] Test in different contexts
- [ ] Verify no side effects
- [ ] Document changes in version notes

## Pattern Recognition

SkillBox skills follow five recognized patterns. Each pattern has specific structural characteristics and real examples in the current skill set.

### Pattern A: Methodology Enforcement

**You will recognize this pattern by:**
- Phase-based workflow with strict completion gates
- Verification checklists with `[ ]`
- "Rules" or "Iron Laws" section
- "Red Flags - STOP" section (in some)
- Mode-based operation (e.g., generate/update/audit)

**When you see this pattern:**
- DO enforce strict phase completion
- DO include verification checkboxes
- DO add "Red Flags" for common mistakes
- DO use "YOU MUST" language

**Real examples in SkillBox:**
- **track-session** - Phases: checkpoint, save, resume, verify. Rules like "Never repeat failures" and "Verify before declaring done." Verification checklists at every step.
- **track-roadmap** - Modes: generate, update, audit, resume. Rules like "User drives the roadmap" and "Keep it high-level." Phase-gated discovery process before writing.

**Structural signature from track-session:**
```markdown
## Rules

1. **Never repeat failures** - Log every failed approach with reason
2. **Resume from checkpoint** - Check for existing SESSION_PROGRESS.md
3. **Keep current** - File should always reflect actual state
4. **Verify before declaring done** - Always run verify before claiming complete
```

### Pattern B: Technical Implementation

**You will recognize this pattern by:**
- Step-by-step instructions with bash commands
- Configuration examples and file templates
- "Quick Start" or "The Process" section
- Troubleshooting with Problem/Solution format

**When you see this pattern:**
- DO include executable code examples
- DO show full command sequences
- DO provide multiple approaches
- DO include verification steps

**Real examples in SkillBox:**
- **git-worktree** - Step-by-step worktree creation, branch management, and cleanup commands.
- **record-tui** - VHS tape file syntax, recording commands, CI integration for automated demos.
- **screenshot-local** - shot-scraper setup, single/batch capture commands, YAML config templates.
- **remember** - Phase-based source gathering (conversations, git, SESSION_PROGRESS) with concrete commands.

**Structural signature from git-worktree:**
```markdown
## Quick Start

**Create a worktree:**
```bash
git worktree add ../project-feature feature-branch
cd ../project-feature
```

**List worktrees:**
```bash
git worktree list
```
```

### Pattern C: Rule-Based Auditing

**You will recognize this pattern by:**
- Rule categories with severity levels (CRITICAL, HIGH, MEDIUM)
- Weighted scoring criteria
- Standardized output format (letter grades, tables)
- "Quick Reference" section

**When you see this pattern:**
- DO organize by severity
- DO provide clear scoring criteria
- DO show impact and fix for each finding
- DO include quick reference

**Real example in SkillBox:**
- **rate-skill** - Seven weighted categories (Length 20%, Conciseness 20%, Repetitiveness 15%, Structure 15%, Triggers 15%, Examples 10%, Troubleshooting 5%). Letter grades A-F with score ranges. Structured output: Summary, Category Scores, Findings by Priority, Strengths, Action Items.

**Structural signature from rate-skill:**
```markdown
## Quality Criteria

| Category | Weight | Criteria |
|----------|--------|----------|
| Length | 20% | Under 500 lines (or progressive disclosure) |
| Conciseness | 20% | Clear, scannable, no fluff |
| Triggers | 15% | 3-5+ specific activation phrases |

## Grading Scale

| Grade | Score | Meaning |
|-------|-------|---------|
| A | 90-100 | Excellent - Production ready |
| B | 80-89 | Good - Minor improvements recommended |
| D-F | 0-69 | Not Ready |
```

### Pattern D: Automation/Integration

**You will recognize this pattern by:**
- Configuration templates and file creation
- Multi-phase setup workflow
- Auto-detection logic or tool installation
- Integration with external tools and services
- Helper scripts or generated config files

**When you see this pattern:**
- DO implement step-by-step setup phases
- DO provide complete config file templates
- DO include verification at each phase
- DO handle errors gracefully

**Real examples in SkillBox:**
- **setup-semantic-release** - 8-phase setup: install deps, configure commitlint, configure semantic-release, init husky, add hooks, add prepare script, create changelog, set up CI. Provides complete config file templates for `commitlint.config.js`, `.releaserc.json`, `.github/workflows/release.yml`.
- **generate-skill** - Multi-phase discovery and generation: ask questions, select pattern, generate SKILL.md, enhance, finalize. Produces a complete skill file from interactive inputs.

**Structural signature from setup-semantic-release:**
```markdown
### Phase 1: Install Dependencies

```bash
npm install --save-dev \
  @commitlint/cli@^19.0.0 \
  semantic-release@^24.0.0 \
  husky@^9.0.0
```

**Verification:**
- [ ] All packages appear in `devDependencies`
- [ ] No install errors

### Phase 2: Configure Commitlint

Create `commitlint.config.js` in the project root:
[complete config template]
```

### Pattern E: Reference/Knowledge

**You will recognize this pattern by:**
- "Core Concepts" or "Patterns Library" section
- Multiple code examples showing structural patterns
- "Best Practices" guidelines
- "When NOT to Use" section
- Anti-pattern documentation

**When you see this pattern:**
- DO provide extensive examples
- DO explain concepts clearly
- DO show anti-patterns
- DO reference official docs

**Real example in SkillBox:**
- **ideal-react-component** - Defines a predictable ordering pattern for React component files (imports, styles, types, sub-components, hooks, render). Includes hooks antipatterns (infinite loops, stale closures) with Good/Bad comparisons.

**Structural signature from ideal-react-component:**
```markdown
## Component Structure Order

1. Imports (external, then internal)
2. Styled components / CSS modules
3. Types and interfaces
4. Sub-components
5. Custom hooks
6. Main component (props -> state -> effects -> handlers -> render)
7. Exports
```

## Agent Communication Templates

### When Creating a Skill

```
I'm creating a new skill called [name] for [purpose].

Phase 1: Discovery
- Skill type: [Methodology/Technical/Auditing/Automation/Reference]
- Triggers: [list 3-5 specific phrases]
- Pattern: [A/B/C/D/E]
- Enforcement: [Strict/Guided/Flexible/Reference]

Phase 2: Generation
[Generate SKILL.md with all required sections]

Phase 3: Validation
- Description: [specific] / [vague]
- Examples: [present] / [missing]
- Troubleshooting: [comprehensive] / [missing]
- Length: [under 500 lines] / [needs progressive disclosure]

Phase 4: Testing
- Tested triggers: [list results]
- Conflicts: [none] / [found]

Ready for review.
```

### When Updating a Skill

```
Updating skill: [name] from v[old] to v[new]

Phase 1: Understanding
- Read complete
- Pattern identified: [A/B/C/D/E]
- Current sections: [list]

Phase 2: Modification
Changes:
- [section]: [description of change]
- Version: [old] -> [new]

Preserved:
- All existing sections
- Skill name unchanged
- Pattern consistency

Phase 3: Verification
- No accidental deletions
- Markdown valid
- Triggers still specific

Phase 4: Testing
- Activation test: [result]
- No regressions

Update complete.
```

### When Debugging Activation

```
Debugging skill activation: [name]

Phase 1: Investigation
- Description field: [specific] / [vague]
- YAML valid: [yes] / [no]
- Trigger count: [N]
- Conflicts: [none] / [found with: X]

Phase 2: Diagnosis
Issue: [description]
Cause: [root cause]

Phase 3: Resolution
Applied fix: [description]
New triggers: [list]

Phase 4: Validation
- Tested all triggers
- No conflicts
- Works as expected

Fix verified.
```

## Red Flags for Agents

If you catch yourself:

- **Generating skill without reading existing examples** - Learn patterns first
- **Writing abstract descriptions instead of specific triggers** - Be concrete
- **Skipping validation checklists** - Complete all phases
- **Making changes without reading full file** - Understand first
- **Using casual language instead of imperative** - Be direct
- **Creating vague examples** - Show Good/Bad clearly
- **Skipping troubleshooting sections** - Users will have issues
- **Not testing trigger phrases** - Activation is critical

**ALL of these mean: STOP. Review this AGENTS.md.**

## Verification Checklist Template

Copy this checklist when working on skills:

```markdown
## Skill Work Verification

### Discovery (if new skill)
- [ ] Read 2-3 existing skills for patterns
- [ ] Identified skill type and pattern
- [ ] Gathered all requirements
- [ ] Selected appropriate template

### Content
- [ ] Valid YAML frontmatter
- [ ] Description has 3-5 specific triggers
- [ ] Overview with core principle
- [ ] "When to Use" section complete
- [ ] Main content matches pattern
- [ ] Examples with Good/Bad comparisons
- [ ] Troubleshooting section present
- [ ] Integration section documented

### Structure
- [ ] SKILL.md under 500 lines
- [ ] Progressive disclosure if needed
- [ ] All sections present
- [ ] Markdown formatting correct
- [ ] Code blocks specify language

### Quality
- [ ] Imperative direct language
- [ ] Short clear sentences
- [ ] Specific not vague
- [ ] Verification checklists (if methodology)
- [ ] Red Flags (if methodology)

### Testing
- [ ] Tested each trigger phrase
- [ ] Verified activation works
- [ ] Checked for conflicts
- [ ] No regressions

### Metadata
- [ ] Version number updated
- [ ] Author specified
- [ ] License included
- [ ] Tags relevant

Can't check all boxes? Return to failed phase.
```

## Agent Integration with SkillBox Skills

### Using track-session as an Agent

When working on complex SkillBox tasks:

1. Create SESSION_PROGRESS.md at project root
2. Plan phases in the file
3. Update after each major step
4. Mark completed items with `[x]`
5. Log failed approaches to avoid repetition

**Template:**
```markdown
# Session Progress

## Plan
- [ ] Create new skill "skill-name" [dependency: none]
- [ ] Write SKILL.md with all sections [dependency: Create]
- [ ] Validate against checklist [dependency: Write]
- [ ] Test activation triggers [dependency: Validate]

## Current Status
Last updated: 2026-03-09 14:30
Working on: Writing SKILL.md
Next: Validate against checklist

## Completed Work
- 2026-03-09 14:15: Created skill directory structure
- 2026-03-09 14:20: Generated YAML frontmatter
```

### Using remember as an Agent

When starting a new SkillBox session:

1. Check for SESSION_PROGRESS.md first
2. Scan recent git log for skill changes
3. Read auto-memory for project context
4. Present structured summary of recent work
5. Offer to continue active work or pick a new task

### Using generate-skill as an Agent

When asked to create a new skill:

1. DO follow generate-skill's phase-based process
2. DO ask discovery questions first
3. DO select appropriate pattern
4. DO generate complete SKILL.md
5. DO validate against all checklists

**Follow the process:**
```
Phase 1: Discovery (ask questions)
Phase 2: Pattern Selection (A/B/C/D/E)
Phase 3: Content Generation (write SKILL.md)
Phase 4: Enhancement (add complexity if needed)
Phase 5: Scripts (if automation needed)
Phase 6: Finalization (validate and present)
```

## References

**Based on:**
- [Claude Code Best Practices](https://antjanus.com/ai/claude-code-best-practices)
- [Agent Skills Specification](https://agentskills.io/specification)
- [Anthropic Skills Patterns](https://github.com/anthropics/skills)

**Philosophy:**
- Imperative direct language for agents
- Repetition for reinforcement
- Text-based diagrams
- Explicit "Do Not Do" lists
- Verification at every phase

**Last Updated:** 2026-03-09
**Applies To:** AI agents working with SkillBox
**Companion To:** CLAUDE.md (project-specific guidance)
