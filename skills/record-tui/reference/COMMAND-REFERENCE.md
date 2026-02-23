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

All settings MUST appear before interaction commands (except `TypingSpeed`).

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
Ctrl+c                              # Control+C (interrupt)
Ctrl+d                              # Control+D (EOF)
Ctrl+l                              # Control+L (clear)
Ctrl+z                              # Control+Z (suspend)
Alt+Enter                           # Alt+Enter
Shift+Tab                           # Shift+Tab
Ctrl+Alt+Delete                     # Multiple modifiers
Shift+Up                            # Shift+Arrow
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
```

`Wait` is essential for TUI apps with variable startup times.

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

## Capture

```tape
Screenshot demo-step1.png           # Capture current frame as PNG
```

## Environment and Composition

```tape
Env MY_VAR "value"                  # Set environment variable
Env TERM "xterm-256color"           # Common for TUI color support
Source setup.tape                    # Include commands from another tape
Require node                        # Fail if program not in PATH
```

## Recommended Dimensions by Use Case

| Use Case | Width | Height | FontSize |
|----------|-------|--------|----------|
| README GIF | 1200 | 600 | 20 |
| Docs/tutorial | 1400 | 800 | 18 |
| Social media | 1200 | 630 | 22 |
| Full TUI app | 1600 | 900 | 16 |
| Compact CLI demo | 800 | 400 | 20 |

## Timing Guidelines

| Situation | Recommended Sleep |
|-----------|------------------|
| After typing a command | 500ms |
| After pressing Enter | 2-3s |
| After launching a TUI | 2-3s |
| Between navigation steps | 300-500ms |
| Final frame (before loop) | 3-5s |
| After form submission | 1-2s |
