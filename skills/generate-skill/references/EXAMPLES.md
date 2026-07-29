# Generate Skill — Worked Examples

Four description pairs plus one body-step pair, each a different situation.

## Example: methodology skill

✅ Desired description

```yaml
description: Code-review methodology. Use whenever the user asks to "review my code", "check this PR", or "look at this diff before I commit". Runs a phased review (correctness, style, security, tests). Do NOT use for grading skill files — see rate-skill.
```

Why it works: a few sentences, third person, three literal triggers, scope clause, negative scoping against `rate-skill`.

## Example: technical skill

✅ Desired description

```yaml
description: docx authoring toolkit. Use whenever the user asks to "create a Word doc", "edit a .docx", "add tracked changes", or "extract text from docx". Do NOT use for PDF — see the pdf skill.
```

Why it works: distinctive token "docx" in first 5 chars; four literal triggers; explicit negative scope; concise (a few sentences).

## Counter-example

❌ Anti-pattern description

```yaml
description: I help you work with Word documents. Use when you need to edit files.
```

Why it fails: (1) first-person POV depresses activation (Seleznov n=650); (2) no distinctive noun in the first 50 chars ("Word documents" is buried, "docx" absent); (3) no literal trigger phrases; (4) no negative scoping against the pdf near-neighbor.

## Example: the same skill, repaired

✅ Desired description

```yaml
description: docx authoring toolkit. Use whenever the user asks to "create a Word doc", "edit a .docx", "add tracked changes", or "extract text from docx" — even if they only say "this report" and name a .docx file. Do NOT use for PDF — see the pdf skill.
```

Why it works: the counter-example's four defects reversed — third person, "docx" in the first 5 chars, four literal triggers plus a coverage clause, explicit negative scope.

## Example: a body step that verifies

✅ Desired

```markdown
Run `skills-ref validate <skill-dir>` and confirm it exits 0 before finalizing.
```

Why it works: it gates on external state the agent cannot know without checking.

## Counter-example

❌ Anti-pattern

```markdown
Before you finish, double-check your work and use a subagent to verify the output.
```

Why it fails: the model already verifies and self-corrects unprompted, so the instruction compounds with its own behavior and costs tokens with no quality gain. The official fix is deletion, not rewording.
