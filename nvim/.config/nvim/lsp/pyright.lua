-- Python: типы и навигация.
-- Линтингом и форматированием занимается ruff, поэтому проверки
-- неиспользуемого у pyright отключены, чтобы не дублировать сообщения.
return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnusedImport = "none", -- это скажет ruff
          reportUnusedVariable = "none",
        },
      },
    },
  },
}
