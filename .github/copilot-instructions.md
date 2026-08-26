# Panmetis project instructions

Panmetis curates an upstream-tracked set of agent skills for Python distribution.

## Invariants

- Use `uv` for dependency, environment, build, and publish operations. Project metadata and build configuration live in `pyproject.toml`.
- Keep `pyproject.toml`'s `project.version` equal to `src/panmetis/__init__.py`'s `__version__`.
- Treat `skills-lock.json` as the source of truth for the selected upstream skills. Bundled skill files live in `src/panmetis/skills/`; `.agents/skills` is a symlink to that directory.
- Require both build artifacts to contain the complete `panmetis/skills/` tree exactly once. Treat missing or duplicate skill entries as a build-configuration failure; project history records `force-include` as producing duplicates that PyPI rejects.
- Use Conventional Commits and stage explicit paths so unrelated work stays outside the commit.

## Workflows

- Release: follow [publish.prompt.md](prompts/publish.prompt.md) for versioning, changelog, archive verification, tagging, pushing, and PyPI publication.
- Skill sync: follow [update-skills.prompt.md](prompts/update-skills.prompt.md) to update upstream content without creating agent-specific project directories.
