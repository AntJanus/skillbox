#!/bin/bash

# Test script to verify SkillBox skills are ready for Vercel Skills publishing
# Run this before publishing to catch any issues

set -e

echo "🧪 Testing SkillBox skills structure..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

# Check if skills directory exists
if [ ! -d "skills" ]; then
  echo -e "${RED}❌ Error: skills/ directory not found${NC}"
  exit 1
fi

echo "✅ Found skills/ directory"
echo ""

# Find all SKILL.md files
SKILL_FILES=$(find skills -name "SKILL.md")

if [ -z "$SKILL_FILES" ]; then
  echo -e "${RED}❌ Error: No SKILL.md files found${NC}"
  exit 1
fi

SKILL_COUNT=$(echo "$SKILL_FILES" | wc -l | tr -d ' ')
echo "📦 Found $SKILL_COUNT skills"
echo ""

# Test each skill
while IFS= read -r skill_file; do
  SKILL_DIR=$(dirname "$skill_file")
  SKILL_NAME=$(basename "$SKILL_DIR")

  echo "Testing: $SKILL_NAME"
  echo "  📄 File: $skill_file"

  # Check if SKILL.md has frontmatter
  if ! head -n 1 "$skill_file" | grep -q "^---$"; then
    echo -e "  ${RED}❌ Missing YAML frontmatter${NC}"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Extract frontmatter (between first two --- lines)
  FRONTMATTER=$(awk '/^---$/{if(++count==2) exit; next} count==1' "$skill_file")

  # Check for required 'name' field
  if echo "$FRONTMATTER" | grep -q "^name:"; then
    NAME_VALUE=$(echo "$FRONTMATTER" | grep "^name:" | cut -d':' -f2- | tr -d ' ')
    echo -e "  ${GREEN}✅ Has name field: $NAME_VALUE${NC}"

    # Verify name matches directory
    if [ "$NAME_VALUE" != "$SKILL_NAME" ]; then
      echo -e "  ${YELLOW}⚠️  Warning: name ($NAME_VALUE) doesn't match directory ($SKILL_NAME)${NC}"
    fi
  else
    echo -e "  ${RED}❌ Missing required 'name' field${NC}"
    ERRORS=$((ERRORS + 1))
  fi

  # Check for required 'description' field
  if echo "$FRONTMATTER" | grep -q "^description:"; then
    echo -e "  ${GREEN}✅ Has description field${NC}"
  else
    echo -e "  ${RED}❌ Missing required 'description' field${NC}"
    ERRORS=$((ERRORS + 1))
  fi

  # Check file size (should be under 500 lines per best practices)
  LINE_COUNT=$(wc -l < "$skill_file")
  if [ "$LINE_COUNT" -gt 500 ]; then
    echo -e "  ${YELLOW}⚠️  Warning: SKILL.md has $LINE_COUNT lines (recommended < 500)${NC}"
    echo "     Consider using progressive disclosure with reference/ directory"
  else
    echo -e "  ${GREEN}✅ SKILL.md size: $LINE_COUNT lines${NC}"
  fi

  # Check for reference/ directory if file is large
  if [ "$LINE_COUNT" -gt 500 ] && [ ! -d "$SKILL_DIR/reference" ]; then
    echo -e "  ${YELLOW}⚠️  Consider adding reference/ directory for extended docs${NC}"
  fi

  echo ""
done <<< "$SKILL_FILES"

# Test with Vercel Skills CLI if available
echo "🔍 Testing with Vercel Skills CLI..."
if command -v npx &> /dev/null; then
  echo "  Running: npx skills add . -l"
  if npx skills add . -l 2>&1 | grep -q "Found"; then
    echo -e "  ${GREEN}✅ Skills CLI can discover skills${NC}"
  else
    echo -e "  ${YELLOW}⚠️  Skills CLI discovery test unclear${NC}"
  fi
else
  echo -e "  ${YELLOW}⚠️  npx not available, skipping CLI test${NC}"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
  echo -e "${GREEN}✅ All tests passed! Ready to publish.${NC}"
  echo ""
  echo "Next steps:"
  echo "  1. Review reference/VERSION-CONTROL.md for the release process"
  echo "  2. Ensure repository is pushed to GitHub"
  echo "  3. Test with: npx skills add antjanus/skillbox -l"
  echo "  4. Announce to community"
  exit 0
else
  echo -e "${RED}❌ Found $ERRORS error(s). Please fix before publishing.${NC}"
  exit 1
fi
