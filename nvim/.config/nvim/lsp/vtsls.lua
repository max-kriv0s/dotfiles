-- TypeScript и JavaScript.
-- vtsls обслуживает и .vue: языковой сервер Vue работает как плагин
-- внутри tsserver, иначе типы между .vue и .ts не видны друг другу.
-- Путь считаем от каталога данных, а не от $MASON: переменная появляется
-- только после загрузки mason, а этот файл может быть прочитан раньше.
local vue_plugin = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

-- Список filetypes задан в plugins/lsp/lspconfig.lua — здесь он бы затёрся
-- одноимённым файлом из lspconfig.
return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin,
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        variableTypes = { enabled = false },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
      },
    },
  },
}
