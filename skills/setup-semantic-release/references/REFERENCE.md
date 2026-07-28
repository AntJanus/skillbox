# Semantic Release — Extended Reference

## Commit type cheat sheet

The full accepted-type list and what each one does to the version. `feat` and `fix` are the only types that release on their own.

```
feat(auth): add login endpoint           # minor bump
fix(api): handle null response           # patch bump
feat!: redesign user model               # MAJOR bump
docs: update readme                      # no release
style: reformat with prettier            # no release
refactor(core): simplify error handling  # no release
perf(parser): cache compiled regexes     # no release
test: add unit tests for parser          # no release
build: switch to esbuild                 # no release
ci: cache node_modules                   # no release
chore: update dependencies               # no release
revert: revert "feat: add login"         # no release
```

A history of only no-release types produces no version at all — semantic-release exits reporting there is nothing to release, which is correct behavior, not a misconfiguration.

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
| 4. Husky | `.husky/commit-msg` has the commitlint command; `.husky/pre-commit` set or removed per user choice; `"prepare": "husky"` in package.json scripts |
| 5. Changelog | Starter `CHANGELOG.md` exists at root |
| 6. CI | `.github/workflows/release.yml` exists; branch matches; `NPM_TOKEN` set if publishing to npm |

Final smoke test:

```bash
echo "feat: test message" | npx commitlint   # exits 0
echo "bad message" | npx commitlint           # exits non-zero with errors
git commit -m "chore: set up semantic release and conventional commits"
npx semantic-release --dry-run                # shows next version (needs token locally)
```

## Troubleshooting

Symptoms whose cause is already covered by the Gotchas in `SKILL.md` — check the named setting first:

| Symptom | Setting to check |
|---|---|
| Commitlint rejects a message that looks fine | `subject-case` (lowercase subject) and `header-max-length` (100) |
| Every commit fails before commitlint prints any rule violations | `commitlint.config.js` module syntax vs the package's `"type"` |
| Release commit itself fails the hook | `'body-max-line-length': [0]` |
| CI releases in a loop | `[skip ci]` in the `@semantic-release/git` message |
| `ENOGITHEAD` / `EGITNOBRANCH` in CI | `fetch-depth: 0` on the checkout step |
| Release succeeds but nothing lands on npm | `@semantic-release/npm` missing from the `plugins` array |

### Husky hooks don't run at all

`.husky/` is missing, or the hooks were never installed into `.git/hooks`. Re-run `npx husky init`, re-create the hook files, confirm `"prepare": "husky"` is in package.json scripts, then run `npm install` to trigger it. Hooks also stay dormant for anyone who cloned before `prepare` existed until they reinstall.

### semantic-release reports "no release published" on a branch with new work

Either every commit since the last tag is a no-release type (see the cheat sheet above), or `branches` in `.releaserc.json` doesn't include the branch being pushed. `npx semantic-release --dry-run` prints which branch it matched and which commits it analyzed.

### The GitHub release fires but `CHANGELOG.md` is empty

`@semantic-release/changelog` is listed after `@semantic-release/git`, so the changelog file is written after the commit that was supposed to contain it. Reorder: analyzer → notes-generator → changelog → git → github.
