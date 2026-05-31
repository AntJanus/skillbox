# Semantic Release — Extended Reference

## Commit message cheat sheet

```
feat(auth): add login endpoint          # minor bump
fix(api): handle null response           # patch bump
feat!: redesign user model               # MAJOR bump
docs: update readme                      # no release
test: add unit tests for parser          # no release
chore: update dependencies               # no release
refactor(core): simplify error handling  # no release

# With body and breaking-change footer:
feat(api): add pagination support

Adds offset/limit parameters to all list endpoints.

BREAKING CHANGE: removed `page` parameter in favor of `offset`
```

✅ **Good** — clear types, optional scopes, lowercase subjects; semantic-release produces a clean changelog grouped by type:

```
feat(parser): add yaml frontmatter extraction
fix(writer): handle unicode in file paths
test: add e2e tests for compile workflow
chore(release): 1.0.0 [skip ci]
```

❌ **Bad** — no types, mixed concerns, uppercase, vague subjects; commitlint rejects these and no meaningful changelog can be derived:

```
Added parser stuff
WIP
updated tests and also fixed a bug and refactored
```

## Multi-branch / pre-release config

Adjust `.releaserc.json` `branches` for pre-releases:

```json
{
  "branches": [
    "main",
    { "name": "beta", "prerelease": true },
    { "name": "alpha", "prerelease": true }
  ]
}
```

## Per-step verification

| After phase | Check |
|-------------|-------|
| 1. Install | All packages in `devDependencies`, no install errors |
| 2. Commitlint | `commitlint.config.js` at root; module syntax matches project type (ESM vs CJS) |
| 3. Release config | `.releaserc.json` at root; `branches` matches default branch; plugin order analyzer→…→github |
| 4. Husky | `.husky/commit-msg` has the commitlint command; `.husky/pre-commit` set or removed per user choice |
| 5. Prepare | `"prepare": "husky"` in package.json scripts |
| 7. CI | `.github/workflows/release.yml` exists; branch matches; `NPM_TOKEN` set if publishing to npm |

Final smoke test:

```bash
echo "feat: test message" | npx commitlint   # exits 0
echo "bad message" | npx commitlint           # exits non-zero with errors
git commit -m "chore: set up semantic release and conventional commits"
npx semantic-release --dry-run                # shows next version (needs token locally)
```

## Troubleshooting

### Commitlint rejects valid-looking messages
Subject starts with uppercase or header exceeds 100 chars. `feat: Add feature` fails; `feat: add feature` passes (the `subject-case` rule enforces lowercase).

### Husky hooks don't run
Hooks not installed or `.husky/` missing. Re-run `npx husky init`, re-create the hook files, verify `"prepare": "husky"` is in package.json, run `npm install` to trigger it.

### Semantic-release creates duplicate changelog entries
The `body-max-line-length` rule conflicts with semantic-release's generated notes. Set `'body-max-line-length': [0]` in commitlint config (already in the template).

### CI release creates an infinite loop
The release commit triggers another CI run. The `[skip ci]` tag in the `@semantic-release/git` commit `message` prevents this — verify it's present.

### "ENOGITHEAD" / "EGITNOBRANCH" in CI
Shallow clone lacks full git history. Ensure `fetch-depth: 0` in the checkout step.
