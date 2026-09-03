# generate-skill — Eval Set

Official-loop format (agentskills.io optimizing-descriptions): 20 queries, 10 should-trigger / 10 should-not-trigger, split 12 train / 8 validation (60/40) with a proportional 1:1 mix of positives and negatives in each half. Shuffled once 2026-07-28; keep the split fixed across iterations.

**Protocol:** run each query in a fresh Claude session ~3 times from an empty working directory — deictic queries (T6, V4, N6) get a `CHECKLIST.md` fixture in that directory so a miss measures the description, not the absence of the thing the query points at. Iterate on T-row failures only; V1 and V4 are read, never tuned against. Trigger rate = fraction of runs where generate-skill was invoked. A should-trigger query passes above 0.5; a should-not-trigger query passes below 0.5. Iterate the description on train failures only; select the variant with the best **validation** score. Any commit that edits `description` adds a row to Results before it ships; a variant with no validation row is unselected.

## Train (12)

| # | Query | Expected |
|---|---|---|
| T1 | "create a skill for running database migrations" | trigger |
| T2 | "generate a skill from this workflow" | trigger |
| T3 | "scaffold a SKILL.md for screenshot automation" | trigger |
| T4 | "turn this workflow into a skill" | trigger |
| T5 | "I want a new Claude Code skill that formats SQL" | trigger |
| T6 | "turn this checklist into a skill" (harness cwd contains `CHECKLIST.md`) | trigger |
| N1 | "rate this skill" | no (rate-skill) |
| N2 | "review my code" | no (code-review) |
| N3 | "create a roadmap for this project" | no (track-roadmap) |
| N4 | "generate screenshots for docs" | no (screenshot-local) |
| N5 | "set up semantic release for this repo" | no (setup-semantic-release) |
| N6 | "add these checks to the roadmap" (harness cwd contains `CHECKLIST.md`) | no (track-roadmap) |

## Validation (8)

| # | Query | Expected |
|---|---|---|
| V1 | "write a SKILL.md for our deploy process" | trigger |
| V2 | "help me make a skill for tracking TODOs" | trigger |
| V3 | "build a skill that wraps the ffmpeg CLI" | trigger |
| V4 | "make this checklist into a reusable skill" | trigger |
| V5 | "grade my SKILL.md" | no (rate-skill) |
| V6 | "write a Jira ticket for this bug" | no (ticket-description) |
| V7 | "audit my SKILL.md for problems" | no (rate-skill) |
| V8 | "write a PR description for this branch" | no (pr-description) |

## Results

| Variant | Date | Train pass | Validation pass | Selected |
|---|---|---|---|---|
| 4.0.0 (near-neighbor scope: +track-roadmap, +track-qa) | 2026-07-28 | not yet run | 7/8 | superseded — description rewritten 2026-09-01 |
| 6.0.0 (track-qa scope dropped; V6 retargeted to ticket-description) | 2026-09-02 | not run | 6/8 | superseded — selected by scope match, not by score |
| 6.1.0 ("checklist" restored to the coverage clause; T6/N6 with a CHECKLIST.md fixture) | 2026-09-02 | 11/12 (T6 0.00) | 7/8 (V4 0.33) | ✓ best validation (6.0.0 was 6/8; V1 now 1.00) |

Measured 2026-09-02, 6.1.0 (3 fresh sonnet sessions per query, `--max-turns 3`, empty working directory, Skill call parsed from stream-json): T1 1.00, T2 1.00, T3 0.67, T4 0.67, T5 1.00, T6 0.00 **FAIL** (with the CHECKLIST.md fixture present — the model read the file and wrote the skill itself, the capable-alone caveat), N1–N6 all 0.00; V1 1.00, V2 1.00, V3 1.00, V4 0.33 **FAIL**, V5–V8 all 0.00. Every miss below is a query that points at something absent from the empty directory ("this app", "this SKILL.md", "the card"); the model asked what to look at instead of invoking. All should-nots were silent. Treat trigger rates as lower bounds and give deictic queries a fixture before iterating the description against them.

Measured rates 2026-09-02, 6.0.0 (fresh sonnet sessions from an **empty** working directory, `--max-turns 1`, stream-json captured to files and parsed as JSON; user-scope install of the shipped description): V1 0.67 (4/6 — the two misses ran Bash to inspect the empty directory before deciding, which the one-turn cap counts as a miss), V2 1.00, V3 1.00, V4 0.00 **FAIL** (all three runs asked the user to paste the checklist the query points at — a deictic query with nothing present, not a description miss), V5–V8 all 0.00 (V5 and V7 invoked rate-skill every run, V6 invoked ticket-description once, V8 invoked pr-description once; never generate-skill). Two harness lessons from this run: the working directory must be empty — a first pass run from the directory holding the eval script produced sessions that said "this looks like an eval harness" and behaved differently; and detect the Skill call by parsing the JSON, not by regex on the serialized input, since the model sometimes emits `args` before `skill`.

Measured rates 2026-07-28 (3 fresh sonnet sessions per query, scratch project with all 14 skills installed): V1 1.00, V2 1.00, V3 1.00, V4 0.00 **FAIL**, V5–V8 all 0.00 (all four should-nots correctly silent, including "create a QA list"). V4 ("make this checklist into a reusable skill") is the known cost of dropping "checklist" from the coverage clause to avoid the track-qa collision — a deliberate precision-over-recall trade. If a future variant re-adds checklist coverage, it must keep V6 at 0.00; iterate on train, not against this query.

## Notes

- N1/V5/V7 test the `Do NOT use for grading existing skills — see rate-skill` clause; N3/N4 test "create/generate X" verbs that belong to other skills; V6 and V8 test "write X" asks that belong to the description skills (track-qa, V6's original target, was deprecated 2026-09-01).
- T5/V2/V4 are indirect asks (no "generate/scaffold" verb) — they test the description's "even if they don't say 'skill'" coverage clause.
