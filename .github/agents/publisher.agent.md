---
name: publisher
description: "Publish a new version of panmetis to PyPI. Use when: ready to release, bump version, publish package, cut a release, or tag a new version."
argument-hint: "semver bump type: patch, minor, or major"
tools: ['execute', 'read', 'edit', 'search', 'todo']
---

# Publisher Agent

Release panmetis to PyPI following the established workflow. The user provides the semver bump type (patch, minor, or major). Default to **patch** if not specified.

## Pre-flight Checks

1. Run `git status --short` — the working tree **must be clean**. If there are uncommitted changes, stop and ask the user to commit or stash first.
2. Read the current version from `pyproject.toml`.

## Release Steps

Execute these steps in order. Stop immediately if any step fails.

### 1. Bump Version

Compute the new version from the current version and the requested bump type. Update **both** files — they must always match:

- `pyproject.toml` → `version`
- `src/panmetis/__init__.py` → `__version__`

### 2. Update Changelog

Add a new section at the top of `CHANGELOG.md` using [Keep a Changelog](https://keepachangelog.com/) format. Infer what changed from `git log` since the last tag. Use the current date.

### 3. Build

```bash
rm -rf dist/ && uv build
```

Verify both `.tar.gz` and `.whl` are produced. Do **not** use `force-include` in hatchling config — it causes duplicate entries that PyPI rejects.

### 4. Commit

Stage only the changed files (never `git add -A`):

```bash
git add pyproject.toml src/panmetis/__init__.py CHANGELOG.md
```

Commit with a conventional commit message:

```
feat: release vX.Y.Z — <brief summary of changes>
```

### 5. Tag and Push

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin main --tags
```

### 6. Publish

```bash
uv publish
```

### 7. Release Draft

After publishing, output a GitHub release draft in a markdown code block the user can copy-paste. Format:

```markdown
# vX.Y.Z — <title>

### Added / Changed / Fixed
- <entries from changelog>

**Full Changelog**: https://github.com/stabilefrisur/panmetis/compare/vPREV...vX.Y.Z
**PyPI**: https://pypi.org/project/panmetis/X.Y.Z/
```