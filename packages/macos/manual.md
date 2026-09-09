# Manual Installation — macOS

Эти инструменты недоступны в Homebrew и устанавливаются вручную.

Обновляются только руками — brew про них не знает. Раз в пару месяцев проходим
по списку и проверяем версии. Подробнее: [docs/brew.md](../../docs/brew.md).

## VPN

### AmneziaVPN
Клиент AmneziaVPN. В Mac App Store отсутствует.
https://amnezia.org — или релизы https://github.com/amnezia-vpn/amnezia-client/releases

> Ставит системное расширение и helper-демон. Обновлять **только** штатным
> установщиком из .dmg, не перетаскиванием `.app` поверх старого — иначе
> останется старый helper и туннель перестанет подниматься.
>
> Перед обновлением проверить, не появился ли cask: `brew info --cask amnezia-vpn`.
> Если появился — перейти на brew и дописать в Brewfile.

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
