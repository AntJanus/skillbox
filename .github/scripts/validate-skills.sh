#!/usr/bin/env bash
#
# validate-skills.sh — Validate all SKILL.md files in the skills/ directory.
#
# Checks:
#   1. YAML frontmatter has required fields (name, version, description)
#   2. Overview + Examples + Troubleshooting present (heading or progressive-disclosure
#      equivalent); When to Use / workflow-steps are soft warnings, not hard fails —
#      current house style folds triggers into the description and treats main content
#      as pattern-specific per skill type
#   3. SKILL.md is under 500 lines (unless reference/ or references/ subdir exists)
#   4. No broken internal links (referenced files in reference/ or references/ must exist)
#
# Usage:
#   .github/scripts/validate-skills.sh [skills-dir]
#   Default skills-dir: skills/

set -euo pipefail

SKILLS_DIR="${1:-skills}"
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0
ERRORS=()

# Colors for terminal output (disabled if not a TTY)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[0;33m'
  BOLD='\033[1m'
  RESET='\033[0m'
else
  GREEN=''
  RED=''
  YELLOW=''
  BOLD=''
  RESET=''
fi

pass() {
  echo -e "  ${GREEN}PASS${RESET} $1"
}

fail() {
  echo -e "  ${RED}FAIL${RESET} $1"
  ERRORS+=("$SKILL_NAME: $1")
}

warn() {
  echo -e "  ${YELLOW}WARN${RESET} $1"
}

# --------------------------------------------------------------------------
# Check 1: YAML frontmatter has required fields
# --------------------------------------------------------------------------
check_frontmatter() {
  local file="$1"
  local has_error=0

  # Verify file starts with ---
  local first_line
  first_line=$(head -n 1 "$file")
  if [ "$first_line" != "---" ]; then
    fail "Missing YAML frontmatter (file does not start with '---')"
    return 1
  fi

  # Extract frontmatter (between first and second ---)
  local frontmatter
  frontmatter=$(sed -n '2,/^---$/p' "$file" | sed '$d')

  if [ -z "$frontmatter" ]; then
    fail "Empty or malformed YAML frontmatter"
    return 1
  fi

  # Check for required top-level fields
  if ! echo "$frontmatter" | grep -qE '^name:'; then
    fail "Frontmatter missing 'name' field"
    has_error=1
  else
    pass "Frontmatter has 'name' field"
  fi

  if ! echo "$frontmatter" | grep -qE '^description:'; then
    fail "Frontmatter missing 'description' field"
    has_error=1
  else
    pass "Frontmatter has 'description' field"
  fi

  # Version can be top-level or under metadata
  if echo "$frontmatter" | grep -qE '^\s*version:'; then
    pass "Frontmatter has 'version' field"
  else
    fail "Frontmatter missing 'version' field (check metadata.version)"
    has_error=1
  fi

  return $has_error
}

