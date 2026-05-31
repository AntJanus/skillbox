---
name: screenshot-local
description: Capture screenshots of local dev servers with shot-scraper. Use when asked to "screenshot my app", "take a screenshot of localhost", "generate screenshots for docs", "batch screenshot my pages", or "set up shot-scraper".
license: MIT
argument-hint: "<url-or-file> [--output filename.png]"
metadata:
  author: Antonin Januska
  version: "1.3.0"
---

# Screenshot Local — shot-scraper

Capture screenshots of local dev servers and HTML files with [shot-scraper](https://github.com/simonw/shot-scraper) (installed via pipx). **Core principle:** screenshots should be reproducible from a command or committed YAML config, not manual captures. For terminal/CLI recordings use `record-tui` (VHS) instead.

## Prerequisites

```bash
brew install pipx            # or: apt install pipx / pip install pipx
pipx install shot-scraper
shot-scraper install         # installs Chromium; add -b firefox / -b webkit for others
shot-scraper --version       # verify
```

If the command isn't found after install, run `pipx ensurepath` and reopen the shell.

## Capture

```bash
shot-scraper http://localhost:3000 -o homepage.png              # localhost page
shot-scraper index.html -o preview.png                          # local HTML file
shot-scraper http://localhost:3000 -w 1200 -h 800 -o home.png   # fixed viewport
shot-scraper http://localhost:3000 --retina -o home@2x.png      # 2x for high-DPI
shot-scraper http://localhost:3000 -s ".hero" -p 20 -o hero.png # element + padding
shot-scraper http://localhost:3000 --wait-for "document.querySelector('.loaded')" -o page.png
shot-scraper http://localhost:3000 -j "document.querySelector('.cookie-banner')?.remove()" -o clean.png
shot-scraper pdf http://localhost:3000 -o page.pdf              # PDF export
shot-scraper http://localhost:3000 -i                           # interactive debug
```

| Flag | Purpose |
|------|---------|
| `-o` | Output filename |
| `-w` / `-h` | Viewport width / height (omit `-h` for full page) |
| `-s` / `--selector-all` | Capture one / all matching elements |
| `-p` | Padding around selector (px) |
| `--retina` | 2x device pixel ratio |
| `--quality N` | Save as JPEG at quality N |
| `--wait N` / `--wait-for "expr"` | Wait ms / until JS returns true |
| `-j "js"` | Run JS before capture (dismiss modals, set state) |
| `--omit-background` | Transparent background (PNG) |
| `-b` | Browser: chromium / firefox / webkit |

Full flag list: **[reference/COMMAND-REFERENCE.md](./reference/COMMAND-REFERENCE.md)**.

## Batch with YAML

Commit a `shots.yml` and run `shot-scraper multi shots.yml`:

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
    document.querySelector('.loading-spinner')?.remove()

- url: http://localhost:3000
  output: screenshots/mobile-home.png
  width: 375
  height: 812
```

**Supported keys:** `url`, `output`, `width`, `height`, `quality`, `wait`, `wait_for`, `selector`, `selectors`, `selector_all`, `padding`, `javascript`, `js_selector`, `retina`, `omit_background`. Copy-paste configs per project type: **[reference/TEMPLATES.md](./reference/TEMPLATES.md)**.

## Recommended dimensions

| Use case | Width | Height | Format |
|----------|-------|--------|--------|
| README hero | 1280 | 800 | PNG |
| Docs screenshot | 1200 | auto | PNG |
| Social/OG image | 1200 | 630 | PNG |
| Mobile / Tablet | 375 / 768 | 812 / 1024 | PNG |
| Full page | 1280 | (omit) | PNG |

## Generating a config for a project

When asked to set up screenshots for a project: read its routes (router config, page files, nav), identify key UI states (loading, empty, populated, error) and the dev-server port, then write a `shots.yml` covering the key screens. Validate with `shot-scraper multi shots.yml` and iterate on timing/selectors.

✅ **Good** — explicit dimensions, SPA waits, organized output, JS cleanup:

```yaml
- url: http://localhost:3000/dashboard
  output: screenshots/dashboard.png
  width: 1280
  height: 900
  wait: 2000
  javascript: |
    document.querySelector('.toast-notification')?.remove()
```

❌ **Bad** — no `output` (messy auto-names), no `width` (inconsistent across machines), no `wait` on an SPA route (captures the loading spinner), output dumped at project root.

## Troubleshooting

- **Blank page / loading spinner** — SPA hasn't hydrated. Add `--wait 3000` or `--wait-for "document.querySelector('.content')"`.
- **"Connection refused"** — dev server not running or wrong port. Start it first (`npm run dev &`), verify with `curl -I http://localhost:3000`, or use the YAML `server` key to auto-start.
- **Wrong dimensions** — `--retina` doubles pixels (1280w → 2560px); set `-h` for a fixed viewport, omit it for full page.
- **Elements missing** — wrong selector or lazy-loaded content. Debug visually with `-i` or `--devtools`.

## CI/CD

Automate regeneration with GitHub Actions so docs stay current; the YAML `server` key auto-starts a dev server during capture. See **[reference/CI-INTEGRATION.md](./reference/CI-INTEGRATION.md)**.

## Integration & references

Pairs with **record-tui** (terminal recordings) and **track-session** (iteration tracking). External: [shot-scraper](https://github.com/simonw/shot-scraper) · [docs](https://shot-scraper.datasette.io/) · [GH Actions template](https://github.com/simonw/shot-scraper-template) · [pipx](https://pipx.pypa.io/).
