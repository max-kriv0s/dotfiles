-- Определение типов файлов для инфраструктуры.
--
-- Некоторые языковые серверы ждут не просто "yaml", а уточнённый тип:
-- docker_compose_language_service — yaml.docker-compose
-- ansiblels                       — yaml.ansible
-- helm_ls                         — helm и yaml.helm-values
-- Без этих правил такие серверы установлены, но никогда не подключаются.

-- Helm-шаблоны и values определяем только внутри чарта: ищем Chart.yaml
-- вверх по дереву, иначе любой каталог templates/ считался бы helm-ом.
local function in_chart(path, filetype)
  local dir = vim.fs.dirname(path)
  local chart = vim.fs.find("Chart.yaml", { path = dir, upward = true })

  return #chart > 0 and filetype or nil
end

vim.filetype.add({
  filename = {
    ["compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
    [".gitlab-ci.yml"] = "yaml.gitlab",
    [".gitlab-ci.yaml"] = "yaml.gitlab",
  },
  pattern = {
    -- compose.dev.yaml, docker-compose.prod.yml и подобные
    ["compose%..*%.ya?ml"] = "yaml.docker-compose",
    ["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",

    -- ansible: плейбуки и задачи ролей
    ["playbook.*%.ya?ml"] = "yaml.ansible",
    ["site%.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/tasks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*/handlers/.*%.ya?ml"] = "yaml.ansible",

    -- helm
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = function(path)
      return in_chart(path, "helm")
    end,
    ["values.*%.ya?ml"] = function(path)
      return in_chart(path, "yaml.helm-values")
    end,
  },
})
