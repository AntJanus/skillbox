# Initial AI setup

The plumbing every AI feature in an app shares. Build it once, after the user approves at least one
proposal, and stop there: each feature is its own build. Follow the app's existing conventions for
where config lives, how external services are wrapped, and how background work runs; this file
names the decisions, not the file layout.

## 1. Runtime detection

Detect, never assume. Each probe has a short timeout so an absent runtime never hangs a page.

| Runtime | Probe | Timeout | Then |
|---|---|---|---|
| Ollama | `GET http://127.0.0.1:11434/api/version`, then `GET /api/tags` for installed models, `GET /api/ps` for loaded ones | 1.5 s | Host from an env var only for a non-standard port, never for a remote host. |
| LM Studio | `GET http://localhost:1234/v1/models` | 1.5 s | OpenAI-compatible `/v1/*`; the user must start its server from the app or `lms server start`. |
| In-process model | Model files present in the directory the app pins (`allowRemoteModels = false`) | none | A missing directory is a reported state with the download command, not an error. |
| Hosted | A key exists where the app keeps external keys, and a one-token test call succeeds | 10 s | Verify on save from the settings field; echo the key back truncated (`sk-ant…wxyz`), never whole. |
| whisper.cpp, llama.cpp | Binary on PATH | none | Name the install step in the feature proposal. |

Do not rely on `GET /` returning "Ollama is running"; it is not in current docs. A missing model
returns 404 "model not found, try pulling it first". The exact tag matters: a bare name does not
resolve when only a tagged variant is cached.

## 2. One runtime interface, several backends

```ts
interface AiRuntime {
  name: "ollama" | "lmstudio" | "bundled" | "hosted";
  embed(texts: string[]): Promise<Float32Array[]>;
  complete(prompt: Prompt, schema?: JsonSchema): Promise<string>;
}
type RuntimeUnavailable = { name: AiRuntime["name"]; reason: string; fix: string };
```

- Selection order is measured per app, not assumed. A 0.5B bundled model obeys "omit fields you are
  guessing" less often than a 3B daemon model, so a daemon usually ranks first when present.
- Pure prompt construction and response parsing live in the app's I/O-free core, testable without a
  model. The runtime is I/O and lives with the app's other external integrations. The server-side
  glue that reads the database and calls the runtime lives wherever the app keeps such glue.
- With every backend absent, return the list of `RuntimeUnavailable` reasons. Render them. Never
  fall back to a non-AI feature the user did not ask for.

## 3. Configuration

Store AI configuration where the app already stores external-service configuration. A settings
table, a config file, environment variables and an OS keychain are all legitimate; the app's
existing convention wins, and the proposal states which one it follows. Whatever the store:

| Key | Default | Purpose |
|---|---|---|
| `ai.enabled` | off | User intent. Every AI entry point checks it first. |
| `ai.runtime` | `auto` | `auto`, `ollama`, `lmstudio`, `bundled`, `hosted`. |
| `ai.model.embed` | the roster pick | Changing it invalidates the vector index; say so and offer a rebuild. |
| `ai.model.classify` | the roster pick | Tags, routing, decisions. |
| `ai.model.generate` | the roster pick | Summaries and drafts. |
| `ai.model.vision` | the roster pick | Captions and scans. |
| `ai.hosted.provider` | unset | `anthropic` or `openai`. |
| `ai.hosted.key` | unset | Verified live on save; echoed truncated. Never written to a file in the repo. |
| `ai.hosted.model` | `claude-sonnet-5` | Never a model with forced retention for personal data. |
| `ai.semantic.ceiling` | measured | Cosine-distance cutoff, calibrated from random pairs, with a calibrated flag. |

Two failure messages, not one. The gate answers intent: "AI features are off. Enable them in
Settings." The probe answers machine reality: "Ollama is not running" or "gemma4:e2b is not
installed" with a Pull action. They are different failures and get different text.

## 4. Model pull with progress

`POST /api/pull` streams progress; a first-run screen shows a real download bar. Confirm the tag
exists on ollama.com before scripting a pull: the library retires models. After the first pull,
preload with an empty request so the first real call is warm.

## 5. Calling the model

| Provider | Structured output | Notes |
|---|---|---|
| Ollama native `/api/chat`, `/api/generate`, `/api/embed` | `format` takes a raw JSON Schema; enums are enforced | Only the native route honours `num_ctx` and `keep_alive`. Tools via `tools` on `/api/chat`, streaming supported. |
| Ollama `/v1` (OpenAI-compatible) | `response_format` json_schema | Drops logprobs, `tool_choice`, context size, image URLs (base64 only). Use only when a library forces the OpenAI shape. |
| Ollama `/v1/messages` (Anthropic-compatible) | via tool use | Lets an Anthropic SDK client point at a local model with `ANTHROPIC_BASE_URL`. |
| Anthropic Messages API | `output_format` with `messages.parse()`; strict tools | No recursive schemas, `additionalProperties: false` everywhere, numeric bounds enforced after parsing. First call pays grammar compilation, cached 24 h. |
| OpenAI Responses API | `text.format` with `type: json_schema, strict: true` | Chat Completions stays supported; Responses is the current path. |
| Vercel AI SDK 7 | `output: Output.object({ schema })` on `generateText` / `streamText` | ESM-only, Node 22+, `instructions` replaced `system`, `generateObject` is deprecated. No official Ollama provider; community `ollama-ai-provider-v2` or `ai-sdk-ollama`. |

