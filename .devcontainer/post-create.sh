#!/usr/bin/env bash
set -euo pipefail

# Tmux config setup
echo "🖥️ Setting up tmux config..."
cp .devcontainer/python-uv/tmux.conf "$HOME/.tmux.conf"
echo "✅ Tmux config installed to ~/.tmux.conf"

# Tmux dev layouts setup
echo "🖥️ Setting up tmux dev layouts..."
cp .devcontainer/python-uv/tmux-dev-layouts.sh "$HOME/.tmux-dev-layouts.sh"
chmod +x "$HOME/.tmux-dev-layouts.sh"
sed -i '/\.tmux-dev-layouts\.sh/d' "$HOME/.bashrc" 2>/dev/null || true
echo 'source "$HOME/.tmux-dev-layouts.sh"' >>"$HOME/.bashrc"
if ! grep -q 'Tmux layouts:' "$HOME/.bashrc" 2>/dev/null; then
  echo 'echo "📺 Tmux layouts: tdl <ai>, tdlm <ai>, tsl <count> <cmd>"' >>"$HOME/.bashrc"
fi
echo "✅ Tmux dev layouts ready! Run: tdl copilot"
