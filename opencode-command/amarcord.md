---
description: Extract reusable knowledge from this session and save it as opencode commands. Run at the end of any session where you debugged something, found a workaround, or figured out something non-obvious.
---

# /amarcord

Reviews this session for knowledge worth keeping. Saves anything valuable as a new
command file in `~/.config/opencode/commands/` so future sessions start smarter.

## Usage

```
/amarcord                        # review and extract
/amarcord "hint about the fix"   # guide what to focus on
```

## What You Do

Just run `/amarcord`. The agent does the rest.

## What the Agent Does

1. Reviews the session — what was hard? what required trial and error?
2. Applies quality criteria (see below)
3. Checks `~/.config/opencode/commands/` for existing related files to update
4. Writes new command files for anything that passes
5. Reports exactly what was saved and why

## Quality Criteria

**Save it if:**
- Solution required significant investigation — not immediately obvious
- Error message was misleading (root cause was different from the symptom)
- Workaround discovered through trial and error
- Project-specific pattern not covered in official docs
- Configuration that differs from the standard/expected setup

**Skip it if:**
- Answer is in the official docs in under a minute
- One-time fix with zero reuse potential
- Too project-specific to ever apply elsewhere

## Output Format

Each saved command follows this structure:

```markdown
---
description: When to use this + what problem it solves
---

# Title

## Problem
Exact symptom or error that triggers this

## Solution
Step-by-step fix or pattern, with code examples

## Why It Works
Root cause explanation — why the fix works, not just what to do

## Watch Out For
Edge cases and situations where this doesn't apply
```

## After Each Session

Three questions worth asking before closing:
- What took longer than expected?
- What would I tell a colleague hitting the same issue?
- What would I wish I knew at the start?

If any answer is non-trivial → run `/amarcord`.
