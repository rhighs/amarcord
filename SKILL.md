---
name: amarcord
description: |
  Continuous learning system for AI coding agents. Extracts reusable knowledge from
  work sessions and saves it as skills/commands for future sessions.
  Triggers: (1) /amarcord command, (2) "save this as a skill", (3) "what did we learn?",
  (4) after any non-obvious debugging, workaround, or trial-and-error discovery.
  Supports team sync: opens a PR to a shared repo so the whole team benefits.
version: 2.0.0
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
---

# amarcord

Makes your AI agent remember what it learned, and share it with the team.

## Core Principle

When you discover something non-obvious — a workaround, a debugging technique,
a project-specific pattern — save it so future sessions start smarter.
If team sync is configured, open a PR so everyone benefits.

## Step 1 — Review the session

Ask: what required trial and error? What was the error message misleading about?
What would have saved time if already documented?

If nothing non-obvious happened → say so and stop.

## Step 2 — Determine namespace

```bash
git remote get-url origin 2>/dev/null | sed 's|.*[:/]\([^/]*\)/\([^/]*\)\.git|\1/\2|; s|.*[:/]\([^/]*\)/\([^/]*\)|\1/\2|' | cut -d'/' -f2
```

Use the repo name as namespace. No git remote → use `general`.
Skill name format: `{namespace}:{kebab-description}`

## Step 3 — Duplicate detection

```bash
# Claude Code
ls ~/.claude/skills/*/SKILL.md 2>/dev/null | xargs -I{} head -5 {}

# opencode
ls ~/.config/opencode/commands/*.md 2>/dev/null | xargs -I{} head -5 {}
```

Look at their descriptions. Is what you're about to save already covered?
- Duplicate → update existing file
- Partial overlap → add new section to existing file
- No overlap → create new

## Step 4 — Write the skill

### Claude Code
Save to `~/.claude/skills/{namespace}:{name}/SKILL.md`:

```yaml
---
name: {namespace}:{name}
description: |
  Specific enough for semantic matching: what problem, what symptom, when to use
version: 1.0.0
---

# Title

## Problem
Exact symptom or error

## Solution
Step-by-step fix with code examples

## Why It Works
Root cause explanation

## Watch Out For
Edge cases
```

### opencode
Save same content to `~/.config/opencode/commands/{namespace}:{name}.md`
with a simpler frontmatter (no `name` or `allowed-tools` needed).

## Step 5 — Team sync (if configured)

```bash
cat ~/.config/amarcord/team.conf 2>/dev/null
```

If `TEAM_REPO_PATH` is set, run:
```bash
~/.config/amarcord/sync.sh {skill-file-path}
```

This copies the skill to both `opencode/` and `claude/` directories in the team repo
and opens a PR. If not configured, skip silently.

## Quality Criteria

**Save it if:**
- Required significant investigation — not immediately obvious
- Error message was misleading
- Workaround found through trial and error
- Project-specific pattern not in official docs

**Skip it if:**
- Answer is in the docs in under a minute
- Zero reuse potential
- One-time fix that'll never apply elsewhere
