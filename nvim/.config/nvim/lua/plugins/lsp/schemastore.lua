-- Каталог схем для JSON и YAML: подсказывает допустимые ключи и подсвечивает
-- опечатки в compose, Taskfile, workflow-файлах CI, манифестах k8s,
-- package.json, tsconfig. Локальная копия schemastore.org.
--
-- Плагин только объявляется. Схемы подключаются в lsp/jsonls.lua и
-- lsp/yamlls.lua — эти файлы читаются в момент запуска сервера,
-- то есть ровно тогда, когда схемы нужны.
return {
  "b0o/schemastore.nvim",
  lazy = true,
}
