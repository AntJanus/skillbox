# VHS Command Reference

Complete reference for all VHS tape file commands and settings.

## Output Formats

```tape
Output demo.gif          # Animated GIF (most common)
Output demo.mp4          # MP4 video
Output demo.webm         # WebM video
Output frames/           # PNG frame sequence
Output demo.txt          # ASCII text capture
Output demo.ascii        # ASCII golden file (for CI diffing)
```

Multiple outputs can be declared — VHS generates all of them in one run.

## Settings

Settings take effect only when they appear before the first interaction command — there is no exception for `TypingSpeed`. A later `Set` is silently discarded and `vhs validate` still exits 0, so the only way to catch a misplaced setting is to watch the rendered output. To vary typing speed mid-tape, use the per-line `Type@100ms "…"` form instead.

### Terminal Dimensions

```tape
Set Width 1200                      # Terminal width in pixels
Set Height 600                      # Terminal height in pixels
Set Padding 20                      # Inner padding
Set Margin 0                        # Outer margin
Set MarginFill "#674EFF"            # Margin color
```

### Font

```tape
Set FontSize 20                     # Font size in pixels
Set FontFamily "JetBrains Mono"     # Font name
Set LetterSpacing 1                 # Character spacing
Set LineHeight 1.2                  # Line height multiplier
```

### Appearance

```tape
Set Theme "Catppuccin Frappe"       # Color theme (use `vhs themes` to list)
Set WindowBar Colorful              # none | Colorful
Set BorderRadius 8                  # Corner rounding
Set CursorBlink false               # Cursor blinking
```

### Playback

```tape
Set Framerate 24                    # GIF framerate (lower = smaller file)
Set PlaybackSpeed 1.0               # Speed multiplier
Set LoopOffset 60%                  # GIF loop point
Set TypingSpeed 75ms                # Delay between keystrokes
```

### Shell

```tape
Set Shell "bash"                    # Shell to use (bash, zsh, fish, etc.)
```

## Input Commands

### Typing

```tape
Type "text here"                    # Type characters
Type@100ms "slower text"            # Override typing speed for this line
Type@30ms "fast boilerplate"        # Speed through unimportant text
```

### Key Presses

```tape
Enter                               # Press Enter
Space                               # Press Space
Tab                                 # Press Tab
Backspace                           # Delete backward
Backspace 5                         # Delete 5 characters
```

### Navigation

```tape
Up                                  # Arrow up
Down                                # Arrow down
Left                                # Arrow left
Right                               # Arrow right
Up 5                                # Press up 5 times
Down 3                              # Press down 3 times
PageUp                              # Page up
PageDown                            # Page down
Insert                              # Insert key
Delete                              # Delete key
```

### Modifier Keys

```tape
Ctrl+C                              # Control+C (interrupt)
Ctrl+D                              # Control+D (EOF)
Ctrl+L                              # Control+L (clear)
Ctrl+Z                              # Control+Z (suspend)
Alt+Enter                           # Alt+Enter
Shift+Tab                           # Shift+Tab
Ctrl+Alt+Delete                     # Multiple modifiers
Shift+Up                            # Shift+Arrow
```

Key names are case-insensitive (`Ctrl+l` and `Ctrl+L` both parse); this reference uses
uppercase throughout so tapes read consistently.

### Other Keys

```tape
Escape                              # Escape key
ScrollUp 3                          # Scroll wheel up, with repeat
ScrollDown 3                        # Scroll wheel down, with repeat
Copy "text"                         # Put text on the clipboard
Paste                               # Paste from the clipboard
```

## Timing Commands

```tape
Sleep 500ms                         # Pause (milliseconds)
Sleep 2s                            # Pause (seconds)
Sleep 1.5s                          # Pause (fractional seconds)
```

### Wait (Conditional Timing)

```tape
Wait /regex/                        # Wait for text pattern in output
Wait+Screen /regex/                 # Wait for pattern on screen
Wait+Line /regex/                   # Wait for pattern on a line
Wait+Screen@30s /ready/             # Same, with a per-command timeout
Set WaitTimeout 30s                 # Global timeout for every Wait
```

`Wait` is essential for TUI apps with variable startup times. It gives up once the
timeout elapses, so raise the timeout for a slow-booting app rather than falling back
to a fixed `Sleep` that will still be wrong on a slower machine.

## Visibility Control

```tape
Hide                                # Stop recording output
Show                                # Resume recording output
```

Use `Hide`/`Show` to:
- Build/compile without cluttering the demo
- Set up environment variables
- Navigate to the right directory
- Clean up after the demo

**Always `Ctrl+L` before `Show`** — clears the screen so the visible recording starts clean without leftover output from hidden setup commands:

```tape
Hide
Type "some-setup-command"
Enter
Sleep 1s
Ctrl+L
Show
```

## Capture

```tape
Screenshot demo-step1.png           # Capture current frame as PNG
```

## Environment and Composition

```tape
Env MY_VAR "value"                  # Set environment variable
Env TERM "xterm-256color"           # Common for TUI color support
Source setup.tape                   # Include commands from another tape
Require node                        # Fail if program not in PATH
```

## Where the rest lives

Recommended dimensions per use case are in `SKILL.md`; sleep/pacing guidelines are in
`OPTIMIZATION.md`. Both are kept in one place so they can't drift apart.
