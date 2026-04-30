# Manual Installation — Fedora

Эти инструменты недоступны в DNF/Flatpak и устанавливаются вручную.

## Browsers

### Zen Browser
Privacy-focused browser based on Firefox.
https://zen-browser.app

## System Monitoring

### MoniThor
Menu bar system monitor (macOS only).

### MacVitals
System health monitor (macOS only).

## Obsidian CLI

Obsidian CLI поставляется вместе с приложением Obsidian.
После установки добавь его в PATH:

\```bash
# Добавь в ~/.zshrc.local
export PATH="$PATH:~/.local/bin"
# или где лежит бинарник после установки Obsidian на Linux
\```

## VS Code

Flatpak версия не рекомендуется — проблемы с расширениями и путями.
Ставить через официальный репозиторий Microsoft:

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install code
```
