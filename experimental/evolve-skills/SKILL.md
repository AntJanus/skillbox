---
name: evolve-skills
description: EXPERIMENTAL skill-evolution pipeline — mines Claude Code transcripts for friction, clusters by active skill, proposes one patch per high-friction skill, validates by headless replay, and writes a report on a branch (never auto-merges). Use when asked to "evolve my skills", "audit skills against recent friction", "propose skill improvements from transcripts", or "run the skill evolution pipeline". Do NOT use to grade one skill (see rate-skill) or scaffold a new skill (see generate-skill).
license: MIT
argument-hint: "[--days=N] [--min-friction=N] [--skip-replay]"
allowed-tools: Read, Write, Bash, Grep, Glob, Task
metadata:
  author: Antonin Januska
  version: "0.2.0"
  status: experimental
---
# Evolve Skills (Experimental)

## Status: Experimental

This skill lives in `skillbox/experimental/` and follows the experimental conventions:

- Always runs on a branch (never `main`).
- Produces a report (`EVOLUTION_REPORT.md`) — never auto-merges.
- Passes through `/publish-check` before any output is surfaced.
- All decisions about which patches to apply are made by the human user via `AskUserQuestion`.

See [experimental/README.md](../README.md) for the full set of conventions.

## Overview

A weekly meta-loop: scan recent Claude Code transcripts, cluster friction events by which skill was active when they occurred, propose patches for the skills with the most friction, validate each patch via headless Claude replay of historical sessions, scrub the report for personal data, and present everything for human review on a branch.

**Core principle:** Skills should compound in capability over time, but only with human-validated changes. The pipeline finds candidates and presents evidence; the human decides what merges.

## When to Use

**Always use when:**
- A weekly skill-evolution cadence is established and it's that day.
- Recent skill audits have surfaced repeated friction patterns and you want to systematize the response.
- After a notable user-friction event you want to ensure doesn't recur.

