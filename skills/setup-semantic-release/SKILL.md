---
name: setup-semantic-release
description: Set up semantic-release with conventional commits. Use when asked to "set up semantic release", "add conventional commits", "configure automated versioning", "set up commitlint", "add husky hooks", or "generate a changelog".
license: MIT
metadata:
  author: Antonin Januska
  version: "1.2.1"
---

# Setup Semantic Release & Conventional Commits

Wire up automated versioning: conventional commits → commitlint → husky hooks → semantic-release. Version bumps, changelogs, and GitHub releases are derived from commit messages. **Core principle:** commits drive releases — enforce format at author time, automate the rest.

**Skip if** the project already has `.releaserc*`, uses another release tool (changesets, release-it, standard-version), or has no `package.json`. **Prerequisites:** `package.json`, git remote on GitHub, Node ≥20.8.1 (the engines floor of the pinned `semantic-release@^24` — install fails on 18), and a CI environment (GitHub Actions).

## Phase 1: Install

```bash
npm install --save-dev \
  @commitlint/cli@^19.0.0 @commitlint/config-conventional@^19.0.0 \
  semantic-release@^24.0.0 @semantic-release/changelog@^6.0.0 \
  @semantic-release/git@^10.0.0 husky@^9.0.0
```

| Package | Purpose |
|---------|---------|
| `@commitlint/cli` + `config-conventional` | Validate commit messages against conventional rules |
| `semantic-release` | Automate version bumps, changelogs, releases |
| `@semantic-release/changelog` | Generate/update CHANGELOG.md |
| `@semantic-release/git` | Commit release artifacts back to repo |
| `husky` | Manage git hooks |

## Phase 2: Commitlint

Create `commitlint.config.js` (use `module.exports = {...}` if package.json lacks `"type": "module"`):

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

**Type → bump:** `feat` = minor · `fix` = patch · `feat!` or `BREAKING CHANGE:` footer = major · all others (`docs`, `test`, `chore`, …) = no release.

✅ `feat(auth): add OAuth login` — valid type + scope, triggers a minor release
❌ `updated auth stuff` — no type prefix; commitlint rejects it and no release happens

## Phase 3: Semantic-release

Create `.releaserc.json` (plugin order matters; set `branches` to your default branch):

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

`[skip ci]` prevents the release commit from triggering an infinite CI loop. For pre-release branches see [references/REFERENCE.md](./references/REFERENCE.md).

## Phase 4: Husky hooks

```bash
npx husky init                                          # creates .husky/, adds "prepare": "husky"
echo 'npx --no -- commitlint --edit $1' > .husky/commit-msg   # validate every commit message
```

Then **ask the user** what pre-commit check they want, and write it (or remove the default):

| Choice | Command |
|--------|---------|
| TypeScript build | `npm run build` |
| Lint | `npm run lint` |
| Test | `npm test` |
| Lint + Test | `npm run lint && npm test` |
| None | `rm .husky/pre-commit` |

```bash
echo '<chosen-command>' > .husky/pre-commit
```

If `npx husky init` didn't add `"prepare": "husky"` to package.json scripts, add it manually — it reinstalls hooks on every `npm install`.

## Phase 5: Starter CHANGELOG

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```

Semantic-release prepends entries on each release.

## Phase 6: CI workflow

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
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}   # only if publishing to npm; else remove
```

`GITHUB_TOKEN` is provided automatically. Update `branches` if your default isn't `main`.

## Files this creates

`commitlint.config.js` · `.releaserc.json` · `.husky/commit-msg` · `.husky/pre-commit` (or removed) · `CHANGELOG.md` · `.github/workflows/release.yml` · modifies `package.json` (devDeps + `prepare`).

## Verify & troubleshoot

Smoke test, per-phase verification checklist, the commit cheat sheet, and troubleshooting (commitlint rejections, husky not running, duplicate changelog entries, CI loops, `ENOGITHEAD`) are in **[references/REFERENCE.md](./references/REFERENCE.md)**.

Quick check: `echo "feat: test" | npx commitlint` exits 0; `echo "bad" | npx commitlint` fails.

## References

[Conventional Commits](https://www.conventionalcommits.org/) · [SemVer](https://semver.org/) · [semantic-release](https://semantic-release.gitbook.io/) · [commitlint](https://commitlint.js.org/) · [Husky](https://typicode.github.io/husky/). Pairs with **track-session** for tracking the setup across phases.
