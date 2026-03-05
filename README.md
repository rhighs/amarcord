# amarcord

> *"amarcord"* — Romagnolo for "I remember." Also: makes your AI agent remember what it learned, and share it with the team.

---

Every session, your agent figures out something non-obvious. Then forgets it.

**amarcord** extracts that knowledge and saves it as a command file. Next session, it's already there. And if you're on a team, one person's discovery becomes everyone's — via a PR to a shared repo.

```
session ends → /amarcord → skill saved locally → PR opened → team benefits
```

---

## Works with both opencode and Claude Code

| | opencode | Claude Code |
|---|---|---|
| Command | `/amarcord` | `/amarcord` |
| Skills location | `~/.config/opencode/commands/` | `~/.claude/skills/` |
| Team sync | ✅ | ✅ |

---

## Install

### Solo (local only)

```bash
curl -fsSL https://raw.githubusercontent.com/rhighs/amarcord/main/install.sh | bash
```

### Team (shared repo + PR workflow)

```bash
# 1. Create a shared repo (e.g. github.com/your-org/team-skills)
#    Use the template at team-repo-template/ as a starting point

# 2. Run setup on each machine
curl -fsSL https://raw.githubusercontent.com/rhighs/amarcord/main/scripts/setup-team.sh \
  | bash -s -- https://github.com/YOUR-ORG/team-skills
```

This clones the team repo and symlinks all skills into place via `stow`.
From now on, `/amarcord` will open a PR instead of saving locally only.

---

## How team sync works

When `/amarcord` extracts a skill, it:

1. Detects the namespace from the current git repo (`my-project`, `pleasetriage`, `general`, etc.)
2. Checks existing skills for duplicates — updates instead of creating if already covered
3. Saves locally (so it's available immediately)
4. Creates a branch in the team repo and opens a PR

Skills are stored in the team repo as:
```
opencode/{namespace}:{skill-name}.md       ← for opencode
claude/{namespace}:{skill-name}/SKILL.md   ← for Claude Code
```

Everyone reviews, merges, and pulls. One discovery → everyone benefits.

---

## Namespace convention

Skill filenames include the project they came from:

```
my-project:mcp-proxy-namespaced-params.md
general:git-rebase-conflict-resolution.md
pleasetriage:vercel-dns-config.md
```

This keeps project-specific skills separate from general ones and makes it easy
to grep for what you need.

---

## Team repo structure

```
team-skills/
  opencode/                    ← stowed to ~/.config/opencode/commands/
    my-project:some-fix.md
    general:some-pattern.md
  claude/                      ← stowed to ~/.claude/skills/
    my-project:some-fix/
      SKILL.md
    general:some-pattern/
      SKILL.md
  README.md
```

---

## Pull latest team skills

```bash
cd ~/.local/share/amarcord/team-skills
git pull
stow opencode --target=~/.config/opencode/commands --restow
stow claude   --target=~/.claude --restow
```

---

## Requirements

- `git` and `gh` CLI (for team sync + PRs)
- `stow` (`brew install stow` / `apt install stow`) for team setup
- opencode or Claude Code

---

## Credit

Inspired by [Claudeception](https://github.com/blader/Claudeception) by [@blader](https://github.com/blader).
Team sync concept from a conversation with Luca Battistini and Michele Battelli.
