---
description: "Update bundled skills from upstream. Use when: refresh skills, update skills, sync skills from upstream."
agent: "agent"
tools: ["execute", "read", "search", "todo"]
---

# Update Skills

Update the bundled skills in `src/panmetis/skills/` from upstream using the skills CLI.

## Steps

### 1. Back up custom files

`copilot-tools.md` is maintained by us (not upstream). Save it before the update wipes it, and snapshot the current upstream files so we can diff them later:

```bash
cp src/panmetis/skills/using-superpowers/references/copilot-tools.md /tmp/copilot-tools.md.bak
git diff HEAD -- src/panmetis/skills/using-superpowers/references/codex-tools.md > /tmp/codex-tools.md.before.diff || true
git diff HEAD -- src/panmetis/skills/using-superpowers/references/gemini-tools.md > /tmp/gemini-tools.md.before.diff || true
```

### 2. Update upstream skills

Run the skills update command in the project root:

```bash
npx skills update
```

This updates `.agents/skills/` and `skills-lock.json`.

### 3. Replace bundled skills

Wipe the existing bundled skills and replace them with the freshly updated ones:

```bash
rm -rf src/panmetis/skills/*
cp -r .agents/skills/* src/panmetis/skills/
```

### 4. Restore custom files and patch SKILL.md

Restore `copilot-tools.md` (not present upstream):

```bash
cp /tmp/copilot-tools.md.bak src/panmetis/skills/using-superpowers/references/copilot-tools.md
```

Patch the `using-superpowers/SKILL.md` Platform Adaptation line to reference all three tool-mapping files (upstream only mentions Codex):

```bash
sed -i "s|see \`references/codex-tools.md\` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.|see \`references/codex-tools.md\` (Codex), \`references/copilot-tools.md\` (VS Code Copilot), or \`references/gemini-tools.md\` (Gemini CLI) for tool equivalents.|" \
  src/panmetis/skills/using-superpowers/SKILL.md
```

Verify the patch applied:

```bash
grep 'copilot-tools' src/panmetis/skills/using-superpowers/SKILL.md
```

### 5. Check if copilot-tools.md needs updating

`codex-tools.md` and `gemini-tools.md` are upstream files. Compare the old and new versions to see if upstream changed them:

```bash
git diff -- src/panmetis/skills/using-superpowers/references/codex-tools.md
git diff -- src/panmetis/skills/using-superpowers/references/gemini-tools.md
```

If either changed (new tool mappings, renamed tools, structural changes), review `copilot-tools.md` and apply equivalent updates. Common things to check:

- New Claude Code tool names added to mapping tables → add VS Code Copilot equivalent
- Tool names renamed → update the corresponding row in `copilot-tools.md`
- New sections added (e.g., new platform feature) → add equivalent section for Copilot if applicable

### 6. Commit

Stage and commit the updated skills:

```bash
git add src/panmetis/skills/
git commit -m "chore: update bundled skills"
```

### 7. Summarise changes

Run `git diff HEAD~1 --stat` and `git diff HEAD~1 -- src/panmetis/skills/` to review what changed. Summarise the diff for the user: which skills were added, removed, or modified, and roughly what changed in each. If `copilot-tools.md` needed updates, call that out explicitly.

### Important

- `.agents/` is gitignored — only `src/panmetis/skills/` gets committed.
- `skills-lock.json` is also gitignored — it is not committed.
- `copilot-tools.md` is our custom addition — upstream does not provide it. Always preserve it across updates.
- The `using-superpowers/SKILL.md` Platform Adaptation line must reference `copilot-tools.md` — upstream omits it, so re-patch after every update.
