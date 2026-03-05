#!/bin/bash
set -e

OPENCODE_DIR="$HOME/.config/opencode/commands"
CLAUDE_DIR="$HOME/.claude/skills/amarcord"
BASE_URL="https://raw.githubusercontent.com/rhighs/amarcord/main"

echo "Installing amarcord..."
echo ""

# opencode
if [ -d "$OPENCODE_DIR" ] || command -v opencode &>/dev/null; then
  mkdir -p "$OPENCODE_DIR"
  curl -fsSL "$BASE_URL/opencode-command/amarcord.md" -o "$OPENCODE_DIR/amarcord.md"
  echo "✓ opencode: $OPENCODE_DIR/amarcord.md"
fi

# Claude Code
if [ -d "$HOME/.claude" ] || command -v claude &>/dev/null; then
  mkdir -p "$CLAUDE_DIR"
  curl -fsSL "$BASE_URL/SKILL.md" -o "$CLAUDE_DIR/SKILL.md"
  echo "✓ Claude Code: $CLAUDE_DIR/SKILL.md"
fi

echo ""
echo "Done."
echo ""
echo "Usage:"
echo "  opencode   → /amarcord"
echo "  claude     → /amarcord"
echo ""
echo "Team sync setup:"
echo "  curl -fsSL $BASE_URL/scripts/setup-team.sh | bash -s -- https://github.com/YOUR-ORG/team-skills"
