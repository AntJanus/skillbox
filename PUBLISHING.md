# Publishing SkillBox to Vercel Skills Ecosystem

This document outlines how SkillBox is structured for publishing on the Vercel Skills platform (skills.sh).

## Publishing Status

**Current Status:** Ready to publish ✅

**Repository:** https://github.com/antjanus/skillbox

**Installation Command:** `npx skills add antjanus/skillbox`

## Requirements Checklist

All requirements for Vercel Skills ecosystem are met:

- [x] Skills are in `skills/` directory
- [x] Each skill has a `SKILL.md` file (uppercase)
- [x] Each SKILL.md has YAML frontmatter with required fields:
  - [x] `name` (kebab-case, unique identifier)
  - [x] `description` (explains purpose and triggers)
- [x] Directory names use kebab-case
- [x] Optional metadata included (author, version, license)
- [x] SKILL.md files are under 500 lines (use progressive disclosure)
- [x] Repository is on GitHub (required for skills.sh discovery)

## Current Skills

All skills are ready for publishing:

1. **track-session** - Session progress tracking
2. **git-worktree** - Parallel branch development
3. **generate-skill** - Interactive skill builder
4. **ideal-react-component** - React component structure pattern

## How Users Install SkillBox

Once published, users can install via:

### Install All Skills

```bash
npx skills add antjanus/skillbox
```

### Install Specific Skills

```bash
npx skills add antjanus/skillbox@track-session
npx skills add antjanus/skillbox@git-worktree
npx skills add antjanus/skillbox@ideal-react-component
npx skills add antjanus/skillbox@generate-skill
```

### Install Globally

```bash
npx skills add antjanus/skillbox -g
```

### List Available Skills Before Installing

```bash
npx skills add antjanus/skillbox -l
```

## Publishing Process

The Vercel Skills CLI automatically discovers skills from GitHub repositories. No explicit "publish" step is needed beyond making the repository public.

### Automatic Discovery

Once the repository is public on GitHub:

1. The skills.sh directory will automatically index the repository
2. Users can install using `npx skills add antjanus/skillbox`
3. Skills appear in the skills.sh leaderboard as they get installed
4. Installation counts are tracked automatically

### Manual Testing Before Public Release

Test the repository structure locally:

```bash
# Test discovery from local path
npx skills add . -l

# Test installation from local path
npx skills add .

# Verify skills were installed
npx skills list

# Remove test installation
npx skills remove antjanus/skillbox
```

### Testing from GitHub (Pre-Release)

You can test installation from GitHub before announcing:

```bash
# Test installation from GitHub
npx skills add antjanus/skillbox -l

# Install to verify
npx skills add antjanus/skillbox

# Verify installation
npx skills list
```

## Post-Publishing

After publishing, the repository will appear on:

- **Skills Directory**: https://skills.sh
- **GitHub Topic**: Consider adding `agent-skills` topic to repository
- **Package Stats**: Installation counts will appear on skills.sh

### Monitoring

Track adoption via:
- skills.sh leaderboard (installation counts)
- GitHub stars and forks
- Issues and discussions

### Updating Skills

When updating skills:

1. Edit the SKILL.md file
2. Increment `metadata.version` in frontmatter
3. Commit and push to GitHub
4. Users can update with: `npx skills check` then reinstall

## SEO and Discovery

To improve discoverability:

- [x] README.md mentions "Vercel Skills" and "skills.sh"
- [x] Clear installation instructions with `npx skills add`
- [ ] Add GitHub topics: `agent-skills`, `claude-code`, `ai-agents`
- [ ] Consider announcing on social media/dev communities
- [ ] Link from skills.sh once indexed

## Vercel Skills CLI Reference

Key commands users will use:

```bash
# Discover skills in a repository
npx skills add <owner/repo> -l

# Install all skills
npx skills add <owner/repo>

# Install specific skill
npx skills add <owner/repo@skill-name>

# Install globally
npx skills add <owner/repo> -g

# List installed skills
npx skills list

# Find skills by query
npx skills find <query>

# Check for updates
npx skills check

# Remove skills
npx skills remove <owner/repo>

# Create new skill template
npx skills init <skill-name>
```

## Maintenance Checklist

Before each skill release:

- [ ] Test skill activation with trigger phrases
- [ ] Verify YAML frontmatter is valid
- [ ] Ensure SKILL.md is under 500 lines
- [ ] Update version number in metadata
- [ ] Test with `npx skills add .` locally
- [ ] Update CHANGELOG if you create one

## Resources

- **Vercel Skills Announcement**: https://vercel.com/changelog/introducing-skills-the-open-agent-skills-ecosystem
- **Skills CLI Repository**: https://github.com/vercel-labs/skills
- **Skills Directory**: https://skills.sh
- **Agent Skills Format**: https://agentskills.io/specification
- **Example Repository**: https://github.com/vercel-labs/agent-skills

## Support

If issues arise with installation:

- Check GitHub Issues: https://github.com/vercel-labs/skills/issues
- Verify YAML frontmatter syntax
- Test locally before reporting upstream issues
- Check that skill names match directory names

---

**Last Updated:** 2026-01-30
**Status:** Ready to publish
**Next Step:** Announce to community after final review
