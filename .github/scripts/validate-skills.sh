#!/usr/bin/env bash
#
# validate-skills.sh — Validate all SKILL.md files in the skills/ directory.
#
# Checks:
#   1. YAML frontmatter has required fields (name, version, description)
#   2. Required sections exist (Overview, When to Use, Examples, Troubleshooting, Integration)
#   3. SKILL.md is under 500 lines (unless reference/ subdir exists for progressive disclosure)
#   4. No broken internal links (referenced files in reference/ must exist)
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

  # Required section headings (## level)
  # "Overview" or "Description" heading
  if grep -qE '^##\s+(Overview|Description)' "$file"; then
    pass "Has 'Overview' section"
  else
    fail "Missing 'Overview' (or 'Description') section"
    has_error=1
  fi

  # "When to Use" or activation section
  if grep -qE '^##\s+When to Use' "$file"; then
    pass "Has 'When to Use' section"
  else
    fail "Missing 'When to Use' section"
    has_error=1
  fi

  # Workflow/Steps — flexible naming across skill patterns:
  # Pattern A (Methodology): "Usage Modes", "Mode:", "Phase N"
  # Pattern B (Technical): "The Workflow", "Quick Start", "The Process", "Recording Workflow"
  # Pattern C (Auditing): "How It Works", "Quality Criteria"
  # Pattern D (Automation): "The Skill Generation Process", "Phase N", "Setup"
  # Pattern E (Reference): "The Ideal Structure", "Section N:", "Component Structure"
  if grep -qE '^##\s+(Workflow|Steps|The Process|Usage Modes|The Skill Generation Process|Quick Start|The Workflow|Phase|Phases|Setup|Recording Workflow|How It Works|Quality Criteria|The Ideal Structure|Component Structure)' "$file" || \
     grep -qE '^## Mode:' "$file" || \
     grep -qE '^##\s+Section [0-9]' "$file" || \
     grep -qE '^###\s+Phase [0-9]' "$file"; then
    pass "Has workflow/steps content"
  else
    fail "Missing workflow/steps section (e.g., 'Workflow', 'Steps', 'The Process', 'Usage Modes', 'How It Works')"
    has_error=1
  fi

  # Examples — either a dedicated ## Examples section or <Good>/<Bad> tags in the file
  if grep -qE '^##\s+Examples' "$file"; then
    pass "Has 'Examples' section"
  elif grep -qE '<Good>' "$file" && grep -qE '<Bad>' "$file"; then
    pass "Has examples (Good/Bad comparison tags found)"
  else
    fail "Missing 'Examples' section (or <Good>/<Bad> comparison tags)"
    has_error=1
  fi

  # Troubleshooting section
  if grep -qE '^##\s+Troubleshooting' "$file"; then
    pass "Has 'Troubleshooting' section"
  else
    fail "Missing 'Troubleshooting' section"
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

  # Check if progressive disclosure is used (reference/ directory exists)
  if [ -d "${skill_dir}/reference" ]; then
    warn "Line count: ${line_count}/500 (reference/ dir exists — progressive disclosure)"
    WARN_COUNT=$((WARN_COUNT + 1))
    return 0
  else
    fail "Line count: ${line_count}/500 (exceeds limit, no reference/ dir for progressive disclosure)"
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

  # Find markdown links to reference/ files: [text](./reference/path) or [text](reference/path)
  # Scoped to reference/ paths only — these are the internal project files that must exist.
  # Bare ./file.md links in example text or code blocks are excluded.
  local links
  links=$(grep -oE '\]\(\./reference/[^)]+\)|\]\(reference/[^)]+\)' "$file" | sed 's/\](\.\///' | sed 's/\](reference\//reference\//' | sed 's/)//' || true)

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
