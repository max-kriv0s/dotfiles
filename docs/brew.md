# Homebrew и обновление приложений в macOS — Шпаргалка

В macOS нет единого пакетного менеджера, как `dnf` в Fedora. Приложения приходят
из трёх независимых источников, и у каждого свой способ обновления.

| Источник | Как обновлять |
|----------|---------------|
| Homebrew | `brew upgrade` / `brew upgrade --cask` |
| Mac App Store | App Store → Updates (или `mas upgrade`) |
| Скачано вручную (.dmg / .pkg) | автоапдейтер внутри приложения или скачать заново |
| Сама macOS | `softwareupdate` — см. раздел ниже |

> **Homebrew не обновляет пакеты сам.** Это главное отличие от `dnf` в Fedora:
> `brew update` обновляет только каталог формул, а установленные пакеты остаются
> старыми, пока не запустишь `brew upgrade` руками.
>
> Разбор списка обновлений — [Как решить, что обновлять](#как-решить-что-обновлять).

---

## Основные команды

Терминология: **formula** — CLI-утилита (собирается/ставится в `/opt/homebrew`),
**cask** — GUI-приложение (кладётся в `/Applications`), **tap** — сторонний
репозиторий с формулами.

### Установка и удаление
```bash
brew install <formula>       # установить CLI-утилиту
brew install --cask <name>   # установить GUI-приложение
brew uninstall <name>        # удалить
brew uninstall --zap --cask <name>   # удалить вместе с конфигами и данными приложения
brew reinstall <name>        # переустановить (лечит битую установку)
```

### Что установлено
```bash
brew list                    # всё установленное
brew list --formula          # только CLI-утилиты
brew list --cask             # только GUI-приложения
brew list --versions <name>  # какие версии стоят
brew list <name>             # какие файлы поставил пакет
brew leaves                  # установленное явно (не как зависимость)
```

### Поиск и информация
```bash
brew search <текст>          # поиск по формулам и caskам
brew search --cask <текст>   # поиск только по GUI-приложениям
brew info <name>             # версия, описание, зависимости, размер
brew home <name>             # открыть сайт проекта в браузере
```

### Зависимости
```bash
brew deps <name>             # от чего зависит пакет
brew deps --tree <name>      # дерево зависимостей
brew uses --installed <name> # кто из установленного зависит от пакета
brew missing                 # у чего сломаны зависимости
```

### Фоновые сервисы (postgres, redis и т.п.)
```bash
brew services list           # статус всех сервисов
brew services start <name>   # запустить и добавить в автозагрузку
brew services stop <name>    # остановить и убрать из автозагрузки
brew services restart <name> # перезапустить
brew services run <name>     # запустить разово, без автозагрузки
```

### Сторонние репозитории
```bash
brew tap                     # список подключённых tap
brew tap <user/repo>         # подключить
brew untap <user/repo>       # отключить
```

### Служебное
```bash
brew --prefix                # корень установки (/opt/homebrew на Apple Silicon)
brew --prefix <name>         # путь к конкретному пакету
brew config                  # конфигурация brew и системы
brew doctor                  # диагностика проблем
brew log <name>              # история изменений формулы
brew help <команда>          # справка по команде
```

---

## Откуда установлено приложение

Прежде чем обновлять — надо понять источник.

```bash
brew list --cask | grep -i <имя>                    # стоит ли через brew
brew info --cask <имя>                              # есть ли вообще такой cask
mdls -name kMDItemAppStoreHasReceipt /Applications/<App>.app   # 1 = из App Store
pkgutil --pkgs | grep -i <имя>                      # ставилось ли через .pkg
xattr -p com.apple.quarantine /Applications/<App>.app          # URL источника скачивания
```

Если ни brew, ни App Store, ни pkg-receipt — приложение перетащено вручную из
.dmg, и обновлять его придётся руками. Такие приложения фиксируем в
[packages/macos/manual.md](../packages/macos/manual.md).

---

## Обновление через Homebrew

```bash
brew update                  # обновить сам brew и список формул (не пакеты!)
brew outdated                # что устарело из формул (CLI-утилит)
brew outdated --cask         # что устарело из casks (GUI-приложений)
brew upgrade                 # обновить формулы
brew upgrade --cask          # обновить casks
brew upgrade <имя>           # обновить что-то одно
```

Автообновление brew умеет, но оно выключено по умолчанию и мы его не включаем:
```bash
brew autoupdate start --upgrade --cleanup --immediate   # НЕ используем
brew autoupdate status
brew autoupdate stop
```
Причина та же, что и с `topgrade`: обновление без спроса может посреди работы
сменить мажорную версию `node`, `go` или `python` и сломать проекты.

### `--greedy` — главный подвох

По умолчанию `brew upgrade --cask` **пропускает** приложения со встроенным
автоапдейтером (`auto_updates true` или Sparkle). Brew считает, что они
обновляют себя сами, и не показывает их даже в `brew outdated --cask`.

```bash
brew outdated --cask --greedy            # реальный список устаревшего
brew upgrade --cask --greedy             # обновить в том числе самообновляющиеся
brew outdated --cask --greedy-auto-updates   # только те, что brew обычно скрывает
```

> Если кажется, что приложение «стоит вручную», потому что brew его не
> показывает — сначала проверь с `--greedy`.

### Закрепить версию

```bash
brew pin <formula>           # не обновлять формулу
brew unpin <formula>
brew list --pinned           # что закреплено
```
Для casks аналога нет — там просто не запускай upgrade для конкретного имени.

### Чистка

```bash
brew autoremove              # удалить осиротевшие зависимости
brew cleanup                 # удалить старые версии и кэш скачиваний
brew cleanup --prune=all     # вычистить кэш полностью
brew doctor                  # диагностика проблем
```

---

## Как решить, что обновлять

Кейс: `brew outdated` выдал полсотни пакетов. Что с этим делать.

### 1. Посмотреть версии, а не только имена

```bash
brew outdated --verbose      # neovim (0.12.2) < 0.12.5
brew outdated --json         # то же машиночитаемо
```
Без `--verbose` видно только имена, и оценить масштаб изменения нельзя.

### 2. Прочитать номера по semver (`major.minor.patch`)

| Что меняется | Риск | Примеры |
|--------------|------|---------|
| patch (`0.12.2 → 0.12.5`) | почти нулевой | neovim, git, lazygit |
| minor (`1.2 → 1.3`) | низкий, у ключевых читаем release notes | ansible, gh, tmux |
| **major** (`22 → 23`) | **высокий**, может сломать проекты | node, go, python, openssl |

Правило: рантаймы (`node`, `go`, `python`, `luajit`) и всё, от чего зависят
рабочие проекты, обновляем отдельно и осознанно. Утилиты вроде `eza`, `fzf`,
`tree`, `zoxide` — можно валом.

### 3. Проверить, кого заденет

```bash
brew uses --installed openssl@3   # кто сломается, если обновить
brew info node@22                 # версия, зависимости, заметки
brew log neovim                   # история изменений формулы
brew home neovim                  # release notes на сайте проекта
```

### 4. Обновить точечно

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade neovim
```
`HOMEBREW_NO_AUTO_UPDATE=1` не даёт brew втихую обновить каталог формул перед
установкой — иначе «точечное» обновление подтянет более свежие версии, чем
показывал `brew outdated`.

> Нюанс: `brew upgrade <name>` всё равно обновит **зависимости пакета**, если
> новая версия их требует. Полностью изолированного обновления в brew нет.

### 5. Закрепить критичное

Рантаймы и всё, что не должно уехать при общем `brew upgrade` —
через `brew pin`, см. [Закрепить версию](#закрепить-версию).

### Откат

Старых версий brew не хранит, поэтому откат — слабое место:

- версионированная формула, если она есть: `brew install node@20`, `python@3.12`;
- иначе — установка из старого коммита tap, долго и муторно.

Вывод: дешевле заранее закрепить (`brew pin`), чем потом откатывать.

---

## Brewfile — состояние системы в git

Список пакетов лежит в [packages/macos/Brewfile](../packages/macos/Brewfile).

```bash
brew bundle --file=packages/macos/Brewfile          # установить всё из файла
brew bundle check --file=packages/macos/Brewfile    # проверить, чего не хватает
brew bundle list --file=packages/macos/Brewfile     # что перечислено в файле
brew bundle dump --file=packages/macos/Brewfile --force   # перезаписать файл текущим состоянием
brew bundle cleanup --file=packages/macos/Brewfile        # показать лишнее (не из файла)
brew bundle cleanup --force --file=packages/macos/Brewfile   # удалить лишнее
```

> `dump --force` затирает комментарии в Brewfile. Новые пакеты лучше дописывать
> в файл руками, в нужную секцию.

---

## Установка нового приложения

```bash
brew search <имя>            # поиск по формулам и caskам
brew info --cask <имя>       # версия, зависимости, описание
brew install --cask <имя>    # установить GUI-приложение
brew install <имя>           # установить CLI-утилиту
```

**Правило:** если приложение есть в brew — ставить только через brew и дописать
в Brewfile. Ручная установка того, что есть в brew, создаёт второй экземпляр
и путаницу с версиями.

Перевести уже стоящее вручную приложение под brew:
1. Выйти из приложения.
2. `brew install --cask <имя>` — brew обычно подхватывает существующий бандл
   (при конфликте: удалить `.app` из `/Applications` и поставить заново).
3. Дописать `cask "<имя>"` в Brewfile.

---

## Mac App Store

```bash
brew install mas             # CLI для App Store
mas list                     # что установлено из App Store
mas outdated                 # что устарело
mas upgrade                  # обновить всё
```

---

## Приложения, установленные вручную

Единственный надёжный способ — держать их список с ссылками на источник в
[packages/macos/manual.md](../packages/macos/manual.md) и раз в пару месяцев
обходить его.

Обновление такого приложения:
1. Проверить в самом приложении: меню → *Check for Updates* (Sparkle).
2. Если автоапдейтера нет — скачать новый .dmg с сайта и поставить поверх.
3. Приложения с системным расширением или helper-демоном (VPN-клиенты,
   виртуализация, драйверы мыши) **нельзя** обновлять простым перетаскиванием
   `.app` — старый helper останется и будет конфликтовать. Ставить только
   штатным установщиком или через `brew upgrade --cask --greedy`.

Посмотреть версию установленного приложения:
```bash
mdls -name kMDItemVersion /Applications/<App>.app
defaults read /Applications/<App>.app/Contents/Info.plist CFBundleShortVersionString
```

---

## Обновления самой macOS

```bash
softwareupdate -l                    # список доступных обновлений
softwareupdate -i <label>            # установить конкретное
softwareupdate -i -r                 # установить все рекомендованные
softwareupdate --list-full-installers  # полные инсталляторы macOS
```

> Мажорные релизы macOS не ставим сразу — первые версии ломают рабочее
> окружение. Ждём минимум `x.2`–`x.3` и полгода после выхода.
> Обновления безопасности (Rapid Security Response, XProtect) ставить можно.

Отключить навязчивые автообновления системы (оставив security-патчи):
System Settings → General → Software Update → ⓘ рядом с Automatic Updates.

---

## Регулярное обслуживание

```bash
brew update && brew outdated --verbose && brew outdated --cask --greedy
brew upgrade && brew upgrade --cask --greedy
brew autoremove && brew cleanup
```

> Единые «обновлятели всего» вроде `topgrade` намеренно не используем: они
> тянут за собой обновления macOS и цепляют всё подряд одной командой без
> возможности посмотреть, что именно поедет. Обновления запускаем по источникам
> и осознанно.
