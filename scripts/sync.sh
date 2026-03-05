#!/bin/bash
# amarcord sync — copy a skill to the team repo and open a PR
# Usage: sync.sh <skill-file-path>
set -e

SKILL_FILE="$1"
CONF="$HOME/.config/amarcord/team.conf"

if [ ! -f "$CONF" ]; then
  echo "No team config found at $CONF. Run setup.sh first." >&2
  exit 1
fi

source "$CONF"   # loads TEAM_REPO_PATH, TEAM_REPO_REMOTE

if [ ! -d "$TEAM_REPO_PATH" ]; then
  echo "Team repo not found at $TEAM_REPO_PATH" >&2
  exit 1
fi

if [ ! -f "$SKILL_FILE" ]; then
  echo "Skill file not found: $SKILL_FILE" >&2
  exit 1
fi

SKILL_NAME=$(basename "$SKILL_FILE" .md)
BRANCH="amarcord/${SKILL_NAME}-$(date +%Y%m%d-%H%M%S)"

cd "$TEAM_REPO_PATH"
git fetch origin --quiet

# Create branch off main
git checkout -b "$BRANCH" origin/main --quiet

# Detect tool and copy to right location
OPENCODE_DEST="opencode/${SKILL_NAME}.md"
CLAUDE_DEST="claude/${SKILL_NAME}/SKILL.md"

mkdir -p "opencode" "claude/${SKILL_NAME}"

# Copy as opencode command
cp "$SKILL_FILE" "$OPENCODE_DEST"

# Generate Claude Code SKILL.md (same content, with required frontmatter)
TITLE=$(grep '^# ' "$SKILL_FILE" | head -1 | sed 's/^# //')
DESC=$(grep -A1 '^description:' "$SKILL_FILE" | tail -1 | sed 's/^  //')

cat > "$CLAUDE_DEST" << SKILLEOF
---
name: ${SKILL_NAME}
description: |
  $(grep 'description:' "$SKILL_FILE" -A3 | grep -v '^---' | grep -v 'description:' | head -2 | sed 's/^  //')
version: 1.0.0
---

$(cat "$SKILL_FILE" | grep -v '^---' | grep -v '^description:' | grep -v '^namespace:' | sed '/^$/N;/^\n$/d')
SKILLEOF

git add "$OPENCODE_DEST" "$CLAUDE_DEST"
git commit -m "skill: add ${SKILL_NAME}

Extracted by amarcord. Works with both opencode and Claude Code.
opencode: ~/.config/opencode/commands/${SKILL_NAME}.md
claude:   ~/.claude/skills/${SKILL_NAME}/SKILL.md"

git push origin "$BRANCH" --quiet

# Open PR
gh pr create \
  --title "skill: ${SKILL_NAME}" \
  --body "## New skill: \`${SKILL_NAME}\`

Extracted by amarcord from a session.

### Install
\`\`\`bash
# opencode
cp opencode/${SKILL_NAME}.md ~/.config/opencode/commands/

# Claude Code
cp -r claude/${SKILL_NAME}/ ~/.claude/skills/
\`\`\`

### Auto-install via stow
\`\`\`bash
stow opencode -t ~/.config/opencode/commands
stow claude   -t ~/.claude
\`\`\`
" \
  --head "$BRANCH" \
  --base main

echo "PR opened for skill: ${SKILL_NAME}"
