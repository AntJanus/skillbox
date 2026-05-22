# EVOLUTION_REPORT.md Format

The pipeline emits a single file — `EVOLUTION_REPORT.md` — committed to the experimental branch (never `main`). One `## Skill: <name>` block per skill that exceeded the friction threshold, followed by a pipeline-diagnostics footer.

Each skill block carries: a friction summary (count + type distribution), redacted representative examples, the proposed patch (rationale + expected reduction + unified diff), the replay-validation result, and a `Decision required` checklist the human ticks during review.

## Template

```markdown
# Skill Evolution Report — <YYYY-MM-DD-runid>

## Run Configuration
- Days scanned: 7
- Transcripts processed: N
- Friction events found: M
- Skills exceeding threshold: K (threshold: 3)
- Replay validation: enabled / skipped

## Skill: <name>

### Friction summary
- Events: N
- Distribution: {interruption: 4, wrong-approach: 2, correction: 1}

### Representative examples
1. <session-id>, <timestamp>: <redacted summary>
2. ...

### Proposed patch
- Rationale: <agent's rationale>
- Expected friction reduction: <agent's claim>

```diff
<unified diff against SKILL.md>
```

### Replay validation
- Sessions replayed: 3
- Friction reproduction rate (before patch): 3/3
- Friction reproduction rate (after patch): 1/3
- Caveat: replay is non-deterministic; treat as signal, not proof.

### Decision required
- [ ] Apply patch as-is
- [ ] Apply with modifications (note them)
- [ ] Reject patch (note rationale)
- [ ] Defer to next week

---

## Skill: <next-skill>
...

## Pipeline diagnostics
- Privacy scrub: PASS / WARN-ack / BLOCK
- Branch: experimental/evolve-skills/<runid>
- Run duration: 14m 22s
```
