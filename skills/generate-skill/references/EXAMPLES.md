# Generate Skill — Description Examples

## Example: methodology skill

✅ Desired description

```yaml
description: Code-review methodology. Use whenever the user asks to "review my code", "check this PR", or "look at this diff before I commit". Runs a phased review (correctness, style, security, tests). Do NOT use for grading skill files — see rate-skill.
```

Why it works: ~250 chars, third person, three literal triggers, scope clause, negative scoping against `rate-skill`.

## Example: technical skill

✅ Desired description

```yaml
description: docx authoring toolkit. Use whenever the user asks to "create a Word doc", "edit a .docx", "add tracked changes", or "extract text from docx". Do NOT use for PDF — see the pdf skill.
```

Why it works: distinctive token "docx" in first 5 chars; four literal triggers; explicit negative scope; under 230 chars.

## Counter-example

❌ Anti-pattern description

```yaml
description: |
  I help you work with Word documents.
  Use when you need to edit docx files.
```

Why it fails: (1) multi-line block scalar silently breaks discovery (anthropics/skills #9817); (2) first-person POV depresses activation; (3) no specific trigger phrases; (4) no negative scoping.
