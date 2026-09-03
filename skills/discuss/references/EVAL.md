# discuss — eval set

The skill is slash-only (`disable-model-invocation: true`), so the standard trigger-rate loop does not apply. This set checks two things instead: (1) no natural-language query invokes the skill without `/discuss`, and (2) once invoked, the mode holds its contract across turns.

## Should-trigger (8) — each begins with the slash command; pass = mode contract holds

Protocol: run each 3 times in a fresh session. A run passes when the first reply leads with a position or a question, contains no `Write`/`Edit` call, closes with exactly one hook, and every sentence is 25 words or fewer.

| # | Query | Split |
|---|---|---|
| 1 | /discuss how does the migration runner decide order | train |
| 2 | /discuss should we split this package in two | train |
| 3 | /discuss is a monorepo a good idea for the True* apps | train |
| 4 | /discuss I want to understand how node:sqlite handles concurrency | train |
| 5 | /discuss what should we do about the flaky CI job | train |
| 6 | /discuss how does retry work in the job queue | validation |
| 7 | /discuss why did we pick zod over valibot | validation |
| 8 | /discuss walk me through the export route design | validation |

## Should-not-trigger (10) — pass = the skill is NOT invoked (regression check on `disable-model-invocation`)

| # | Query | Split |
|---|---|---|
| 1 | how does retry work in the job queue | train |
| 2 | let's talk through the architecture of this repo | train |
| 3 | what do you think about caching the whole result set | train |
| 4 | discuss the tradeoffs of SQLite vs Postgres here | train |
| 5 | review my changes before I commit | train |
| 6 | research whether node:sqlite is production ready | train |
| 7 | is this a good idea: one artifact per thread | validation |
| 8 | explain the migration runner to me | validation |
| 9 | I want to debate the package split with you | validation |
| 10 | fix the flaky CI job | validation |

## Persistence probes (run after any should-trigger query, same session)

1. Turn 2 changes topic entirely — mode must still hold (position-first, condensed, read-only).
2. Turn 3: "okay, now fix it" — a single edit is made, then turn 4 returns to discussion shape without re-invocation.
3. Turn 5: "stop discuss" — one-line confirmation, then default style.

Selection rule: the description/body iteration with the best validation-half pass rate wins, not the most recent one. Split fixed across iterations.
