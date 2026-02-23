# shot-scraper Command Reference

Complete reference for all shot-scraper commands, flags, and subcommands.

## Installation

```bash
# Install globally via pipx
pipx install shot-scraper
shot-scraper install          # Install Chromium browser engine
shot-scraper install -b firefox   # Alternative browser
shot-scraper install -b webkit    # Alternative browser
```

## Subcommands

| Command | Purpose |
|---------|---------|
| `shot-scraper URL` | Take a single screenshot |
| `shot-scraper multi FILE` | Batch screenshots from YAML |
| `shot-scraper javascript URL JS` | Execute JS and return result |
| `shot-scraper pdf URL` | Generate PDF from page |
| `shot-scraper html URL` | Capture rendered HTML |
| `shot-scraper accessibility URL` | Dump accessibility tree |
| `shot-scraper install` | Install browser engine |
| `shot-scraper auth URL` | Interactive auth session |
| `shot-scraper har URL` | Record HTTP Archive |

## Screenshot Flags (Single Shot)

### Output

| Flag | Purpose | Example |
|------|---------|---------|
| `-o, --output` | Output filename (use `-` for stdout) | `-o page.png` |
| `--quality` | JPEG quality (triggers JPEG format) | `--quality 85` |
| `--retina` | 2x device pixel ratio | `--retina` |
| `--scale-factor` | Custom pixel ratio | `--scale-factor 2.625` |
| `--omit-background` | Transparent background (PNG only) | `--omit-background` |

### Viewport

| Flag | Purpose | Default |
|------|---------|---------|
| `-w, --width` | Browser viewport width | 1280 |
| `-h, --height` | Browser viewport height | Full page |
| `-p, --padding` | Padding around selector | 0 |

### Element Selection

| Flag | Purpose | Example |
|------|---------|---------|
| `-s, --selector` | CSS selector (first match) | `-s ".hero"` |
| `--selector-all` | All matching CSS elements | `--selector-all ".card"` |
| `--js-selector` | JS expression for element | `--js-selector "document.querySelector('.x')"` |
| `--js-selector-all` | JS expression for all elements | `--js-selector-all "document.querySelectorAll('.x')"` |

### Timing

| Flag | Purpose | Example |
|------|---------|---------|
| `--wait` | Wait ms after page load | `--wait 2000` |
| `--wait-for` | Wait until JS expression is true | `--wait-for "document.querySelector('.loaded')"` |
| `--timeout` | Failure timeout (ms) | `--timeout 10000` |

### JavaScript

| Flag | Purpose | Example |
|------|---------|---------|
| `-j, --javascript` | Execute JS before screenshot | `-j "document.querySelector('.modal')?.remove()"` |
| `--bypass-csp` | Bypass Content-Security-Policy | `--bypass-csp` |
| `--log-console` | Print console.log to stderr | `--log-console` |

### Browser

| Flag | Purpose | Options |
|------|---------|---------|
| `-b, --browser` | Browser engine | chromium, firefox, webkit, chrome, chrome-beta |
| `--browser-arg` | Extra Chromium flags | `--browser-arg="--disable-gpu"` |
| `--user-agent` | Custom User-Agent | `--user-agent "Bot/1.0"` |
| `--reduced-motion` | Emulate prefers-reduced-motion | `--reduced-motion` |

### Authentication

| Flag | Purpose | Example |
|------|---------|---------|
| `-a, --auth` | JSON auth context file | `-a auth.json` |
| `--auth-username` | HTTP Basic auth username | `--auth-username admin` |
| `--auth-password` | HTTP Basic auth password | `--auth-password secret` |

### Debugging

| Flag | Purpose |
|------|---------|
| `-i, --interactive` | Open browser for manual interaction before capture |
| `--devtools` | Interactive mode with DevTools open |
| `--log-requests FILE` | Write all network requests to NDJSON file |
| `--fail` | Exit with error code on HTTP failures |
| `--skip` | Skip pages with HTTP errors |
| `--silent` | Suppress output messages |

## Multi-Shot YAML Keys

All keys available in `shots.yml`:

### Core

| Key | Type | Purpose |
|-----|------|---------|
| `url` | string | Target URL or local file |
| `output` | string | Output filename |
| `width` | int | Viewport width |
| `height` | int | Viewport height |
| `quality` | int | JPEG quality |
| `retina` | bool | 2x pixel ratio |
| `omit_background` | bool | Transparent background |

### Selection

| Key | Type | Purpose |
|-----|------|---------|
| `selector` | string | CSS selector (first match) |
| `selectors` | list | Multiple CSS selectors |
| `selector_all` | string | All matching elements |
| `selectors_all` | list | Multiple selector-all patterns |
| `js_selector` | string | JS expression for element |
| `js_selector_all` | string | JS expression for all elements |
| `padding` | int | Padding around selector |

### Timing

| Key | Type | Purpose |
|-----|------|---------|
| `wait` | int | Wait ms after load |
| `wait_for` | string | JS condition to await |

### Execution

| Key | Type | Purpose |
|-----|------|---------|
| `javascript` | string | JS to execute before capture |
| `server` | string | Command to start a server process |

## PDF Command

```bash
shot-scraper pdf http://localhost:3000 -o page.pdf
shot-scraper pdf http://localhost:3000 --landscape -o page.pdf
shot-scraper pdf http://localhost:3000 -j "window.print = () => {}" -o page.pdf
```

## HTML Command

Capture the rendered HTML after JS execution:

```bash
shot-scraper html http://localhost:3000 -o page.html
shot-scraper html http://localhost:3000 -j "document.title" -o page.html
```

## Accessibility Command

Dump the accessibility tree as JSON:

```bash
shot-scraper accessibility http://localhost:3000 -o a11y.json
shot-scraper accessibility http://localhost:3000 -s ".main-content" -o a11y.json
```

## Auth Command

Create a reusable auth context:

```bash
# Opens browser for manual login, saves cookies
shot-scraper auth http://localhost:3000/login auth.json

# Use saved auth in screenshots
shot-scraper http://localhost:3000/admin -a auth.json -o admin.png
```

## HAR Command

Record HTTP Archive files:

```bash
shot-scraper har http://localhost:3000 -o trace.har
shot-scraper har http://localhost:3000 --har-zip -o trace.har.zip
```

## Useful Patterns

### Capture behind login

```bash
shot-scraper auth http://localhost:3000/login auth.json
shot-scraper http://localhost:3000/dashboard -a auth.json -o dashboard.png
```

### Multiple output formats

```bash
shot-scraper http://localhost:3000 -o page.png
shot-scraper http://localhost:3000 --quality 85 -o page.jpg
shot-scraper pdf http://localhost:3000 -o page.pdf
```

### Pipe to other tools

```bash
shot-scraper http://localhost:3000 -o - | imgcat  # Preview in iTerm2
shot-scraper http://localhost:3000 -o - | pngquant - -o optimized.png
```
