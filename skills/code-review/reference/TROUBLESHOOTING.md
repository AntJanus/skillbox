# Code Review — Troubleshooting

Extended troubleshooting for the `code-review` skill. SKILL.md keeps the three most-common entries inline; everything else lives here.

---

### Problem: Reviewer returns vague findings

**Cause:** The agent drifted from the output format, usually because the prompt was paraphrased.

**Solution:** Re-dispatch that one agent with the exact skeleton from `reference/AGENTS.md`. Include "no preamble, no summary — only findings in the specified format."

### Problem: Correctness lane returns only style/hygiene observations

**Cause:** The lane reverted to surface reading instead of tracing data flow.

**Solution:** Its findings must each carry a `Trigger:` (a concrete input) and a `Wrong result:`. If they don't, re-dispatch with the exact correctness prompt and "for every finding, name the input that produces the wrong output — if you can't, it's not a correctness finding."

### Problem: Architecture finding reads as "a sibling does it differently"

**Cause:** The lane reverted to the old consistency-mode bar.

**Solution:** The 2.0 architecture lane judges soundness *for the code's purpose* and must state a concrete `Consequence:`. "Inconsistent with a peer but nothing breaks" is not a finding — it should have been dropped. Re-dispatch with the exact prompt; in `--blueprint` mode confirm the blueprint skill name was passed in.

### Problem: ui-ux lane fired on a backend/CLI diff

**Cause:** Scope detection matched a non-UI file as UI, or the lane was dispatched unconditionally.

**Solution:** ui-ux is dispatched *only* when the scope includes components/templates/styles/design-token files. If it fired on a pure backend change, fix Phase-1 UI detection — don't send the lane at all when there's no UI in scope.

### Problem: Two lanes flag the same line

**Cause:** Natural overlap (a hardcoded key is both a `[Secret]` and a config-drift note; a wrong-result branch is both correctness and "no test").

**Solution:** In synthesis, keep the most severe finding and add `(also flagged by X)`. Don't print both. Rule of thumb: if it computes a wrong answer, it's **correctness**; if it's dead/typo/drift, it's **hygiene**; a real committed credential is **hygiene `[Secret]`** (blocking).

### Problem: Report is still too nitpicky

**Cause:** The verifier isn't enforcing the impact floor — it's keeping true-but-trivial findings instead of dropping them.

**Solution:** This is the single most important thing to get right. Re-dispatch the verifier with the exact `reference/AGENTS.md#verifier` prompt and "default to DROP; every kept blocking finding must name a concrete bad outcome (wrong result, data loss, security, real regression, reader-trap). Cosmetic/stylistic/doc-only fails the floor." Nits belong in the held bucket, not the report — they only show with `--nits`.

### Problem: The nit tail is showing up by default

**Cause:** Synthesis rendered the `[Nit]` bucket without `--nits`.

**Solution:** Nits are held back unless the run passed `--nits`. The summary line still reports how many were held (`H nits held`). Only a `[Secret]` Critical from the hygiene lane surfaces without the flag.

### Problem: Verifier dropped a finding the user thinks is real

**Cause:** Either the citation didn't hold against current code (evidence drop), or the finding was true but failed the impact floor (no concrete bad outcome on this change).

**Solution:** Drops are intentional in 2.0 — the skill removes low-impact truths on purpose. If the user believes it was high-impact, they can re-run with `--nits` (a floor-failed finding tagged `[Nit]` is preserved in the held bucket), or re-stage and re-run so line numbers align if it was an evidence drop from drift. There is no `[Unverified]` demote-and-keep tier anymore; the impact floor replaced it.

### Problem: `## What to fix first` is empty or missing

**Cause:** Either only Minor survived (correct — the verifier emits `Nothing blocking — only polish remains.`), or the distillation block was dropped in synthesis.

**Solution:** If Criticals or high-impact Majors exist but the section is empty, the synthesizer skipped it — re-render from the verifier's returned distillation. The section always appears, even when it's the single "Nothing blocking" line.

### Problem: `--blueprint <skill>` had no effect / skill not found

**Cause:** The blueprint skill name was not resolvable, so the architecture/ui-ux lanes fell back to sibling/default judgment.

**Solution:** Confirm the skill exists (`ls ~/.claude/skills/<name>` or the project skills dir). Load its SKILL.md and pass its rules into the lane prompts explicitly. If it genuinely doesn't exist, tell the user and run without `--blueprint`.

### Problem: Background review never wrote REVIEW.md

**Cause:** `--background` was run by launching the whole skill as one subagent — which can't spawn the reviewers (subagents don't fan out) — or a reviewer tried to write into the worktree.

**Solution:** Background must be orchestrated from the MAIN thread: main dispatches each reviewer with `run_in_background: true` + `isolation: "worktree"`, then the verifier, then main itself writes REVIEW.md to the real repo root (`git rev-parse --show-toplevel` of the main tree — not the worktree, which is torn down). Reviewers stay read-only so the worktree auto-cleans.

### Problem: Scope is empty

**Cause:** No uncommitted changes and no branch diff against main (diff modes only).

**Solution:** Stop and tell the user — "No changes detected. Pass a path, use `--branch <base>`, or `--repo` for a whole-repo pass." Do not fabricate a review. (`--repo` is never empty.)

### Problem: Diff / repo is huge (hundreds of files)

**Cause:** A merge/rebase caught in scope, or `--repo` on a large codebase.

**Solution:** Show the file count and confirm before dispatching. For a large `--repo` pass, prefer `--background` so it doesn't block, and consider `--blueprint` to keep the lanes focused on conformance rather than open-ended review.

### Problem: REVIEW.md shows up as a dirty file in git

**Solution:** Add `REVIEW.md` to `.gitignore` (project) or `~/.config/git/ignore` (global). It's an ephemeral artifact, always overwritten at the repo root.