# --------------------------------------------------------------------------
# Check 2: Required sections exist
# --------------------------------------------------------------------------
check_sections() {
  local file="$1"
  local has_error=0

  # Overview — an explicit heading, OR non-empty prose directly under the H1 title.
  # Current house style often skips the heading and leads straight into a summary
  # paragraph (title + core-principle sentence), which serves the same purpose.
  if grep -qE '^##\s+(Overview|Description)' "$file"; then
    pass "Has 'Overview' section"
  elif awk '/^# /{seen=1; next} seen && /^## /{exit} seen && NF>0{found=1} END{exit !found}' "$file"; then
    pass "Has intro content under the title (no separate Overview heading needed)"
  else
    fail "Missing an Overview — no heading and no prose before the first '##' section"
    has_error=1
  fi

  # "When to Use" now lives in the frontmatter description, not a body section
  # (house style: fold triggers into the description; the body only loads post-activation).
  # Soft-check only: warn if the description looks too short to carry real triggers.
  local desc_len
  desc_len=$(sed -n '2,/^---$/p' "$file" | sed '$d' | grep '^description:' | head -1 | wc -c | tr -d ' ')
  if [ -n "$desc_len" ] && [ "$desc_len" -lt 60 ]; then
    warn "description is short (${desc_len} chars) — when-to-use triggers belong in the description now, not a body section"
    WARN_COUNT=$((WARN_COUNT + 1))
  fi

  # Workflow/steps — deliberately pattern-specific per house style ("[Main Content -
  # Pattern Specific]"), so heading names vary too much to hard-enumerate reliably.
  # Soft-check: known headings pass silently; anything else just gets a warn to review.
  if grep -qE '^##\s+(Workflow|Steps|The Process|Usage Modes|The Skill Generation Process|Quick Start|The Workflow|Phase|Phases|Setup|Recording Workflow|How It Works|Quality Criteria|The Ideal Structure|Component Structure|Pipeline|Prerequisites)' "$file" || \
     grep -qE '^## Mode:' "$file" || \
     grep -qE '^##\s+Section [0-9]' "$file" || \
     grep -qE '^###\s+Phase [0-9]' "$file"; then
    pass "Has workflow/steps content"
  else
    warn "No recognized workflow/steps heading — main content is pattern-specific per house style; verify manually"
    WARN_COUNT=$((WARN_COUNT + 1))
  fi

  # Examples — a dedicated section (singular or plural heading), ✅/❌ comparison pairs
  # (current convention, inline or in a references/reference file), or the deprecated
  # <Good>/<Bad> tags (still accepted, with a warn).
  local ref_dir
  ref_dir=$(dirname "$file")
  if grep -qE '^##\s+Examples?' "$file"; then
    pass "Has 'Examples' section"
  elif grep -qF '✅' "$file" && grep -qF '❌' "$file"; then
    pass "Has examples (✅/❌ comparison pairs found)"
  elif { [ -d "${ref_dir}/references" ] && grep -qF '✅' "${ref_dir}/references/"*.md 2>/dev/null && grep -qF '❌' "${ref_dir}/references/"*.md 2>/dev/null; } || \
       { [ -d "${ref_dir}/reference" ] && grep -qF '✅' "${ref_dir}/reference/"*.md 2>/dev/null && grep -qF '❌' "${ref_dir}/reference/"*.md 2>/dev/null; }; then
    pass "Has examples (✅/❌ comparison pairs in a reference(s)/ file)"
  elif grep -qE '<Good>' "$file" && grep -qE '<Bad>' "$file"; then
    warn "Has examples via deprecated <Good>/<Bad> tags — migrate to ✅/❌"
    WARN_COUNT=$((WARN_COUNT + 1))
  else
    fail "Missing 'Examples' section (or ✅/❌ comparison pairs)"
    has_error=1
  fi

  # Troubleshooting — inline heading, OR 'Gotchas' (the current house-style equivalent —
  # per SkillBox's own checklist, Gotchas is now the highest-signal section), inline or
  # in any references/reference file under progressive disclosure. Checked by content,
  # not by filename — troubleshooting/gotchas content can live in any reference doc.
  local skill_dir
  skill_dir=$(dirname "$file")
  if grep -qE '^##\s+(Troubleshooting|Gotchas)' "$file"; then
    pass "Has 'Troubleshooting'/'Gotchas' section"
  elif { [ -d "${skill_dir}/references" ] && grep -qE '^##\s+(Troubleshooting|Gotchas)' "${skill_dir}/references/"*.md 2>/dev/null; } || \
       { [ -d "${skill_dir}/reference" ] && grep -qE '^##\s+(Troubleshooting|Gotchas)' "${skill_dir}/reference/"*.md 2>/dev/null; }; then
    pass "Has 'Troubleshooting'/'Gotchas' in a reference(s)/ file (progressive disclosure)"
  else
    fail "Missing 'Troubleshooting'/'Gotchas' section (inline or in a reference(s)/ file)"
    has_error=1
  fi

  return $has_error
}

