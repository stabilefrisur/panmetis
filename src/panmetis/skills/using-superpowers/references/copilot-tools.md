# VS Code Copilot Tool Mapping

Skills use Claude Code tool names. When you encounter these in a skill, use your platform equivalent:

| Skill references | VS Code Copilot equivalent |
|-----------------|----------------------------|
| `Read` (file reading) | `read_file` |
| `Write` (file creation) | File editing tools when enabled; otherwise `run_in_terminal` |
| `Edit` (file editing) | File editing tools when enabled; otherwise `run_in_terminal` |
| `Bash` (run commands) | `run_in_terminal` |
| `Grep` (search file content) | `grep_search` |
| `Glob` (search files by name) | `file_search` |
| `TodoWrite` (task tracking) | `manage_todo_list` |
| `Skill` tool (invoke a skill) | `read_file` on the skill's SKILL.md path (see below) |
| `WebSearch` | No built-in equivalent (MCP servers can provide this) |
| `WebFetch` | No built-in equivalent (MCP servers can provide this) |
| `Task` tool (dispatch subagent) | No equivalent — VS Code Copilot does not support subagents |

## No subagent support

VS Code Copilot has no equivalent to Claude Code's `Task` tool. Skills that rely on subagent dispatch (`subagent-driven-development`, `dispatching-parallel-agents`) will fall back to single-session execution via `executing-plans`.

## Skill invocation

Claude Code loads skills via a dedicated `Skill` tool. In VS Code Copilot, skills are referenced in `.github/copilot-instructions.md` (or `.copilot-instructions.md`) with a file path. When a skill applies, use `read_file` to load the full SKILL.md content and follow its instructions.

Skills can also be listed in the `<skills>` block of agent instructions, which makes their descriptions visible for matching but still requires reading the file for full instructions.

## File editing tools

VS Code Copilot's file editing tools (create, insert, replace, rename) can be enabled or disabled by the user. When disabled, fall back to `run_in_terminal` with shell commands (`cat >`, `sed`, `patch`, etc.) for file creation and modification.

Check whether editing tools are available before attempting to use them. If a skill says "use Write tool," try the editing tool first; if unavailable, write via the terminal.

## Deferred tools

Some tools are not loaded until discovered via `tool_search_tool_regex`. These include:

| Tool | Purpose |
|------|---------|
| `vscode_listCodeUsages` | Find references and usages of symbols |
| `get_changed_files` | List files modified in the workspace |
| `test_failure` | Get details of test failures |
| `create_and_run_task` | Create and run VS Code tasks (build, run, custom) |
| `kill_terminal` | Kill a running terminal |

Before calling a deferred tool, search for it first with `tool_search_tool_regex` to load it.

## Additional VS Code Copilot tools

These tools are available in VS Code Copilot but have no direct Claude Code equivalent:

| Tool | Purpose |
|------|---------|
| `semantic_search` | Natural language search across the codebase |
| `get_errors` | Get compile/lint diagnostics from VS Code |
| `view_image` | View image files (png, jpg, gif, webp) |
| `list_dir` | List directory contents |
| `get_terminal_output` | Check output of background terminal processes |
| `tool_search_tool_regex` | Discover deferred and MCP-provided tools at runtime |

## MCP server extensions

VS Code Copilot supports MCP (Model Context Protocol) servers that can provide additional tools at runtime. Common extensions include web search, database access, and API integrations. Use `tool_search_tool_regex` to discover MCP-provided tools by name or description.

## Windows considerations

When running on Windows, skills that use shell commands assume a Unix shell. Adapt as follows:

- **Shell:** `run_in_terminal` uses the VS Code default terminal shell. On Windows this is often PowerShell. If skills require bash syntax, use Git Bash or WSL, or translate commands to PowerShell equivalents.
- **Paths:** VS Code normalizes paths to forward slashes internally, but terminal commands may need backslashes or quoted paths with spaces.
- **Line endings:** Files may use CRLF. Git's `core.autocrlf` setting handles this for version-controlled files, but scripts written to disk may need explicit `LF` endings.
- **Case sensitivity:** The Windows file system is case-insensitive. Avoid relying on case to distinguish files or directories.
- **Permissions:** `chmod` has no effect on Windows outside WSL. Skip permission-setting commands in skills.
- **Background processes:** `nohup` and `disown` are bash-specific. For background tasks, use `run_in_terminal` with `isBackground: true` instead of translating shell job control.
