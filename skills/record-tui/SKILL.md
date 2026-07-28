---
name: record-tui
description: Use this skill to record a terminal or TUI demo with VHS whenever the user wants to "record a demo", "create a GIF of my CLI", "write a VHS tape", "make a terminal recording", or "add a demo GIF to the README" — even if they never say "VHS" and only ask for an animated demo of a command-line tool. Covers tape syntax, dimensions, pacing, GIF size reduction, and CI golden-file recording. Do NOT use this skill to screenshot a web app on localhost (see screenshot-local) or to capture video of anything outside a terminal.
license: MIT
argument-hint: "<app-command> [output-format]"
metadata:
  author: Antonin Januska
  version: "1.6.0"
---

# Record TUI — VHS Terminal Recording

## Overview

[Charmbracelet VHS](https://github.com/charmbracelet/vhs) renders a `.tape` script to GIF / MP4 / WebM / ASCII. Write the demo as code rather than capturing a screen, because a `.tape` re-renders unattended when the app changes and runs the same way in CI. For a throwaway recording nobody will re-run, `asciinema` is lighter.

## Setup

```bash
# macOS
brew install charmbracelet/tap/vhs ffmpeg ttyd
# Debian/Ubuntu
sudo apt install ffmpeg && sudo snap install ttyd --classic && go install github.com/charmbracelet/vhs@latest

vhs --version && ffmpeg -version && ttyd --version   # all three are required
```

## Tape file structure

Every `Set` goes above the first interaction command. A `Set` placed lower is silently discarded — see Gotchas.

```tape
Output demo.gif              # 1. output (gif/mp4/webm/ascii)
Require my-app               # 2. fail fast if the app is missing

Set Shell "bash"             # 3. settings, all grouped before any command
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Frappe"
Set WindowBar Colorful
Set Padding 20
Set TypingSpeed 75ms

Hide                         # 4. hidden setup — Ctrl+L before Show
Type "export TERM=xterm-256color"
Enter
Sleep 500ms
Ctrl+L
Show

Type "my-app --demo"         # 5. visible interactions, with deliberate pauses
Sleep 500ms
Enter
Sleep 2s
Down 3                       # 6. app interaction
Enter
Sleep 3s                     # generous final frame before the loop restarts
```

## Quick reference

| Command | Purpose |
|---------|---------|
| `Output file.gif` | Output file + format (gif/mp4/webm/ascii); repeat for several formats |
| `Require app` | Fail if the program is not on PATH |
| `Set Key Value` | Terminal settings (FontSize, Width, Height, Theme, Framerate, …) |
| `Type "text"` / `Type@100ms "text"` | Emulate typing (optionally at a per-line speed) |
| `Enter` / `Tab` / `Space` / `Escape` | Key presses |
| `Up`/`Down`/`Left`/`Right` (`Down 3`) | Navigation with optional repeat count |
| `Ctrl+key`, `Alt+key`, `Shift+key` | Modifier combos |
| `Sleep 2s` | Fixed pause (ms or s) |
| `Wait+Screen@30s /regex/` | Block until screen content matches, with a timeout |
| `Hide` / `Show` | Control recording visibility (execution continues either way) |
| `Screenshot file.png` | Capture the current frame |
| `Env VAR "val"` / `Source other.tape` | Set an env var / include another tape |

```bash
vhs validate demo.tape    # parse-check, no rendering
vhs demo.tape             # record
vhs themes                # list themes
vhs new demo.tape         # scaffold from template
```

Full command + settings detail: **[reference/COMMAND-REFERENCE.md](./reference/COMMAND-REFERENCE.md)**.

| Use case | Width | Height | FontSize |
|----------|-------|--------|----------|
| README GIF | 1200 | 600 | 20 |
| Docs/tutorial | 1400 | 800 | 18 |
| Social media | 1200 | 630 | 22 |
| Full TUI app | 1600 | 900 | 16 |
| Compact CLI | 800 | 400 | 20 |

## Recording a tape for an app

Read the app's `--help` output or its source to learn how it launches, which keys it responds to, and which states are worth showing. Draft a tape covering those states, then `vhs validate demo.tape` → `vhs demo.tape` → watch the rendered file → adjust. Watching is the step that matters: validation parses syntax and cannot tell you the demo outruns the viewer.

Copy-paste starting points (Basic CLI, Interactive TUI, Build-and-Run, Multi-Panel, CI golden file, composable `Source` tapes): **[reference/TEMPLATES.md](./reference/TEMPLATES.md)**.

## Examples

✅ Output first, settings grouped above the commands, `Require` guarding the binary, a pause after typing and a long final frame:

```tape
Output demo.gif
Require my-app

Set Shell "bash"
Set FontSize 20
Set Width 1200
Set Height 600

Type "my-app status"
Sleep 500ms
Enter
Sleep 3s
```

❌ Same tape, three defects — `Set Width` lands after `Type` and is dropped, nothing separates typing from execution, and a missing binary produces a confusing empty GIF instead of an error:

```tape
Output demo.gif

Type "my-app status"
Enter
Set Width 1200
```

✅ Pacing a TUI whose startup time varies — wait on a screen match instead of guessing a `Sleep`:

```tape
Type "my-tui"
Enter
Wait+Screen@30s /Ready/
Down 3
Sleep 500ms
Enter
Sleep 3s
```

## Gotchas

- **A `Set` below the first command is silently dropped, and `vhs validate` still exits 0.** Verified on vhs 0.11.0: `Set FontSize 40` after a `Type` rendered at the default size, and the same holds for `Set TypingSpeed` — there is no per-setting exception. Keep every `Set` above the first `Type`/key command and confirm by watching the output, because nothing in the toolchain reports this.
- **`vhs validate` only parses.** It never launches the app, so a missing binary, a wrong keybinding, or a demo that races ahead of the app all pass. Add `Require <app>` so a missing dependency fails loudly rather than rendering an empty terminal.
- **`Type "cmd"` does not press Enter.** Follow it with an explicit `Enter`, and put `Sleep 500ms` between them so the viewer can read the command before it runs.
- **`Hide` hides output, not execution.** Commands inside a `Hide` block still run. End the block with `Ctrl+L` before `Show` so leftover setup output doesn't open the recording.
- **`Wait` times out.** Raise it per command (`Wait+Screen@30s /ready/`) or globally (`Set WaitTimeout 30s`) for a slow-booting TUI, rather than padding with a longer `Sleep` that will still be wrong on a slower machine.
- **VHS records in a fresh shell, so your prompt customizations are absent.** Pin `Set Shell "bash"` to get the same prompt on your machine and in CI.
- **A TUI that renders with wrong colors or wrapping is usually a terminal-setup problem.** Pin it in the `Hide` block: `Env TERM "xterm-256color"` plus `Type "stty rows 50 cols 120"`.
- **GIFs cross 5 MB quickly.** GitHub renders them inline, but the README crawls. Try `Set Framerate 15` first — it is the cheapest win and costs little perceived smoothness — then `gifsicle -O3 --lossy=80`, and switch to MP4 before shrinking dimensions past readability.

## Optimize & CI

Size reduction, playback tuning, and the GIF-vs-MP4-vs-WebM decision tree: **[reference/OPTIMIZATION.md](./reference/OPTIMIZATION.md)**. Recording in GitHub Actions, plus ASCII output as a golden file for UI regression tests: **[reference/CI-INTEGRATION.md](./reference/CI-INTEGRATION.md)**.

## Integration

Pairs with **build-tui** — record the TUI right after building it, and commit the `.tape` next to the source so the GIF regenerates with the app. Use **screenshot-local** instead when the target is a web UI on localhost.

External: [VHS](https://github.com/charmbracelet/vhs) · [VHS Action](https://github.com/charmbracelet/vhs-action) · [examples](https://github.com/charmbracelet/vhs/tree/main/examples) · [themes](https://github.com/charmbracelet/vhs/blob/main/THEMES.md) · [gifsicle](https://www.lcdf.org/gifsicle/).
