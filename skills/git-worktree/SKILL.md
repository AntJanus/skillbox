---
name: git-worktree
description: Use when you need to work on multiple branches simultaneously, run parallel Claude Code sessions, handle emergency hotfixes during feature work, review PRs without switching branches, or test across branches without losing current work
license: MIT
metadata:
  author: antonin
  version: "1.0.0"
  argument-hint: <branch-name> [base-branch]
---

# Git Worktree - Parallel Development with Claude Code

## Overview

Git worktrees enable multiple working directories from a single repository, allowing parallel development without the overhead of multiple clones. Each worktree has its own branch, index, and HEAD while sharing the same Git object database.

**Core principle:** One worktree per Claude Code session = true parallel AI development without interference.

## When to Use

**Always use worktrees when:**
- Running multiple Claude Code agents on different features simultaneously
- Emergency hotfix needed while Claude is working on a long-running feature
- Reviewing PRs without disrupting current development work
- Testing across branches without stashing or losing current state
- Running long-lived test suites while continuing development

**Useful for:**
- Parallel feature development (3+ features at once)
- Code review workflows with isolated environments
- A/B testing different implementation approaches
- CI/CD builds at specific commits

**Avoid when:**
- Quick branch switch for 5 minutes (use stash instead)
- Single feature, single branch workflow
- Working with submodules (experimental support only)

## The Process

### Phase 1: Directory Selection and Safety Check

**Before creating worktree, you MUST:**
1. Determine parent directory for worktrees
2. Verify directory structure is safe
3. Ensure worktrees won't be tracked by Git

**Directory Priority:**
```markdown
1. Existing sibling worktrees (if detected)
2. CLAUDE.md worktree_parent_dir setting (if present)
3. Ask user for preference
```

**Safety verification:**
```bash
# Check if worktree path would be tracked
git check-ignore ../project-feature-name

# If not ignored, verify .gitignore has pattern
grep -q "../project-*" .gitignore || echo "WARNING: Worktrees may be tracked!"
```

**You MUST verify before proceeding:**
- [ ] Parent directory exists and is writable
- [ ] Worktree path won't conflict with existing directories
- [ ] Worktrees won't be tracked by Git (in .gitignore or outside repo)

### Phase 2: Worktree Creation

When creating a new worktree/branch, follow any conventions already setup around naming.

**Basic creation patterns:**

```bash
# Create worktree with new branch from HEAD
git worktree add ../project-feature-name -b feature-name

# Create from specific base branch
git worktree add ../project-hotfix -b hotfix-critical origin/main

# Create from existing remote branch
git worktree add ../project-review pr-123

# Detached HEAD for testing (disposable)
git worktree add --detach ../project-test HEAD
```

**Recommended configuration (run once):**
```bash
# Auto-track remote branches
git config worktree.guessRemote true

# Use relative paths (portable)
git config worktree.useRelativePaths true
```

**You MUST verify after creation:**
- [ ] Worktree directory created successfully
- [ ] Branch checked out (or detached HEAD if intended)
- [ ] No error messages in git worktree output

### Phase 3: Environment Setup

**Project-specific initialization:**

```bash
cd ../project-feature-name

# read README.md
# follow installation instructions
```

**You MUST verify before starting Claude:**
- [ ] Dependencies installed (node_modules, .venv, etc.)
- [ ] Environment files copied (.env, config files)
- [ ] Project builds successfully
- [ ] Tests pass (baseline verification)

### Phase 4: Start Claude Code Session

**Navigate and start:**
```bash
cd ../project-feature-name
claude
```

**Name your session immediately:**
```
> /rename feature-auth-implementation
```

**Session naming best practices:**
- Use descriptive names: `feature-auth-oauth`, `bugfix-payment-validation`
- Include feature area: `refactor-database-layer`, `review-pr-456`
- Avoid generic names: "help me with this", "quick fix"

