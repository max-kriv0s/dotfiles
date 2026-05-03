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
  zsh
  tmux
  git
  nvim
  zed
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
# Node (через fnm)
# ──────────────────────────────────────────────────────
if command -v fnm &>/dev/null; then
  eval "$(fnm env --shell bash)"
  if ! fnm list | grep -q "v22"; then
    echo "--> Installing Node LTS..."
    fnm install --lts
    fnm default lts-latest
  fi
fi

# ── TPM (Tmux Plugin Manager) ─────────────────────────────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "--> Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# ── oh-my-zsh ────────────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "--> Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ── powerlevel10k ─────────────────────────────────────────────────────────────
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
  echo "--> Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# ── zsh plugins ──────────────────────────────────────────────────────────────
if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo ""
echo "==> Готово! Перезапусти терминал."
echo "    Не забудь заполнить ~/.gitconfig.local"
