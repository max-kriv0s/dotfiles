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
- [ ] в `.go`-файле `:echo &expandtab` → `0`
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
- [x] `plugins/bufferline.lua` — режим буферов, диагностики, фильтр пустого буфера, место под дерево
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
- [x] which-key всплывает после `<leader>` и все пункты подписаны, пустых нет
- [x] в подсказках which-key нет кириллических дублей
- [x] группы в which-key подписаны по-русски: Буферы, Split-окна, Вкладки, Переключатели
- [x] `<leader>?` показывает сочетания текущего буфера
- [x] `:checkhealth which-key` — нет жалоб на конфликты маппингов

---

## Фаза 3 — код

- [ ] mason + mason-tool-installer
- [ ] lspconfig, серверы разработки: vtsls, vue_ls, eslint, gopls, basedpyright, ruff, tailwindcss, emmet_ls, cssls, jsonls, lua_ls
- [ ] lspconfig, серверы инфраструктуры: dockerls, docker_compose_language_service, yamlls, helm_ls, terraformls, ansiblels, bashls, taplo
- [ ] SchemaStore.nvim — автодополнение и валидация схем: docker-compose, Taskfile, GitHub Actions, GitLab CI, k8s-манифесты, package.json, tsconfig
- [ ] Taskfile (go-task): распознавание `Taskfile.yml` / `Taskfile.dist.yml`, схема go-task в yamlls
- [ ] blink.cmp + LuaSnip + friendly-snippets
- [ ] nvim-autopairs
- [ ] conform — форматирование при сохранении + toggle (prettierd, ruff, gofmt/goimports, stylua, shfmt, terraform_fmt, taplo)
- [ ] nvim-lint, линтеры разработки: eslint_d, ruff, golangcilint
- [ ] nvim-lint, линтеры инфраструктуры: hadolint (Dockerfile), yamllint, shellcheck, tflint, actionlint (GitHub Actions), ansible-lint
- [ ] DevSecOps: trivy (образы и IaC), gitleaks (секреты), semgrep (AppSec-правила) — решить, что запускать в редакторе, а что оставить в CI/pre-commit

**Проверка:**

- [ ] `:Mason` открывается, все пакеты из списка установились
- [ ] `:checkhealth vim.lsp` — клиент подключается в `.ts`, `.tsx`, `.vue`, `.go`, `.py`, `.lua`
- [ ] LSP подключается в `Dockerfile`, `compose.yaml`, `Taskfile.yml`, `*.tf`, `*.sh`, `*.yaml`
- [ ] `gd`, `K`, `gr`, `<leader>ca`, `<leader>rn` работают в коде
- [ ] в `compose.yaml` и `.github/workflows/*.yml` есть автодополнение ключей по схеме
- [ ] автодополнение всплывает при вводе, `<CR>` принимает вариант
- [ ] сниппеты разворачиваются и по ним можно прыгать `Tab` / `Shift+Tab`
- [ ] autopairs: скобка и кавычка закрываются сами, в том числе в JSX
- [ ] при `:w` файл форматируется (проверить `.ts`, `.py`, `.go`, `.tf`, `.lua`)
- [ ] toggle автоформата выключает форматирование при сохранении
- [ ] линтер показывает ошибки: `eslint` в `.ts`, `ruff` в `.py`, `hadolint` в `Dockerfile`, `yamllint` в `.yaml`, `shellcheck` в `.sh`
- [ ] решено, что из trivy / gitleaks / semgrep запускается в редакторе, а что в CI

---

## Фаза 4 — навигация и инструменты

- [ ] fzf-lua
- [ ] neo-tree — урезать колонки иконок, стрелки и `h`/`l` для открытия/закрытия
- [ ] `plugins/nvim-tree.lua` — целиком закомментирован, для быстрой замены и сравнения
- [ ] oil.nvim — те же `h`/`l`/стрелки
- [ ] gitsigns + lazygit
- [ ] trouble + todo-comments
- [ ] toggleterm
- [ ] auto-session
- [ ] vim-tmux-navigator
- [ ] maximize split без плагина

**Проверка:**

- [ ] поиск файлов по имени и поиск текста по проекту работают
- [ ] поиск по буферам, недавним файлам, символам, диагностикам
- [ ] neo-tree открывается по клавише, иконки не разъезжаются в несколько колонок
- [ ] в neo-tree `l` и `→` открывают файл и папку, `h` и `←` закрывают
- [ ] в neo-tree работают создание, удаление, переименование, копирование
- [ ] oil открывается по `-`, правка имён и `:w` применяет изменения к диску
- [ ] в oil `l` / `h` и стрелки ведут себя так же, как в дереве
- [ ] переключение между neo-tree и nvim-tree сводится к раскомментированию файла
- [ ] gitsigns: значки изменений в gutter, `]h` / `[h`, stage и preview hunk
- [ ] lazygit открывается по клавише и корректно закрывается
- [ ] trouble показывает диагностики проекта и буфера
- [ ] todo-comments подсвечивает `TODO`, `FIXME` и ищет их по проекту
- [ ] терминал открывается и скрывается, `jj` и `Esc` выходят в Normal
- [ ] auto-session: `<leader>wr` восстанавливает сессию каталога
- [ ] `<C-h/j/k/l>` переходят между окнами nvim и панелями tmux одинаково
- [ ] maximize split разворачивает окно и возвращает обратно

---

## Фаза 5 — финал

- [ ] открытый вопрос: раскладка клавиш терминала (сейчас `<leader>t` занят табами) — изучить, как это решают в других конфигах
- [ ] разобрать понятия splits / buffers / tabs, дописать раздел в `docs/nvim.md`
- [ ] полная таблица сочетаний клавиш, проверка что нет маппингов без `desc`
- [ ] `:checkhealth` без ошибок
- [ ] актуализировать `docs/nvim.md` под новую сборку
- [ ] перенос: `nvim-next` → `nvim`, удалить `nvim-test`
- [ ] `aliases.zsh`: вернуть `nv="nvim"`, убрать `nv-old` и `nv-test`
- [ ] снять симлинк `~/.config/nvim-next`
- [ ] очистить состояние старой сборки

**Проверка:**

- [ ] `:checkhealth` без ❌
- [ ] `nvim` без `NVIM_APPNAME` стартует на новом конфиге
- [ ] `nv` работает как обычный `nvim`
- [ ] в `docs/nvim.md` описаны все актуальные сочетания клавиш, устаревшие убраны
- [ ] в репозитории не осталось каталогов `nvim-test` и `nvim-next`
- [ ] конфиг разворачивается с нуля из репозитория: клон, stow, первый запуск

---

## Фаза 6 — после переноса

- [ ] DAP: точки останова, пошаговая отладка — Go, Python, Node/TS
- [ ] neotest: jest / vitest / pytest / go test
- [ ] донастройка темы coolnight: alacritty (сейчас жёстко прописана, переключение не работает), blur/прозрачность
- [ ] coolnight для ghostty, tmux, vscode, zed

**Проверка:**

- [ ] точка останова срабатывает, видно значения переменных — Go, Python, Node/TS
- [ ] шаги внутрь, через и наружу работают
- [ ] тесты запускаются из редактора, результат виден у самого теста
- [ ] цвета совпадают во всех инструментах

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
