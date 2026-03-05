# Opencode-ception

Port of [Claudeception](https://github.com/blader/Claudeception) for [opencode](https://opencode.ai).

Same concept: extract reusable knowledge from work sessions and save it as commands
so future sessions start smarter instead of from zero.

## How It Differs from the Claude Code Version

| Claude Code | opencode |
|---|---|
| `~/.claude/skills/` | `~/.config/opencode/commands/` |
| `SKILL.md` with frontmatter | `.md` command files |
| `UserPromptSubmit` hook | System prompt injection (see below) |
| `Skill(claudeception)` tool | `/opencode-ception` command |

## Installation

### Step 1 — Add the command

```bash
cp opencode-command/opencode-ception.md ~/.config/opencode/commands/
```

### Step 2 — Enable auto-evaluation (optional but recommended)

The original uses a `UserPromptSubmit` hook to inject a reminder on every prompt.
opencode doesn't have a hook system, so instead add this to your opencode system prompt
or project-level `AGENTS.md`:

```
After completing any task that involved non-obvious investigation, debugging, or
trial-and-error, evaluate whether the session produced extractable knowledge.
If yes, run /opencode-ception to save it as a reusable command.
```

### Step 3 — Use it

At the end of any session where you learned something non-trivial:

```
/opencode-ception
```

opencode will review the session, decide what's worth keeping, and write a new
command file to `~/.config/opencode/commands/`.

## What Gets Extracted

Non-obvious debugging techniques, workarounds, project-specific patterns, tool
integration knowledge, error resolution (especially where the error message was misleading).

Not extracted: obvious solutions, one-off fixes, things already in the docs.

## Examples

See `examples/` for sample extracted commands from real sessions.
