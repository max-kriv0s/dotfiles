# Сборка единого конфига Neovim — чеклист

Собираем новый конфиг из двух готовых сборок: `nvim/` (A) и `nvim-test/` (B).
Работаем изолированно через `NVIM_APPNAME=nvim-next`, старый конфиг не трогаем до самого конца.

Стек:

- разработка: JS/TS, Python, Go, React, Vue
- инфраструктура: Docker, docker-compose, Kubernetes/Helm, Terraform, Ansible, Bash, CI (GitHub Actions/GitLab CI), Makefile
- форматы: YAML, JSON, TOML, HCL, Markdown
- DevSecOps / AppSec: статический анализ и security-линтеры прямо в редакторе

---

## Фаза 0 — подготовка

- [x] создать каталог `dotfiles/nvim-next/.config/nvim-next/`
- [x] создать `checklist.md`
- [x] проверить `git status`, при необходимости закоммитить текущие изменения вручную
- [x] симлинк: `ln -s ~/dotfiles/nvim-next/.config/nvim-next ~/.config/nvim-next`
- [x] в `zsh/.config/zsh/aliases.zsh` переключить `nv` на новую сборку

**Проверка:**

- [x] `ls -la ~/.config | grep nvim-next` — симлинк существует и указывает в dotfiles
- [x] `nv` запускается (после `source` конфига zsh или в новом окне терминала)

---

## Фаза 1 — ядро

- [x] `.stylua.toml` — правила форматирования Lua-кода конфига
- [x] `init.lua` — точка входа
- [x] `lua/core/options.lua` — опции (слияние A+B, langmap RU, wrap включён)
- [x] `lua/core/keymaps.lua` — базовые маппинги, все с `desc`
- [x] `lua/core/autocmds.lua` — автокоманды
- [x] `lua/core/lazy.lua` — bootstrap lazy.nvim
- [x] отключить luarocks в lazy и неиспользуемые провайдеры (node/perl/python/ruby)
- [x] `lua/core/lang.lua` — таблица раскладок, `langmap` и кириллические дубли маппингов

**Проверка:**

- [x] `nv` стартует без красных ошибок
- [x] `:Lazy` открывается, список плагинов пуст — это правильно
- [x] `:checkhealth` — секции `lazy`, `vim.health`, `vim.provider` без ❌ и лишних ⚠️
- [x] перенос строк: длинная строка переносится на следующую строку экрана, а не уезжает вбок
- [x] `j` / `k` двигают курсор по видимым строкам, `5j` прыгает на 5 строк файла
- [x] `<leader>uw` выключает и включает перенос
- [x] `<leader>un` переключает относительные номера строк
- [x] русская раскладка в Normal: `ц` работает как `w`, `ф` как `a`
- [x] русская раскладка: `о` / `л` двигают курсор по экранным строкам, как `j` / `k`
- [x] русская раскладка: `<leader>ым` создаёт split, как `<leader>sv`
- [x] русская раскладка: `<leader>ещ` открывает вкладку, как `<leader>to`
- [x] русская раскладка: `<leader>ич` закрывает буфер, как `<leader>bx`
- [x] `jj` в Insert выходит в Normal
- [x] `<leader>sv` / `<leader>sh` создают split, `<leader>sx` закрывает, `<leader>se` уравнивает
- [x] `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` переходят между окнами
- [x] `<leader>to` / `<leader>tx` / `<leader>tn` / `<leader>tp` — вкладки
- [x] `Tab` / `Shift+Tab` переключают буферы, `<leader>bx` закрывает буфер (нужно открыть 2+ файла)
- [x] `<leader>nh` убирает подсветку после поиска
- [x] `<leader>+` / `<leader>-` меняют число под курсором
- [x] в Visual `<` и `>` сдвигают строки и не сбрасывают выделение
- [x] `:echo &wrap` → `1`, `:echo &expandtab` → `1` (вывод `:set wrap?` затирается следующим сообщением, `:verbose set wrap?` ещё покажет, где значение задано)
- [x] в `.go`-файле `:echo &expandtab` → `0`
- [x] `<leader>tp` успевает набраться без спешки, символ под курсором не подменяется
- [x] копирование подсвечивается (`yy`)
- [x] `y` и `p` работают с системным буфером обмена

---

## Фаза 2 — внешний вид

