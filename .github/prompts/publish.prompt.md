---
description: "Start or resume a panmetis release: version, changelog, build, tag, push, and PyPI publication."
argument-hint: "semver bump: patch, minor, or major (default: patch)"
agent: "agent"
tools: ["execute", "read", "edit", "search", "todo"]
---

# Release panmetis

Release panmetis from `main`. Use the requested semantic-version bump; use `patch` when none is supplied. Detect and resume an incomplete release instead of creating another version. Run the applicable stages in order and stop at the first failed completion criterion.

The release is complete only when the two version declarations match, both distributions contain the bundled skills, the release commit and tag are on `origin`, the new version is on PyPI, and the user has a GitHub release draft.

## 1. Establish a clean release base

1. Confirm that the current branch is `main` and `git status --short` is empty. If either check fails, stop before changing files and report the exact state.
2. Read the current versions from `pyproject.toml` and `src/panmetis/__init__.py`; they must match. Call that version `CURRENT`.
3. Determine the release mode:
   - If `vCURRENT` resolves to `HEAD`, query PyPI for `CURRENT`. If it is absent, resume that release: set `X.Y.Z` to `CURRENT`, find the preceding version tag, inspect that tag through `HEAD`, skip stage 2, and use the resumed-release path in stage 4. If PyPI already exposes `CURRENT`, verify the remote refs, report it with stage 6, and stop without changing files. Treat anything other than a confirmed version or confirmed absence as a query failure.
   - Otherwise, start a new release: find the latest version tag and inspect every commit from that tag through `HEAD`.
4. Establish a usable PyPI authentication path without printing credentials. For a local release, accept `UV_PUBLISH_TOKEN`, a complete `UV_PUBLISH_USERNAME`/`UV_PUBLISH_PASSWORD` pair, or a successful `uv auth token upload.pypi.org >/dev/null 2>&1` check. In a trusted-publishing environment, confirm that OIDC is available. Stop before changing files if no path is available.

This stage is complete when the release starts from a clean `main`, the mode and target version are unambiguous, the full change range is known, and publication authentication is available.

## 2. Prepare a new release

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

Verify the distributions with the repository's fail-fast checker:

```bash
./scripts/verify-distributions.sh X.Y.Z
```

Treat any failure as a build-configuration failure and stop.

This stage is complete when both clean artifacts exist for `X.Y.Z` and both contain the bundled skills.

## 4. Commit and tag

For a new release, stage only the release metadata, inspect the staged diff, then commit and tag:

```bash
git add pyproject.toml src/panmetis/__init__.py CHANGELOG.md
git diff --cached
git commit -m "feat: release vX.Y.Z — <brief summary>"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

For a resumed release, create nothing: verify that `vX.Y.Z` already resolves to `HEAD` and tracked files are clean.

This stage is complete when `HEAD` is the reviewed release commit, `vX.Y.Z` resolves to `HEAD`, and tracked files are clean.

## 5. Push and publish

Run each command separately and stop if one fails:

```bash
git push origin main
git push origin vX.Y.Z
uv publish --check-url https://pypi.org/simple/ dist/panmetis-X.Y.Z.tar.gz dist/panmetis-X.Y.Z-py3-none-any.whl
```

Confirm that `origin/main` contains the release commit, the remote tag resolves to that commit, and PyPI exposes exactly the expected sdist and wheel for `X.Y.Z` with hashes matching the local artifacts.

## 6. Report the release

Report the released version, commit, tag, and PyPI URL. Then provide this completed GitHub release draft in a Markdown code block:

```markdown
# vX.Y.Z — <title>

### <applicable Keep a Changelog heading>
- <entries from that changelog heading; repeat for every applicable heading>

**Full Changelog**: https://github.com/stabilefrisur/panmetis/compare/vPREVIOUS...vX.Y.Z
**PyPI**: https://pypi.org/project/panmetis/X.Y.Z/
```
