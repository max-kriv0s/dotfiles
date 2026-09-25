# Тестовые файлы

Набор для проверки конфига: по файлу на каждый язык и формат из стека.
В репозитории лежат временно — удаляются вместе с `nvim-next` при переносе
конфига в `nvim` (Фаза 5).

Открывать так: `nv ~/dotfiles/nvim-next/test/check.ts`

## Что чем проверяется

| Файл | Серверы | Форматтер | Линтер |
| --- | --- | --- | --- |
| `check.ts` | vtsls, eslint | prettierd | eslint_d |
| `check.tsx` | vtsls, eslint, tailwindcss | prettierd | eslint_d |
| `check.vue` | vue_ls, vtsls | prettierd | eslint_d |
| `check.go`, `go.mod` | gopls | goimports | golangci-lint |
| `check.py` | basedpyright, ruff | ruff | ruff |
| `Dockerfile` | dockerls | — | hadolint |
| `compose.yaml` | docker_compose_language_service, yamlls | prettierd | yamllint |
| `Taskfile.yml` | yamlls | prettierd | yamllint |
| `.gitlab-ci.yml` | yamlls | prettierd | actionlint |
| `main.tf` | terraformls | terraform fmt | tflint |
| `check.sh` | bashls | shfmt | shellcheck |
| `playbooks/site.yml` | ansiblels | — | ansible-lint |
| `chart/Chart.yaml` | yamlls | prettierd | yamllint |
| `chart/values.yaml` | helm_ls | — | — |
| `chart/templates/deployment.yaml` | helm_ls | — | — |
| `tsconfig.json` | jsonls | prettierd | — |

## Проверка типов файлов

Правила из `lua/core/filetypes.lua`. В каждом файле выполнить `:echo &filetype`:

| Файл | Ожидаемый тип |
| --- | --- |
| `compose.yaml` | `yaml.docker-compose` |
| `.gitlab-ci.yml` | `yaml.gitlab` |
| `playbooks/site.yml` | `yaml.ansible` |
| `chart/values.yaml` | `yaml.helm-values` |
| `chart/templates/deployment.yaml` | `helm` |
| `Taskfile.yml` | `yaml` |
| `check.go` | `go`, при этом `:echo &expandtab` → `0` |

## Намеренные ошибки

Оставлены, чтобы было видно работу диагностик и линтеров:

- `check.ts` — в `findUser` передана строка вместо числа
- `check.py` — обращение к неопределённой переменной
- `check.sh` — переменная без кавычек (SC2086)
- `Dockerfile` — `apt-get` без версии пакета и лишним слоем
- `main.tf` — кривые отступы, выправятся при сохранении
