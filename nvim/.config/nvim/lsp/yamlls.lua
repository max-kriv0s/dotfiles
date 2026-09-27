-- YAML. Схемы из schemastore: compose, Taskfile, GitHub Actions, GitLab CI,
-- манифесты kubernetes и прочее.
return {
  settings = {
    yaml = {
      keyOrdering = false, -- не требовать алфавитного порядка ключей
      validate = true,
      format = { enable = false }, -- форматирует prettierd через conform
      schemaStore = {
        -- Встроенный загрузчик отключён: схемы берём из плагина, иначе
        -- yamlls лезет за ними в сеть при каждом запуске
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}
