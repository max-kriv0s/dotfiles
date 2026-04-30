#!/usr/bin/env bash

set -euo pipefail

# Убедимся что flatpak установлен
if ! command -v flatpak &>/dev/null; then
  echo "--> Installing flatpak..."
  sudo dnf install -y flatpak
fi

# Добавляем Flathub если ещё нет
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "--> Installing flatpak packages..."

FLATPAKS=(
  com.discordapp.Discord        # Discord
  us.zoom.Zoom                  # Zoom
  md.obsidian.Obsidian          # Obsidian
  org.keepassxc.KeePassXC       # менеджер паролей
  com.brave.Browser             # Brave Browser
  org.mozilla.firefox           # Firefox
  io.github.zen_browser.zen     # Zen Browser
  com.gitlab.davem.DBeaver      # DBeaver
  io.tableplus.TablePlus        # TablePlus
  io.beekeeperstudio.Bruno      # Bruno (замена Postman)
)

for pkg in "${FLATPAKS[@]}"; do
  echo "  → $pkg"
  flatpak install -y flathub "$pkg"
done#!/usr/bin/env bash
