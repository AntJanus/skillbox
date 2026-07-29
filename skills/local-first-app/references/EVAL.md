# Activation eval set

The description-optimization loop this set feeds (agentskills.io/skill-creation/optimizing-descriptions).
20 queries, 10 should-trigger and 10 should-not, split 60/40 with a proportional mix in both halves.

## Protocol

Run each query in a **fresh session**, ~3 times. Trigger rate = fraction of runs that invoked the
skill. A should-trigger query passes above **0.5**; a should-not-trigger query passes below it.

Iterate on **train failures only** — rework the description in SKILL.md, never against validation.
Check validation after, and **select the description with the best validation score**: an earlier
draft can beat the last one, because later iterations overfit the train half. Five iterations is
usually enough.

Keep the split below **fixed** across iterations. Reshuffling it invalidates the comparison.

Caveat: agents consult skills for tasks beyond what they handle alone, so a trivially simple query
may not trigger even a well-described skill. Don't churn the description over those.

## Train (12 — 6 should-trigger, 6 should-not)

**Should trigger**

1. "build me a local app to track my game backlog"
2. "a habit tracker that runs offline and persists locally"
3. "personal workout log, no account, data stays on disk"
4. "where should the rollup/summary logic live in my Next tracker app?"
5. "add a persisted entity with a zod-validated server action over node:sqlite"
6. "small inventory manager that stores everything in a local SQLite file"

**Should NOT trigger**

1. "what hex colors should my dashboard use?" → color-system
2. "fix the layout and spacing on this page" → frontend-design
3. "add OAuth login and multi-tenant accounts" → out of scope (multi-user auth)
4. "deploy this to Vercel with hosted Postgres" → out of scope (hosted/server DB)
5. "review my code changes before I commit" → code-review
6. "set up CI/CD for this repo" → out of scope

## Validation (8 — 4 should-trigger, 4 should-not)

**Should trigger**

1. "single-user book/movie catalog that saves to my machine"
2. "scaffold a recipe manager I can run as a desktop app"
3. "package this Next.js app as a downloadable desktop binary"
4. "a plant-care app that computes next-watering dates and saves my plants locally"

**Should NOT trigger**

1. "what font size and line-height for body text?" → typography
2. "debug this useEffect infinite loop" → ideal-react-component
3. "build a REST API backend for my mobile app" → out of scope (backend service)
4. "create a skill for running migrations" → generate-skill (skill authoring, not app building)

## Load-bearing discriminators

The adjacent *app-building* requests — hosted Postgres, multi-tenant auth, a mobile backend — are
the ones the skill rejects on scope rather than on topic, and they sit in both halves deliberately.
If activation over-fires on those, sharpen the scope clause in the description rather than the
trigger list.
