#!/usr/bin/env bash

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  # Homebrew
  if ! command -v brew &>/dev/null; then
    echo "--> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# ──────────────────────────────────────────────────────
# zsh
# ──────────────────────────────────────────────────────
if ! command -v zsh &>/dev/null; then
  echo "--> zsh not found, installing..."

  if [[ "$OS" == "Linux" ]]; then
    sudo dnf install -y zsh
  elif [[ "$OS" == "Darwin" ]]; then
    brew install zsh
  fi
fi

ZSH_PATH="$(command -v zsh)"

if [[ "$OS" == "Darwin" ]]; then
  CURRENT_SHELL="$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')"
else
  CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
fi

if [[ -z "$CURRENT_SHELL" ]]; then
  echo "✗ Could not determine current shell for user $USER" >&2
  exit 1
fi

if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
  echo "--> Setting zsh as default shell..."
  chsh -s "$ZSH_PATH" "$USER"

  echo ""
  echo "⚠️ Please re-login or restart terminal"
  exit 0
fi
# ──────────────────────────────────────────────────────

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
  echo "--> Installing packages from Brewfile.dev..."
  brew bundle --file="$DOTFILES/packages/macos/Brewfile.dev"

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
  if [[ -d "$DOTFILES/$pkg" ]]; then
    echo "  ✓ stow $pkg"
    stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
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
  echo "--> fnm detected, initializing..."

  # только если fnm реально работает
  if fnm --version &>/dev/null; then
    fnm install --lts || true
    fnm default lts-latest || true
    fnm use lts-latest || true
  fi
fi

# ── TPM (Tmux Plugin Manager) ─────────────────────────────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "--> Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# VS Code
if [[ "$OS" == "Darwin" ]]; then
  VSCODE_DIR="$HOME/Library/Application Support/Code/User"
elif [[ -f /etc/fedora-release ]]; then
  VSCODE_DIR="$HOME/.config/Code/User"
fi

if [[ -n "$VSCODE_DIR" ]]; then
  mkdir -p "$VSCODE_DIR"
  ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_DIR/settings.json"
  ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_DIR/keybindings.json"
  echo "--> VS Code config linked"
fi

# VS Code extensions
if command -v code &>/dev/null; then
  echo "--> Installing VS Code extensions..."
  while IFS= read -r extension; do
    code --install-extension "$extension" --force
  done < "$DOTFILES/vscode/extensions.txt"
fi

echo ""
echo "==> Готово! Перезапусти терминал."
echo "    Не забудь заполнить ~/.gitconfig.local"
