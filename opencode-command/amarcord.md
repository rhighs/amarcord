---
description: Extract reusable knowledge from this session. Saves it locally and optionally syncs to a shared team repo via PR. Run at the end of any session where you debugged something non-obvious.
---

# /amarcord

Reviews this session for knowledge worth keeping. Saves it as a command file,
checks for duplicates, and (if team sync is configured) opens a PR to share it.

## Usage

```
/amarcord                        # review and extract
/amarcord "hint about what to extract"
```

---

## Step 1 — Review the session

Look back at what happened this session. Ask:
- What required trial and error?
- What would have saved time if documented?
- Was the error message misleading?

If nothing non-obvious happened → say so and stop.

---

## Step 2 — Determine namespace

Read the current git remote to determine the namespace:

```bash
git remote get-url origin 2>/dev/null | sed 's|.*[:/]\([^/]*\)/\([^/]*\)\.git|\1/\2|; s|.*[:/]\([^/]*\)/\([^/]*\)|\1/\2|'
```

If that returns something like `rhighs/my-project`, the namespace is `my-project`.
If no git remote, use `general`.

Skill filename format: `{namespace}:{kebab-description}.md`
Example: `my-project:mcp-proxy-namespaced-params.md`

---

## Step 3 — Duplicate detection

List existing skills:

```bash
# opencode
ls ~/.config/opencode/commands/*.md 2>/dev/null | xargs -I{} head -5 {} 2>/dev/null

# claude code
ls ~/.claude/skills/*/SKILL.md 2>/dev/null | xargs -I{} head -5 {} 2>/dev/null
```

Look at their descriptions. Ask yourself: is what I'm about to save already covered?

**If a duplicate exists** → update it instead of creating a new file.
**If partial overlap** → add a new section to the existing file.
**If no overlap** → create new.

---

## Step 4 — Write the skill

### For opencode

Save to `~/.config/opencode/commands/{namespace}:{name}.md`:

```markdown
---
description: One-line description. When to use it. What problem it solves.
namespace: {namespace}
---

# Title

## Problem
Exact symptom or error

## Solution
Step-by-step fix with code examples

## Why It Works
Root cause — not just what to do, but why it works

## Watch Out For
Edge cases where this doesn't apply
```

### For Claude Code

Create `~/.claude/skills/{namespace}:{name}/SKILL.md` with the same content but
add YAML frontmatter:

```yaml
---
name: {namespace}:{name}
description: |
  Same description as above — be specific enough for semantic matching
version: 1.0.0
---
```

---

## Step 5 — Team sync (if configured)

Check if team sync is configured:

```bash
cat ~/.config/amarcord/team.conf 2>/dev/null
```

If the file exists and contains `TEAM_REPO_PATH`, run:

```bash
~/.config/amarcord/sync.sh {skill-file-path}
```

This copies the skill to the team repo and opens a PR. If not configured, skip silently.

---

## Quality Criteria

**Save it if:**
- Required significant investigation — not immediately obvious
- Error message was misleading (root cause non-obvious)
- Workaround found through trial and error
- Project-specific pattern not in official docs

**Skip it if:**
- Answer is in the docs in under a minute
- Zero reuse potential
- Too specific to ever apply elsewhere
