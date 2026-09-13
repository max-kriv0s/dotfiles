return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    -- import mason-tool-installer
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "bashls",
        "docker_compose_language_service",
        "dockerls",
        "eslint",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "emmet_ls",
        "graphql",
        "jsonls",
        "lua_ls",
        "prismals",
        "pyright",
        "sqls",
        "taplo",
        "terraformls",
        "vue_ls",
        "yamlls",
      },
      automatic_enable = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
      },
    })
  end,
}