# --------------------------------------------------------------------------
# Check 3: Line count under 500 (with progressive disclosure exception)
# --------------------------------------------------------------------------
check_line_count() {
  local file="$1"
  local skill_dir
  skill_dir=$(dirname "$file")
  local line_count
  line_count=$(wc -l < "$file" | tr -d ' ')

  if [ "$line_count" -le 500 ]; then
    pass "Line count: ${line_count}/500"
    return 0
  fi

  # Progressive disclosure: either references/ (canonical) or reference/ (legacy,
  # still used by a few not-yet-migrated skills) satisfies the exception.
  if [ -d "${skill_dir}/references" ] || [ -d "${skill_dir}/reference" ]; then
    warn "Line count: ${line_count}/500 (reference(s)/ dir exists — progressive disclosure)"
    WARN_COUNT=$((WARN_COUNT + 1))
    return 0
  else
    fail "Line count: ${line_count}/500 (exceeds limit, no reference(s)/ dir for progressive disclosure)"
    return 1
  fi
}

# --------------------------------------------------------------------------
# Check 4: No broken internal links
# --------------------------------------------------------------------------
check_internal_links() {
  local file="$1"
  local skill_dir
  skill_dir=$(dirname "$file")
  local has_error=0

  # Find markdown links to reference(s)/ files: [text](./reference/path), [text](reference/path),
  # and the plural references/ form (canonical per current house style).
  # Scoped to reference(s)/ paths only — these are the internal project files that must exist.
  # Bare ./file.md links in example text or code blocks are excluded.
  local links
  links=$(grep -oE '\]\(\.?/?references?/[^)]+\)' "$file" | sed -E 's/^\]\(\.?\/?//; s/\)$//' || true)

  if [ -z "$links" ]; then
    pass "No internal links to check"
    return 0
  fi

  while IFS= read -r link; do
    # Strip any anchor (#section)
    local file_path
    file_path=$(echo "$link" | sed 's/#.*//')
    if [ -z "$file_path" ]; then
      continue
    fi

    local full_path="${skill_dir}/${file_path}"
    if [ -f "$full_path" ]; then
      pass "Link OK: ${link}"
    else
      fail "Broken link: ${link} (file not found: ${full_path})"
      has_error=1
    fi
  done <<< "$links"

  return $has_error
}

# --------------------------------------------------------------------------
# Main
# --------------------------------------------------------------------------
echo -e "${BOLD}SkillBox Skill Validation${RESET}"
echo "========================="
echo ""

if [ ! -d "$SKILLS_DIR" ]; then
  echo -e "${RED}ERROR: Skills directory '${SKILLS_DIR}' not found${RESET}"
  exit 1
fi

skill_count=0

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_file="${skill_dir}SKILL.md"
  SKILL_NAME=$(basename "$skill_dir")

  if [ ! -f "$skill_file" ]; then
    echo -e "${YELLOW}SKIP${RESET} ${SKILL_NAME}/ — no SKILL.md found"
    continue
  fi

  skill_count=$((skill_count + 1))
  echo -e "${BOLD}--- ${SKILL_NAME} ---${RESET}"

  skill_pass=true

  check_frontmatter "$skill_file" || skill_pass=false
  check_sections "$skill_file" || skill_pass=false
  check_line_count "$skill_file" || skill_pass=false
  check_internal_links "$skill_file" || skill_pass=false

  if $skill_pass; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo -e "  ${GREEN}RESULT: PASS${RESET}"
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo -e "  ${RED}RESULT: FAIL${RESET}"
  fi
  echo ""
done

# --------------------------------------------------------------------------
# Summary
# --------------------------------------------------------------------------
echo "========================="
echo -e "${BOLD}Summary${RESET}"
echo "  Skills checked: ${skill_count}"
echo -e "  ${GREEN}Passed: ${PASS_COUNT}${RESET}"
echo -e "  ${RED}Failed: ${FAIL_COUNT}${RESET}"
if [ "$WARN_COUNT" -gt 0 ]; then
  echo -e "  ${YELLOW}Warnings: ${WARN_COUNT}${RESET}"
fi

if [ ${#ERRORS[@]} -gt 0 ]; then
  echo ""
  echo -e "${RED}Errors:${RESET}"
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
fi

echo ""

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo -e "${RED}Validation FAILED${RESET}"
  exit 1
else
  echo -e "${GREEN}Validation PASSED${RESET}"
  exit 0
fi
