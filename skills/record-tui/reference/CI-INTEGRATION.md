# VHS CI/CD Integration

Automate demo recording so README GIFs stay current without manual effort. Load this when setting up automated demo pipelines or golden-file regression tests.

## GitHub Actions Workflow

Record on push to main, commit the updated GIF back:

```yaml
name: Record Demo
on:
  push:
    branches: [main]
    paths:
      - "demo.tape"
      - "src/**"

jobs:
  record:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Record demo
        uses: charmbracelet/vhs-action@v2
        with:
          path: "demo.tape"

      - name: Commit updated GIF
        uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: "docs: update demo recording"
          file_pattern: "*.gif"
```

**Key points:**
- `paths:` filter means the workflow only fires when source or tape changes
- `charmbracelet/vhs-action@v2` handles VHS + ffmpeg + ttyd installation
- `stefanzweifel/git-auto-commit-action` commits the GIF back — skip if you prefer manual review

## Golden File Regression Testing

Detect UI regressions by comparing ASCII output against a committed baseline:

```tape
Output demo.ascii
# ... your interactions ...
```

```bash
# In CI: compare against committed golden file
vhs demo.tape
diff demo.ascii demo.ascii.golden
```

**When the diff fails:** either the UI changed legitimately (update the golden) or there's a regression (fix the code). The workflow forces the decision.

## Regenerating Goldens

Add a manual step for intentional golden updates:

```yaml
- name: Update golden (manual trigger only)
  if: github.event_name == 'workflow_dispatch'
  run: |
    vhs demo.tape
    mv demo.ascii demo.ascii.golden
    git add demo.ascii.golden
    git commit -m "test: update vhs golden"
    git push
```

## Cost Control

Recording runs on every push — keep it fast:

- Use `paths:` filters so the workflow only fires on relevant changes
- Target `Set Width` / `Set Height` to match your final use case (no wasted pixels)
- Use `Set Framerate 15` for CI — faster recording, smaller artifacts
- Split long demos into separate tape files that can skip unchanged sections
