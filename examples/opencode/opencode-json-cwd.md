---
description: opencode doesn't inherit cwd from the terminal — the opencode.json must be in the project root or you must set cwd explicitly. Use when opencode can't find project files or runs tools from the wrong directory.
---

# opencode Working Directory

## Problem
opencode runs tools from the wrong directory. File reads fail. Git commands
operate on the wrong repo. Build commands don't find the project.

## Solution

Create or check `opencode.json` at the project root:

```json
{
  "cwd": "/absolute/path/to/project"
}
```

Or launch opencode from the project root:
```bash
cd ~/repos/my-project && opencode
```

## Why It Works
opencode resolves relative paths from its own cwd, not the terminal's.
If launched from `~` with a project at `~/repos/foo`, all relative paths break.

## Watch Out For
- The `opencode.json` `cwd` must be absolute — relative paths are relative to
  where opencode is installed, not where you expect
- Per-project `opencode.json` takes precedence over global config
