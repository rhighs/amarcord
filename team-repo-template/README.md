# team-skills

Shared AI agent skills for the team. Works with both opencode and Claude Code.

Every skill here was extracted by [amarcord](https://github.com/rhighs/amarcord)
from a real session — non-obvious fixes, workarounds, project patterns.

## Structure

```
opencode/         → opencode command files (~/.config/opencode/commands/)
claude/           → Claude Code skills (~/.claude/skills/)
```

## Install (one-time)

```bash
curl -fsSL https://raw.githubusercontent.com/rhighs/amarcord/main/scripts/setup-team.sh | bash -s -- https://github.com/YOUR-ORG/team-skills
```

This clones the repo and symlinks everything into place via `stow`.

## Pull latest skills

```bash
git pull
stow opencode --target=~/.config/opencode/commands --restow
stow claude   --target=~/.claude --restow
```

## Add a skill (via amarcord)

Run `/amarcord` at the end of any opencode or Claude Code session.
If team sync is configured, it opens a PR automatically.

## Namespace convention

Skill files are named `{project}:{description}.md`

- `my-project:mcp-proxy-namespaced-params.md`
- `general:git-rebase-conflict-resolution.md`
- `pleasetriage:vercel-dns-config.md`
