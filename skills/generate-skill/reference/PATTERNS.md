# Skill Pattern Templates

This reference contains the full structure templates for all five skill patterns used in the generate-skill workflow. Use this when you need the detailed skeleton for a specific pattern.

## Pattern Selection Guide

| Pattern | Use When | Enforcement | Key Sections |
|---------|----------|-------------|--------------|
| A: Methodology | TDD, debugging, code review, quality gates | Strict phases + Iron Laws | Phases, Red Flags, Verification |
| B: Technical | Project setup, build automation, deployment | Step-by-step guidance | Quick Start, Configuration, Troubleshooting |
| C: Auditing | Code quality, performance, accessibility | Rule-based checking | Rule Categories, Output Format, Quick Reference |
| D: Automation | Browser testing, API integration, CI/CD | Workflow automation | Auto-Detection, Configuration, Helper Functions |
| E: Reference | Library patterns, architecture, best practices | Information on demand | Core Concepts, Patterns Library, Best Practices |

**You MUST select a pattern before generating:**
- [ ] Pattern matches skill type
- [ ] Pattern supports enforcement level
- [ ] Pattern includes necessary sections

---

## Pattern A: Methodology Enforcement

**Use when:** TDD, debugging, code review, quality gates

**Structure:**
```markdown
# Skill Title

## Overview
[Core principle statement]

## The Iron Law (if strict enforcement)
```
NON-NEGOTIABLE RULE
```

## When to Use
[Specific triggers]

## The Process (Phase-Based)

### Phase 1: [Step Name]
**Before proceeding, you MUST:**
- [ ] Requirement 1
- [ ] Requirement 2

### Phase 2: [Step Name]
[...]

## Red Flags - STOP
- Warning sign 1
- Warning sign 2

**If you see these: STOP and return to Phase 1**

## Verification Checklist
- [ ] Requirement 1
- [ ] Requirement 2

## Common Rationalizations
| Excuse | Reality |
|--------|---------|
| "Just this once..." | Always leads to problems |

## Examples
<Good>
[Code example]
</Good>

<Bad>
[Code example]
</Bad>
```

**Key characteristics:**
- Phase-based workflow with mandatory checkboxes
- "Iron Laws" for non-negotiable rules
- Red Flags section to catch violations
- Common Rationalizations table
- Verification checklist at end

---

## Pattern B: Technical Implementation

**Use when:** Project setup, build automation, deployment

**Structure:**
```markdown
# Skill Title

## Overview
[What it does and tech stack]

## Quick Start

### Step 1: Setup
```bash
command-here
```

### Step 2: Configure
[Instructions]

### Step 3: Execute
```bash
command-here
```

## Configuration Options
[Customization details]

## Common Patterns
[Code examples]

## Troubleshooting
**Problem:** [Issue]
**Solution:** [Fix]

## Integration
**Pairs with:**
- Other skills
```

**Key characteristics:**
- Quick Start for fast adoption
- Step-by-step numbered instructions
- Configuration reference section
- Practical code examples
- Integration points with other tools

---

## Pattern C: Rule-Based Auditing

**Use when:** Code quality, performance, accessibility checks

**Structure:**
```markdown
# Skill Title

## How It Works
1. Read specified files
2. Check against rules
3. Output findings in priority order

## Rule Categories

| Priority | Category | Impact |
|----------|----------|--------|
| CRITICAL | Category A | Must fix |
| HIGH | Category B | Should fix |

## Quick Reference

### Category A (CRITICAL)
- `rule-id-1` - Description
- `rule-id-2` - Description

## Usage
[How to invoke]

## Output Format
```
CRITICAL: Issue description (file.js:123)
- Impact: [explanation]
- Fix: [solution]
```
```

**Key characteristics:**
- Priority-based rule categories (CRITICAL/HIGH/MEDIUM/LOW)
- Quick reference table for all rules
- Standardized output format
- Clear severity levels and impact descriptions
- Structured fix recommendations

---

## Pattern D: Automation/Integration

**Use when:** Browser testing, API integration, external tools

**Structure:**
```markdown
# Skill Title

## How It Works
[High-level workflow]

## Critical Workflow
1. Auto-detect environment
2. Generate configuration
3. Execute with parameters
4. Present results

## Auto-Detection
```bash
# Detection script
```

## Configuration
[Parameterization details]

## Helper Functions
[Utility library if needed]

## Common Tasks
[Pre-built examples]

## Troubleshooting
[Common issues]
```

**Key characteristics:**
- Auto-detection of environment and tools
- Parameterized configuration
- Helper functions/libraries
- Pre-built common task examples
- Error handling and recovery

---

## Pattern E: Reference/Knowledge

**Use when:** Library usage, architecture patterns, domain knowledge

**Structure:**
```markdown
# Skill Title

## Overview
[When to use this knowledge]

## Core Concepts
[Key ideas explained]

## Patterns Library

### Pattern A: [Use Case]
```javascript
// Code example with annotations
```

### Pattern B: [Use Case]
```javascript
// Code example
```

## Best Practices
[Guidelines]

## Common Mistakes
[Anti-patterns to avoid]

## When NOT to Use
[Situations to avoid]
```

**Key characteristics:**
- Knowledge organized by concept
- Annotated code examples
- Best practices and anti-patterns
- Clear guidance on when NOT to use
- Patterns library for common scenarios

---

## Combining Patterns

Some skills benefit from combining elements of multiple patterns:

| Combination | Example Use Case |
|-------------|-----------------|
| A + D | Methodology enforcement with automation scripts |
| B + E | Technical setup with reference knowledge |
| C + D | Automated auditing with tool integration |
| A + C | Process enforcement with rule-based checks |

When combining, choose a **primary pattern** for overall structure and incorporate specific sections from the secondary pattern.