Schema enforcement guarantees shape, never correctness. Keep validators after parsing and re-prompt
with the validation error when a field is wrong.

## 6. Vectors in SQLite

| Rows | Store | Search |
|---|---|---|
| under ~50k | a `BLOB` column of float32 in an `<entity>_embedding` table keyed by row id and content hash | brute-force cosine in the app; sqlite-vec's own measurement is under 75 ms for 100k rows at 384 to 768 dims |
| over ~50k | sqlite-vec `vec0` virtual table (still brute force in the stable release; ANN only in alphas) | KNN with `match` and `k`; metadata filters accept only `= != > >= < <=` |

- Keep the `vec0` table outside the migration chain: the loadable extension may legitimately be
  absent, and `node:sqlite` only loads extensions when the connection was opened with
  `allowExtension: true`. Bun's bundled SQLite cannot load extensions at all.
- Embeddings are derived data: rebuildable on reindex, excluded when the source row is in trash,
  deleted in the same transaction as the source row (foreign keys are off per connection in
  `node:sqlite`, so a cascade will not do it).
- Lock the dimension count to the model. A model change is an index rebuild.
- Hybrid search: fuse the keyword list (FTS5 bm25) with the vector list by reciprocal rank fusion
  (k = 60), then apply a calibrated distance ceiling. Report the count after the ceiling, never the
  candidate pool size. Label each result by provenance: keyword, meaning, both.

## 7. Packaging

- An in-process Transformers.js model with a pinned models directory survives a compiled
  single-binary build; ship the directory beside the binary or download it on first run with
  progress.
- A sqlite-vec dylib inside a compiled binary is not proven; plan to ship it beside the binary or
  stay on the BLOB path.
- A daemon (Ollama, LM Studio) is the user's install, not the app's. The settings screen links to
  it and reports its state.
- Vision, speech and reranking are separate installs; the proposal names them.

## 8. Stack notes

| Stack | Runtime | Notes |
|---|---|---|
| Next.js / Node | official `ollama` npm client or plain `fetch`; `@huggingface/transformers` in-process; `@anthropic-ai/sdk`, `openai` | AI calls are server actions or the app's equivalent, never client-side with a key. Mark heavy packages as server-external in the bundler config. |
| SvelteKit | same clients in `+server.ts` or form actions | Static sites have no server at request time; AI runs at build time (excerpts, alt text, related posts) or in a separate admin app. |
| Go | `net/http` against Ollama's JSON API; official Anthropic and OpenAI Go SDKs | A CLI reads the key from the environment or the OS keychain; there is no settings screen. Print the runtime state on `--version` or a `doctor` subcommand. |
| Rust | `reqwest` against Ollama; `ollama-rs`; provider crates | Same as Go. Keep the model call off the render thread in a TUI. |
| Python | `ollama` package; `anthropic`, `openai`; Instructor for validation retries | `messages.parse()` and `responses.parse()` take a Pydantic model. |
| Godot | HTTPRequest against Ollama on localhost | Game text generation runs in a thread; cache generated lines per seed so a replay is deterministic. |

## 9. Hygiene

- **Untrusted content** (a pasted email, an OCR'd page, a web fetch) goes into tool results or a
  JSON-encoded block, never into the system prompt. Say in the system prompt that such content is
  data, not instructions. Screen it with a cheap classifier before it reaches a tool-using agent.
- **Keys** never enter a repo file, a log line, or a client bundle. Echo truncated.
- **Spend caps** on hosted keys. Anthropic returns 429 with `error_code: enforced_spend_limit_reached`
  and no `retry-after` at the cap, so the SDK's auto-retry loops until the month resets; branch on
  that shape. A self-set lower limit returns 400 instead.
- **Retention.** Anthropic API conversation content is not retained by default except for covered
  models that force 30 days, and flagged sessions can be kept up to 2 years. OpenAI keeps
  abuse-monitoring logs 30 days. State this in the proposal for any hosted feature over personal
  data.
- **Rate-limit headers** are per model and per tier; read `retry-after` and the
  `anthropic-ratelimit-*` or `x-ratelimit-*` headers rather than guessing.
- **The OWASP LLM Top 10 (2026 edition)** names prompt injection, sensitive information
  disclosure, excessive agency and vector-store weaknesses first; a local app with a vector table
  and a tool-using feature is in scope for all four.

## Sources

- https://docs.ollama.com/api/openai-compatibility · https://docs.ollama.com/api/anthropic-compatibility ·
  https://github.com/ollama/ollama/blob/main/docs/api.md · https://docs.ollama.com/faq
- https://lmstudio.ai/docs/developer/core/server
- https://platform.claude.com/docs/en/api/rate-limits ·
  https://platform.claude.com/docs/en/manage-claude/api-and-data-retention ·
  https://platform.claude.com/docs/en/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks
- https://developers.openai.com/api/docs/guides/structured-outputs ·
  https://developers.openai.com/api/docs/guides/your-data ·
  https://developers.openai.com/api/docs/guides/safety-best-practices
- https://ai-sdk.dev/docs/migration-guides/migration-guide-7-0 ·
  https://ai-sdk.dev/providers/community-providers/ollama
- https://github.com/asg017/sqlite-vec · https://alexgarcia.xyz/sqlite-vec/js.html ·
  https://alexgarcia.xyz/blog/2024/sqlite-vec-stable-release/index.html ·
  https://nodejs.org/api/sqlite.html
- https://genai.owasp.org/resource/owasp-genai-llm-top-10-2026/
