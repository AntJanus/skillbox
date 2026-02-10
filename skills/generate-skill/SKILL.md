---
name: generate-skill
description: Use when asked to "create a skill", "generate a SKILL.md", "make me a skill", "build a custom skill", or when user wants to extend Claude Code capabilities with a new skill
license: MIT
metadata:
  author: Antonin Januska
  version: "1.2.0"
  argument-hint: [skill-topic]
tags: [skill-creation, meta, automation, documentation]
---

# Generate Skill - Interactive Skill Builder

## Overview

This skill guides users through creating high-quality Claude Code skills using proven patterns from top community skills (obra/superpowers, Anthropic, Vercel). It asks targeted questions to understand requirements, then generates a complete SKILL.md file with appropriate structure, documentation, and best practices.

**Core principle:** Generate skills that activate reliably, enforce processes effectively, and consume context efficiently.

## When to Use

**Always use when user asks to:**
- "Create a skill for [topic]"
- "Generate a SKILL.md for [workflow]"
- "Build me a skill that does [task]"
- "Help me make a custom skill"
- "Turn these instructions into a skill"

**Useful for:**
- Capturing team workflows as reusable skills
- Documenting methodology enforcement (TDD, debugging, code review)
- Creating automation skills (deployment, testing, setup)
- Building domain-specific guidance (architecture, security, performance)

**Avoid when:**
- User just wants general help (not skill creation)
- Requirement is too vague to create useful skill
- Task is better solved with existing skills

## The Skill Generation Process

### Phase 1: Discovery - Understanding Requirements

**You MUST gather this information through AskUserQuestion:**

1. **Skill purpose and triggers**
   - What should this skill help with?
   - When should Claude activate it?
   - What user phrases should trigger it?

2. **Skill type identification**
   - Methodology enforcement? (TDD, debugging process, code review)
   - Technical implementation? (project setup, build automation, deployment)
   - Rule-based auditing? (code quality, performance, accessibility)
   - Automation/integration? (browser testing, API calls, CI/CD)
   - Reference/knowledge? (library patterns, architecture, best practices)

3. **Content requirements**
   - Existing documentation to incorporate?
   - Specific rules or checklists?
   - Code examples needed?
   - Scripts or automation required?

4. **Enforcement level**
   - Strict methodology with "Iron Laws"?
   - Flexible guidance with recommendations?
   - Checklist-based verification?

**Ask these questions interactively:**
```markdown
Use AskUserQuestion tool with these questions:

Question 1: "What task or workflow should this skill help with?"
- Header: "Purpose"
- Options:
  1. Enforce a development methodology (TDD, debugging, code review)
  2. Automate technical tasks (setup, deployment, testing)
  3. Audit code against rules (performance, accessibility, security)
  4. Provide reference knowledge (patterns, architecture, APIs)
  5. Integrate external tools (browsers, services, CI/CD)

Question 2: "What should trigger this skill?"
- Header: "Triggers"
- Options:
  1. Specific user phrases (list them)
  2. File types or patterns (e.g., *.tsx files)
  3. Project characteristics (e.g., Next.js projects)
  4. Development phases (e.g., before implementing features)

Question 3: "How strict should enforcement be?"
- Header: "Enforcement"
- Options:
  1. Strict - Iron Laws with mandatory phases
  2. Guided - Clear recommendations with Red Flags
  3. Flexible - Best practices and suggestions
  4. Reference only - Information when needed
```

**Verification before proceeding:**
- [ ] Skill purpose clearly defined
- [ ] Activation triggers identified
- [ ] Skill type determined
- [ ] Enforcement level chosen
- [ ] User provided any existing documentation or rules

### Phase 2: Pattern Selection

**Based on skill type, select the appropriate pattern:**

| Pattern | Use When | Key Sections |
|---------|----------|--------------|
| **A: Methodology** | TDD, debugging, code review, quality gates | Phases, Iron Laws, Red Flags, Verification Checklist |
| **B: Technical** | Project setup, build automation, deployment | Quick Start, Configuration, Troubleshooting |
| **C: Auditing** | Code quality, performance, accessibility | Rule Categories, Output Format, Quick Reference |
| **D: Automation** | Browser testing, API integration, CI/CD | Auto-Detection, Configuration, Helper Functions |
| **E: Reference** | Library patterns, architecture, best practices | Core Concepts, Patterns Library, Common Mistakes |

For full pattern templates with complete structure skeletons, see **[Pattern Templates](./reference/PATTERNS.md)**.

**Verification before proceeding:**
- [ ] Pattern matches skill type
- [ ] Pattern supports enforcement level
- [ ] Pattern includes necessary sections

### Phase 3: Content Generation

