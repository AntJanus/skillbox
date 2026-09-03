---
name: setup-semantic-release
description: Use this skill to set up semantic-release and conventional commits in a repo whenever the user wants releases automated from commit messages. Triggers include "set up semantic release", "add conventional commits", "configure automated versioning", "set up commitlint", "add husky hooks", or "automate our changelog and GitHub releases" — even if they never name semantic-release and only ask for version bumps, tags, or a changelog to be generated for them. Do NOT use this skill for a hand-maintained CHANGELOG plus manual `git tag` flow (that stays manual by design), or for general CI pipeline work unrelated to releasing.
license: MIT
metadata:
  author: Antonin Januska
  version: "1.4.1"
---

# Setup Semantic Release & Conventional Commits

## Overview

Wires up automated versioning end to end: conventional commits → commitlint → husky → semantic-release. Version numbers, `CHANGELOG.md`, git tags, and GitHub releases are all derived from commit messages, so the only release input a human still writes is the commit subject. Enforce the format at author time and the rest is mechanical.

**Stop and say so if** the repo already has a `.releaserc*`, uses another release tool (changesets, release-it, standard-version), or has no `package.json` — a second release pipeline layered on the first produces double tags and duplicate changelog entries.

**Prerequisites:** `package.json`, a GitHub remote, Node ≥22.14 — or ≥24.10 on the 24.x line (the engines floor of `semantic-release@^25`, which dropped Node 20/21/23; `@commitlint/*@^21` needs ≥22.12) — and GitHub Actions.

## Setup workflow

### Phase 1: Install

```bash
npm install --save-dev \
  @commitlint/cli@^21.0.0 @commitlint/config-conventional@^21.0.0 \
  semantic-release@^25.0.0 @semantic-release/changelog@^6.0.0 \
  @semantic-release/git@^10.0.0 husky@^9.0.0
```

| Package | Purpose |
|---------|---------|
| `@commitlint/cli` + `config-conventional` | Validate commit messages against conventional rules |
| `semantic-release` | Automate version bumps, changelogs, releases |
| `@semantic-release/changelog` | Generate/update CHANGELOG.md |
| `@semantic-release/git` | Commit release artifacts back to repo |
| `husky` | Manage git hooks |

Check: every package listed above appears in `devDependencies` and `npm install` exited 0.

### Phase 2: Commitlint

Create `commitlint.config.js` — use `module.exports = {...}` instead of `export default` when package.json lacks `"type": "module"`:

```js
export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert',
    ]],
    'subject-case': [2, 'always', 'lower-case'],
    'header-max-length': [2, 'always', 100],
    'body-max-line-length': [0], // disable — conflicts with semantic-release notes
  },
};
```

Check: `commitlint.config.js` exists at the root and its module syntax matches `"type"` in package.json.

### Phase 3: Semantic-release

Create `.releaserc.json`. Plugin order is execution order, and `branches` must name the repo's actual default branch:

```json
{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    ["@semantic-release/changelog", { "changelogFile": "CHANGELOG.md" }],
    ["@semantic-release/git", {
      "assets": ["CHANGELOG.md", "package.json", "package-lock.json"],
      "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
    }],
    "@semantic-release/github"
  ]
}
```

Pre-release and multi-branch variants are in [references/REFERENCE.md](./references/REFERENCE.md).

Check: `.releaserc.json` exists at the root, `branches` names the default branch, and plugin order is analyzer → notes-generator → changelog → git → github.

### Phase 4: Husky hooks

```bash
npx husky init                                                # creates .husky/, adds "prepare": "husky"
echo 'npx --no -- commitlint --edit $1' > .husky/commit-msg    # validate every commit message
```

Pick the pre-commit check from the project's own `package.json` scripts rather than asking — first match wins: `lint` **and** `test` present → `npm run lint && npm test`; else `test`; else `lint`; else `build`.

```bash
echo 'npm run lint && npm test' > .husky/pre-commit   # substitute the matched command
```

If none of those scripts exist, `rm .husky/pre-commit` — a hook running a missing script fails every commit, and an empty one hides that nothing is checked.

Confirm `"prepare": "husky"` landed in package.json scripts; add it if `husky init` didn't. It reinstalls hooks on every `npm install`, and without it a fresh clone commits with no validation at all.

Check: `.husky/commit-msg` contains the commitlint command, `.husky/pre-commit` is set or deleted, and `"prepare": "husky"` is in package.json scripts.

