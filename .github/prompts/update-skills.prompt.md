---
description: "Update bundled skills from upstream. Use when: refresh skills, update skills, sync skills from upstream."
agent: "agent"
tools: ["execute", "read", "search", "todo"]
---

# Update Skills

Update the bundled skills in `src/panmetis/skills/` from upstream using the skills CLI.

`.agents/skills/` is a symlink to `src/panmetis/skills/`, so `npx skills update` writes directly into the package source — no copy step needed.

## Steps

### 1. Update upstream skills

```bash
npx skills update --project --yes
```

This updates `src/panmetis/skills/` directly (via the symlink) and `skills-lock.json`.

### 2. Commit

```bash
git add src/panmetis/skills/
git commit -m "chore: update bundled skills"
```

### 3. Summarise changes

Run `git diff HEAD~1 --stat` and `git diff HEAD~1 -- src/panmetis/skills/` to review what changed. Summarise for the user: which skills were added, removed, or modified, and roughly what changed in each.
