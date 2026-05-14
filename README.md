# panmetis

A curated collection of agent skills for AI coding assistants.

## Installation

```bash
uv add panmetis
```

Or with pip:

```bash
pip install panmetis
```

## Usage

```python
import panmetis
```

## Development

Clone the repository and sync dependencies:

```bash
git clone https://github.com/stabilefrisur/panmetis.git
cd panmetis
uv sync
```

Build:

```bash
uv build
```

## Updating Skills

Skills are managed via the [`skills`](https://www.npmjs.com/package/skills) CLI. The `.agents/skills/` directory is symlinked to `src/panmetis/skills/`, so updates write directly into the package source.

```bash
npx skills update --project --yes
```

## License

[MIT](LICENSE)