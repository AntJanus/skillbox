# Activation eval set

Feeds the description-optimization loop (agentskills.io/skill-creation/optimizing-descriptions).
20 queries, 10 should-trigger and 10 should-not, split 60/40 with a proportional mix in both halves.
Built 2026-09-22 with the 1.0.0 description; 1.0.1 added two "see Y" pointers to the negative-scope clause without changing the triggers.

## Protocol

Run each query in a **fresh session**, ~3 times. Trigger rate = fraction of runs that invoked the
skill. A should-trigger query passes above **0.5**; a should-not-trigger query passes below it.

Iterate on **train failures only** — rework the description in SKILL.md, never against validation.
Check validation after, and **select the description with the best validation score**: an earlier
draft can beat the last one, because later iterations overfit the train half. Five iterations is
usually enough. Keep the split below **fixed** across iterations.

Caveat: agents consult skills for tasks beyond what they handle alone, so a trivially simple query
may not trigger even a well-described skill. Don't churn the description over those.

## Train (12 — 6 should-trigger, 6 should-not)

**Should trigger**

1. "what AI features could my recipe app have?"
2. "add semantic search to my notes app using a local model"
3. "set up Ollama for this project so I can auto-tag records"
4. "should this summary feature use Claude or something running on my machine?"
5. "I want the app to fill in tags by itself when I add a book"
6. "make search understand what I mean, not just the words"

**Should NOT trigger**

1. "what's the current price of Claude Sonnet per million tokens?" → claude-api
2. "build an MCP server that exposes my database" → mcp-server-dev
3. "point Claude Code at a local Ollama model" → harness configuration, not an app feature
4. "design the settings screen for my tracker" → ui-ux-design
5. "add a trash view so deletes can be undone" → local-first-app
6. "review my changes before I commit" → code-review

## Validation (8 — 4 should-trigger, 4 should-not)

**Should trigger**

1. "brainstorm AI ideas for a photo library app"
2. "add a feature that summarizes a car's maintenance history"
3. "wire up an Anthropic key and a local fallback for this app"
4. "which model should I use to read receipts into expense rows?"

**Should NOT trigger**

1. "write a Python script that calls the OpenAI API once" → plain coding (claude-api skips when OpenAI is named)
2. "fine-tune a model on my data" → out of scope (training)
3. "what colors should my dashboard use?" → color-system
4. "create a skill for running database migrations" → generate-skill

## Load-bearing discriminators

The near-neighbours are the Claude API reference (a question about the API itself), Claude Code's
own model configuration (pointing the harness at Ollama), and MCP server authoring. All three
mention models or AI without asking for a feature inside an app; they sit in both halves on purpose.
If activation over-fires on them, sharpen the negative-scope clause rather than adding triggers.

## Results

| Description version | Train | Validation | Run |
|---|---|---|---|
| 1.0.1 (current) | not measured | not measured | — |

The shipped description has no validation score, which rate-skill treats as a standing P1 until a
run is recorded here.
