# Manual Installation — Fedora

Эти инструменты недоступны в DNF/Flatpak и устанавливаются вручную.

## Установка шрифта JetBrains Mono
скачиваем https://www.jetbrains.com/lp/mono/ , потом разархивируем
```bash
mkdir -p ~/.local/share/fonts/jetbrains-mono
cp ttf/*.ttf ~/.local/share/fonts/jetbrains-mono/

fc-cache -fv # обновление кеша
fc-list | grep -i "JetBrains" # проверка 
```

скачиваем nerd-fonts `curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip`
```bash
mkdir -p ~/.local/share/fonts/jetbrains-nerd
cp *Mono-Regular.ttf ~/.local/share/fonts/jetbrains-nerd/
cp *Mono-Bold.ttf ~/.local/share/fonts/jetbrains-nerd/
cp *Mono-Italic.ttf ~/.local/share/fonts/jetbrains-nerd/
cp *Mono-BoldItalic.ttf ~/.local/share/fonts/jetbrains-nerd/
fc-cache -fv
```


## VS Code

Flatpak версия не рекомендуется — проблемы с расширениями и путями.
Ставить через официальный репозиторий Microsoft:

https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

dnf check-update &&
sudo dnf install code
```

### GitHub CLI
https://github.com/cli/cli/blob/trunk/docs/install_linux.md#rpm

```bash
sudo dnf install dnf5-plugins
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh
```
