---
description: "Sync the bundled skills and skills-lock.json with their configured upstream revisions."
agent: "agent"
tools: ["execute", "read", "search", "todo"]
---

# Sync bundled skills

Refresh the upstream skills recorded in `skills-lock.json`. Treat that lockfile as the source of truth for the selected skills and their upstream repositories.

The sync is complete only when any changes stay within expected paths, every change has been reviewed, the package still builds with its skills, and one focused commit records the result. If upstream is already current, report that result without creating a commit.

## 1. Establish a clean base

1. Confirm that `git status --short` is empty. If it is not, stop before changing files and report the exact state.
2. Confirm that `.agents/skills` resolves to `src/panmetis/skills`. The updater writes through this symlink into the package source.
3. Read `skills-lock.json` to establish the skills and sources that should remain selected.

This stage is complete when the starting commit is clean, the symlink targets the package source, and the selected upstream set is known.

## 2. Run the updater in isolation

The skills CLI detects agent runtimes from the home directory. Give this invocation an isolated home containing only a Universal-compatible Copilot marker, so it updates the shared skills directory without adding runtime-specific project links:

```bash
skills_update_home=$(mktemp -d)
trap 'rm -rf "$skills_update_home"' EXIT
mkdir -p "$skills_update_home/.copilot"
HOME="$skills_update_home" XDG_CONFIG_HOME="$skills_update_home/.config" npx --yes skills update --project --yes
```

This stage is complete when the command succeeds, the temporary directory is removed, and no runtime-specific skill directory was created.

## 3. Review and verify

Inspect the complete unstaged change before committing:

```bash
git status --short
git diff --stat
git diff -- skills-lock.json src/panmetis/skills/
```

Account for every added, removed, and modified skill. Confirm that tracked changes are confined to `skills-lock.json` and `src/panmetis/skills/`, and that the lockfile still describes every bundled skill. If no tracked files changed, report that the bundle is current and stop.

Build the package and inspect the resulting sdist and wheel:

```bash
uv build --clear
```

This stage is complete when every upstream change is understood, only expected tracked paths changed, and both distributions contain the updated bundled skills.

## 4. Commit and report

Stage the two authoritative paths, inspect the staged summary, and commit:

```bash
git add skills-lock.json src/panmetis/skills/
git diff --cached --stat
git commit -m "chore: update bundled skills"
```

Report the commit and list which skills were added, removed, or modified, with a concise description of each material change. This stage is complete when one focused commit contains every reviewed sync change and tracked files are clean.
