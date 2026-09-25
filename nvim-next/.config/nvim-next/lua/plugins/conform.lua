-- Форматирование при сохранении.
-- Форматтеры ставит mason-tool-installer, список — в plugins/lsp/mason.lua
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        -- разработка
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        vue = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        html = { "prettierd" },
        graphql = { "prettierd" },
        markdown = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        python = { "ruff_organize_imports", "ruff_format" },
        go = { "goimports" }, -- заодно сортирует импорты
        lua = { "stylua" },
        -- инфраструктура
        sh = { "shfmt" },
        bash = { "shfmt" },
        yaml = { "prettierd" },
        ["yaml.docker-compose"] = { "prettierd" },
        ["yaml.gitlab"] = { "prettierd" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        toml = { "taplo" },
      },

      format_on_save = function(bufnr)
        -- Переключатель <leader>uf: выключает автоформат для буфера
        -- или для всей сессии
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        return {
          lsp_format = "fallback", -- нет форматтера — попросим языковой сервер
          timeout_ms = 1000,
        }
      end,
    })

    local map = require("core.lang").map

    map({ "n", "v" }, "<leader>cf", function()
      conform.format({ lsp_format = "fallback", timeout_ms = 1000 })
    end, { desc = "Форматировать файл или выделение" })

    map("n", "<leader>uf", function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat

      vim.notify(
        vim.g.disable_autoformat and "Автоформат выключен" or "Автоформат включён",
        vim.log.levels.INFO
      )
    end, { desc = "Форматирование при сохранении" })
  end,
}
