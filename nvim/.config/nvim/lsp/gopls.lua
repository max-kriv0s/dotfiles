-- Go
return {
  settings = {
    gopls = {
      analyses = {
        unusedparams = true, -- неиспользуемые параметры функций
        shadow = true, -- переменная затеняет другую с тем же именем
      },
      staticcheck = true,
      gofumpt = true, -- более строгое форматирование, чем gofmt
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