- [x] `lua/core/colorscheme.lua` — чтение темы из симлинка, применение, подписка на SIGUSR1
- [x] `colors/coolnight.lua` — своя тема coolnight на основе tokyonight
- [x] `plugins/themes/coolnight.lua` — палитра coolnight + прозрачность
- [x] `plugins/themes/kanagawa.lua`, `plugins/themes/catppuccin.lua` — запасные, тоже прозрачные
- [x] `scripts/theme/themes/coolnight/` — новая тема; ghostty/vscode/zed пока копии kanagawa
- [x] `alacritty.toml` — импорт темы через симлинк вместо жёсткого пути
- [x] `change-theme` — `reload_nvim()` шлёт SIGUSR1 вместо опроса по `FocusGained`
- [x] `plugins/treesitter.lua` — парсеры под весь стек, подсветка и отступы
- [x] nvim-treesitter-textobjects — `af`/`if`, `ac`/`ic`, `aa`/`ia`, прыжки `]f`/`[f`, `]c`/`[c`
- [x] nvim-ts-autotag — закрывающий тег в JSX/TSX/Vue/HTML
- [x] nvim-ts-context-commentstring — правильный комментарий внутри JSX
- [x] `plugins/lualine.lua` — цвет по режиму, тема `auto` из активной colorscheme, счётчик обновлений lazy, пересборка по `ColorScheme`
- [x] `plugins/bufferline.lua` — режим буферов, диагностики, фильтр пустых безымянных буферов, место под дерево
- [x] bufferline: `<leader>bo` остальные, `<leader>ba` все, `<leader>bp` / `<leader>bc` выбор по букве
- [x] `plugins/which-key.lua` — группы с описаниями, `delay = 300`, фильтр кириллических дублей

**Проверка:**

- [x] `theme list` показывает `coolnight`, `kanagawa`, `catppuccin`
- [x] `theme set coolnight` — alacritty и nvim меняются одновременно, без перезапуска
- [x] `theme set kanagawa` и `theme set catppuccin` работают так же
- [x] тема применяется при старте `nv`, совпадает с текущей в alacritty
- [x] фон прозрачный, фон терминала виден
- [x] смены темы не мигают (SIGUSR1 вместо опроса по фокусу)
- [x] `:colorscheme coolnight` доступна по имени `coolnight`, а не `tokyonight`
- [x] подсветка синтаксиса работает в `.ts`, `.tsx`, `.vue`, `.go`, `.py`, `Dockerfile`, `compose.yaml`, `.tf`
- [x] `:checkhealth vim.treesitter` — парсеры установились, ошибок нет
- [x] текст-объекты: `vaf` выделяет функцию, `vif` — её тело, `vac`/`vic` — класс, `vaa`/`via` — аргумент
- [x] `]f` / `[f` прыгают по функциям, `]c` / `[c` — по классам
- [x] autotag: в `.tsx` при вводе `<div>` закрывающий тег появляется сам, в `.vue` тоже
- [x] `gcc` в `.tsx` внутри JSX ставит `{/* */}`, а в обычном коде `//`
- [x] отступы: `==` и `=` в `.ts` и `.go` выравнивают по дереву, а не по старым правилам
- [x] lualine меняет цвет при переходе Normal → Insert → Visual
- [x] в lualine виден счётчик доступных обновлений плагинов
- [x] lualine показывает ветку git, изменения, путь к файлу, тип, позицию
- [x] после `theme set kanagawa` цвета lualine меняются вместе с темой
- [x] bufferline показывает открытые файлы, `Tab` / `Shift+Tab` по ним ходят
- [x] bufferline: пустой стартовый буфер не занимает место в полосе
- [x] после `<leader>to` и `<leader>tx` в полосе не остаётся буфер «No Name»
- [x] `<leader>bo` закрывает остальные буферы, `<leader>ba` — все
- [x] `<leader>bp` показывает буквы на буферах, нажатие буквы переводит на буфер
- [x] `<leader>bc` закрывает выбранный по букве буфер
- [x] which-key всплывает после `<leader>` и все пункты подписаны, пустых нет
- [x] в подсказках which-key нет кириллических дублей
- [x] группы в which-key подписаны по-русски: Буферы, Split-окна, Вкладки, Переключатели
- [x] `<leader>?` показывает сочетания текущего буфера
- [x] `:checkhealth which-key` — нет жалоб на конфликты маппингов

---

## Фаза 3 — код

