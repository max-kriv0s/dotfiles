#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$(uname)" != "Linux" ]]; then
  echo "x install.server-ai.sh is intended for Fedora Linux only"
  exit 1
fi

if [[ ! -f /etc/fedora-release ]]; then
  echo "x Fedora not detected"
  exit 1
fi

echo "--> Installing Fedora Server AI packages..."
bash "$DOTFILES/packages/fedora/packages.server-ai.sh"

if ! command -v stow &>/dev/null; then
  echo "x stow not found - should have been installed above"
  exit 1
fi

echo "--> Linking dotfiles..."
cd "$DOTFILES"

# Серверный набор: без графики, поэтому нет ghostty, alacritty и zed
PACKAGES=(
  zsh
  git
  tmux
  nvim
  lazygit
)

for pkg in "${PACKAGES[@]}"; do
  if [[ -d "$DOTFILES/$pkg" ]]; then
    echo "  v stow $pkg"
    stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
  fi
done

if command -v zsh &>/dev/null && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
  echo "--> Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
fi

echo "Fedora Server AI setup complete"