**Generate SKILL.md with these 10 required components:**

#### 1. Frontmatter (CRITICAL)
```yaml
---
name: skill-name-kebab-case
description: |
  Use when [trigger phrase 1], when asked to "[user phrase]",
  or when [situation]. Include multiple trigger variations for
  better activation. Be specific about WHEN to activate.
license: MIT
metadata:
  author: [author-name]
  version: "1.0.0"
  argument-hint: <optional-args>
tags: [relevant, tags, here]
hooks:                           # Optional: automation triggers
  post_tool_use:
    - Action after Write/Edit operations
  stop:
    - Action before session ends
---
```

**Required fields:**
- `name` - kebab-case skill identifier (used in `/skill-name`)
- `description` - Trigger-rich activation text (see best practices below)

**Optional fields:**
- `license` - License type (default: MIT)
- `metadata.author` - Creator name
- `metadata.version` - Semantic version (e.g., "1.0.0")
- `metadata.argument-hint` - Hint shown for skill arguments (e.g., `<branch-name>`)
- `tags` - Array of categorization tags
- `hooks` - Automation triggers (post_tool_use, stop, etc.)

**Description field best practices:**
- Include 3-5 specific trigger phrases
- Use "when" clauses for situations
- Include user language ("when asked to 'do X'")
- Be concrete, not vague
- Avoid: "A skill for..." (too vague) or single generic descriptions

**Hooks field (advanced):**
Use hooks to automate actions at specific points:
- `post_tool_use` - Runs after Write, Edit, or other tools
- `stop` - Runs before session ends (verification, cleanup)

#### 2. Overview Section
Include 1-2 sentence description plus a **Core principle** one-liner.

#### 3. When to Use Section
Include three subsections: "Always use when" (specific triggers), "Useful for" (broader use cases), and "Avoid when" (anti-cases with alternatives).

#### 4. Main Content (Pattern-Specific)
Insert the selected pattern structure. See **[Pattern Templates](./reference/PATTERNS.md)** for full skeletons.

#### 5. Quick Reference (if applicable)
Add a summary table or command cheat sheet for fast lookup.

#### 6. Red Flags (for methodology skills)
List 3-5 warning signs that indicate the user is going off-track. End with: "ALL of these mean: STOP. Return to Phase 1."

#### 7. Examples Section
Include at least 2 Good/Bad code comparisons using `<Good>` and `<Bad>` tags. Show real-world scenarios with clear explanations.

#### 8. Troubleshooting Section
Include 3-5 common problems with structured **Problem / Cause / Solution** format.

#### 9. Integration Section
Document what the skill enables, what it pairs with, and what calls it.

#### 10. References Section
Include source links: inspiration, official docs, and community resources.

**Verification checklist:**
- [ ] All 10 components included
- [ ] Trigger-rich description field
- [ ] Clear examples with Good/Bad comparisons
- [ ] Phase-based workflow (if methodology)
- [ ] Troubleshooting section complete
- [ ] Integration points documented

### Phase 6: Finalization and Output

**Before presenting skill to user:**

1. **Run quality checklist:**
   - [ ] Description field has 3+ trigger phrases
   - [ ] Overview explains core principle clearly
   - [ ] Examples include Good/Bad comparisons
   - [ ] Troubleshooting section addresses common issues
   - [ ] Appropriate pattern for skill type
   - [ ] Under 500 lines or uses progressive disclosure
   - [ ] Integration points documented
   - [ ] References included

2. **Validate against anti-patterns:**
   - Vague description ("provides testing")
   - No examples
   - Missing troubleshooting
   - No clear triggers
   - Monolithic structure (>1000 lines without reference/)
   - No verification checklists (for methodology skills)

3. **Generate folder structure suggestion:**
```
skill-name/
├── SKILL.md              # Core skill (generated)
├── reference/            # Optional: extended docs
│   ├── STANDARDS.md
│   └── EXAMPLES.md
├── scripts/              # Optional: automation
│   ├── setup.sh
│   └── execute.sh
└── lib/                  # Optional: helpers
    └── helpers.js
```

4. **Present complete output:**
   - Write full SKILL.md content
   - Include folder structure
   - Include installation instructions
   - Include usage examples

**Final verification:**
- [ ] Complete SKILL.md generated
- [ ] Quality checklist passed
- [ ] Installation instructions provided
- [ ] Usage examples included
- [ ] No anti-patterns present

## Deep Reference

For detailed guides, load these files when needed:

- **[Pattern Templates](./reference/PATTERNS.md)** - Full structure templates for all 5 skill patterns
- **[Advanced Topics](./reference/ADVANCED.md)** - Multi-file skills, scripts, templates, integration patterns

