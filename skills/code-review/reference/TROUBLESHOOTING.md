# Code Review — Troubleshooting

Extended troubleshooting for the `code-review` skill. SKILL.md keeps the three most-common entries inline; everything else lives here.

---

### Problem: Agent returns vague findings

**Cause:** Agent drifted from the output format, usually because the prompt was paraphrased.

**Solution:** Re-dispatch that one agent with the exact output format skeleton from this skill. Include the phrase "no preamble, no summary — only findings in the specified format."

### Problem: Architecture agent didn't read siblings

**Cause:** The mandatory-first-step instruction got dropped or softened.

**Solution:** Look at its output — if there are no sibling file references in the findings, re-dispatch with "MANDATORY FIRST STEP" capitalized and first in the prompt body. Consider listing specific sibling candidates in the prompt.

### Problem: Two agents flag the same issue

**Cause:** Natural overlap (e.g., a dead function is both "basics: dead code" and "testing: no test for it"; a stale comment can be flagged by both `basics` and `repo-hygiene`).

**Solution:** In synthesis, keep the most severe finding and add a `(also flagged by X)` note. Don't print both. Lane attribution rule of thumb: if it's *unused/dead*, it's basics; if it points at a renamed/moved/missing target, it's repo-hygiene.

### Problem: repo-hygiene flags every env var as undocumented

**Cause:** The `.env.example` (or equivalent) file isn't in the repo, so the agent has nothing to compare against — and reads that as "all env vars undocumented."

**Solution:** If the project genuinely has no env-template file, that itself is one Major finding ("no `.env.example` exists; document required env vars there"), not one finding per env var. If the file lives under a non-standard name (`env.template`, `config.example.yml`), tell the agent where to look in the prompt.

### Problem: repo-hygiene flags secrets that are obviously fixtures

**Cause:** Test fixtures and example values look like real secrets to a pattern matcher (e.g., `"sk_test_..."` keys, fake JWTs in tests).

**Solution:** Findings should be **Critical only** when the value looks live (production-shaped key, real domain, non-test path). Test files, `*.example`, `*.sample`, and anything under a fixtures directory should be Minor at most, or skipped entirely if clearly placeholder. Re-dispatch the agent with that distinction stated explicitly.

### Problem: Scope is empty

**Cause:** No uncommitted changes and no branch diff against main.

**Solution:** Stop and tell the user — "No changes detected. Pass a path to review specific files, or use --branch <base> to compare against another branch." Do not fabricate a review.

### Problem: Diff is huge (hundreds of files)

**Cause:** Review scope caught a merge commit or a rebase.

**Solution:** Show the user the file count and ask whether to narrow scope (e.g., only files touched in the last commit). A 300-file review from five agents will be slow and the signal will be buried.

### Problem: Report is too long to be useful

**Cause:** Synthesis skipped the 5-Nit cap.

**Solution:** Phase 3 caps Nits at 5. Keep the 5 most actionable in full-block form; collapse the rest into a single closing line: `_…plus N similar nits across <file list>._` Critical/Major/Minor are never collapsed.

### Problem: REVIEW.md keeps showing up as a dirty file in git

**Cause:** REVIEW.md is a local review artifact, not a committed file.

**Solution:** Add `REVIEW.md` to `.gitignore` (project-level) or `~/.config/git/ignore` (global). The skill always overwrites it at the repo root — it's meant to be ephemeral.

### Problem: REVIEW.md written to the wrong directory

**Cause:** Used `cwd` instead of the git repo root.

**Solution:** Always resolve the target path with `git rev-parse --show-toplevel` before writing. If not inside a git repo, fall back to `cwd` and tell the user.

### Problem: Verifier dropped findings the user thinks are real

**Cause:** Verifier couldn't substantiate the citation against the current code (e.g., file moved between agent run and verification, or the agent quoted an approximate line number).

**Solution:** Verifier-demoted findings are tagged `[Unverified]` rather than dropped silently — they still appear in REVIEW.md one severity tier lower. If the user wants to re-promote, they can re-run `/code-review` after re-staging the file so the line numbers align. Persistent demotions usually point at agent-side line-number drift; refresh the diff and re-dispatch.

### Problem: Verifier kept everything (no demotions, no drops)

**Cause:** Verifier prompt was paraphrased and lost the substantiation requirement, or the agent findings were already strong enough.

**Solution:** Check the verifier's summary line — if it says `kept N of N; demoted 0; dropped 0` on a large finding set, re-dispatch with the exact verifier prompt from `reference/AGENTS.md#verifier`, emphasizing "re-read the cited line and confirm the issue is present in the current code."
