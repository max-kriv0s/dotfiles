-- Python: типы и навигация.
-- Линтингом и форматированием занимается ruff, поэтому проверки
-- импортов у basedpyright отключены, чтобы не дублировать сообщения.
return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = "none", -- это скажет ruff
          reportUnusedVariable = "none",
        },
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
        },
      },
    },
  },
}
