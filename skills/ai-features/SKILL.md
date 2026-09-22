---
name: ai-features
description: AI features for an existing app — audit the codebase, propose the AI features its data can support, mock the strongest ones as screens, then wire the initial AI setup with Ollama or LM Studio locally, Anthropic or OpenAI hosted, and the right model for each job. Use this skill whenever the user wants to "add AI to my app", "what AI features could this app have", "add semantic search", "auto-tag these records", "summarize this with a local model", "set up Ollama for this project", or "should this use Claude or a local model" — even if they never say AI and only describe search that understands meaning, tags that fill themselves in, or a summary of their own data. Do NOT use this skill for pointing Claude Code itself at a local model (harness configuration — see update-config), for building an MCP server (see mcp-server-dev), or for a question about the Claude API alone — see claude-api.
license: MIT
argument-hint: "[brainstorm | setup]"
effort: high
metadata:
  author: Antonin Januska
  version: "1.1.0"
---

# AI Features

## Overview

An AI feature earns its place when it removes a step the user performs by hand today, or answers a question the interface cannot. Everything else is a sparkle button. The skill reads the app first, proposes only features tied to a real column and a real user moment, shows each as a static mock built on example data, and builds the shared plumbing once the user has chosen.

Two principles drive the workflow:

- **The app's data decides.** A proposal names the table and column it reads. No column, no feature.
- **Narrow beats conversational.** Narrowly scoped AI features are easier to understand and see better adoption (NN/g); a chat box in front of a working feature is the last thing to propose.

## Navigation

| Load | When |
|---|---|
| **[references/CATALOG.md](references/CATALOG.md)** | Phase 3 — the feature catalog: shipped features by app category, what the user sees, data needed, model tier, and the ones users rejected |
| **[references/MODELS.md](references/MODELS.md)** | Phase 3 and 6 — which model for which job, local vs hosted rules, prices, memory and context, dated |
| **[references/SETUP.md](references/SETUP.md)** | Phase 6 — runtime detection, the runtime interface, configuration keys, structured output per provider, vectors in SQLite, packaging, hygiene |
| **[references/EVAL.md](references/EVAL.md)** | Tuning the description |

## Workflow

**Goal:** the user holds a ranked, mocked set of AI feature proposals for their app, and, once they pick, the app has the runtime, configuration and gate every AI feature shares.
**Constraints:** proposals cite only columns found in the app; mocks use example data, never rows from the user's database; the setup phase builds plumbing only. A pre-existing bug or behaviour the task doesn't mention is a follow-up to report, not a change to make here. Commit tests only where the task asks or the repo already keeps tests for that kind of change, sized like the neighbouring test files; scratch checks are not test files.
**Gates:** each phase ends on something outside the agent — command output, a written sheet, a rendered mock, the user's choice.

Six phases. The order is load-bearing in two places: the machine inventory comes before candidates because a proposal that needs a runtime the machine lacks carries its install step; the app sheet comes before candidates because the sheet is the only source a proposal may cite.

### Phase 1: Inventory the machine

Probe, never assume. Ollama at `/api/version` and `/api/tags` with a 1.5 s timeout; LM Studio at `localhost:1234/v1/models`; whisper.cpp and llama.cpp on PATH; total memory; hosted keys by variable name in the environment and in the app's own configuration store, values never read. "Not installed" is a legitimate row.

**Before proceeding:** a machine sheet with the real command output.

### Phase 2: Read the app

From the repo's own agent doc, schema and migrations: every table, every free-text column, every external client and where its credentials live, the search implementation, any background-job system, the packaging path. Read schema and code, not data rows. One Explore subagent for a repo past roughly 200 source files, none for a smaller one; dispatch it and keep working on the machine sheet while it runs.

**Before proceeding:** a data-shape sheet. A proposal may cite only what is on it.

### Phase 3: Generate and score candidates

Cross the catalog with the data sheet. Drop a candidate when any of these holds: it restates a feature the app already does well; the user would not notice it missing; it needs data the app does not hold; its wrong answer is expensive and it has no visible source; it leads with jargon. Score the survivors:

