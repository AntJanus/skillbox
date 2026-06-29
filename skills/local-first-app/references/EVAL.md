# Activation eval set

Spot-check 3–5 of these in a fresh Claude session to confirm the description triggers (and doesn't over-trigger). If activation is unreliable, rework the description in SKILL.md.

## Should trigger

1. "build me a local app to track my game backlog"
2. "single-user book/movie catalog that saves to my machine"
3. "a habit tracker that runs offline and persists locally"
4. "personal workout log, no account, data stays on disk"
5. "scaffold a recipe manager I can run as a desktop app"
6. "where should the rollup/summary logic live in my Next tracker app?"
7. "add a persisted entity with a zod-validated server action over node:sqlite"
8. "package this Next.js app as a downloadable desktop binary"
9. "small inventory manager that stores everything in a local SQLite file"
10. "a plant-care app that computes next-watering dates and saves my plants locally"

## Should NOT trigger (adjacent skills / out of scope)

1. "what hex colors should my dashboard use?"  → color-system (palette choice)
2. "fix the layout and spacing on this page"  → frontend-design
3. "what font size and line-height for body text?"  → typography
4. "debug this useEffect infinite loop"  → ideal-react-component
5. "add OAuth login and multi-tenant accounts"  → out of scope (multi-user auth)
6. "deploy this to Vercel with hosted Postgres"  → out of scope (hosted/server DB)
7. "build a REST API backend for my mobile app"  → out of scope (backend service, not local-first)
8. "review my code changes before I commit"  → code-review
9. "create a skill for running migrations"  → generate-skill (skill authoring, not app building)
10. "set up CI/CD for this repo"  → out of scope

**Load-bearing discriminators:** #5–#7 above are adjacent *app-building* requests the skill rejects via its scope clause (single-user, local-data, no hosted/multi-user backend). If activation over-fires on these, sharpen the `Do NOT…`/scope note in SKILL.md rather than the trigger list.
