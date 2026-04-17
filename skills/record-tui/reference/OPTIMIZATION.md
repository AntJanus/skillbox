# VHS Output Optimization

Reduce file size, tune timing, and produce viewer-friendly output. Load this when a tape produces bloated or choppy results.

## GIF Size Reduction

GIFs get large quickly. Use these tape-level settings first:

```tape
Set Framerate 15          # Lower framerate (default 30)
Set PlaybackSpeed 1.5     # Speed up slow parts
Set Width 800             # Smaller dimensions
```

Post-process with gifsicle for further reduction:

```bash
gifsicle -O3 --lossy=80 demo.gif -o demo-optimized.gif
```

## Target Sizes

| Use | Size limit | Reason |
|-----|-----------|--------|
| README GIF | < 5 MB | GitHub renders inline |
| Docs GIF | < 10 MB | Reasonable load time |
| Over 10 MB | switch to MP4/WebM | GIF is the wrong format |

## Timing Guidelines

Pacing is what separates a polished demo from a rushed one. These rules consistently produce readable output:

- `Sleep 500ms` after typing a command — lets the viewer read what was typed before it runs
- `Sleep 2-3s` after Enter — lets the viewer see the output
- `Sleep 3-5s` on the final frame — prevents abrupt loop restart
- `Set LoopOffset 0%` for smoother GIF looping
- `Type@100ms` for important text the viewer should follow
- `Type@30ms` for boilerplate the viewer doesn't need to read

## Format Decision Tree

```
Size < 5 MB & static UI?       → GIF (universal support)
Size > 5 MB & browser target?  → MP4 or WebM
Needs transparency?             → WebM
Needs regression testing?       → ASCII (see golden file testing)
```

## ASCII Output for Regression Testing

VHS can emit plain-text ASCII from a tape — useful for CI golden-file comparisons:

```tape
Output demo.ascii
# ... same interactions as your GIF tape
```

```bash
vhs demo.tape
diff demo.ascii demo.ascii.golden
```

Commit the `.golden` file alongside source. Re-regenerate whenever the UI legitimately changes.
