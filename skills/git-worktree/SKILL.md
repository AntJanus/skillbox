---
name: git-worktree
description: Use when you need to work on multiple branches simultaneously, run parallel Claude Code sessions, handle emergency hotfixes during feature work, review PRs without switching branches, or test across branches without losing current work
license: MIT
metadata:
  author: antonin
  version: "2.0.0"
  argument-hint: <branch-name> [base-branch]
---

# Git Worktree - Parallel Development

## Overview

Git worktrees enable multiple working directories from a single repository. Each worktree has its own branch while sharing the same Git object database.

**Core principle:** Check worktree status, create worktree for parallel work, reference cleanup commands as needed.

## When to Use

**Use worktrees when:**
- Working on multiple branches simultaneously
- Emergency hotfix needed without disrupting current work
- Reviewing PRs in isolation
- Testing across branches without stashing

**Avoid when:**
- Quick branch switch (use `git switch` instead)
- Single feature, single branch workflow

## The Workflow

### Step 1: Check Worktree Status

Before creating a worktree, check what already exists:

```bash
# List all worktrees
git worktree list

# Verbose output with branch info
git worktree list --verbose
```

### Step 2: Create Worktree

**Basic creation:**

```bash
# Create worktree with new branch from HEAD
git worktree add ../project-feature-name -b feature-name

# Create from specific base branch
git worktree add ../project-hotfix -b hotfix-critical origin/main

# Create from existing remote branch
git worktree add ../project-review pr-123
```

**Safety check:**
Ensure worktrees are either outside the repo or in `.gitignore` to avoid tracking them.

```bash
# Check if path would be tracked
git check-ignore ../project-feature-name
```

**Recommended configuration (run once):**
```bash
git config worktree.guessRemote true
git config worktree.useRelativePaths true
```

### Step 3: Work in Worktree

Navigate to the worktree and work normally:

```bash
cd ../project-feature-name
# Install dependencies, run tests, start Claude, etc.
```

## Worktree Management Reference

These commands are available for managing worktrees. Surface these to the user when relevant:

**List worktrees:**
```bash
# List all worktrees
git worktree list

# Verbose output with branch and commit info
git worktree list --verbose
```

**Remove worktrees:**
```bash
# Remove a worktree (must have no uncommitted changes)
git worktree remove ../project-feature-name

# Force remove (discards uncommitted changes)
git worktree remove -f ../project-feature-name
```

**Prune stale worktrees:**
```bash
# Clean up metadata for manually deleted worktrees
git worktree prune

# Dry run to see what would be pruned
git worktree prune -n

# Repair a disconnected worktree
git worktree repair ../project-feature-name
```

## Troubleshooting

### "Another worktree already uses this branch"

**Cause:** Can't checkout same branch in multiple worktrees.

**Solution:**
```bash
# Check which worktree has it
git worktree list | grep branch-name

# Create new branch from same base instead
git worktree add ../new-path -b branch-copy origin/branch-name
```

### "Worktree contains modified or untracked files"

**Cause:** Can't remove worktree with uncommitted changes.

**Solution:**
```bash
# Commit or stash changes first
cd ../project-feature-name
git add . && git commit -m "Final changes"

# Or force remove (discards changes)
git worktree remove -f ../project-feature-name
```

### Stale Worktree References

**Cause:** Manually deleted worktree directory without `git worktree remove`.

**Solution:**
```bash
# List worktrees (shows "prunable" entries)
git worktree list --verbose

# Clean up stale metadata
git worktree prune
```
## Examples

**Create worktree for new feature:**
```bash
git worktree list  # Check current worktrees
git worktree add ../myproject-auth -b feature/auth
cd ../myproject-auth
# Install dependencies, start work
```

**Emergency hotfix pattern:**
```bash
git worktree add ../myproject-hotfix -b hotfix/payment origin/main
cd ../myproject-hotfix
# Fix bug, commit, push, then remove worktree
```

**Review PR without switching:**
```bash
git fetch origin pull/123/head:pr-123
git worktree add ../myproject-pr-123 pr-123
cd ../myproject-pr-123
# Review code, test changes
```

## Integration

Use this skill when parallel branch work is needed. Pairs well with `/commit` for committing work in each worktree.
