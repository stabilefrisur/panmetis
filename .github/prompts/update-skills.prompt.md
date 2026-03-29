---
description: "Update bundled skills from upstream. Use when: refresh skills, update skills, sync skills from upstream."
agent: "agent"
tools: ["execute", "read", "search", "todo"]
---

# Update Skills

Update the bundled skills in `src/panmetis/skills/` from upstream using the skills CLI.

## Steps

### 1. Update upstream skills

Run the skills update command in the project root:

```bash
npx skills update
```

This updates `.agents/skills/` and `skills-lock.json`.

### 2. Replace bundled skills

Wipe the existing bundled skills and replace them with the freshly updated ones:

```bash
rm -rf src/panmetis/skills/*
cp -r .agents/skills/* src/panmetis/skills/
```

### 3. Commit

Stage and commit the updated skills:

```bash
git add src/panmetis/skills/
git commit -m "chore: update bundled skills"
```

### 4. Summarise changes

Run `git diff HEAD~1 --stat` and `git diff HEAD~1 -- src/panmetis/skills/` to review what changed. Summarise the diff for the user: which skills were added, removed, or modified, and roughly what changed in each.

### Important

- `.agents/` is gitignored — only `src/panmetis/skills/` gets committed.
- `skills-lock.json` is also gitignored — it is not committed.
