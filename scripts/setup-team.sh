#!/bin/bash
# amarcord team setup — clone shared repo, configure stow, write team.conf
set -e

echo "amarcord team setup"
echo ""

if [ -z "$1" ]; then
  echo "Usage: setup-team.sh <team-repo-url>"
  echo "Example: setup-team.sh https://github.com/myteam/skills"
  exit 1
fi

TEAM_REPO_URL="$1"
TEAM_REPO_PATH="${2:-$HOME/.local/share/amarcord/team-skills}"

# Clone or pull team repo
if [ -d "$TEAM_REPO_PATH/.git" ]; then
  echo "→ Pulling latest team skills..."
  git -C "$TEAM_REPO_PATH" pull --quiet
else
  echo "→ Cloning team skills repo..."
  git clone "$TEAM_REPO_URL" "$TEAM_REPO_PATH" --quiet
fi

# Write config
mkdir -p "$HOME/.config/amarcord"
cat > "$HOME/.config/amarcord/team.conf" << CONF
TEAM_REPO_PATH="$TEAM_REPO_PATH"
TEAM_REPO_REMOTE="$TEAM_REPO_URL"
CONF

echo "→ Config written to ~/.config/amarcord/team.conf"

# Install stow if not present
if ! command -v stow &>/dev/null; then
  echo "→ stow not found. Install it:"
  echo "   brew install stow     # macOS"
  echo "   apt install stow      # Ubuntu/Debian"
  exit 0
fi

# Stow opencode skills
if [ -d "$TEAM_REPO_PATH/opencode" ]; then
  mkdir -p "$HOME/.config/opencode/commands"
  stow --dir="$TEAM_REPO_PATH" opencode --target="$HOME/.config/opencode/commands" --restow
  echo "→ opencode skills linked to ~/.config/opencode/commands/"
fi

# Stow Claude Code skills  
if [ -d "$TEAM_REPO_PATH/claude" ]; then
  mkdir -p "$HOME/.claude/skills"
  stow --dir="$TEAM_REPO_PATH" claude --target="$HOME/.claude" --restow
  echo "→ Claude Code skills linked to ~/.claude/skills/"
fi

# Copy sync.sh to amarcord config dir
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/sync.sh" "$HOME/.config/amarcord/sync.sh"
chmod +x "$HOME/.config/amarcord/sync.sh"

echo ""
echo "Done. Team skills are live."
echo ""
echo "When amarcord extracts a skill, it will open a PR to:"
echo "  $TEAM_REPO_URL"
echo ""
echo "To pull latest skills from the team:"
echo "  git -C $TEAM_REPO_PATH pull && stow --restow"