**Useful for:**
- Catching subtle skill drift (where a skill's triggers no longer match how users phrase requests).
- Finding skills whose instructions are ignored frequently (a sign the wording isn't sticky).

## When NOT to Use

- Fewer than 7 days of transcripts available (signal-to-noise too low).
- A skill is itself under active development (its drift is intentional).
- You don't have time to review the report — running without review defeats the safety guarantee.

## How It Works

Six phases, each with a gate. Failing a gate halts the pipeline.

### Phase 1: Branch creation

Create a branch in the skillbox repo:

```bash
git checkout -b experimental/evolve-skills/<YYYY-MM-DD-runid>
```

If the working tree is dirty, halt — experimental skills should not be run on a dirty tree.

**Gate:** On a clean experimental branch.

### Phase 2: Transcript scan and friction extraction

Read JSONL transcripts under `~/.claude/projects/` from the last `--days` (default: 7).

For each transcript, extract events that match a friction pattern (see [references/friction-patterns.md](./references/friction-patterns.md)):

- **Interruption:** `request_interrupted_by_user` events.
- **Wrong-approach rejection:** user message contains "no", "stop", "wait", "actually", "don't" near a recent assistant tool call.
- **Re-roll:** same task started 2+ times within a session.
- **Correction:** user explicitly reverts or contradicts an assistant decision.
- **Skip-confirmation:** assistant executed multi-step work without an `AskUserQuestion` checkpoint and was interrupted.

For each friction event, capture: `(session_id, timestamp, friction_type, active_skill_or_none, surrounding_context)`.

**Gate:** At least one friction event found, or pipeline exits cleanly with "no friction to act on."

### Phase 3: Clustering by active skill

Group friction events by the skill that was active (frontmatter context, recent skill invocation in transcript, or "no skill" if none was active).

For each skill, compute:
- `friction_count`
- `friction_types_distribution`
- `representative_examples` (top 3 most distinctive events, after redacting verbatim text)

Skills with `friction_count` < `--min-friction` (default: 3) are excluded from patch generation.

**Gate:** ≥ 1 skill exceeds threshold, else exit with "no skill warrants patches this week."

### Phase 4: Parallel patch proposal

For each qualifying skill, dispatch a parallel Agent (subagent_type: `general-purpose`) with:

- The current `SKILL.md` (full content).
- The friction events for that skill.
- A contract: "Propose ONE concrete patch — a specific edit to `SKILL.md` — that would have prevented or reduced these friction events. Include rationale and a unified diff."
- A boundary: "Do not rewrite the skill from scratch. The patch should be the smallest change that addresses the friction."

Each agent returns: `{patch_diff, rationale, expected_friction_reduction}`.

**Gate:** All agents return — either with a proposal or a "no patch warranted" justification.

### Phase 5: Replay validation

Skipped if `--skip-replay` was passed (the "lite" version of the pipeline).

For each proposed patch:

1. Pick 2-3 historical sessions from the friction set.
2. Apply the patch to a copy of the skill.
3. Replay each session via `claude --headless` (or equivalent CLI invocation) with the patched skill loaded.
4. Score the replay: did the friction event reoccur? (Match the original friction signature against the replay output.)

Replay validation is **non-deterministic** — expect score variance run-to-run. The skill records the validation as one signal among several, not as a gate.

See [references/replay-protocol.md](./references/replay-protocol.md) for the exact replay invocation, scoring rubric, and known caveats.

**Gate:** Each patch has a validation result attached (or marked "skipped: --skip-replay" / "skipped: replay infrastructure unavailable").

### Phase 6: Privacy scrub and report assembly

Assemble `EVOLUTION_REPORT.md` (see Output Format below).

**Run `/publish-check`** on the report. Friction context can include verbatim user messages, file paths, and skill content — all sources of leakable PII. The privacy scrub is non-optional.

If `/publish-check` returns BLOCK, halt and surface the BLOCKERS. The user fixes the report (or the underlying patches) and the pipeline resumes.

If `/publish-check` returns WARN, surface findings via `AskUserQuestion` for ack-and-continue or revise.

If `/publish-check` returns PASS, write the report to the branch and surface it for review.

**Commit the report to the branch** (not main):
```bash
git add EVOLUTION_REPORT.md
git commit -m "evolve-skills: report for <YYYY-MM-DD-runid>"
```

DO NOT commit the proposed patches. They live in `runs/<runid>/proposed-patches/<skill>.diff` and the user applies them manually after review (or via a follow-up `/apply-patch` flow that does not exist yet).

**Gate:** Report committed to branch, ready for review.

## Output Format

A single `EVOLUTION_REPORT.md` committed to the experimental branch (never `main`): one `## Skill: <name>` block per skill over the friction threshold — each with a friction summary, redacted representative examples, the proposed patch (rationale + unified diff), the replay-validation result, and a `Decision required` checklist — followed by a pipeline-diagnostics footer.

See [references/report-format.md](./references/report-format.md) for the full template.

## Usage

**Default (last 7 days, replay enabled):**
```bash
/evolve-skills
```

**Wider window:**
```bash
/evolve-skills --days=14
```

**Lite mode (skip replay validation):**
```bash
/evolve-skills --skip-replay
```

**Higher friction threshold (only well-established patterns):**
```bash
/evolve-skills --min-friction=5
```

## Examples

### Example 1: Weekly run, 2 skills warrant patches

**Input:** `/evolve-skills` (default 7-day window)

**Pipeline output:**
```
Phase 1: Branch experimental/evolve-skills/2026-05-07-a3b9 created ✅
Phase 2: 47 transcripts scanned, 34 friction events found ✅
Phase 3: Clustered by skill:
  - code-review: 8 events (above threshold)
  - track-session: 4 events (above threshold)
  - publish-check: 1 event (below threshold, excluded)
  - 22 events with no active skill (excluded)
Phase 4: Dispatching 2 patch-proposal agents in parallel
  - Agent A (code-review): patch proposed (12-line diff to "How It Works")
  - Agent B (track-session): patch proposed (4-line diff to triggers)
Phase 5: Replay validation (3 sessions per patch)
  - code-review patch: 2/3 friction avoided (mean 0.67)
  - track-session patch: 1/3 friction avoided, 1/3 inconclusive (mean 0.50)
Phase 6: /publish-check on EVOLUTION_REPORT.md → PASS ✅
EVOLUTION_REPORT.md committed to branch.

Open: ~/projects/antjanus/skillbox/EVOLUTION_REPORT.md
```

The user reviews the report, approves the code-review patch, defers track-session for next week.

### Example 2: No skill exceeds threshold

**Input:** `/evolve-skills --min-friction=5`

**Pipeline output:**
```
Phase 1: Branch experimental/evolve-skills/2026-05-07-c8f2 created ✅
Phase 2: 41 transcripts scanned, 19 friction events found ✅
Phase 3: Clustered by skill — max friction count: 3 (below threshold of 5)
Pipeline exits cleanly: "no skill warrants patches this week."

No EVOLUTION_REPORT.md generated. Branch experimental/evolve-skills/2026-05-07-c8f2 left empty (no commits).
```

The user can either lower `--min-friction` for a wider audit or accept that no patches are needed.

### Example 3: Privacy scrub blocks the report

**Input:** `/evolve-skills`

**Pipeline output:**
```
Phase 1-5: completed ✅
Phase 6: /publish-check on EVOLUTION_REPORT.md → BLOCK
  - skills/publish-check/representative-examples:1: "/Users/<USER>/projects/<repo>/..."
  - 1 BLOCKER finding

Pipeline halted. Fix the report (or the underlying friction-extraction patterns
that included the unredacted path) and re-run Phase 6.
```

The user investigates, finds the friction-pattern extractor wasn't redacting absolute paths in `representative_examples`, fixes the extractor, re-runs.

## Constraints

- **Never commits to main.** Hard rule. The skill exits with an error if the working tree is on main.
- **Never auto-applies patches.** Patches live in `runs/<runid>/proposed-patches/`. Application is a separate human-driven step.
- **Replay validation is best-effort.** Non-deterministic; the report is honest about this.
- **Privacy scrub is non-optional.** No report is surfaced without passing `/publish-check`.

## Known Limitations

- **Friction detection is heuristic.** Pattern-matching on transcript text catches the obvious cases but misses subtle drift (e.g., a user who never explicitly objects but consistently routes around a skill).
- **Replay scoring is noisy.** Same patch + same session can score differently across runs. Trust the trend across multiple sessions, not a single replay.
- **Cost.** Each replay is a real headless Claude session. With multiple skills × 2-3 replays each, weekly cost is non-trivial. Use `--skip-replay` for cheaper iterations.
- **The agents proposing patches see only the skill text and friction events** — they don't see the broader skill ecosystem. Patches may conflict with conventions enforced by other skills (rate-skill, generate-skill).

## Graduation Criteria

This skill graduates from `experimental/` to `skills/` when:

- It has run successfully against ≥3 weeks of real transcript data.
- The proposed patches have produced measurable improvements (post-patch friction < pre-patch friction across ≥2 skills).
- Replay validation infrastructure has stabilized (replay-to-replay variance < 30%).
- A human reviewer has signed off on at least 5 generated reports without rejecting them as low-signal.

## Integration

**Composes with:**
- **`/publish-check`** — required for Phase 6 (privacy scrub).
- **`/rate-skill`** — orthogonal; rate the skill before applying any patch to track quality changes.

**Does NOT compose with:**
- **Auto-versioning / auto-release tools** — this skill explicitly does not bump versions or push tags. That's a separate human-driven step after the report is reviewed.

## References

- [references/friction-patterns.md](./references/friction-patterns.md) — The patterns used to detect friction.
- [references/replay-protocol.md](./references/replay-protocol.md) — Headless replay invocation and scoring rubric.
- [references/report-format.md](./references/report-format.md) — Full EVOLUTION_REPORT.md template.
- [experimental/README.md](../README.md) — Overall conventions for experimental skills.
- [/publish-check](~/.claude/skills/publish-check/SKILL.md) — The privacy scrub.