| Axis | Question | Scale |
|---|---|---|
| Usefulness | What does the user stop doing by hand? | 0 nothing · 1 saves a click · 2 removes a chore · 3 answers what the UI cannot |
| Fit | How much already exists? | 0 new subsystem · 1 new module · 2 extends a module · 3 one new column or job kind |
| Cost tier | Cheapest tier that does the job well | 3 in-process · 2 local small · 1 local large · 0 hosted |
| Risk | What a wrong answer costs, and may the data leave the machine | 3 reversible, local · 2 reversible, hosted fine · 1 needs review · 0 sensitive data |

Sum. Below 6 of 12 goes to a later list. A risk score of 0 forces local-only regardless of the rest. Cap the now list at eight; a longer list is a signal to split, not to keep enumerating.

### Phase 4: Mock the strongest proposals

For the top three to five, one self-contained HTML page per proposal, written to the scratchpad, never into the repo: the full screen the feature lives on, in the app's own navigation and header, with the new control in place — never the control cropped out on its own, because a fragment can't be judged against the screen it has to share. Show it in its populated state and in its degraded state (runtime missing, with the message and the fix), with a day/night toggle so both colour schemes are checked from one file. Use the app's own colour and type tokens (read them from its theme file) so the mock looks like the app; when the Artifact tool is available, publish the pages as one artifact with a tab per proposal, which is what Phase 5 presents. Mocks are built on well-known example data (a reading list with *Dune* and *The Hobbit*, a trip to Lisbon, a 2016 hatchback's oil change), never on the user's records, and are labelled as examples. A mock in a foreign visual language gets feedback about colours instead of about the feature.

**Before proceeding:** every mock renders in both colour schemes at body-size text.

### Phase 5: Present

An artifact when the Artifact tool is available, otherwise a written list in chat. Findings first, one tab or section per proposal, then a setup section, then open questions. Per proposal:

| Field | Content |
|---|---|
| What the user sees | One screen or control, in the user's words |
| Model and runtime | The tag to pull or the hosted model id, and why that tier |
| Plugs into | The existing module, job kind or route it extends |
| Stores | New column or table, keyed how, derived or primary, trash behaviour |
| Degrades to | The message when the runtime, model or key is missing |
| Mock | The rendered screen, populated and degraded |
| Estimate | "An afternoon if the search module already has a keyword index; two days if not" |

Match length to the proposal count; no methodology essay, no repeated summary. The user accepts, cuts or reorders one proposal at a time. Record what was cut and why in the same report.

File each accepted proposal in the project's `ROADMAP.md` through track-roadmap before Phase 6: the proposal's name and what the user sees as the item line, and the model, what it plugs into, what it stores, how it degrades, the estimate and the mock's link as quoted notes under it. The artifact is not read by a later session that builds the feature without this skill; the roadmap item is.

### Phase 6: Initial AI setup

Only after approval, and only the shared plumbing from SETUP.md: runtime detection, one runtime interface over the backends the machine has, configuration keys in the store the app already uses for external services, the feature gate off by default, the model pull with progress, and the two failure messages. Each approved feature then becomes an ordinary work item built on its own.

**Before reporting done:** the runtime state shows in the app's settings or a `doctor` command, and `ollama list` (or the equivalent) shows the pulled tags.

## Examples

Model tags below are MODELS.md's picks as of its stated date; confirm on the library before quoting one.

### Example: a book catalog with a notes column and a tag table

✅ Desired

> **Tags that suggest themselves.** When a book is saved, three tags from the existing 42-tag vocabulary appear as chips with accept and dismiss; nothing is applied until accepted. Model: `gemma4:e2b-it-qat` through Ollama with a JSON-schema enum built from the `tags` table. Plugs into the existing save action. Stores nothing until accepted; accepted tags carry `source = suggested`. Degrades to: chips absent, one line reading "Suggestions need Ollama with gemma4:e2b — pull it from Settings." Mock: the edit form with three example chips under the tag field, and the same form with the one-line notice. Estimate: half a day.

❌ Anti-pattern

> **Smart tags.** On save, the model tags the book automatically. Model: Claude. Stores the tags directly on the row.

Why it fails: no vocabulary, so labels drift; applied without review, so a wrong tag is silent; hosted with no reason given for personal notes; no degraded state, so a missing key breaks save.

Why the first works: a real column, a real moment, an enforced vocabulary, a visible degraded state, and an estimate tied to what exists.

