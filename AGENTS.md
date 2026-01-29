# Agent Workflow Guide for SkillBox

This file provides guidance on how to work effectively as an AI agent within the SkillBox project. It complements CLAUDE.md with workflow patterns and agent-specific best practices.

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
You might want to consider reading the skill file, and then perhaps checking if the frontmatter looks correct, and maybe verifying whether the triggers seem specific enough.
```

### 2. Repetition for Reinforcement

Repeat critical information liberally. Agents benefit from seeing important rules multiple times in different contexts.

**Example:**
- Description MUST have 3-5 triggers (stated in standards)
- Description MUST have 3-5 triggers (stated in validation)
- Description MUST have 3-5 triggers (stated in troubleshooting)
- Description MUST have 3-5 triggers (stated in checklist)

### 3. Text-Based Diagrams

Use ASCII diagrams and structured text instead of abstract descriptions.

**Good:**
```
Phase 1 → Phase 2 → Phase 3
   ↓         ↓         ↓
 Check    Verify   Complete
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

### Pattern A: Methodology Enforcement

**You will recognize this pattern by:**
- "The Iron Law" section
- Phase-based workflow
- Verification checklists with `[ ]`
- "Red Flags - STOP" section
- "Common Rationalizations" table

**When you see this pattern:**
- DO enforce strict phase completion
- DO include verification checkboxes
- DO add "Red Flags" for common mistakes
- DO use "YOU MUST" language

**Examples in SkillBox:**
- None currently (but generate-skill can create them)

### Pattern B: Technical Implementation

**You will recognize this pattern by:**
- "Quick Start" or "The Process" section
- Step-by-step instructions
- Bash commands with examples
- Configuration options
- Troubleshooting with Problem/Solution format

**When you see this pattern:**
- DO include executable code examples
- DO show full command sequences
- DO provide multiple approaches
- DO include verification steps

**Examples in SkillBox:**
- git-worktree (parallel development)

### Pattern C: Rule-Based Auditing

**You will recognize this pattern by:**
- Rule categories (CRITICAL, HIGH, MEDIUM)
- Priority tables
- "Quick Reference" section
- Standardized output format
- Rule IDs (e.g., `rule-id-1`)

**When you see this pattern:**
- DO organize by severity
- DO provide rule IDs
- DO show impact and fix
- DO include quick reference

**Examples in SkillBox:**
- None currently (but generate-skill can create them)

### Pattern D: Automation/Integration

**You will recognize this pattern by:**
- "Critical Workflow" section
- Auto-detection logic
- Helper functions or scripts
- Configuration templates
- Integration with external tools

**When you see this pattern:**
- DO implement auto-detection
- DO provide scripts in `scripts/`
- DO include helper libraries
- DO handle errors gracefully

**Examples in SkillBox:**
- None currently (but generate-skill can create them)

### Pattern E: Reference/Knowledge

**You will recognize this pattern by:**
- "Patterns Library" section
- "Core Concepts" explanations
- Multiple code examples
- "Best Practices" guidelines
- "When NOT to Use" section

**When you see this pattern:**
- DO provide extensive examples
- DO explain concepts clearly
- DO show anti-patterns
- DO reference official docs

**Examples in SkillBox:**
- Aspects of save-session (progress tracking patterns)

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
- Description: [specific] ✓ / [vague] ✗
- Examples: [present] ✓ / [missing] ✗
- Troubleshooting: [comprehensive] ✓ / [missing] ✗
- Length: [under 500 lines] ✓ / [needs progressive disclosure] ✗

Phase 4: Testing
- Tested triggers: [list results]
- Conflicts: [none] ✓ / [found] ✗

Ready for review.
```

### When Updating a Skill

```
Updating skill: [name] from v[old] to v[new]

Phase 1: Understanding
- Read complete: ✓
- Pattern identified: [A/B/C/D/E]
- Current sections: [list]

Phase 2: Modification
Changes:
- [section]: [description of change]
- Version: [old] → [new]

Preserved:
- All existing sections ✓
- Skill name unchanged ✓
- Pattern consistency ✓

Phase 3: Verification
- No accidental deletions ✓
- Markdown valid ✓
- Triggers still specific ✓

Phase 4: Testing
- Activation test: [result]
- No regressions: ✓

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
- Tested all triggers: ✓
- No conflicts: ✓
- Works as expected: ✓

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

### Using save-session as an Agent

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
Last updated: 2025-01-29 14:30
Working on: Writing SKILL.md
Next: Validate against checklist

## Completed Work
- 2025-01-29 14:15: Created skill directory structure
- 2025-01-29 14:20: Generated YAML frontmatter
```

### Using git-worktree as an Agent

When asked to work on SkillBox in parallel:

1. DO NOT actually create worktrees (no code to run)
2. DO explain how worktrees would help
3. DO document multiple skills in parallel
4. DO track which "branch" (context) is which skill

**Example:**
```
user: Work on two skills at once - save-session improvements and a new testing skill

A: I can work on both skills by tracking them separately:

Context A (save-session improvements):
- Reading current save-session/SKILL.md
- Planning updates to progress tracking

Context B (new testing skill):
- Using generate-skill pattern
- Creating testing-workflow/SKILL.md

I'll maintain separate progress for each and avoid mixing contexts.
```

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

**Last Updated:** 2025-01-29
**Applies To:** AI agents working with SkillBox
**Companion To:** CLAUDE.md (project-specific guidance)
