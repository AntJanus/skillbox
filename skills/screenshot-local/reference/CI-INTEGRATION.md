# shot-scraper CI/CD Integration

Automate screenshot regeneration so docs stay current without manual effort. Load this when setting up automated capture pipelines.

## GitHub Actions Workflow

Regenerate screenshots on source changes and commit them back:

```yaml
name: Update Screenshots
on:
  push:
    branches: [main]
    paths: ["src/**", "shots.yml"]

jobs:
  screenshots:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install shot-scraper
        run: |
          pip install shot-scraper
          shot-scraper install

      - name: Capture screenshots
        run: |
          npm ci && npm run dev &
          sleep 5
          shot-scraper multi shots.yml

      - name: Commit updated screenshots
        uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: "docs: update screenshots"
          file_pattern: "screenshots/*.png"
```

**Key points:**
- `paths:` filter — workflow only fires on source or config changes
- `npm run dev &` + `sleep 5` — starts the dev server in background before capture
- `stefanzweifel/git-auto-commit-action` — commits images back; skip if you prefer manual review

## Auto-Starting the Dev Server (YAML `server` key)

For shots that need a running server, use the `server` key in `shots.yml` to let shot-scraper manage it:

```yaml
- url: http://localhost:3000
  output: screenshots/homepage.png
  width: 1280
  height: 800
  server: npm run dev
```

shot-scraper starts the server, waits for the port, captures, then shuts down. Cleaner than managing lifecycle in CI steps.

## Cost Control

Screenshot workflows run on every push — keep them lean:

- Use aggressive `paths:` filters — don't fire on docs-only changes
- Skip retina in CI if the output isn't for high-DPI display
- Reduce `height` for fixed-viewport shots — full-page captures are expensive
- Cache `shot-scraper install` output if your runner supports it
- Split batch configs — run only affected shots when a subset of pages changed

## Regression Testing with Screenshots

Unlike VHS ASCII output, screenshots don't diff cleanly — pixel differences are noisy. For UI regression testing, use dedicated tools (Percy, Chromatic, Playwright's `toHaveScreenshot`) rather than `diff`-ing `.png` files directly.

Keep shot-scraper for documentation artifacts, not regression gates.
