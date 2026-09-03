#!/usr/bin/env python3
"""Report description length, body lines, and estimated body tokens for a SKILL.md,
or (`score` mode) turn seven rate-skill category scores into the weighted table and letter."""
import sys

RUBRIC = [
    ("Description quality", 25),
    ("Frontmatter validity", 20),
    ("Length & disclosure", 15),
    ("Structure", 15),
    ("Examples", 10),
    ("Conciseness", 10),
    ("Anti-patterns/calib.", 5),
]


def letter_grade(total: float) -> str:
    for floor, letter in ((90, "A"), (80, "B"), (70, "C"), (60, "D")):
        if total >= floor:
            return letter
    return "F"


if len(sys.argv) > 1 and sys.argv[1] == "score":
    scores = [int(value) for value in sys.argv[2:]]
    if len(scores) != len(RUBRIC) or any(not 0 <= score <= 100 for score in scores):
        sys.exit("usage: measure.py score <7 category scores 0-100, in rubric order>")
    total = 0.0
    print("| Category | Score | Weight | Weighted |")
    print("|---|---|---|---|")
    for (category, weight), score in zip(RUBRIC, scores):
        weighted = score * weight / 100
        total += weighted
        print(f"| {category:<21} | {score:>3} | {weight:>2} | {weighted:>4.1f} |")
    print(f"\nOverall: {letter_grade(total)} ({total:.1f}/100)")
    sys.exit(0)

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
