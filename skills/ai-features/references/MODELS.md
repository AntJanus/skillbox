# Which model for which job

Dated **2026-09-22**. Model rosters rot in months: the Ollama library retires tags (three named
models disappeared between July and September 2026), benchmark leaderboards change index versions,
and hosted price lists move. Before scripting a pull or quoting a price, open the library page or the
vendor price page and confirm. Treat every figure here as "true on the date above".

## Runtime tiers

| Tier | Runs where | Needs | Fits |
|---|---|---|---|
| **In-process embedder** | Inside the app's own process (Transformers.js / ONNX, or a native binding) | Model files pinned in a directory the app owns; no daemon | Semantic search, related items, near-duplicates, clustering. Survives packaging as a single binary. |
| **Local daemon, small model** | Ollama (or LM Studio) on the user's machine | The daemon running, one 3 to 9 GB model | Tagging, routing, yes/no decisions, short rewrites, filter parsing. Stays resident beside a larger model. |
| **Local daemon, large model** | Same daemon, a 17 to 23 GB model | 32 GB or more of unified memory for comfort | Summaries, drafts, vision on photos and scans, natural-language queries. |
| **Hosted frontier** | Anthropic or OpenAI API | A key, a spend cap, and a data-handling decision | Extraction from messy input, published-quality writing, multi-step agents, long-context reasoning. |
| **Not a language model** | whisper.cpp, tesseract, plain statistics | Its own install | Speech to text, plain OCR, anomaly baselines. |

## Roster by job

Sizes are the Ollama library's 4-bit download sizes; add 20 to 40 percent for a long KV cache.
A 256K context on a 27B model does not fit beside its weights in 64 GB.

