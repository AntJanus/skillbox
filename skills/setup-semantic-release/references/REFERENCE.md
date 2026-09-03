# Semantic Release — Extended Reference

## No release produced

A history of only no-release types (`docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`) produces no version at all — semantic-release exits reporting there is nothing to release, which is correct behavior, not a misconfiguration. The type → release mapping is in SKILL.md's Quick reference.

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

## Dry run

After the commitlint smoke test in SKILL.md passes:

```bash
git commit -m "chore: set up semantic release and conventional commits"
npx semantic-release --dry-run                # prints the matched branch, analyzed commits, and next version (needs a token locally)
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

Either every commit since the last tag is a no-release type (see the no-release list above), or `branches` in `.releaserc.json` doesn't include the branch being pushed. `npx semantic-release --dry-run` prints which branch it matched and which commits it analyzed.

### The GitHub release fires but `CHANGELOG.md` is empty

`@semantic-release/changelog` is listed after `@semantic-release/git`, so the changelog file is written after the commit that was supposed to contain it. Reorder: analyzer → notes-generator → changelog → git → github.
