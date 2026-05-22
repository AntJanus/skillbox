# Friction Patterns

These are the patterns the `evolve-skills` pipeline uses in Phase 2 to extract friction events from transcripts. All are heuristics — false positives and false negatives are expected.

Patterns are ordered by signal strength (highest first).

---

## 1. User interruption (highest signal)

**Definition:** Transcript contains a `request_interrupted_by_user` event, or an explicit `[Request interrupted by user]` marker, immediately followed by a user message that redirects.

**Detection:**
- Grep transcripts for `request_interrupted_by_user`, `Request interrupted by user`, or analogous markers used by the harness.
- Capture the assistant's tool call right before the interruption — this is what was being done that triggered the user to stop.
- Capture the user's redirect message — this is the corrective signal.

**Friction type:** `interruption`

**Caveats:** Some interruptions are benign (user changed their mind unrelated to skill behavior). The agent proposing the patch should weigh whether the interruption is skill-relevant.

---

## 2. Explicit rejection / correction

**Definition:** User message starts with or prominently contains a rejection word ("no", "stop", "wait", "actually not", "don't") in the same turn after an assistant tool call.

**Detection:**
- Sliding window: when a user message starts with or contains in the first ~20 words: `no\b`, `stop\b`, `wait\b`, `actually\s+(not|don't|let)`, `don't\b`, `that's wrong`, `that's not what I asked`.
- Verify the prior assistant turn included a tool call (Edit/Write/Bash) — pure-conversation rejections are lower signal.

**Friction type:** `wrong-approach` if the rejection redirects the approach; `correction` if it asks for a fix to specific output.

**Caveats:** "No, that's fine" is a false-positive trigger. Agents should read context, not just match the keyword.

---

## 3. Re-roll (same task started 2+ times)

**Definition:** Same intent appears in two user messages within the session, with the second message rephrasing or restarting.

**Detection:**
- For each user message, compare to all previous user messages in the same session via lightweight semantic match (shared 5+ content words).
- Re-rolls within ~5 minutes of each other are highest signal.

**Friction type:** `re-roll`

**Caveats:** Hard to detect reliably without an actual semantic embedding. Until that's available, this pattern over-fires on multi-turn refinement (which is normal, not friction).

---

## 4. Skip-confirmation execution

**Definition:** Assistant executed multi-step work (3+ Edit/Write tool calls) without an `AskUserQuestion` checkpoint, AND the user interrupted before completion OR the next user message contained corrective language.

**Detection:**
- For each session, find sequences of ≥3 consecutive Edit/Write/Bash tool calls without an intervening `AskUserQuestion`.
- Check if the sequence ended with: an interruption, a correction message, or a re-roll.

**Friction type:** `skipped-confirmation`

**Caveats:** Many fast sessions legitimately do bulk work without checkpoints. This pattern only fires when the bulk work was followed by friction.

---

## 5. Diff-base mismatch (skill-specific)

**Definition:** Code-review or PR-prep skills ran against `main` when the user expected `origin/dev` (or vice versa), and the user corrected.

**Detection:**
- Find tool calls invoking `git diff main`, `git log main..HEAD`, etc.
- Check user's next message for: `dev`, `origin/dev`, "should be against dev", "wrong base".

**Friction type:** `wrong-scope`

**Caveats:** This is the highest-signal, lowest-noise pattern in the set — almost zero false positives.

---

## 6. Silent fallback rejection

**Definition:** Assistant added a fallback (try/except, default value, optional chaining) and the user explicitly rejected it in favor of raising an error.

**Detection:**
- Find Edit operations adding `try`, `except`, `catch`, `?.`, `??`, `default = `, etc.
- Look in user's next 2 messages for: "raise", "throw", "don't swallow", "no fallback", "fail loudly".

**Friction type:** `wrong-approach`

**Caveats:** Niche, high signal when it fires.

---

## How patterns are scored

Each detected friction event gets a `confidence` score:

| Score | Criteria |
|-------|----------|
| **HIGH** | Explicit interruption/rejection with a clear assistant tool call as the trigger |
| **MEDIUM** | Inferred from corrective language without an explicit interruption |
| **LOW** | Heuristic matches (re-roll, skip-confirmation) without explicit user signal |

Skills are clustered using ALL detected events; thresholds (`--min-friction`) apply to the count regardless of confidence. The proposed-patch agent receives the full event list with confidences and can weight accordingly.

## Adding a new friction pattern

1. Identify a recurring pattern in transcripts that the existing 6 patterns miss.
2. Write a detection rule (regex or simple state machine).
3. Add it here with: definition, detection, friction type, caveats.
4. Add test fixtures showing positive and negative cases.
5. Bump the skill version (patch for new pattern in existing taxonomy, minor for new friction-type category).