*Only load these when specifically needed to save context.*

## Red Flags During Generation

If you catch yourself:

- **Generating without asking questions** - Need user input first!
- **Using vague description field** - Add specific triggers
- **Skipping examples section** - Always include Good/Bad examples
- **No troubleshooting** - Users will encounter issues
- **Wrong pattern for skill type** - Review pattern selection
- **Over 500 lines without progressive disclosure** - Split into reference/
- **No verification checklist for methodology skills** - Required for enforcement

**ALL of these mean: STOP. Return to appropriate phase.**

## Examples of Generated Skills

### Example 1: Methodology Skill
**User:** "Create a skill for enforcing commit message conventions"
- Pattern A (Methodology Enforcement)
- Iron Law: "No commit without following format"
- Phases: Validate, Format, Verify
- Red Flags, Verification Checklist, Good/Bad commit message examples

### Example 2: Automation Skill
**User:** "Make a skill that runs database migrations safely"
- Pattern D (Automation/Integration)
- Auto-detect: Database type, migration tool
- Workflow: Backup, Dry run, Execute, Verify
- Scripts: setup.sh, migrate.sh, rollback.sh

### Example 3: Auditing Skill
**User:** "Build a skill to check Python code for security issues"
- Pattern C (Rule-Based Auditing)
- Rule categories: CRITICAL, HIGH, MEDIUM, LOW
- Output format: `file.py:123 CRITICAL: SQL injection risk`
- Quick reference table, vulnerable-to-secure examples

## Quality Standards Checklist

Before delivering a generated skill, verify:

- [ ] Description has 3-5 trigger phrases
- [ ] Overview explains core principle (1-2 sentences)
- [ ] "When to Use" lists specific situations
- [ ] Examples show Good/Bad comparisons
- [ ] SKILL.md under 500 lines (or progressive disclosure)
- [ ] Sections in logical order with proper Markdown
- [ ] Code blocks have language specified
- [ ] Step-by-step instructions clear
- [ ] Phases have completion criteria (methodology skills)
- [ ] Red flags documented (methodology skills)
- [ ] Troubleshooting addresses real issues
- [ ] Integration points documented
- [ ] Auto-detection where possible
- [ ] Helpful error messages and clear prompts

## Troubleshooting Skill Generation

### Problem: User request is too vague

**Example:** "Make me a skill for React"

**Solution:** Use AskUserQuestion to clarify: What aspect of React? What should it enforce or guide? When should it activate? What's the primary goal?

### Problem: Skill type unclear

**Example:** "Create a skill for deployment"

**Solution:** Determine if it's Automation (Pattern D) for scripted deployment, Methodology (Pattern A) for process enforcement, or Reference (Pattern E) for best practices. Ask: "Should this automate deployment or guide the process?"

### Problem: Generated skill too long

**Cause:** Too much content in SKILL.md

**Solution:** Keep SKILL.md under 500 lines. Move extensive content to reference/. Use progressive disclosure pattern. Link to reference files with clear descriptions.

### Problem: Description doesn't trigger activation

**Cause:** Description too generic

**Solution:** Include specific phrases users actually say. Bad: "A skill for testing". Good: "Use when writing tests, implementing TDD, creating test suites, or when asked to 'test my code' or 'add test coverage'"

### Problem: No clear examples

**Cause:** Skill too abstract

**Solution:** Always include at least 2 Good/Bad code comparisons, real-world scenarios, before/after examples, and common use cases.

## Meta: This Skill's Structure

This skill itself follows Pattern B (Technical Implementation):
- **Phase 1:** Discovery (questions to user)
- **Phase 2:** Pattern Selection (match type to structure)
- **Phase 3:** Content Generation (create SKILL.md)
- **Phase 6:** Finalization (quality check and output)
- **Phases 4-5:** Available in [Advanced Topics](./reference/ADVANCED.md)

## References

- [Anthropic Skills Repository](https://github.com/anthropics/skills)
- [obra/superpowers](https://github.com/obra/superpowers)
- [Vercel Agent Skills](https://github.com/vercel-labs/agent-skills)

**Official Resources:**
- [Agent Skills Specification](https://agentskills.io/specification)
- [Claude Code Documentation](https://code.claude.com/docs/)

## Integration

**This skill enables:**
- Custom skill creation for any workflow
- Capturing team processes as skills
- Extending Claude Code capabilities
- Documenting methodologies

**Pairs with:**
- Existing skills as examples
- Git workflows for versioning skills
- Team documentation processes

**Use this skill to create:**
- Methodology enforcement skills
- Technical automation skills
- Audit and validation skills
- Domain knowledge skills
- Tool integration skills
