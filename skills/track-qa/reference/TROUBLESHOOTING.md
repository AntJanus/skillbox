# Track QA — Extended Troubleshooting

Edge cases and gotchas not covered in the main `SKILL.md` Troubleshooting section.

---

## Migrate mode: portfolio file format unfamiliar

**Symptom:** `/track-qa migrate` is run against a `QA_BACKLOG.md` (or similar) that doesn't have one section per repo.

**Diagnosis:** The migrate mode expects either ad-hoc per-repo notes (CLAUDE.md, README.md) OR a portfolio-level file with `### project-name` headings followed by checklist items. Other layouts need manual splitting.

**Resolution:**
- Ask the user to identify which lines belong to which project
- Or, run migrate per-section: open the portfolio file, copy one repo's lines into a temp file, run migrate on the temp file, repeat per repo

---

## Migrate mode: ID collisions

**Symptom:** Generated IDs collide with IDs already used elsewhere in the project (e.g., the project also has a SESSION_PROGRESS.md with `t_` IDs and the migrator tries to reuse one).

**Diagnosis:** Should never happen — `q_` IDs share no namespace with `r_`, `t_`, `f_`, `i_`. If you see a collision, the migrator is using the wrong prefix.

**Resolution:**
- Verify the migrator is generating `q_` prefixed IDs
- Run the validate-skills script to catch malformed IDs

---

## Audit mode: passed items reset too aggressively

**Symptom:** Audit proposes resetting every passed item to pending, even items that were verified yesterday.

**Diagnosis:** The 30-day staleness heuristic is a default — if the project has a release cadence shorter than 30 days, the heuristic should be tightened (or skipped for items younger than the most recent release).

**Resolution:**
- During audit, ask: "What's the project's release cadence?"
- Adjust the staleness window accordingly (e.g., reset only items older than the last release tag)
- Don't reset items the user explicitly says are still valid

---

## cc-dash dashboard: items don't appear after writing QA.md

**Symptom:** Wrote a new QA.md, refreshed the dashboard, items don't show.

**Diagnosis (in order):**
1. Discovery cache — the dashboard caches discovered projects. Restart the dev server or wait for the next refresh tick.
2. Frontmatter validity — if `schema:` isn't exactly `cc-dash/qa@1`, discovery skips the file.
3. File location — QA.md must be in the project root, alongside ROADMAP.md / SESSION_PROGRESS.md.
4. Item format — items that don't match the `- <!-- id:q_xxxxx status:... --> Description` shape are silently skipped by the parser.

**Resolution:**
- Open the file in VS Code; the YAML frontmatter and HTML comments should syntax-highlight cleanly.
- Run the dashboard's MCP `get_qa_for_project` tool against the project — it returns parser errors verbatim if the file is malformed.

---

## Failed items pile up after a roadmap fix

**Symptom:** A QA item was failed and a roadmap issue was filed. The roadmap issue was completed, but the QA item is still marked failed.

**Diagnosis:** Failing → Reset is a one-way reset; cc-dash does not auto-flip the QA item back to pending when the linked roadmap item moves to `done`. This is by design — the QAer should re-verify after the fix lands, not trust that the fix worked.

**Resolution:**
- After the roadmap fix is verified, run `/track-qa update` and reset the QA item to pending
- Re-run the QA check
- If it passes this time, mark passed; if it fails again, file a new roadmap issue (the original roadmap item is closed, so a new one captures the regression context)

---

## "Needs-decision" items never resolve

**Symptom:** Items marked `needs-decision` accumulate over months without being addressed.

**Diagnosis:** Decision items represent design questions, not execution tasks. They block on a conversation, not on engineering work. Without a forcing function, conversations are easy to defer indefinitely.

**Resolution:**
- During `/track-qa audit`, surface every needs-decision item older than 2 weeks
- Either schedule the conversation, convert to a normal pending item with a specific resolution path, or remove the item if the question is no longer relevant
- Consider: a needs-decision item that has been open for 3 months is signal that the question is actually unimportant — remove it

---

## QA.md disagrees with ROADMAP.md after manual edits

**Symptom:** A user manually edited ROADMAP.md to delete a `qa-issues` category item that was filed by `failQaItem`. Now the QA item's `roadmapRef` points to a non-existent ID.

**Diagnosis:** The cross-link is one-way (QA item references roadmap item, not vice versa). Deleting the roadmap item without updating the QA item leaves a dangling reference.

**Resolution:**
- The dashboard surfaces the roadmap ref as a link; clicking it 404s into the roadmap (or shows the missing item gracefully)
- Run `/track-qa audit`; the audit should detect dangling refs
- Reset the QA item to pending OR clear the `roadmapRef` (manually editing the HTML comment is fine — IDs are immutable but optional fields aren't)
