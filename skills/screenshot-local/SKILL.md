---
name: screenshot-local
description: Use this skill to screenshot a local dev server or HTML file with shot-scraper whenever the user wants to "screenshot my app", "take a screenshot of localhost", "generate screenshots for the README", "batch screenshot my pages", or "set up shot-scraper" — even if they never name shot-scraper and just ask for an image of a page, an OG image, or pictures for the docs. Do NOT use this skill for terminal or CLI recordings (see record-tui), for starting or debugging the app itself (see the project's run skill), or for editing an image that already exists.
license: MIT
argument-hint: "<url-or-file> [--output filename.png]"
metadata:
  author: Antonin Januska
  version: "1.5.0"
---

# Screenshot Local — shot-scraper

## Overview

Capture screenshots of local dev servers and static HTML files with [shot-scraper](https://github.com/simonw/shot-scraper), a Playwright wrapper installed via pipx. Prefer a committed `shots.yml` over one-off commands whenever more than one image is involved — a capture the repo can regenerate stays current, while a manual one rots the moment the UI changes.

## Install

```bash
pipx install shot-scraper     # brew install pipx / apt install pipx first
shot-scraper install          # downloads Chromium — a separate step, easy to miss
shot-scraper --version
```

`command not found` after installing means pipx isn't on `PATH`: run `pipx ensurepath`, then reopen the shell.

## Command Surface

| Subcommand | Purpose |
|---|---|
| `shot-scraper URL` | One screenshot |
| `shot-scraper multi shots.yml` | Batch from YAML |
| `shot-scraper pdf URL` | PDF export |
| `shot-scraper auth URL auth.json` | Save a login session for reuse |
| `shot-scraper accessibility URL` | Dump the accessibility tree as JSON |

| Flag | Purpose |
|---|---|
| `-o` | Output filename (`-` for stdout) |
| `-w` / `-h` | Viewport width / height — omit `-h` for a full-page shot |
| `-s` / `--selector-all` | Capture the first / every matching element |
| `-p` | Padding around the selector, in px |
| `--retina` | 2x device pixel ratio |
| `--quality N` | Save as JPEG at quality N |
| `--wait N` / `--wait-for "expr"` | Wait N ms / until a JS expression is truthy |
| `-j "js"` | Run JS before capture — dismiss modals, seed state |
| `-a auth.json` | Reuse a saved auth context |
| `-i` / `--devtools` | Open the browser to debug a shot interactively |

Every flag and YAML key: **[reference/COMMAND-REFERENCE.md](./reference/COMMAND-REFERENCE.md)**. Upstream docs: <https://shot-scraper.datasette.io/>.

Dimensions to use when the user doesn't name any:

| Use case | Width | Height |
|---|---|---|
| README hero | 1280 | 800 |
| Docs screenshot | 1200 | omit (full page) |
| Social / OG image | 1200 | 630 |
| Mobile / tablet | 375 / 768 | 812 / 1024 |

## Sample Invocation

One-off captures:

```bash
shot-scraper http://localhost:3000 -o homepage.png
shot-scraper index.html -o preview.png
shot-scraper http://localhost:3000 -w 1200 -h 630 -o og.png
shot-scraper http://localhost:3000 -s ".hero" -p 20 --retina -o hero@2x.png
shot-scraper http://localhost:3000 --wait-for "document.querySelector('.loaded')" -o app.png
```

Setting up a project's screenshots: read its router config, page files, or nav to find the real routes and the dev-server port, choose the states worth documenting (populated beats empty), write `shots.yml`, then run `shot-scraper multi shots.yml`. Expect the first run to need timing or selector adjustments — open the resulting images and confirm they show the intended UI before reporting the job done.

✅ Explicit dimensions, an SPA wait, output under a directory, transient chrome removed:

```yaml
- url: http://localhost:3000
  output: screenshots/homepage.png
  width: 1280
  height: 800

- url: http://localhost:3000/dashboard
  output: screenshots/dashboard.png
  width: 1280
  height: 900
  wait: 2000
  javascript: |
    document.querySelector('.toast-notification')?.remove()
```

❌ Captures the loading spinner into a machine-dependent auto-named file dumped at the repo root:

```yaml
- url: http://localhost:3000/dashboard
```

✅ Fixed-dimension OG image — both `-w` and `-h` set, `--retina` omitted:

```bash
shot-scraper http://localhost:3000 -w 1200 -h 630 -o og.png
```

❌ `--retina` on a spec'd size — writes a 2400×1260 file into a slot that wants 1200×630, and the failure stays invisible until the card renders wrong:

```bash
shot-scraper http://localhost:3000 -w 1200 -h 630 --retina -o og.png
```

✅ Full-page docs capture — omit `-h` deliberately so height tracks content:

```bash
shot-scraper http://localhost:3000/docs -w 1200 -o docs.png
```

Starter configs per project type — SPA, Storybook, responsive sweep, static site, auth: **[reference/TEMPLATES.md](./reference/TEMPLATES.md)**.

## Failure Modes

- **"Connection refused"** — nothing is serving that port. Start the dev server (`npm run dev &`), confirm with `curl -I http://localhost:3000`, or hand the lifecycle to shot-scraper via the YAML `server:` key.
- **Blank page or a loading spinner** — the SPA hadn't hydrated when the shot fired. Prefer `--wait-for "document.querySelector('.content')"` over a fixed `--wait 3000`, because a fixed wait tuned on a warm laptop fails on a slower CI runner.
- **Empty image or the wrong element** — the selector matched nothing, or the content lazy-loads below the fold. Reproduce with `-i` and inspect the live page instead of guessing at another selector.
- **Timeout on a heavy page** — raise `--timeout 30000`. The default gives up sooner than a cold Next.js dev server takes to compile a route on first request.
- **Passes locally, fails in CI** — the runner never ran `shot-scraper install`, so no browser engine exists. Install the engine as its own CI step.

## Gotchas

- **`shot-scraper install` is a second, separate install step.** `pipx install shot-scraper` alone leaves no browser engine behind, so the first capture on a fresh machine or CI runner fails.
- **`--quality` switches the format to JPEG regardless of the output extension.** `--quality 80 -o hero.png` writes JPEG bytes into a file named `.png` (verified on 1.9.1). Omit `--quality` when you want a real PNG.
- **`--retina` doubles the output pixels, not the layout.** `-w 1200 --retina` produces a 2400px-wide file, which breaks fixed-size targets like a 1200×630 OG image. Use it for README art, not for spec'd dimensions.
- **A per-shot `auth:` key in `shots.yml` is silently ignored** — the shot still succeeds, just logged out, so the failure looks like a broken page rather than missing auth. Pass auth to the whole batch instead: `shot-scraper multi shots.yml -a auth.json`.
- **Omitting `-h` makes the height track the content**, so two captures of the same route can differ in size. Set an explicit `-h` for before/after pairs.
- **The YAML `server:` process spans the entire `multi` run** and is torn down at the end (`--leave-server` keeps it). One `server:` entry covers the batch; repeating it per shot doesn't start more servers.
- **Screenshots don't diff cleanly.** Antialiasing and font rendering make PNG diffs noisy, so keep shot-scraper for documentation artifacts and reach for Percy, Chromatic, or Playwright's `toHaveScreenshot` when the goal is a regression gate.

## CI

Regenerate screenshots on source changes with a GitHub Actions workflow and commit them back — full workflow, cost controls, and the `server:` key pattern: **[reference/CI-INTEGRATION.md](./reference/CI-INTEGRATION.md)**.
