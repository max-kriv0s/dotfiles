# Theme

## Commands

```bash
theme current          # show current theme
theme list             # show available themes
theme next             # switch to next theme
theme set kanagawa     # enable Kanagawa
theme set catppuccin   # enable Catppuccin
theme init             # create symlink if missing (called by install.sh)
```

## How it works

Текущая тема — это симлинк вне репозитория:

```text
~/.config/theme/current -> dotfiles/scripts/theme/themes/<theme>
```

Переключение = смена симлинка. Генерируемых файлов и файлов состояния нет,
репозиторий при переключении не меняется — кроме VS Code и Zed, у которых
нет include-механизма, поэтому их `settings.json` правится на месте.

## Files

```text
scripts/theme/themes/<theme>/alacritty.toml   # import темы alacritty
scripts/theme/themes/<theme>/ghostty          # theme = ...
scripts/theme/themes/<theme>/nvim             # имя colorscheme
scripts/theme/themes/<theme>/vscode           # workbench.colorTheme
scripts/theme/themes/<theme>/zed              # theme.dark
```

## How it applies

| App | Reload |
|---|---|
| Ghostty | сразу, SIGUSR2 |
| Neovim | при возврате фокуса в окно |
| Alacritty | live config reload |
| VS Code / Zed | правится settings.json, применяется сразу |

## Adding a theme

1. Создать `scripts/theme/themes/<name>/` с пятью файлами выше.
2. Добавить плагин colorscheme в `nvim/.config/nvim/lua/plugins/colorscheme.lua`
   и проверку `if theme_key() == "<name>" then apply_theme() end` в его `config`.
3. Установить тему в VS Code и Zed (расширение или встроенная).

## Notes

- `theme set` и `theme next` изменяют tracked-файлы `vscode/settings.json`
  и `zed/.config/zed/settings.json` — после переключения рабочее дерево грязное.
- Значения тем допускают только буквы, цифры, пробел, `.`, `_`, `-` —
  скрипт падает на всём остальном, потому что значение подставляется в JSON.
