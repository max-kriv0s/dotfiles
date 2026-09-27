-- Линтеры: то, что языковой сервер не проверяет.
-- Сами линтеры ставит mason-tool-installer, список — в plugins/lsp/mason.lua
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- разработка
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      vue = { "eslint_d" },
      go = { "golangcilint" },
      -- инфраструктура
      dockerfile = { "hadolint" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      yaml = { "yamllint" },
      ["yaml.docker-compose"] = { "yamllint" },
      ["yaml.gitlab"] = { "yamllint" },
      ["yaml.ansible"] = { "ansible_lint" },
      terraform = { "tflint" },
    }

    -- Python не указан намеренно: ruff работает как языковой сервер
    -- и отдаёт свои замечания через LSP, второй раз запускать его незачем.

    local group = vim.api.nvim_create_augroup("user_lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function()
        -- Молча пропускаем, если линтера нет в системе или проекту
        -- не хватает его конфига
        lint.try_lint(nil, { ignore_errors = true })

        -- Workflow-файлы GitHub Actions остаются обычным yaml, чтобы за ними
        -- сохранились схемы и автодополнение, поэтому actionlint выбираем
        -- по пути, а не по типу файла
        if vim.api.nvim_buf_get_name(0):match("%.github/workflows/.*%.ya?ml$") then
          lint.try_lint("actionlint", { ignore_errors = true })
        end
      end,
    })

    require("core.lang").map("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Запустить линтер для файла" })
  end,
}
