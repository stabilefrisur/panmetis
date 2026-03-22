# Panmetis — Project Guidelines

A curated collection of agent skills published as a Python package on PyPI.

## Package Manager

Use **uv** for all package management. Never use pip directly.

```bash
uv sync          # install dependencies
uv build         # build sdist + wheel
uv publish       # publish to PyPI
```

## Project Structure

```
src/panmetis/
  __init__.py       # version string only
  py.typed          # PEP 561 marker
  skills/           # 21 bundled agent skills (the core content)
```

Skills live inside the Python package at `src/panmetis/skills/`. They were originally sourced from `obra/superpowers` and `anthropics/skills` (tracked in `skills-lock.json`).

## Build System

Hatchling with `src` layout. Non-Python files (`.md`, `.xsd`, scripts) are included via the `[tool.hatch.build.targets.wheel]` config — do not add `force-include` as it causes duplicate entries that PyPI rejects.

## Version Management

Version is defined in **two places** — both must be updated together:

- `pyproject.toml` → `version`
- `src/panmetis/__init__.py` → `__version__`

## Release Process

1. Bump version in both `pyproject.toml` and `__init__.py`
2. Update `CHANGELOG.md` (Keep a Changelog format)
3. `rm -rf dist/ && uv build`
4. Commit, tag (`git tag -a vX.Y.Z -m "Release vX.Y.Z"`), push with tags
5. `uv publish`

## Conventions

- Conventional commits: `feat:`, `fix:`, `docs:`, `chore:`
- Stage specific files — never `git add -A`
- MIT license
- Python ≥3.12
