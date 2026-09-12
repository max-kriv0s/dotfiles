#!/usr/bin/env bash

set -euo pipefail

echo "--> Updating DNF..."
sudo dnf update -y

# ── Shell ────────────────────────────────────────────────────────────────────
PACKAGES=(

  alacritty

  #zsh                  # shell
  stow                 # управление симлинками dotfiles
  tmux		       # терминальный мультиплексор
  btop 
  
  # ── Редакторы ──────────────────────────────────────────────────────────────
  neovim               # терминальный редактор

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

  # ── Dev: языки ──────────────────────────────────────────────────────────────
  golang               # Go (на fedora называется golang)
  lua                  # Lua
  tree-sitter-cli      # CLI для сборки parsers nvim-treesitter
)

echo "--> Installing packages..."
sudo dnf install -y "${PACKAGES[@]}"

echo "--> Ensuring dnf-plugins-core is installed..."
if ! rpm -q dnf-plugins-core &>/dev/null; then
  sudo dnf install -y dnf-plugins-core
fi

# ─────────────────────────────────────────────────────────────
# COPR helper function
# ─────────────────────────────────────────────────────────────
enable_copr() {
  local repo="$1"
  if ! dnf repolist | grep -q "$repo"; then
    sudo dnf copr enable -y "$repo"
  fi
}

# ─────────────────────────────────────────────────────────────
# Ghostty
# ─────────────────────────────────────────────────────────────
if ! command -v ghostty &>/dev/null; then
  echo "--> Installing Ghostty..."
  enable_copr "scottames/ghostty"
  sudo dnf install -y ghostty
fi

# Yazi (COPR) - Файловый менеджер
if ! command -v yazi >/dev/null 2>&1; then
echo "--> Installing yazi..."

if ! dnf repolist | grep -q "copr.fedorainfracloud.org:lihaohong"; then
sudo dnf copr enable -y lihaohong/yazi
fi

sudo dnf install -y yazi # TUI файловый менеджер
fi

# Lazydocker (COPR)
if ! command -v lazydocker &>/dev/null; then
  echo "--> Installing lazydocker (COPR)..."

  sudo dnf copr enable -y atim/lazydocker
  sudo dnf install -y lazydocker
fi

# Lazygit (COPR)
if ! command -v lazygit &>/dev/null; then
  echo "--> Installing lazygit (COPR)..."

  sudo dnf copr enable -y dejan/lazygit
  sudo dnf install -y lazygit
fi

# fnm (не в DNF — ставится через curl)
if ! command -v fnm &>/dev/null; then
  echo "--> Installing fnm..."
  
  SHELL="$(command -v zsh)" \
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

# uv (Python менеджер)
if ! command -v uv &>/dev/null; then
  echo "--> Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ── TablePlus ────────────────────────────────────────────────────────────────
if ! command -v tableplus &>/dev/null; then
  echo "--> Installing TablePlus..."

  # repo key (idempotent)
  sudo rpm -v --import https://yum.tableplus.com/apt.tableplus.com.gpg.key

  # repo (only if missing)
  if [[ ! -f /etc/yum.repos.d/tableplus.repo ]]; then
    sudo dnf config-manager addrepo \
      --from-repofile=https://yum.tableplus.com/rpm/x86_64/tableplus.repo
  fi

  # install
  sudo dnf install -y tableplus
fi
