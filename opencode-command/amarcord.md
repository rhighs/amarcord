---
description: Review current session for extractable knowledge and save it as opencode commands. Run at end of any session where you debugged, found workarounds, or discovered non-obvious patterns.
---

# /amarcord

Extracts reusable knowledge from this session and saves it as opencode command files.

## Usage

```
/amarcord                  # Review session and extract if valuable
/amarcord "context hint"   # Provide hint about what was discovered
```

## What This Does

1. Reviews the session for non-obvious discoveries
2. Evaluates each candidate against quality criteria
3. Checks ~/.config/opencode/commands/ for existing related files
4. Saves new commands or updates existing ones
5. Reports what was extracted and why

## Extraction Criteria

Extract when:
- Solution required significant investigation
- Error message was misleading or root cause non-obvious
- Workaround found through trial and error
- Project-specific pattern not in the docs

Skip when:
- Solution is in the official docs
- One-time fix with no future value

## Output Location

~/.config/opencode/commands/<kebab-name>.md

## Command File Format

---
description: When to use this and what problem it solves
---

# Title

## Problem
Exact symptom or error that triggers this

## Solution
Step-by-step fix or pattern

## Why It Works
Root cause explanation

## Watch Out For
Edge cases and gotchas

## After Each Session

Before closing, ask yourself:
- What took longer than expected?
- What would I tell a colleague hitting the same issue?
- What would I wish I knew at the start?

If any answer is non-trivial, run /amarcord.