- [x] fzf-lua (перенесён из Фазы 4: LSP-переходы сразу открываются в нём, без переделки)
- [x] mason + mason-tool-installer
- [x] lspconfig, серверы разработки: vtsls, vue_ls, eslint, gopls, pyright, ruff, tailwindcss, emmet_ls, cssls, jsonls, lua_ls
- [x] lspconfig, серверы инфраструктуры: dockerls, docker_compose_language_service, yamlls, helm_ls, terraformls, ansiblels, bashls, taplo
- [x] SchemaStore.nvim — автодополнение и валидация схем: docker-compose, Taskfile, GitHub Actions, GitLab CI, k8s-манифесты, package.json, tsconfig
- [x] Taskfile (go-task): распознавание `Taskfile.yml` / `Taskfile.dist.yml`, схема go-task в yamlls
- [x] blink.cmp + LuaSnip + friendly-snippets
- [x] nvim-autopairs
- [x] conform — форматирование при сохранении + toggle (prettierd, ruff, gofmt/goimports, stylua, shfmt, terraform_fmt, taplo)
- [x] nvim-lint, линтеры разработки: eslint_d, ruff, golangcilint
- [x] nvim-lint, линтеры инфраструктуры: hadolint (Dockerfile), yamllint, shellcheck, tflint, actionlint (GitHub Actions), ansible-lint
- [x] DevSecOps: trivy (образы и IaC), gitleaks (секреты), semgrep (AppSec-правила) — решить, что запускать в редакторе, а что оставить в CI/pre-commit

**Проверка:**

- [x] `:Mason` открывается, все пакеты из списка установились
- [x] `:checkhealth vim.lsp` — клиент подключается в `.ts`, `.tsx`, `.vue`, `.go`, `.py`, `.lua`
- [x] LSP подключается в `Dockerfile`, `compose.yaml`, `Taskfile.yml`, `*.tf`, `*.sh`, `*.yaml`
- [x] `gd`, `K`, `gr`, `<leader>ca`, `<leader>rn` работают в коде

Проверяем на файлах из `nvim-next/test/`, таблицы соответствий — в `test/README.md`.

Поиск, любой файл:

- [x] `<leader>ff` файл по имени, `<leader>fw` текст по проекту, `<leader>fr` недавние
- [x] `<leader>fb` буферы, `<leader>fh` справка, `<leader>fk` все сочетания клавиш
- [x] `<leader>fd` ошибки по проекту, `<leader>fg` изменённые файлы git
- [x] `<leader>fR` возврат к прошлому поиску, `Shift+↑` / `Shift+↓` прокрутка предпросмотра

Навигация по коду, `test/check.ts` и `test/check.go`:

- [x] `gd` определение, `gD` объявление, `gi` реализация, `gt` тип, `gR` использования
- [x] `K` документация во всплывающем окне
- [x] `<leader>ca` список исправлений на строке с ошибкой
- [x] `<leader>rn` переименование символа во всех местах
- [x] `<leader>d` ошибка текущей строки, `<leader>D` все ошибки файла
- [x] `]d` / `[d` переход по ошибкам
- [x] `<leader>rs` перезапуск сервера не ломает подсветку и диагностики
- [x] `<leader>uh` показывает и убирает серые подсказки типов

Отдельные случаи:

- [x] `test/check.vue`: `gd` на импорте `activeNames` открывает `check.ts`
- [x] `test/check.py`: `K` на `print` даёт документацию от pyright, а не пустоту
- [x] типы файлов из `core/filetypes.lua` проверены: compose, gitlab-ci, ansible, helm, values
- [x] в `compose.yaml` и `.github/workflows/*.yml` есть автодополнение ключей по схеме
- [x] автодополнение всплывает при вводе, `<CR>` принимает вариант
- [x] сниппеты разворачиваются и по ним можно прыгать `Tab` / `Shift+Tab`
- [x] autopairs: скобка и кавычка закрываются сами, в том числе в JSX
- [x] при `:w` файл форматируется (проверить `.ts`, `.py`, `.go`, `.tf`, `.lua`)
- [x] toggle автоформата выключает форматирование при сохранении
- [x] линтер показывает ошибки: `eslint` в `.ts`, `ruff` в `.py`, `hadolint` в `Dockerfile`, `yamllint` в `.yaml`, `shellcheck` в `.sh`
- [x] решено, что из trivy / gitleaks / semgrep запускается в редакторе, а что в CI

---

## Фаза 4 — навигация и инструменты

