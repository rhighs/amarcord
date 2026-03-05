# Opencode Port

Differences from the original Claude Code version:

| Claude Code | opencode |
|---|---|
| `~/.claude/skills/` | `~/.config/opencode/commands/` |
| `SKILL.md` with frontmatter | `.md` with optional frontmatter |
| `UserPromptSubmit` hook in `settings.json` | No native hook system — inject via custom instruction |
| Skill loaded via semantic match | Command invoked via `/command-name` or included in system prompt |
| `Skill(claudeception)` tool call | Read the command file content |

