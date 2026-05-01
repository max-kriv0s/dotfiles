#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

echo "==> Dotfiles bootstrap | OS: $OS | Dir: $DOTFILES"

# ──────────────────────────────────────────────────────
# macOS
# ──────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then

  # Homebrew
  if ! command -v brew &>/dev/null; then
    echo "--> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Brewfile
  echo "--> Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES/packages/macos/Brewfile"

# ──────────────────────────────────────────────────────
# Fedora
# ──────────────────────────────────────────────────────
elif [[ -f /etc/fedora-release ]]; then

  echo "--> Installing packages for Fedora..."
  bash "$DOTFILES/packages/fedora/packages.sh"

  echo "--> Installing flatpak packages..."
  bash "$DOTFILES/packages/fedora/flatpak.sh"

else
  echo "⚠ Unknown OS, skipping package installation"
  exit 1
fi

# ──────────────────────────────────────────────────────
# Stow
# ──────────────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  echo "✗ stow not found — should have been installed above"; exit 1
fi

echo "--> Stowing dotfiles..."
cd "$DOTFILES"

PACKAGES=(
  ghostty
  alacritty   
  # zsh
  # git
  # nvim
)

for pkg in "${PACKAGES[@]}"; do
  if [[ -d "$pkg" ]]; then
    echo "  ✓ stow $pkg"
    stow --restow "$pkg"
  fi
done

# ──────────────────────────────────────────────────────
# .local шаблоны (не перезаписывать если уже есть)
# ──────────────────────────────────────────────────────
[[ ! -f ~/.gitconfig.local ]] && \
  cp "$DOTFILES/local/.gitconfig.local.example" ~/.gitconfig.local && \
  echo "--> Created ~/.gitconfig.local — заполни имя и email"

[[ ! -f ~/.zshrc.local ]] && \
  cp "$DOTFILES/local/.zshrc.local.example" ~/.zshrc.local && \
  echo "--> Created ~/.zshrc.local — для машино-специфичных настроек"

# ──────────────────────────────────────────────────────
# macOS defaults
# ──────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]] && [[ -f "$DOTFILES/scripts/macos-defaults.sh" ]]; then
  echo "--> Applying macOS defaults..."
  bash "$DOTFILES/scripts/macos-defaults.sh"
fi

# ──────────────────────────────────────────────────────
# Node (через nvm)
# ──────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"

  if ! command -v node &>/dev/null; then
    echo "--> Installing Node LTS..."
    nvm install --lts
    nvm alias default node
  fi
fi

echo ""
echo "==> Готово! Перезапусти терминал."
echo "    Не забудь заполнить ~/.gitconfig.local"
