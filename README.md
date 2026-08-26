# panmetis

Panmetis is a curated, upstream-tracked collection of agent skills intended for Python distribution.

## Install

```bash
uv add panmetis
```

Or install it into an existing Python environment:

```bash
python -m pip install panmetis
```

## Access the skills

Each directory under [`src/panmetis/skills/`](src/panmetis/skills/) contains a `SKILL.md` and may contain references, scripts, templates, or agent metadata. In a source checkout, `.agents/skills` points to that directory for runtimes that discover Universal skills there.

The current build configuration omits the skills tree from the sdist and wheel, so installing the Python package does not yet install the skills. Use a source checkout until archive inclusion is fixed and verified.

The selected skills and their upstream sources are recorded in [`skills-lock.json`](skills-lock.json).

## Develop

```bash
git clone https://github.com/stabilefrisur/panmetis.git
cd panmetis
uv sync
uv build --clear
```

The build must produce an sdist and wheel containing the bundled skills.

## Maintain

- Sync upstream skills with the [update-skills prompt](.github/prompts/update-skills.prompt.md). It owns the isolated updater, review, and verification sequence.
- Publish a version with the [release prompt](.github/prompts/publish.prompt.md). It owns version alignment, changelog, build, tag, push, and PyPI completion criteria.

## License

[MIT](LICENSE)
