# Git — Шпаргалка

---

## Базовый workflow

### Статус и просмотр изменений
```bash
git status              # что изменено
git st                  # то же (alias)

git diff                # что изменилось в файлах (не staged)
git diff --staged       # что попадёт в коммит

git log                 # история коммитов
git lg                  # красивый граф веток (alias)
```

### git diff с delta (side-by-side)
```bash
git diff                    # было/стало в две колонки
git diff --staged           # staged изменения

# навигация внутри delta
n                           # следующий файл
N                           # предыдущий файл
/ + текст                   # поиск
q                           # выйти

# git add -p с delta
git add -p                  # интерактивное добавление по кускам
                            # delta подсвечивает что добавляешь
```

### Добавление изменений
```bash
git add file.txt        # добавить файл
git add .               # добавить всё
git add -p              # добавлять по кускам интерактивно
```

### Коммиты
```bash
git commit -m "feat: add feature"    # обычный коммит
git commit --allow-empty -m "msg"    # пустой коммит

# Добавить изменения к последнему коммиту
git commit --amend --no-edit         # без изменения сообщения
git commit --amend -m "новый текст"  # с изменением сообщения
```
> ⚠️ `amend` меняет историю — не делай если уже запушил в общую ветку.

---

## Ветки

### Навигация
```bash
git branch              # список локальных веток
git branch -a           # все ветки включая remote

git switch main         # переключиться на ветку (современный способ)
git co main             # то же (alias для checkout)
git checkout main       # старый способ (то же самое)

git switch -c feature   # создать и переключиться на новую ветку
git checkout -b feature # то же, старый способ
```

### Удаление веток
```bash
git branch -d feature        # удалить локальную ветку (если смержена)
git branch -D feature        # удалить локальную ветку принудительно
git push origin -d feature   # удалить remote ветку
```

---

## Remote

### Получение изменений
```bash
git fetch                    # получить изменения не применяя
git fetch origin             # явно указать remote
git pull                     # fetch + merge
```

### Отправка изменений
```bash
git push                     # запушить (upstream уже настроен)
git push -u origin feature   # первый push новой ветки + настроить upstream
git push --force-with-lease  # force push безопасный (не перезапишет чужие коммиты)
```

### Удаление устаревших веток
```bash
git fetch --prune            # удаляет устаревшие ссылки на remote-ветки, которых уже нет на сервере
```
---

## Merge и Rebase

### Merge
```bash
# Влить remote ветку не переключаясь на неё
git fetch origin
git merge origin/main        # влить origin/main в текущую ветку

# Стандартный merge
git switch main
git merge feature            # влить feature в main
git merge --no-ff feature    # всегда создавать merge commit
```

### Rebase
```bash
# Rebase текущей ветки на удалённую — без переключения
git fetch origin
git rebase origin/main       # rebase на origin/main

# Интерактивный rebase (переписать историю)
git rebase -i HEAD~3         # последние 3 коммита
git rebase -i origin/main    # все коммиты относительно origin/main

# Команды внутри интерактивного rebase:
# pick   — оставить коммит как есть
# reword — изменить сообщение коммита
# squash — склеить с предыдущим коммитом
# drop   — удалить коммит
```

> ⚠️ Rebase меняет историю — не делай на ветках которые уже запушены в общий репозиторий.

### При конфликтах
```bash
# После конфликта при merge или rebase:
git status                   # посмотреть что конфликтует
# ... решаешь конфликты в редакторе ...
git add file.txt             # отметить как решённый
git merge --continue         # продолжить merge
git rebase --continue        # продолжить rebase

# Отменить если всё пошло не так
git merge --abort
git rebase --abort
```

---

## Stash

```bash
git stash                    # спрятать текущие изменения
git stash push -m "описание" # спрятать с описанием
git stash list               # список спрятанного
git stash pop                # достать последнее и удалить из stash
git stash apply stash@{0}    # достать конкретное, оставить в stash
git stash drop stash@{0}     # удалить конкретное
git stash clear              # очистить всё
```

---

## Отмена изменений

```bash
# Отменить изменения в файле (не staged)
git restore file.txt         # современный способ
git checkout -- file.txt     # старый способ

# Убрать файл из staged
git restore --staged file.txt
git reset HEAD file.txt      # старый способ

# Отменить последний коммит — оставить изменения
git reset --soft HEAD~1

# Отменить последний коммит — убрать изменения из staged
git reset HEAD~1

# Отменить последний коммит — удалить изменения полностью
git reset --hard HEAD~1

# Безопасная отмена — создаёт новый коммит отменяющий изменения
git revert HEAD              # отменить последний коммит
git revert abc1234           # отменить конкретный коммит

# Взять файл из другой ветки в текущую
git checkout feature -- file.txt        # старый способ
git restore --source=feature file.txt   # современный способ

# Взять файл из конкретного коммита
git restore --source=abc1234 file.txt
```

> ⚠️ `reset --hard` удаляет изменения безвозвратно.
> `revert` безопаснее если уже запушил.

---

## Cherry-pick

```bash
git cherry-pick abc1234      # применить конкретный коммит в текущую ветку
git cherry-pick abc1..def5   # применить диапазон коммитов
git cherry-pick --no-commit abc1234  # применить без создания коммита
```

---

## Теги

```bash
git tag                      # список тегов
git tag v1.0.0               # создать легковесный тег
git tag -a v1.0.0 -m "msg"   # создать аннотированный тег
git push origin v1.0.0       # запушить тег
git push origin --tags       # запушить все теги
git tag -d v1.0.0            # удалить локальный тег
git push origin -d v1.0.0    # удалить remote тег
```

---

## Полезные команды

```bash
# Найти коммит который сломал что-то
git bisect start
git bisect bad               # текущий коммит плохой
git bisect good abc1234      # этот коммит был хорошим
# git будет переключать коммиты, ты говоришь good/bad
git bisect reset             # закончить

# Посмотреть кто написал строку
git blame file.txt

# Найти коммит по тексту
git log --grep="fix bug"

# Найти все коммиты где менялась строка
git log -S "function name"

# Показать что было в файле в конкретном коммите
git show abc1234:file.txt
```