**Verification:**
- [ ] Claude session started in worktree directory
- [ ] Session renamed with descriptive name
- [ ] Git status shows correct branch
- [ ] Claude can read files and execute commands

### Phase 5: Parallel Development

**Managing multiple sessions:**

**List all worktrees:**
```bash
git worktree list
# /path/to/main              abc123 [main]
# /path/to/project-feature-a def456 [feature-a]
# /path/to/project-feature-b ghi789 [feature-b]
```

**Resume specific session:**
```bash
# From any directory
claude --resume feature-auth-implementation

# Or use interactive picker
claude --resume
# Press 'B' to filter by branch
# Press '/' to search by name
```

**Monitor progress:**
```bash
# Check commits in each worktree
git log feature-a --oneline -5
git log feature-b --oneline -5

# View changes vs main
cd ../project-feature-a
git diff main

# Check active Claude sessions
claude --resume  # Shows all sessions including worktrees
```

**You MUST maintain for each worktree:**
- [ ] Descriptive session names for easy identification
- [ ] Regular commits with clear messages
- [ ] Awareness of which worktree has which branch (can't checkout same branch twice)

### Phase 6: Cleanup and Integration

**When feature is complete:**

```bash
# From main project directory
cd ../main-project

# Merge completed work
git merge feature-a
git push origin main

# Remove worktree
git worktree remove ../project-feature-a

# Or force remove (if uncommitted changes you want to discard)
git worktree remove -f ../project-feature-a
```

**Prune stale worktrees:**
```bash
# Check for prunable worktrees
git worktree list --verbose

# Clean up metadata for deleted worktrees
git worktree prune

# Dry run to see what would be pruned
git worktree prune -n
```

**Troubleshooting common cleanup issues:**

**"Worktree contains modified or untracked files":**
```bash
# Review changes first
cd ../project-feature-a
git status

# Commit or stash if needed
git add . && git commit -m "Final changes"

# Then remove from main project
cd ../main-project
git worktree remove ../project-feature-a
```

**"Worktree is prunable but directory exists":**
```bash
# Repair connection
git worktree repair ../project-feature-a

# Or manually clean up
rm -rf ../project-feature-a
git worktree prune
```

**You MUST verify cleanup:**
- [ ] Worktree removed successfully
- [ ] Changes merged or preserved if needed
- [ ] No stale worktree metadata (`git worktree list` clean)
- [ ] Disk space reclaimed

## Quick Reference Cheatsheet

```bash
# Create worktree with new branch
git worktree add ../project-feature-a -b feature-a

# Create from existing branch
git worktree add ../project-bugfix bugfix-123

# List all worktrees
git worktree list

# Navigate and start Claude
cd ../project-feature-a
claude

# Name your Claude session
> /rename feature-a-implementation

# Resume specific session
claude --resume feature-a-implementation

# View all sessions (including worktrees)
claude --resume

# Check worktree status
git worktree list --verbose

# Remove worktree
git worktree remove ../project-feature-a

# Clean up stale metadata
git worktree prune

# Configuration (run once)
git config worktree.guessRemote true
git config worktree.useRelativePaths true
```

## Integration with Claude Code

### Session Management Across Worktrees

**Key insight:** Claude Code's `/resume` picker shows sessions from all worktrees in the same repository. This enables seamless switching between parallel development contexts.

**Session Picker Features:**
| Shortcut | Action |
|----------|--------|
| `↑` / `↓` | Navigate sessions |
| `Enter` | Resume session |
| `P` | Preview session |
| `R` | Rename session |
| `B` | Filter by git branch |
| `A` | Toggle all projects |
| `/` | Search sessions |

**Best practices:**
- Always name sessions after creating worktree: `/rename feature-name`
- Use consistent naming: `<type>-<area>-<description>`
- Filter by branch (`B`) when managing many sessions
- Use search (`/`) for quick session location

### Parallel Claude Workflows

**Scenario 1: Multiple Feature Development**
```bash
# Terminal 1: Feature A
git worktree add ../project-feature-a -b feature-a
cd ../project-feature-a && npm install
claude
> Implement user profile page with avatar upload
> /rename feature-profile-page

# Terminal 2: Feature B
git worktree add ../project-feature-b -b feature-b
cd ../project-feature-b && npm install
claude
> Add email notification system with templates
> /rename feature-email-system

# Terminal 3: Main work
cd ../main-project
# Continue your own development
```

**Scenario 2: Emergency Hotfix Pattern**
```bash
# Claude working on long-running feature in ../project-feature

# Create hotfix worktree from production
git worktree add ../project-hotfix -b hotfix-critical origin/main

# Start new Claude session
cd ../project-hotfix && npm install
claude
> Critical bug in payment processing. Fix validation in checkout.js
> /rename hotfix-payment-validation

# Deploy hotfix
git push origin hotfix-critical
# Create PR, merge to main

# Clean up
git worktree remove ../project-hotfix

# Original feature work continues uninterrupted
```

**Scenario 3: Code Review Isolation**
```bash
# Fetch PR branch
git fetch origin pull/123/head:pr-123

# Create review worktree
git worktree add ../project-review-pr-123 pr-123

# Start Claude for review
cd ../project-review-pr-123
claude
> Review this PR for security issues, code quality, and test coverage
> /rename review-pr-123
```

## Red Flags - STOP and Follow Process

If you catch yourself doing any of these:

- **Creating worktree without checking .gitignore** - Worktrees might get tracked!
- **Skipping environment setup** - Claude will fail with missing dependencies
- **Using default session names** - Can't find sessions later with multiple worktrees
- **Trying to checkout same branch in multiple worktrees** - Git will error
- **Removing worktree manually (rm -rf) instead of git worktree remove** - Creates stale metadata
- **Forgetting to copy .env files** - Application won't run correctly
- **Not verifying baseline tests** - Unknown if starting point is clean

**ALL of these mean: STOP. Return to appropriate phase.**

## Common Gotchas and Solutions

### Problem: "Another worktree already uses this branch"

**Cause:** Can't checkout same branch in multiple worktrees.

**Solutions:**
```bash
# Option 1: Check which worktree has it
git worktree list | grep branch-name

# Option 2: Create new branch from same base
git worktree add ../new-path -b branch-copy origin/branch-name

# Option 3: Use --force (DANGEROUS - can lose work)
git worktree add --force ../new-path branch-name
```

### Problem: Dependencies Not Installed

**Cause:** New worktree doesn't inherit node_modules, .venv, etc.

**Solution:** Create setup automation script (see Phase 3).

### Problem: Claude Sessions Not Showing in Picker

**Cause:** Sessions stored per directory, need to use picker correctly.

**Solution:**
```bash
# Use --resume without session name to see all
claude --resume

# Then press 'B' to filter by current branch
# Or press '/' to search by name
```

### Problem: Disk Space with Many Worktrees

**Cause:** Each worktree has full working files + dependencies.

**Solutions:**
```bash
# Use sparse checkout for large repos
git worktree add --no-checkout ../sparse-work
cd ../sparse-work
git sparse-checkout init --cone
git sparse-checkout set src/ tests/
git checkout

# Remove unused worktrees regularly
git worktree prune

# Check disk usage
du -sh ../project-*/
```

### Problem: Stale Worktree References

**Cause:** Manually deleted worktree directory without git worktree remove.

**Solution:**
```bash
# List worktrees (shows "prunable" entries)
git worktree list --verbose

# Clean up stale metadata
git worktree prune

# Or repair if directory still exists
git worktree repair ../worktree-path
```

## Verification Checklist

Before marking worktree setup complete:

- [ ] Worktree created in safe location (outside repo or in .gitignore)
- [ ] Branch checked out correctly (or detached HEAD if intended)
- [ ] Dependencies installed (node_modules, .venv, etc.)
- [ ] Environment files copied (.env, config)
- [ ] Baseline tests pass (known clean state)
- [ ] Claude session started in worktree directory
- [ ] Session named descriptively for easy resuming
- [ ] Git status shows correct branch
- [ ] Can navigate between worktrees with `git worktree list`

Can't check all boxes? Setup incomplete. Return to appropriate phase.

## Advanced Patterns

### Parallel Testing Strategy

```bash
# Terminal 1: Feature A tests
cd ../project-feature-a
claude
> Run all tests for feature-a and fix failures

# Terminal 2: Feature B tests
cd ../project-feature-b
claude
> Run all tests for feature-b and fix failures

# Terminal 3: Integration tests
cd ../project-main
claude
> Run integration tests after merging feature-a and feature-b
```

### Detached Worktrees for CI/CD

```bash
# Create disposable worktree at specific commit
git worktree add --detach ../ci-build abc123def

cd ../ci-build
claude -p 'run the full build pipeline and report any issues' > ci-report.txt

# Clean up immediately
cd ../main-project
git worktree remove ../ci-build
```

### A/B Testing Different Approaches

```bash
# Approach A: Implementation style 1
git worktree add ../experiment-approach-a -b experiment/approach-a
cd ../experiment-approach-a
claude
> Implement caching using Redis

# Approach B: Implementation style 2
git worktree add ../experiment-approach-b -b experiment/approach-b
cd ../experiment-approach-b
claude
> Implement caching using in-memory cache

# Benchmark both, keep the winner
```

## Configuration Reference

**Recommended global config:**
```bash
# Auto-track remote branches when creating worktrees
git config --global worktree.guessRemote true

# Use relative paths for portability
git config --global worktree.useRelativePaths true
```

**Per-worktree config (if needed):**
```bash
# Enable worktree-specific config
git config extensions.worktreeConfig true

# Set worktree-specific settings
git config --worktree user.email "feature-dev@company.com"
git config --worktree core.sparseCheckout true
```

**Project CLAUDE.md settings:**
```markdown
## Worktree Configuration

**Parent directory:** `../`
**Naming pattern:** `project-<feature-name>`
**Setup script:** `.claude/setup-worktree.sh`

After creating worktree:
1. Run setup script: `.claude/setup-worktree.sh`
2. Name Claude session: `/rename <feature-name>`
```

## When NOT to Use Worktrees

| Scenario | Use Instead | Why |
|----------|-------------|-----|
| Quick branch switch (< 5 min) | `git switch` or stash | Worktree overhead not worth it |
| Single feature workflow | Normal branching | No parallelism needed |
| Repositories with submodules | Manual clones | Experimental worktree support only |
| Very large monorepos (100GB+) | Partial clones | Disk space concerns |

## Tools Integration

### Shell Aliases (Optional)

```bash
# Add to ~/.gitconfig or ~/.bashrc

[alias]
    wa = worktree add
    wl = worktree list
    wr = worktree remove
    wp = worktree prune

# Or bash/zsh functions
alias gwl='git worktree list'
alias gwa='git worktree add'
alias gwr='git worktree remove'
```

### IDE Integration

```bash
# Open worktree in VS Code
code ../project-feature-a

# Or create integrated workflow
claude-worktree() {
  local branch_name=$1
  local worktree_path="../$(basename $(pwd))-${branch_name}"

  git worktree add "$worktree_path" -b "$branch_name"
  cd "$worktree_path"
  npm install
  code .
  claude
}
```
## Integration

**This skill enables:**
- Parallel Claude Code development on multiple features
- Emergency hotfix workflows without disrupting feature work
- Code review in isolation
- A/B testing different implementation approaches

**Pairs well with:**
- `/commit` skill - For committing work in each worktree
- Test-driven development workflows
- Systematic debugging (in isolated worktree)
- CI/CD automation (detached worktrees)

**Called by:**
- Any workflow requiring branch isolation
- Emergency hotfix scenarios
- Multi-feature parallel development
