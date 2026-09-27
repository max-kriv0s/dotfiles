-- Mason ставит языковые серверы, форматтеры и линтеры в каталог данных nvim
-- (:echo stdpath("data")). Сами языки (node, go, python) он не ставит — они системные.
return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    -- Языковые серверы. automatic_enable включает каждый установленный сервер,
    -- подхватывая настройки из каталога lsp/ в корне конфига.
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = true,
      ensure_installed = {
        -- разработка
        "vtsls", -- TypeScript и JavaScript
        "vue_ls", -- Vue
        "eslint",
        "gopls",
        "pyright", -- типы для Python
        "ruff", -- быстрый линтер и форматтер Python
        "tailwindcss",
        "emmet_ls",
        "cssls",
        "jsonls",
        "lua_ls",
        -- инфраструктура
        "dockerls",
        "docker_compose_language_service",
        "yamlls",
        "helm_ls",
        "terraformls",
        "ansiblels",
        "bashls",
        "taplo", -- TOML
      },
    },
  },

  {
    -- Форматтеры и линтеры: это не языковые серверы, их ставит отдельный плагин.
    -- Загрузка не отложена намеренно: установку он запускает по VimEnter,
    -- а при ленивой загрузке подписался бы на уже прошедшее событие.
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        -- форматтеры
        "prettierd", -- js/ts/vue/css/json/yaml/markdown
        "stylua", -- lua
        "shfmt", -- bash
        "goimports", -- go, заодно сортирует импорты
        -- линтеры
        "eslint_d",
        "yamllint",
        "actionlint", -- GitHub Actions
        -- отладчики для nvim-dap
        "delve", -- go
        "debugpy", -- python
        "js-debug-adapter", -- node и typescript
        -- Остальные линтеры ставятся через brew и берутся из системы:
        -- shellcheck, hadolint, tflint, golangci-lint, ansible-lint.
        -- Причина — размер: у Mason это отдельные копии на ~400 МБ,
        -- а в brew они общие для всех инструментов, не только для nvim.
      },
    },
  },
}
