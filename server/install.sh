#!/bin/bash
# Server-side dotfiles installation script
# Run this on your remote server to set up the development environment

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== Installing server dotfiles ==="

# Install .bashrc.prompt
echo "Installing .bashrc.prompt..."
cp "$DOTFILES_DIR/server/.bashrc.prompt" ~/.bashrc.prompt

# Add source line to .bashrc if not already present
if ! grep -q "source ~/.bashrc.prompt" ~/.bashrc 2>/dev/null; then
  echo "" >> ~/.bashrc
  echo "# Custom prompt with zmx and git" >> ~/.bashrc
  echo "source ~/.bashrc.prompt" >> ~/.bashrc
  echo "Added source line to .bashrc"
fi

# Install Claude config
echo "Installing Claude config..."
mkdir -p ~/.claude
cp "$DOTFILES_DIR/server/.claude/settings.json" ~/.claude/settings.json
cp "$DOTFILES_DIR/server/.claude/statusline.sh" ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh

# Create projects directory
mkdir -p ~/projects

echo ""
echo "=== Installation complete ==="
echo ""
echo "Next steps:"
echo "1. Run: source ~/.bashrc"
echo "2. Install zmx: ../scripts/install-zmx.sh"
echo "3. Set ANTHROPIC_API_KEY in your environment"
