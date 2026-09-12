#!/usr/bin/env bash

set -euo pipefail

echo "--> Updating DNF..."
sudo dnf update -y

PACKAGES=(
  # Shell / terminal
  zsh
  stow
  tmux
  btop

  # SSH / server basics
  openssh-server
  curl
  wget
  unzip
  tar
  dnf-plugins-core

  # Editors
  neovim

  # Git
  git
  git-delta
  gh

  # Modern unix tools
  eza
  bat
  fd-find
  ripgrep
  fzf
  zoxide
  tldr
  tree

  # Dev languages / build tools
  golang
  lua
  tree-sitter-cli
  make
  gcc
  gcc-c++
  pkgconf-pkg-config
  openssl-devel
)

echo "--> Installing packages..."
sudo dnf install -y "${PACKAGES[@]}"

# COPR helper function
enable_copr() {
  local repo="$1"
  if ! dnf repolist | grep -q "$repo"; then
    sudo dnf copr enable -y "$repo"
  fi
}

if ! command -v yazi &>/dev/null; then
  echo "--> Installing yazi (COPR)..."
  enable_copr "lihaohong/yazi"
  sudo dnf install -y yazi
fi

if ! command -v lazygit &>/dev/null; then
  echo "--> Installing lazygit (COPR)..."
  enable_copr "dejan/lazygit"
  sudo dnf install -y lazygit
fi

echo "--> Enabling SSH service..."
sudo systemctl enable --now sshd

if ! command -v fnm &>/dev/null; then
  echo "--> Installing fnm..."
  SHELL="$(command -v zsh)" \
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi

if ! command -v uv &>/dev/null; then
  echo "--> Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
