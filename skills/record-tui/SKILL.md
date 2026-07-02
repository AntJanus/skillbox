---
name: record-tui
description: Records terminal demos and TUI screencasts with VHS. Use this skill whenever the user wants to "record a demo", "create a GIF of my CLI", "write a VHS tape", "make a terminal recording", or "add a demo GIF to the README".
license: MIT
argument-hint: "<app-command> [output-format]"
metadata:
  author: Antonin Januska
  version: "1.5.1"
---

# Record TUI — VHS Terminal Recording

Record polished terminal demos with [Charmbracelet VHS](https://github.com/charmbracelet/vhs) — `.tape` scripts → GIF / MP4 / WebM, reproducible and CI-friendly. **Core principle:** write tape files as code, not screen captures; every demo reproducible from one `.tape`. For web UIs use `screenshot-local` instead; for throwaway recordings use `asciinema`.

## Prerequisites

```bash
# macOS
brew install charmbracelet/tap/vhs ffmpeg ttyd
# Debian/Ubuntu
sudo apt install ffmpeg && sudo snap install ttyd --classic && go install github.com/charmbracelet/vhs@latest

vhs --version && ffmpeg -version && ttyd --version   # verify all three
```

## Tape file structure

Settings must come before commands:

```tape
Output demo.gif              # 1. output (gif/mp4/webm/ascii)
Require my-app               # 2. fail fast if dependency missing

Set Shell "bash"             # 3. settings, grouped before any command
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Frappe"
Set WindowBar Colorful
Set Padding 20
Set TypingSpeed 75ms

Hide                         # 4. hidden setup — always Ctrl+L before Show
Type "export TERM=xterm-256color"
Enter
Sleep 500ms
Ctrl+L
Show

Type "my-app --demo"         # 5. visible interactions, with deliberate pauses
Sleep 500ms
Enter
Sleep 2s
Down Down Down               # 6. app interaction
Enter
Sleep 3s                     # generous final frame for the loop
```

| Command | Purpose |
|---------|---------|
| `Output file.gif` | Output file + format (gif/mp4/webm/ascii) |
| `Require app` | Fail if dependency missing |
| `Set Key Value` | Terminal settings (FontSize, Width, Height, Theme, …) |
| `Type "text"` / `Type@100ms "text"` | Emulate typing (optionally at a set speed) |
| `Enter` / `Tab` / `Space` | Key presses |
| `Up`/`Down`/`Left`/`Right` (`Down 3`) | Navigation with optional repeat |
| `Ctrl+key` | Modifier combos |
| `Sleep 2s` | Pause (ms or s) |
| `Wait+Screen /regex/` | Wait until screen content matches |
| `Hide` / `Show` | Control recording visibility |
| `Screenshot file.png` | Capture current frame |
| `Env VAR "val"` / `Source other.tape` | Set env var / include another tape |

Full command + settings detail: **[reference/COMMAND-REFERENCE.md](./reference/COMMAND-REFERENCE.md)**.

## CLI

```bash
vhs validate demo.tape    # check syntax
vhs demo.tape             # record
vhs themes                # list themes
vhs new demo.tape         # scaffold from template
```

## Recommended dimensions

| Use case | Width | Height | FontSize |
|----------|-------|--------|----------|
| README GIF | 1200 | 600 | 20 |
| Docs/tutorial | 1400 | 800 | 18 |
| Social media | 1200 | 630 | 22 |
| Full TUI app | 1600 | 900 | 16 |
| Compact CLI | 800 | 400 | 20 |

## Generating a tape for an app

Read the app's code or `--help` to learn how it launches, which keys it responds to, and the states worth showing. Build a tape covering its key features, then `vhs validate demo.tape` → `vhs demo.tape` → review → adjust timing/interactions. Copy-paste starting points (Basic CLI, Interactive TUI, Build-and-Run, Multi-Panel, CI golden file, composable `Source` tapes): **[reference/TEMPLATES.md](./reference/TEMPLATES.md)**.

✅ **Good** — output first, settings grouped, `Require`, hidden setup with `Ctrl+L`, deliberate pacing (`Sleep 500ms` after typing, `2-3s` after Enter, `3s` final frame).

❌ **Bad** — no `Output`; `Set` scattered among commands (errors/ignored); no `Sleep` after `Enter` (output flashes by); rapid-fire `Tab Tab Tab` the viewer can't follow; dimensions too small for a TUI; no `Require` (silently fails if app missing).

## Optimize & CI

Keep README GIFs under ~5 MB: `Set Framerate 15`, reduce dimensions, speed slow sections with `Set PlaybackSpeed`, or post-process `gifsicle -O3 --lossy=80 demo.gif -o demo-small.gif`; if still large, use MP4 with a `<video>` tag. Details + format decision tree: **[reference/OPTIMIZATION.md](./reference/OPTIMIZATION.md)**. Automate recording in CI (ASCII output enables golden-file regression tests): **[reference/CI-INTEGRATION.md](./reference/CI-INTEGRATION.md)**.

## Troubleshooting

- **Choppy GIF** — `Set Framerate 15`, don't speed playback; if still choppy reduce dimensions or use MP4.
- **TUI renders wrong** — set the terminal up in a `Hide` block: `Env TERM "xterm-256color"`, `Type "stty rows 50 cols 120"`, `Ctrl+L`, `Show`.
- **Keys arrive before app is ready** — add `Sleep 1-3s` after launch, or `Wait+Screen /ready/` for variable startup.
- **GIF too large for GitHub** — reduce dimensions/framerate, speed slow sections, `gifsicle` post-process, or switch to MP4.

## Integration & references

Pairs with **build-tui** (record TUIs you build) and **track-session** (iteration tracking). External: [VHS](https://github.com/charmbracelet/vhs) · [VHS Action](https://github.com/charmbracelet/vhs-action) · [examples](https://github.com/charmbracelet/vhs/tree/main/examples) · [themes](https://github.com/charmbracelet/vhs/blob/main/THEMES.md) · [gifsicle](https://www.lcdf.org/gifsicle/).