- [x] neo-tree — урезать колонки иконок, стрелки и `h`/`l` для открытия/закрытия
- [x] `plugins/nvim-tree.lua` — целиком закомментирован, для быстрой замены и сравнения
- [x] oil.nvim — те же `h`/`l`/стрелки
- [x] gitsigns + lazygit
- [x] trouble + todo-comments
- [x] toggleterm
- [x] auto-session
- [x] vim-tmux-navigator
- [x] maximize split без плагина — своя функция или кусок, забранный из плагина

**Проверка:**

- [x] neo-tree открывается по клавише, иконки не разъезжаются в несколько колонок
- [x] в neo-tree `l` и `→` открывают файл и папку, `h` и `←` закрывают
- [x] в neo-tree работают создание, удаление, переименование, копирование
- [x] oil открывается по `-`, правка имён и `:w` применяет изменения к диску
- [x] в oil `l` / `h` и стрелки ведут себя так же, как в дереве
- [x] переключение между neo-tree и nvim-tree сводится к раскомментированию файла
- [x] gitsigns: значки изменений в gutter, `]h` / `[h`, stage и preview hunk
- [x] lazygit открывается по клавише и корректно закрывается
- [x] trouble показывает диагностики проекта и буфера
- [x] todo-comments подсвечивает `TODO`, `FIXME` и ищет их по проекту
- [x] терминал открывается и скрывается, `jj` и `Esc` выходят в Normal
- [x] auto-session: `<leader>wr` восстанавливает сессию каталога
- [x] `<C-h/j/k/l>` ходят по сплитам nvim и дальше переносят в панель tmux; обратно из панели — `prefix + h/j/k/l`
- [x] maximize split разворачивает окно и возвращает обратно

---

## Фаза 5 — финал

- [x] открытый вопрос: раскладка клавиш терминала (сейчас `<leader>t` занят табами) — изучить, как это решают в других конфигах
- [x] разобрать понятия splits / buffers / tabs, дописать раздел в `docs/nvim.md`
- [x] полная таблица сочетаний клавиш, проверка что нет маппингов без `desc`
- [x] `:checkhealth` без ошибок
- [ ] актуализировать `docs/nvim.md` под новую сборку
- [ ] перенос: `nvim-next` → `nvim`, удалить `nvim-test`
- [ ] `aliases.zsh`: вернуть `nv="nvim"`, убрать `nv-old` и `nv-test`
- [ ] снять симлинк `~/.config/nvim-next`
- [ ] очистить состояние старой сборки

**Проверка:**

- [x] `:checkhealth` без ❌
- [ ] `nvim` без `NVIM_APPNAME` стартует на новом конфиге
- [ ] `nv` работает как обычный `nvim`
- [x] в `docs/nvim.md` описаны все актуальные сочетания клавиш, устаревшие убраны
- [ ] в репозитории не осталось каталогов `nvim-test` и `nvim-next`
- [ ] конфиг разворачивается с нуля из репозитория: клон, stow, первый запуск

---

## Фаза 6 — после переноса

- [ ] DAP: точки останова, пошаговая отладка — Go, Python, Node/TS
- [ ] neotest: jest / vitest / pytest / go test

**Проверка:**

- [ ] точка останова срабатывает, видно значения переменных — Go, Python, Node/TS
- [ ] шаги внутрь, через и наружу работают
- [ ] тесты запускаются из редактора, результат виден у самого теста
- [ ] цвета совпадают во всех инструментах

---

## Фаза 7 — оставшиеся вопросы

