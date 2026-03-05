#!/bin/bash
set -e

COMMANDS_DIR="$HOME/.config/opencode/commands"
AMARCORD_URL="https://raw.githubusercontent.com/rhighs/amarcord/main/opencode-command/amarcord.md"

mkdir -p "$COMMANDS_DIR"

echo "Installing amarcord..."
curl -fsSL "$AMARCORD_URL" -o "$COMMANDS_DIR/amarcord.md"

echo ""
echo "Done. amarcord installed at:"
echo "  $COMMANDS_DIR/amarcord.md"
echo ""
echo "Usage: run /amarcord at the end of any opencode session where"
echo "you learned something non-obvious."
