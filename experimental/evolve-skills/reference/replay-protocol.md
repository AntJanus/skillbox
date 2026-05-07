# Replay Protocol

This document specifies the headless Claude Code replay used by `evolve-skills` Phase 5 to validate proposed patches.

## Status

**Replay validation is best-effort.** Non-deterministic. Treat the score as one signal among several, not as proof.

## Invocation

For each `(session, patch)` pair:

1. **Snapshot the original session prompt and tool environment.** Read the JSONL transcript and extract:
   - System prompt and any persistent context.
   - The user message that triggered the friction event (the "trigger turn").
   - The first ~3 turns of conversation leading up to the trigger turn.

2. **Apply the patch.** Copy the skill's `SKILL.md` to a tmp location and apply the unified diff.

3. **Run headless Claude Code.** Approximate invocation:

   ```bash
   claude \
     --headless \
     --skill-dir <tmp-skill-dir> \
     --max-turns 10 \
     --output-format json \
     <<< "<system_prompt>\n<priors>\n<trigger_turn>"
   ```

   *Note: the actual flag set depends on the Claude Code CLI's headless mode. Check `claude --help` and update this doc when invocation changes.*

4. **Capture the output transcript.**

5. **Score the replay** (see Scoring Rubric below).

## Scoring Rubric

For each replay, classify the outcome:

| Outcome | Criteria | Score |
|---------|----------|-------|
| **Friction avoided** | Replay output does NOT contain the friction signature (no interruption-trigger tool call, no skipped-confirmation pattern, no wrong-base diff, etc.) | 1 |
| **Friction reproduced** | Replay output exhibits the same friction signature as the original | 0 |
| **Different failure** | Replay produced a NEW friction event not present in original | -1 |
| **Inconclusive** | Replay errored, timed out, or produced output too different to compare | n/a |

A patch's overall validation score is the mean across all replays, with `Inconclusive` excluded. The pipeline reports both the mean and the raw outcome distribution so the human reviewer can judge variance.

**Friction signature matching:**
- For `interruption` events: did the patched skill produce the same tool call sequence that triggered the original interruption?
- For `wrong-approach`: did the patched skill make the same approach decision?
- For `wrong-scope` (diff base): did the patched skill use the corrected base or the original?
- For `skipped-confirmation`: did the patched skill checkpoint with `AskUserQuestion` where the original did not?

## Caveats

### Non-determinism

Two replays of the same patch on the same session can produce different outputs. Sources of variance:
- Sampling temperature in the headless model.
- Tool result variance (e.g., `git status` output may have changed since the session was recorded).
- Model version drift between when the session was recorded and when it's replayed.

**Mitigation:** Run each `(session, patch)` replay 2-3 times and report the distribution.

### Tool environment drift

The tools available to the original session may not match the replay environment. Examples:
- A skill that was loaded at session time may have been deleted.
- A file the original session read may have changed or been deleted.
- An MCP server the original session used may not be available.

**Mitigation:** Detect environment drift before scoring. If detected, mark replay `Inconclusive`.

### Partial reproduction

A patch may reduce friction without eliminating it. Examples:
- Original session: 3 interruptions before user gave up.
- Replay with patch: 1 interruption.

This counts as `Friction reproduced` (not avoided), but the patch still helped. Future versions of the rubric may add a "partial" tier; for v0.1.0, the binary classification is intentional simplicity.

## Cost note

Each replay is a real headless Claude Code invocation against a model. Approximate cost per replay (Sonnet, 5-turn session): ~$0.03 to ~$0.08. With 5 patches × 3 replays × $0.05, a weekly run costs ~$0.75. Use `--skip-replay` if you don't need the validation signal.

## Pipeline failure modes

| Failure | Symptom | Pipeline response |
|---------|---------|-------------------|
| Headless Claude not available | `claude --headless` errors | Mark replay phase as "skipped: replay infrastructure unavailable" and continue; report explicitly notes this |
| Replay times out | Single session > 5min | Mark that replay `Inconclusive`, continue with others |
| All replays inconclusive | No scorable outcomes for a patch | Report patch with "validation: inconclusive across all replays" — human still reviews |

## Future improvements

- **Embedding-based friction signature matching.** Current text-based matching misses semantically equivalent rephrasings.
- **Multi-patch replay.** Compose patches across multiple skills and validate them together rather than independently.
- **Cost dashboard.** Track replay spend over time so weekly runs don't surprise.

These improvements graduate the skill closer to `skills/` from `experimental/`.