### Example: a photo library with a job runner and an empty caption column

✅ Desired

> **Describe photos as a background job.** A new job kind on the existing jobs screen with a progress bar; captions land in the caption column and proposed tags wait in a review list marked as suggested. Model: `qwen3.5:9b` (vision) through Ollama. Runs only on the index, never touches originals.

Why it works: it spends the app's own job runner and progress reporter instead of inventing a new subsystem.

### Counter-example: chat in front of a working search

❌ Anti-pattern

> **Ask your library anything.** A chat panel on every screen answers questions about the collection using Claude.

Why it fails: it duplicates the search and filters beside it, is slower than the UI for every question the UI already answers, and sends personal records to a hosted model with no reason given.

### Example: a maintenance log the user re-reads

✅ Desired

> **The last twelve months in one paragraph.** On a car's page: three services, two parts, the next due item. Every sentence links to the log row it came from; the schema requires a source id per sentence and the UI refuses a sentence without one. Model: `gemma4:e4b` locally. Regenerated on demand and cached by the log's latest update time.

Why it works: the source-id requirement turns the summary's main failure mode, an invented event, into a rejected row.

## Anti-patterns

- ❌ Proposing from the catalog without reading the schema — the proposal cites a column that does not exist
  ✅ Build the data-shape sheet first and cite only from it
- ❌ Mocking with the user's real records to make it convincing
  ✅ Example data, labelled as such; the feature is judged on the interaction, not the rows
- ❌ Silently falling back to keyword search when the embedder is missing
  ✅ Say which mode produced the results and what would enable the other
- ❌ Building the first feature inside the setup phase
  ✅ Stop at plumbing; each feature is its own change with its own verification

## Gotchas

- **Symptom:** the tagger returns labels that are not in the vocabulary. **Cause:** the vocabulary was described in the prompt. **Fix:** an enum in the schema passed as `format` on Ollama's native `/api/chat`; dedupe in the resolver.
- **Symptom:** a summary of a long record silently covers only its start. **Cause:** Ollama's default context scales with machine memory (4K under 24 GB) and the OpenAI-compatible route ignores `num_ctx`. **Fix:** set `num_ctx` on the native API, sized to the input.
- **Symptom:** meaning search returns two hundred hits for every query. **Cause:** no distance ceiling; the candidate pool was reported as the match count. **Fix:** calibrate a cosine ceiling from random pairs, show it in settings, count only hits within it.
- **Symptom:** a confidence number looks right and is worthless. **Cause:** it was generated as text. **Fix:** read logprobs (llama.cpp, MLX) or use a decision encoder; fit a temperature on labelled rows.
- **Symptom:** the feature works in development and is absent in the packaged binary. **Cause:** the model directory or the sqlite-vec extension was not bundled. **Fix:** in-process embeddings with a pinned models directory and a BLOB column under 50k rows; a dylib in a compiled binary is unproven.
- **Symptom:** a hosted call returns 429 and the SDK retries until the month ends. **Cause:** the monthly spend cap, which returns no `retry-after`. **Fix:** branch on `error_code: enforced_spend_limit_reached` and show it.
- **Symptom:** a deleted record still appears in meaning search. **Cause:** its embedding row survived; `node:sqlite` opens with foreign keys off, so a cascade did nothing. **Fix:** remove or trash the embedding in the same transaction; exclude trashed ids in the query.
- **Symptom:** the pull script 404s on a tag that worked last month. **Cause:** the library retired the model. **Fix:** check the library page before scripting a pull; keep MODELS.md's date visible.
- **Symptom:** a transcript feature returns text for silent audio. **Cause:** Whisper hallucinates on non-speech. **Fix:** gate on voice activity detection before transcribing.
- **Symptom:** feedback on the mock is all about colours and spacing. **Cause:** the mock used a visual language foreign to the app. **Fix:** reuse the app's components and tokens, or show the mock in greyscale.

## Integration

- **local-first-app** for the settings, trash and packaging rules an AI feature inherits · **ui-ux-design** for the four states every AI surface ships (loading, empty, error with retry, success) · **track-roadmap** to file approved proposals as items carrying their Phase 5 fields as quoted notes · **claude-api** for the Anthropic API reference when a hosted feature is built
