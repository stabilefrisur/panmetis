---
description: "Release panmetis: bump its version, update its changelog, build, tag, push, and publish to PyPI."
argument-hint: "semver bump: patch, minor, or major (default: patch)"
agent: "agent"
tools: ["execute", "read", "edit", "search", "todo"]
---

# Release panmetis

Release panmetis from `main`. Use the requested semantic-version bump; use `patch` when none is supplied. Run the stages in order and stop at the first failed completion criterion.

The release is complete only when the two version declarations match, both distributions contain the bundled skills, the release commit and tag are on `origin`, the new version is on PyPI, and the user has a GitHub release draft.

## 1. Establish a clean release base

1. Confirm that the current branch is `main` and `git status --short` is empty. If either check fails, stop before changing files and report the exact state.
2. Read the current versions from `pyproject.toml` and `src/panmetis/__init__.py`; they must match.
3. Find the latest version tag and inspect every commit from that tag through `HEAD`.

This stage is complete when the release starts from a clean `main`, the current version is unambiguous, and the full change range is known.

## 2. Prepare the release

1. Compute `X.Y.Z` from the current version and requested bump.
2. Set both version declarations to `X.Y.Z`:
   - `pyproject.toml` → `project.version`
   - `src/panmetis/__init__.py` → `__version__`
3. Add `## [X.Y.Z] - YYYY-MM-DD` above the previous release in `CHANGELOG.md`. Derive an exhaustive, user-facing summary from the change range and group entries under the applicable Keep a Changelog headings.

This stage is complete when both declarations equal `X.Y.Z` and the changelog accounts for every meaningful change since the previous tag without inventing changes.

## 3. Build and inspect

```bash
uv build --clear
```

Confirm that the build produced one sdist and one wheel for `X.Y.Z`. Inspect both archives and confirm that each contains the complete `panmetis/skills/` tree exactly once. Treat missing or duplicate skill entries as a build-configuration failure and stop; project history records `force-include` as producing duplicates that PyPI rejects.

This stage is complete when both clean artifacts exist for `X.Y.Z` and both contain the bundled skills.

## 4. Commit and tag

Stage only the release metadata, inspect the staged diff, then commit and tag:

```bash
git add pyproject.toml src/panmetis/__init__.py CHANGELOG.md
git diff --cached
git commit -m "feat: release vX.Y.Z — <brief summary>"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

This stage is complete when `HEAD` is the reviewed release commit, `vX.Y.Z` resolves to `HEAD`, and tracked files are clean.

## 5. Push and publish

Run each command separately and stop if one fails:

```bash
git push origin main
git push origin vX.Y.Z
uv publish dist/panmetis-X.Y.Z.tar.gz dist/panmetis-X.Y.Z-py3-none-any.whl
```

Confirm that `origin/main` contains the release commit, the remote tag resolves to that commit, and PyPI exposes version `X.Y.Z`.

## 6. Report the release

Report the released version, commit, tag, and PyPI URL. Then provide this completed GitHub release draft in a Markdown code block:

```markdown
# vX.Y.Z — <title>

### Added / Changed / Fixed
- <entries from the changelog; include only applicable headings>

**Full Changelog**: https://github.com/stabilefrisur/panmetis/compare/vPREVIOUS...vX.Y.Z
**PyPI**: https://pypi.org/project/panmetis/X.Y.Z/
```
