# Manual Installation — macOS

Эти инструменты недоступны в Homebrew и устанавливаются вручную.

## Browsers

### Zen Browser
Privacy-focused browser based on Firefox.
https://zen-browser.app

## System Monitoring

### MoniThor
Menu bar system monitor.
https://monithor.dev

### MacVitals
System health monitor.
https://macvitals.app

## Obsidian CLI

Obsidian CLI поставляется вместе с приложением Obsidian.
После установки через Brewfile добавь его в PATH:

\```bash
# Добавь в ~/.zshrc.local
export PATH="$PATH:/Applications/Obsidian.app/Contents/Resources/bin"
\```

Проверить:
\```bash
obsidian --version
\```
