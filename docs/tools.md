# Terminal Tools — Шпаргалка

Краткое руководство по инструментам из Brewfile.
Полная документация: `tldr <tool>` или `man <tool>`.

---

## Навигация и файлы

### eza — замена `ls`
```bash
eza                      # список файлов
eza -l                   # подробный список
eza -la                  # включая скрытые файлы
eza --tree               # дерево папок
eza --tree --level=2     # дерево, глубина 2
eza -l --git             # показать git-статус файлов
```

### yazi — файловый менеджер
```bash
yazi                     # запуск
```
| Клавиша | Действие |
|---------|----------|
| `h/j/k/l` или стрелки | навигация |
| `Enter` | открыть файл / войти в папку |
| `Space` | выделить файл |
| `y` | копировать |
| `x` | вырезать |
| `p` | вставить |
| `d` | удалить в корзину |
| `D` | удалить безвозвратно |
| `/` | поиск |
| `q` | выйти |

### zoxide — умный `cd`
```bash
z dotfiles               # прыгнуть в ~/dotfiles (по истории)
z doc                    # достаточно части имени папки
zi                       # интерактивный выбор из истории (через fzf)
```
> zoxide запоминает папки по мере того как ты в них заходишь через `z` или `cd`.
> Чем чаще заходишь — тем выше в приоритете.

---

## Поиск

### fd — замена `find`
```bash
fd config                # найти всё с именем config
fd .js                   # найти все .js файлы
fd .js src/              # искать в папке src/
fd -e toml               # найти файлы с расширением .toml
fd -H config             # включая скрытые файлы
```

### ripgrep — замена `grep`
```bash
rg "text"                # найти text в текущей папке рекурсивно
rg "text" src/           # искать в папке src/
rg -i "text"             # без учёта регистра
rg -l "text"             # показать только имена файлов
rg -t js "text"          # искать только в .js файлах
```

### fzf — fuzzy finder
```bash
fzf                      # интерактивный поиск файлов
Ctrl+r                   # поиск по истории команд (в терминале)
Ctrl+t                   # вставить путь к файлу в команду
cat file.txt | fzf       # фильтровать любой вывод
```

---

## Просмотр файлов

### bat — замена `cat`
```bash
bat file.txt             # просмотр с подсветкой синтаксиса
bat -n file.txt          # с номерами строк
bat *.js                 # несколько файлов
bat --language=json -    # читать из stdin как JSON
```

---

## Документация

### tldr — короткие man-страницы
```bash
tldr git                 # примеры использования git
tldr tar                 # примеры tar
tldr fd                  # примеры fd
tldr --update            # обновить базу страниц
```

---

## Git

### git-delta — красивый diff
Не вызывается напрямую — подключается через `.gitconfig` как pager.
Когда настроим git конфиг, delta будет автоматически использоваться в:
```bash
git diff                 # красивый diff с подсветкой и side-by-side
git log                  # улучшенный лог
git show                 # просмотр коммита
```
> Настройка будет в `git/.gitconfig` — добавим когда дойдём до git.

---

## Dev

### fnm — Node Version Manager
```bash
fnm install 22          # установить версию
fnm install --lts       # установить последний LTS
fnm use 22              # переключиться на версию
fnm default 22          # сделать версию дефолтной
fnm list                # список установленных версий
fnm current             # текущая версия
```
> Автоматически переключает версию при наличии `.nvmrc` в папке проекта.

### uv — Python менеджер
```bash
uv python install 3.12   # установить Python 3.12
uv venv                  # создать виртуальное окружение
uv pip install pandas    # установить пакет
uv run script.py         # запустить скрипт в окружении
uv sync                  # установить зависимости из pyproject.toml
```

### lazydocker — TUI для Docker
```bash
lazydocker               # запуск
```
| Клавиша | Действие |
|---------|----------|
| стрелки | навигация |
| `Enter` | выбрать |
| `r` | перезапустить контейнер |
| `s` | остановить контейнер |
| `d` | удалить |
| `l` | логи |
| `q` | выйти |

---

## Редакторы

### micro — простой терминальный редактор
```bash
micro file.txt           # открыть файл
```
| Клавиша | Действие |
|---------|----------|
| `Ctrl+S` | сохранить |
| `Ctrl+Q` | выйти |
| `Ctrl+C` | копировать |
| `Ctrl+V` | вставить |
| `Ctrl+Z` | отменить |
| `Ctrl+F` | поиск |
| `Ctrl+G` | перейти к строке |

### neovim — осваиваем постепенно
```bash
nvim file.txt            # открыть файл
```
| Клавиша | Режим | Действие |
|---------|-------|----------|
| `i` | normal → insert | начать редактировать |
| `Esc` | insert → normal | выйти из редактирования |
| `:w` | normal | сохранить |
| `:q` | normal | выйти |
| `:wq` | normal | сохранить и выйти |
| `:q!` | normal | выйти без сохранения |

> Подробнее: `vimtutor` в терминале — интерактивный туториал на 30 минут.

---

## Полезные ссылки

- [eza](https://github.com/eza-community/eza)
- [yazi](https://github.com/sxyazi/yazi)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [fd](https://github.com/sharkdp/fd)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat)
- [uv](https://docs.astral.sh/uv/)
- [lazydocker](https://github.com/jesseduffield/lazydocker)
- [micro](https://micro-editor.github.io)
- [neovim](https://neovim.io)
