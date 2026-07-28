#!/usr/bin/env python3
"""Report description length, body lines, and estimated body tokens for a SKILL.md."""
import sys

try:
    import yaml
except ModuleNotFoundError:
    sys.exit("measure.py needs PyYAML: pip install pyyaml (or pipx/uv equivalent)")

path = sys.argv[1] if len(sys.argv) > 1 else "SKILL.md"
raw_text = open(path).read()
parts = raw_text.split("---", 2)
frontmatter, body = parts[1], parts[2]
description = yaml.safe_load(frontmatter)["description"]

print(f"description: {len(description)} chars (cap 1024)")
print(f"body lines:  {body.count(chr(10))} (aim <300, cap 500)")
print(f"body tokens: ~{len(body) // 4} (cap ~5000)")
