# Experimental Skills

Skills in this folder are **research-grade**. They generate proposals, run analyses, or perform actions that are speculative enough to require human review before any change lands.

Treat this folder as a sandbox — its contents are not part of the public skillbox release surface, and SKILLs here may have rougher edges than `skillbox/skills/`.

## Conventions

Every experimental skill MUST:

1. **Run on a branch.** Never operate against `main`. The skill creates or checks out a feature branch (e.g., `experimental/<skill-name>/<run-id>`) before touching anything.
2. **Produce a report, not a merged change.** The skill's output is a markdown report (e.g., `EVOLUTION_REPORT.md`, `BUG_SQUASH_REPORT.md`). Any code/skill diffs the skill generates live on the branch — they do not auto-merge into `main`.
3. **Pass through `/publish-check`** before any report is surfaced. Reports can pull in transcript snippets, file paths, and historical context — all sources of leakable PII. The privacy gate is non-optional.
4. **Surface decisions via `AskUserQuestion`.** The user decides what merges. Never auto-merge, auto-tag, or auto-publish.
5. **Document run state.** Each run leaves a `RUN.md` (or similar) in the skill folder describing what was run, what was generated, and what's pending review.

## Lifecycle

```
experimental/<name>/
└── SKILL.md              # The experimental skill itself
└── reference/            # Patterns, fixtures, prompts
└── runs/                 # Per-run output (gitignored or reviewed before commit)
    └── <date>-<id>/
        ├── REPORT.md
        ├── proposed-patches/
        └── replay-logs/
```

## Graduating a skill from experimental → skills/

A skill is ready to leave experimental when:

- It has run successfully against ≥3 distinct real scenarios.
- Output quality is consistent (no false positives that would block users).
- Privacy gate has caught at least one real leak (or the maintainer has manually verified the gate covers all categories the skill could surface).
- A human reviewer has signed off on the skill's behavior.

To graduate:

1. Create a graduation PR from the experimental branch.
2. Move the skill folder from `experimental/<name>/` to `skills/<name>/`.
3. Bump version to `1.0.0` and add a CHANGELOG entry.
4. Update the main `README.md` to list the new skill.
5. Run `/rate-skill skills/<name>/SKILL.md` and address findings until grade is A or B.

## Running experimental skills

Most experimental skills assume:

- You are inside the skillbox repo on a worktree or feature branch dedicated to the run.
- `/publish-check` is installed (see `~/.claude/skills/publish-check/`).
- You have committed any in-progress work elsewhere — experimental skills should not be run on a dirty tree.

## Current experimental skills

_None yet. The first experimental skill is `evolve-skills`, in development._

## Why a separate folder?

Experimental skills break two implicit guarantees of `skills/`:

- **Determinism.** Production skills produce predictable, reproducible output. Experimental skills can produce different output across runs (e.g., friction-clustering depends on transcript volume).
- **Read-only safety.** Production skills are mostly read-only or operate on a single user-controlled scope. Experimental skills generate code, propose patches, and run replays — all of which need extra guardrails.

Keeping them in a separate folder makes the contract explicit: anything in `skillbox/skills/` is ready to use on real work; anything in `skillbox/experimental/` is research that needs supervision.
