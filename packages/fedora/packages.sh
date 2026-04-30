#!/usr/bin/env bash

#!/usr/bin/env bash

set -euo pipefail

echo "--> Updating DNF..."
sudo dnf update -y

# ── Shell ────────────────────────────────────────────────────────────────────
PACKAGES=(
  zsh                  # shell
  stow                 # управление симлинками dotfiles

  # ── Редакторы ──────────────────────────────────────────────────────────────
  neovim               # терминальный редактор
  micro                # простой редактор для быстрых правок

  # ── Git ────────────────────────────────────────────────────────────────────
  git                  # актуальная версия git
  git-delta            # красивый diff с подсветкой синтаксиса

  # ── Современные замены unix утилит ─────────────────────────────────────────
  eza                  # замена ls
  bat                  # замена cat
  fd-find              # замена find (на fedora называется fd-find)
  ripgrep              # замена grep
  fzf                  # fuzzy finder
  zoxide               # замена cd
  tldr                 # короткие man-страницы
  tree                 # структура папок

  # ── Файловый менеджер ───────────────────────────────────────────────────────
  yazi                 # TUI файловый менеджер

  # ── Dev: языки ──────────────────────────────────────────────────────────────
  golang               # Go (на fedora называется golang)

  # ── Dev: утилиты ────────────────────────────────────────────────────────────
  lazydocker           # TUI для Docker
)

echo "--> Installing packages..."
sudo dnf install -y "${PACKAGES[@]}"

# ── Starship ─────────────────────────────────────────────────────────────────
# не в DNF — ставится отдельным скриптом
if ! command -v starship &>/dev/null; then
  echo "--> Installing starship..."
  curl -sS https://starship.rs/install.sh | sh
fi

# ── nvm + Node ───────────────────────────────────────────────────────────────
if ! command -v nvm &>/dev/null; then
  echo "--> Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default node
fi

# ── uv (Python менеджер) ─────────────────────────────────────────────────────
if ! command -v uv &>/dev/null; then
  echo "--> Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
