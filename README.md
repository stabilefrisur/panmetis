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

Skills are managed via the [`skills`](https://www.npmjs.com/package/skills) CLI. The `.agents/skills/` directory is symlinked to `src/panmetis/skills/`, so updates write directly into the package source. The temporary home prevents the CLI from also creating links for installed agent runtimes such as Claude Code.

```bash
tmp_home=$(mktemp -d)
trap 'rm -rf "$tmp_home"' EXIT
mkdir -p "$tmp_home/.copilot"
HOME="$tmp_home" XDG_CONFIG_HOME="$tmp_home/.config" npx --yes skills update --project --yes
```

## License

[MIT](LICENSE)