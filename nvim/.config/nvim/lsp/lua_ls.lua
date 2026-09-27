-- Lua. Типы для nvim-API добавляет lazydev, здесь только базовое.
return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }, -- vim — глобальная переменная, а не опечатка
      },
      completion = {
        callSnippet = "Replace", -- дополнять сразу со скобками и аргументами
      },
    },
  },
}
