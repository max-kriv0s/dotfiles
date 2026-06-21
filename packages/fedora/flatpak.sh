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
  app.zen_browser.zen	        # Zen Browser
  ru.yandex.Browser		# Yandex Browser
  io.dbeaver.DBeaverCommunity   # DBeaver
  com.usebruno.Bruno	        # Bruno (замена Postman)
)

for pkg in "${FLATPAKS[@]}"; do
  if flatpak list --app | awk '{print $1}' | grep -q "^$pkg$"; then
    echo "  → already installed: $pkg"
  else
    echo "  → installing $pkg"
    flatpak install -y flathub "$pkg"
  fi
done