### Phase 5: Starter CHANGELOG

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```

Semantic-release prepends each release above this header.

Check: `CHANGELOG.md` exists at the root.

### Phase 6: CI workflow

Create `.github/workflows/release.yml`:

```yaml
name: Release
on:
  push:
    branches: [main]
permissions:
  contents: write
  issues: write
  pull-requests: write
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0          # required — semantic-release needs full history
      - uses: actions/setup-node@v4
        with:
          node-version: 'lts/*'
      - run: npm ci
      - run: npx semantic-release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}   # drop unless you added @semantic-release/npm
```

`GITHUB_TOKEN` is supplied by Actions automatically. Update `branches` here and in `.releaserc.json` together if the default branch isn't `main`.

Check: `.github/workflows/release.yml` exists, `branches` matches `.releaserc.json`, and `NPM_TOKEN` is present only if `@semantic-release/npm` is in the plugin list.

## Quick reference

**Commit type → release:**

| Commit | Release |
|---|---|
| `feat: …` | minor |
| `fix: …` | patch |
| `feat!: …` or a `BREAKING CHANGE:` footer | major |
| `docs` `style` `refactor` `perf` `test` `build` `ci` `chore` `revert` | none |

**Creates:** `commitlint.config.js` · `.releaserc.json` · `.husky/commit-msg` · `.husky/pre-commit` (or deleted) · `CHANGELOG.md` · `.github/workflows/release.yml`, plus devDependencies and a `prepare` script in `package.json`.

**Smoke test:** `echo "feat: test" | npx commitlint` exits 0; `echo "bad" | npx commitlint` exits non-zero.

## Examples

✅ Subjects that release cleanly — type prefix, optional scope, lowercase:

```
feat(auth): add OAuth login          # minor bump
fix(api): handle null response       # patch bump
feat!: drop the v1 endpoints         # major bump
```

❌ Subjects that are rejected, or that ship a feature with no version at all:

```
updated auth stuff        # no type prefix — commitlint rejects the commit
feat: Add OAuth login     # capitalized — the subject-case rule rejects it
chore: add OAuth login    # accepted, but chore never releases; the feature ships unversioned
```

✅ Breaking change declared in the footer, so the generated notes explain the break:

```
feat(api): add pagination

Adds offset/limit to all list endpoints.

BREAKING CHANGE: removed `page` in favor of `offset`
```

✅ `commitlint.config.js` syntax matched to the package's module system:

```js
// package.json has no "type": "module"
module.exports = { extends: ['@commitlint/config-conventional'] };
```

❌ Same file in the same package — commitlint throws at config load and every commit fails before any rule runs:

```js
export default { extends: ['@commitlint/config-conventional'] };
```

## Gotchas

- **An explicit `plugins` array replaces the defaults, it does not extend them.** semantic-release's default list includes `@semantic-release/npm`; the Phase 3 config omits it, so nothing publishes to npm. Add `"@semantic-release/npm"` before `"@semantic-release/github"` when the package should publish — otherwise remove `NPM_TOKEN` from the workflow, because it does nothing. ([docs](https://semantic-release.gitbook.io/semantic-release/usage/plugins))
- **`@semantic-release/changelog` must precede `@semantic-release/git`.** Reversed, the git plugin commits a `CHANGELOG.md` that hasn't been written yet.
- **`body-max-line-length: [0]` is deliberate, not sloppiness.** semantic-release writes the full release notes into its own release commit body, which blows past the default 100-char limit and makes the release commit fail its own hook.
- **`subject-case: lower-case` rejects a capitalized subject.** `feat: Add feature` fails; `feat: add feature` passes. This is the single most common "but my message looks fine" rejection.
- **`fetch-depth: 0` is required in CI.** Actions clones shallow by default, leaving semantic-release with no tag history — it fails with `ENOGITHEAD` or `EGITNOBRANCH`.
- **`[skip ci]` in the git plugin's `message` prevents an infinite loop.** The release commit lands on the release branch and would otherwise trigger the workflow again.
- **Match `commitlint.config.js` to the package's module system** — see the last example pair; a mismatch fails every commit before any rule runs.

## Deep reference

Pre-release branch config and troubleshooting (husky hooks not running, duplicate changelog entries, CI loops, `ENOGITHEAD`) live in **[references/REFERENCE.md](./references/REFERENCE.md)** — load it when a phase's Check line fails, not up front.

## References

[Conventional Commits](https://www.conventionalcommits.org/) · [SemVer](https://semver.org/) · [semantic-release](https://semantic-release.gitbook.io/) · [commitlint](https://commitlint.js.org/) · [Husky](https://typicode.github.io/husky/). Pairs with **track-session** when the setup spans more than one sitting.