- [x] заметил что набирать текст не сильно удобно если встречается j или о кнопка не печатается видимо из-за команды пока не пройдет таймаут, я уменьшел его до 1000, но нужно изучить как люди работают, ведь все меняют esc на jj или jk
- [ ] актуализировать документацию nvim
- [ ] актуализировать docs/nvim.scenaries.md исходя из новых возможностей
- [ ] добавить файл nim.plugins.md описывающий основные установленные плагины и их назначение
- [ ] проработать вопрос можно ли с ctrl + h/j/k/l сделать чтобы было как замена стрелок
- [ ] часто вижу что для переключения вкладок используют ]b/[b нужно рассмотреть этот вариант и сравнить с реализованным
- [ ] работа с ИИ моделями в nvim
- [ ] Использование Vimdiff в качестве инструмента для слияния Git
- [ ] посмотреть нужна ли связка Lazygit + Fugitive/Gitsigns
- [ ] нужно определиться как я могу синхронизировать файлы с macos/linux на внешний диск чтобы спокойно переносить и иметь бекапы
- [ ] добавить возможность собирать информацию о коде и копировать в буфер для передачи в ИИ, например как в zed add to agent treads
- [ ] рассмотреть возможность настроить окрытия на весь экран и свертывания обратно активного окна как в zed через shift+esc

---

## Фаза 8 — установщики dotfiles

Не про nvim, а про dotfiles в целом. Делать после переноса сборки, чтобы не
смешивать две разные задачи.

### Зачем

Сейчас `install.sh` и `install_dev.sh` различаются **четырьмя строками из 182** —
только тем, какой Brewfile передаётся в `brew bundle`. Всё остальное, от
установки zsh до stow и шаблонов `.local`, скопировано дословно. Каждая правка
требует одинаковых изменений в двух файлах, и рано или поздно один отстанет —
так уже случилось с `lazygit`, которого не было ни в одном списке.

Второе: списки пакетов разложены по операционным системам, а не по назначению.
Поэтому требование «одинаковый набор на Fedora 44 и MacBook» сегодня нечем
проверить — это два независимых файла, и совпадают они, только пока про оба
помнишь.

### Три профиля

| Профиль   | Что входит                                 | Где применяется                  |
| --------- | ------------------------------------------ | -------------------------------- |
| `base`    | zsh, tmux, nvim, git, lazygit, cli-утилиты | сервер и любая машина            |
| `desktop` | base + ghostty, alacritty, шрифты, zed     | Fedora 44 и MacBook — один набор |
| `dev`     | desktop + линтеры, языки, docker           | Mac mini                         |

Главный принцип: **профиль отвечает за «что ставим», операционная система —
только за «чем ставим»**. `zsh` входит в `base` всегда, а поставится через
`brew` на macOS и через `dnf` на Fedora.

Профиль `dev` для Mac mini не обязателен — выбирается в момент установки,
поменять решение значит запустить скрипт с другим флагом.

### Как должно выглядеть

```
packages/macos/Brewfile.base     packages/fedora/packages.base.sh
packages/macos/Brewfile.desktop  packages/fedora/packages.desktop.sh
packages/macos/Brewfile.dev      packages/fedora/packages.dev.sh

lib/common.sh    — общие шаги: ensure_zsh, stow_packages, link_local_templates
install.sh       — единственная точка входа
```

Имена профилей одинаковые с обеих сторон, файлы лежат парами — расхождение
видно сравнением двух файлов.

```bash
./install.sh --profile base       # сервер
./install.sh --profile desktop    # MacBook и Fedora 44
./install.sh --profile dev        # Mac mini
```

`install_dev.sh` и `install.server-ai.sh` становятся не нужны — превращаются
в значение флага. Удаление файлов — отдельным шагом, с подтверждением.

### Шаги

- [ ] разложить пакеты по профилям: `base` / `desktop` / `dev` для обеих систем
- [ ] вынести общие шаги в `lib/common.sh`
- [ ] добавить в `install.sh` разбор `--profile`
- [ ] перенести серверную часть (sshd, отсутствие графики) в профиль `base`
- [ ] сверить пары файлов: набор `desktop` совпадает на macOS и Fedora
- [ ] прогнать `bash -n` и `shellcheck` по всем скриптам
- [ ] обновить README с описанием профилей
- [ ] удалить `install_dev.sh` и `install.server-ai.sh` — отдельным подтверждением

**Проверка:**

Полная проверка возможна только на чистой машине или в виртуалке — скрипты
меняют систему, локально прогнать их целиком нельзя.

- [ ] `bash -n` и `shellcheck` проходят без ошибок на всех скриптах
- [ ] `./install.sh --profile desktop` на текущей машине не ломает существующие симлинки
- [ ] списки `desktop` для macOS и Fedora сверены глазами, расхождения объяснимы
- [ ] на чистой виртуалке Fedora `--profile base` даёт рабочую оболочку с nvim и lazygit

---

## Команды

Подключить новую сборку (один раз):

```bash
ln -s ~/dotfiles/nvim-next/.config/nvim-next ~/.config/nvim-next
ls -la ~/.config | grep nvim-next
```

Сбросить состояние **новой** сборки (плагины переустановятся):

```bash
rm -rf ~/.local/share/nvim-next ~/.local/state/nvim-next ~/.cache/nvim-next
```

Удалить состояние **старой** сборки — только на фазе 5, после переноса:

```bash
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Размер каталогов:

```bash
du -sh ~/.config/nvim* ~/.local/share/nvim* ~/.local/state/nvim* ~/.cache/nvim*
```

удалить файл checklist.md
