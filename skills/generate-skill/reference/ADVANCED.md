# Advanced Skill Generation Topics

This reference covers enhancement, scripting, multi-file skills, template variables, integration patterns, and guidance on when NOT to generate skills.

---

## Phase 4: Enhancement and Refinement

Add these enhancements based on skill complexity:

### For Simple Skills (< 300 lines)
- Single SKILL.md file
- Inline examples
- Basic troubleshooting
- Quick reference table

### For Medium Skills (300-500 lines)
- SKILL.md with detailed sections
- Multiple examples (3-5)
- Comprehensive troubleshooting
- Integration documentation
- Consider reference/ directory for extended docs

### For Complex Skills (> 500 lines)
- SKILL.md (core guide, < 500 lines)
- reference/ directory with:
  - STANDARDS.md (detailed rules)
  - EXAMPLES.md (extensive code samples)
  - TROUBLESHOOTING.md (advanced issues)
- scripts/ directory if automation needed
- Progressive disclosure pattern
- Helper libraries (lib/ directory)

**Progressive disclosure example:**
```markdown
## Deep Reference

For detailed information, load these files when needed:

- **[Complete Standards](./reference/STANDARDS.md)** - Full rule set
- **[Code Examples](./reference/EXAMPLES.md)** - 50+ examples
- **[Advanced Troubleshooting](./reference/TROUBLESHOOTING.md)**

*Only load these when specifically needed to save context.*
```

**Verification:**
- [ ] Appropriate complexity level chosen
- [ ] Files organized logically
- [ ] Progressive disclosure if > 500 lines
- [ ] No unnecessary complexity

---

## Phase 5: Scripts and Automation (Optional)

If the skill requires scripts, create these:

### Setup Script Pattern
```bash
#!/bin/bash
set -e  # Fail fast

echo "Setting up [skill-name]..." >&2

# Install dependencies
npm install dependency1 dependency2

# Configure environment
cp .env.example .env

# Verify installation
echo '{"status": "success", "message": "Setup complete"}' # JSON output
```

### Execution Script Pattern
```bash
#!/bin/bash
set -e

# Parse arguments
TARGET="${1:-default-value}"

echo "Running [task] on $TARGET..." >&2

# Auto-detect environment
DETECTED=$(detect_environment)

# Execute main task
result=$(perform_task "$TARGET")

# Output structured result
echo "{\"status\": \"success\", \"result\": \"$result\"}"
```

### Helper Library Pattern (Node.js)
```javascript
// lib/helpers.js
module.exports = {
  async autoDetect() {
    // Auto-detection logic
    return detected_value;
  },

  async safeOperation(params) {
    // Safe operations with retry
    for (let i = 0; i < 3; i++) {
      try {
        return await operation(params);
      } catch (e) {
        if (i === 2) throw e;
      }
    }
  },

  formatOutput(data) {
    // Standardized formatting
    return JSON.stringify(data, null, 2);
  }
};
```

### Script Best Practices
- Use `set -e` for error handling
- Status messages to stderr (>&2)
- Data output to stdout (JSON preferred)
- Cleanup traps for temp files
- Parameterization at top
- Auto-detection where possible

### Script Verification
- [ ] Scripts executable (chmod +x)
- [ ] Error handling implemented
- [ ] Output properly formatted
- [ ] Dependencies documented
- [ ] Scripts tested manually

---

## Advanced: Multi-File Skills

For complex skills, generate multiple files:

**SKILL.md (core, < 500 lines):**
```yaml
---
name: complex-skill
description: [triggers]
---
```

```markdown
# Complex Skill

## Quick Start
[Essential info]

## Core Workflow
[Main process]

## Deep Reference
- [Standards](./reference/STANDARDS.md) - 100+ rules
- [Examples](./reference/EXAMPLES.md) - 50+ examples
```

**reference/STANDARDS.md:**
```markdown
# Detailed Standards Reference

## Category A Rules

### Rule: RULE-001
- **Severity:** Critical
- **Description:** [detailed explanation]
- **Fix:** [solution]
- **Example:** See EXAMPLES.md #001

[... extensive rule documentation ...]
```

**reference/EXAMPLES.md:**
```markdown
# Code Examples

## Example #001: [Rule Name]

### Before (Problematic)
```python
# Bad code
```

### After (Fixed)
```python
# Good code
```

[... 50+ examples ...]
```

**Generate multi-file structure when:**
- Skill has 20+ rules
- Extensive examples needed (10+)
- Complex troubleshooting
- Multiple integration points

---

## Skill Generation Templates

### Template Variables

When generating, customize these placeholders:

```markdown
# Frontmatter variables
{{SKILL_NAME}}         # kebab-case name (required)
{{DESCRIPTION}}        # Trigger-rich description (required)
{{LICENSE}}            # License type (default: MIT)
{{AUTHOR}}             # Author name
{{VERSION}}            # Semantic version (default: "1.0.0")
{{ARGUMENT_HINT}}      # Argument hint (e.g., <branch-name>)
{{TAGS}}               # Array of tags
{{HOOKS}}              # Optional automation hooks

# Content variables
{{SKILL_TITLE}}        # Human-readable title
{{CORE_PRINCIPLE}}     # One-line principle
{{TRIGGER_PHRASES}}    # List of activation phrases
{{PATTERN_CONTENT}}    # Pattern-specific structure
{{EXAMPLES}}           # Code examples
{{TROUBLESHOOTING}}    # Common issues
{{REFERENCES}}         # Source links
```

### Quick Generation Flow

```
1. Ask user questions ->
2. Determine skill type ->
3. Select pattern ->
4. Generate content ->
5. Add examples ->
6. Add troubleshooting ->
7. Quality check ->
8. Present to user
```

---

## Integration Patterns

### Skill Chains

Some skills naturally call others:

```markdown
## Integration

**This skill (git-workflow):**
- Creates feature branch
- Guides development process

**Then activates:**
- test-driven-development - For implementation
- code-review - Before committing
- git-commit - For proper commit messages

**Pairs with:**
- git-worktree - For parallel features
```

### Skill Composition

Multiple skills working together:

```markdown
## Integration

**Works with:**
- react-best-practices - Performance checks
- web-design-guidelines - Accessibility audit
- security-audit - Vulnerability scanning

**Combined usage:**
All three skills active = comprehensive component review
```

---

## When NOT to Generate Skills

| User Request | Why Not | Alternative |
|--------------|---------|-------------|
| "Help me with React" | Too vague | Ask clarifying questions first |
| "Create a skill to fix bugs" | Too general | Use systematic-debugging skill |
| "Make a skill for everything" | Not focused | Create multiple focused skills |
| "Turn this 5000 line doc into skill" | Too large | Split into multiple skills with progressive disclosure |