| Job | Local pick | Size | Hosted pick | Rule |
|---|---|---|---|---|
| Embeddings for search and related items | `embeddinggemma:300m` (2K context); `qwen3-embedding:0.6b` when inputs run past 2K tokens (32K context, Matryoshka dims) | 622 MB / 639 MB | Usually none. OpenAI `text-embedding-3-small` $0.02 per 1M tokens if the app is hosted anyway | Never mix dimensions in one index. Changing the model invalidates the index; say so and rebuild. |
| Tagging, routing, classification | `gemma4:e2b-it-qat` or `qwen3.5:4b`, JSON-schema enum over the app's own vocabulary | 4.3 GB / 3.4 GB | `claude-haiku-4-5` for bulk runs | Enum, not prose: a prose-stated vocabulary lets a small model invent labels; a schema enum makes invention impossible. Dedupe in the resolver. |
| Typed decisions with a probability | Read logprobs through llama.cpp or MLX, or use a 400M decision encoder (Laya, von) | under 1 GB | Jev (hosted only, closed weights) | Ollama's OpenAI-compatible route drops logprobs. A model asked to emit a confidence number emits a plausible number. Calibrate on labeled rows from the app. |
| Summaries, rewrites, drafts | `gemma4:26b` (MoE, fast decode) or `gemma4:e4b` for short text | 19 GB / 9.6 GB | `claude-sonnet-5` | Every claim carries a source id back to a row or timestamp. Hosted when the text is published under the user's name. |
| Natural language to filters | `qwen3.5:9b` up to `qwen3.8:27b-mlx`, JSON schema whose enums are the real filter vocabularies | 6.6 GB / 18 GB | `claude-sonnet-5` when accuracy decides | Show the resolved filter as editable chips. Reject out-of-vocabulary values. Text-to-SQL tops out near 82% on BIRD against a 93% human baseline. |
| Vision: captions, receipts, screenshots | `qwen3.5:9b` (native image input); `deepseek-ocr` for document pipelines; tesseract for plain OCR without a model | 6.6 GB | `claude-sonnet-5` with structured outputs | Messy scans go hosted into a prefilled form the user saves. Clean text stays local. |
| Speech to text | whisper.cpp `large-v3-turbo` (99 languages); parakeet-mlx for English on Apple Silicon | 809 MB | OpenAI `gpt-transcribe` $0.0045 per minute | Not an Ollama job. Gate on voice activity: Whisper hallucinates on silence and repeats. |
| Reranking | `llama-server --reranking` with `bge-reranker-v2-m3` | about 1 GB | Voyage or Cohere rerank | Ollama has no rerank endpoint (PR #14172 open since Feb 2026). Reranking cut retrieval failures from 2.9% to 1.9% in Anthropic's measurement. |
| Agentic loops, coding | `qwen3.8:27b-mlx` | 18 GB | `claude-opus-5` or `claude-sonnet-5` | Local for exploration and privacy; hosted when consistent tool calling over many turns decides completion. |

**Current generations, for orientation:** Qwen 3.5 / 3.6 / 3.8 (vision native, 0.8B to 122B),
Gemma 4 (12B, 26B MoE, 31B, e2b/e4b edge with audio), Meta's muse-glimmer 30B for local agents,
DeepSeek V4, Phi-4 (no Phi-5), gpt-oss 20B/120B. GLM-5.3 exists only as a cloud tag. No
Qwen3.5-Embedding exists; the embedding line lags the chat line.

## Hosted price per 1M tokens

| Model | Input | Output | Batch in / out | Note |
|---|---|---|---|---|
| `claude-haiku-4-5` | $1 | $5 | $0.50 / $2.50 | Bulk classification. Vendor example: 10,000 tickets at 3,700 tokens each for about $37. |
| `claude-sonnet-5` | $2 | $10 | $1 / $5 | Default hosted tier. |
| `claude-opus-5` | $5 | $25 | $2.50 / $12.50 | Agentic loops. |
| `claude-fable-5-1` | $10 | $50 | $5 / $25 | Requires 30-day retention and is unavailable under zero-data-retention. Wrong tier for personal data. |
| `gpt-5.6-luna` | $0.20 | $1.20 | $0.10 / $0.60 | OpenAI's cheap tier. |
| `gpt-5.6-terra` | $2 | $12 | $1 / $6 | |
| `gpt-6-astra` | $10 | $50 | $5 / $25 | OpenAI's top tier. |

Prompt-cache hits cost a tenth of base input on Claude and do not count toward the input rate limit.
Batch is half price both ways. Anthropic prices from
https://platform.claude.com/docs/en/about-claude/pricing; OpenAI from
https://developers.openai.com/api/docs/pricing.

## Local or hosted

| Go local when | Go hosted when |
|---|---|
| The data is personal or belongs to someone else. Flagged Anthropic API sessions can be retained up to 2 years; OpenAI keeps abuse-monitoring logs 30 days. Both survive the no-training promise. | Reasoning quality decides the outcome: extraction from a messy scan, a summary that gets published, a multi-step agent. |
| The task is small, repetitive and latency-bound: embeddings, tags, routing, yes/no decisions. | The context is long and reused, so prompt caching pays. |
| The app must work offline or ship as a binary with no account. | Consistent tool calling over many turns is required. Local models lose it over long sessions. |
| A wrong answer is cheap and reversible. | The user already holds a key and the volume is tiny. |

Cost is not a reason to go local at personal-app scale: a few thousand hosted calls a month on
Haiku or Sonnet cost less than keeping a 27B model warm. The reasons are privacy, offline
operation, latency on small tasks, and shipping without an account.

## Memory and context

- **Memory budget:** weights plus 20 to 40 percent for the KV cache at a long context. A 27B dense
  model at 4-bit is about 18 GB of weights and 15 to 25 GB more at 128K context.
- **Decode speed is bandwidth-bound.** A dense 27B reads about 18 GB per token, so a laptop with
  about 400 GB/s of memory bandwidth lands in the low tens of tokens per second; a mixture-of-experts
  model with 3 to 4B active parameters runs three to five times faster at the same download size. No independently
  measured tokens-per-second table exists for most Apple Silicon chips; measure with
  `ollama run --verbose`.
- **Ollama's default context scales with memory:** 4K under 24 GB, 32K at 24 to 48 GB, 256K at 48 GB
  and above. On a small machine a long note truncates silently; on a large one the KV cache is the
  thing that runs out of memory. Set `num_ctx` per request on the native API, or
  `OLLAMA_CONTEXT_LENGTH` on the daemon.
- **Cold start:** models unload after five minutes idle (`keep_alive`). First token after a cold
  load costs seconds on a 7B-class model. Preload with an empty request at app start when a feature
  is enabled.

## Sources

- Ollama library and docs: https://ollama.com/library · https://docs.ollama.com/context-length ·
  https://docs.ollama.com/faq · https://docs.ollama.com/api/openai-compatibility ·
  https://github.com/ollama/ollama/issues?q=rerank
- Model cards: https://huggingface.co/Qwen/Qwen3-Embedding-0.6B ·
  https://ai.google.dev/gemma/docs/embeddinggemma · https://huggingface.co/openai/whisper-large-v3
- Retrieval and accuracy: https://www.anthropic.com/news/contextual-retrieval ·
  https://bird-bench.github.io/ · https://github.com/vectara/hallucination-leaderboard
- Typed decisions: https://github.com/r-ms/mini-jev (reading option-letter logits matched
  constrained JSON on accuracy and ran about 4x faster) ·
  https://typesafe.ai/blog/introducing-system-one-models-and-jev
- Retention: https://platform.claude.com/docs/en/manage-claude/api-and-data-retention ·
  https://developers.openai.com/api/docs/guides/your-data
