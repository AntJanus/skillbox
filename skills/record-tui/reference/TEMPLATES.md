# VHS Tape Templates

Copy-paste templates for common recording scenarios.

## Basic CLI Demo

```tape
Output demo.gif
Require my-cli

Set Shell "bash"
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Frappe"
Set WindowBar Colorful
Set TypingSpeed 75ms
Set Padding 20

Type "my-cli --help"
Sleep 500ms
Enter
Sleep 3s

Type "my-cli run example"
Sleep 500ms
Enter
Sleep 5s
```

## Interactive TUI Demo

```tape
Output demo.gif
Require my-tui

Set Shell "bash"
Set FontSize 18
Set Width 1400
Set Height 800
Set Theme "Dracula"
Set WindowBar Colorful
Set TypingSpeed 50ms
Set Padding 20

# Launch the app
Type "my-tui"
Sleep 300ms
Enter
Sleep 2s

# Navigate the interface
Down Down Down
Sleep 500ms
Enter
Sleep 1s

# Interact with a form
Type "Hello World"
Sleep 500ms
Tab
Type "Description here"
Sleep 500ms
Enter
Sleep 2s

# Show result
Sleep 3s

# Exit
Ctrl+c
Sleep 500ms
```

## Build-and-Run Demo

Use `Hide`/`Show` to build from source without cluttering the recording.

```tape
Output demo.gif
Require go

Set Shell "bash"
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Frappe"
Set WindowBar Colorful
Set TypingSpeed 75ms

# Build the app (hidden from recording)
Hide
Type "go build -o my-app ."
Enter
Sleep 5s
Ctrl+L
Show

# Show the app in action
Type "./my-app"
Sleep 300ms
Enter
Sleep 2s

# Interact
Down Down
Enter
Sleep 3s
```

## Multi-Panel TUI (lazygit, k9s, etc.)

```tape
Output demo.gif
Require lazygit

Set Shell "bash"
Set FontSize 16
Set Width 1600
Set Height 900
Set Theme "Tokyo Night"
Set WindowBar Colorful
Set TypingSpeed 50ms

# Setup a demo repo (hidden)
Hide
Type "cd /tmp && mkdir demo-repo && cd demo-repo && git init"
Enter
Sleep 1s
Type "echo 'hello' > file.txt && git add . && git commit -m 'init'"
Enter
Sleep 2s
Ctrl+L
Show

# Launch
Type "lazygit"
Sleep 300ms
Enter
Sleep 2s

# Navigate panels
Tab
Sleep 500ms
Tab
Sleep 500ms

# Stage a file
Space
Sleep 500ms

# Open commit dialog
Type "c"
Sleep 500ms
Type "feat: add feature"
Enter
Sleep 2s

# Show result
Sleep 3s

# Exit
Type "q"
Sleep 1s
```

## CI Golden File Testing

Use ASCII output for regression testing.

```tape
Output demo.ascii
Require my-cli

Set Shell "bash"
Set Width 80
Set Height 24

Type "my-cli --version"
Enter
Sleep 1s

Type "my-cli status"
Enter
Sleep 2s
```

Compare in CI:
```bash
vhs demo.tape
diff demo.ascii demo.ascii.golden
```

## Multi-Format Output

Generate GIF, MP4, and screenshots in one tape.

```tape
Output demo.gif
Output demo.mp4
Output demo.webm

Set Shell "bash"
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Frappe"
Set WindowBar Colorful
Set TypingSpeed 75ms

Type "my-app"
Enter
Sleep 2s

# Capture a key moment
Screenshot hero-image.png

Down Down
Enter
Sleep 3s
```

## Composable Tapes with Source

Split long recordings into reusable parts.

**setup.tape:**
```tape
Set Shell "bash"
Set FontSize 20
Set Width 1200
Set Height 600
Set Theme "Catppuccin Frappe"
Set WindowBar Colorful
Set TypingSpeed 75ms
```

**demo.tape:**
```tape
Output demo.gif
Source setup.tape

Type "my-app"
Enter
Sleep 3s
```

This keeps settings DRY across multiple recordings.
