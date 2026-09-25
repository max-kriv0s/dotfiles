-- Языковые серверы: общие настройки, маппинги и вид диагностик.
-- Настройки конкретных серверов лежат по одному файлу в каталоге lsp/
-- в корне конфига — nvim подхватывает их сам при vim.lsp.enable().
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local map = require("core.lang").map

      -- Маппинги вешаются только на буферы, где подключился сервер
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(event)
          local function buf_map(mode, lhs, rhs, desc)
            map(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          -- Навигация. Списки открываются в fzf-lua: если результат один,
          -- прыгаем сразу, если несколько — выбор с предпросмотром.
          -- gD идёт мимо fzf: объявление всегда одно.
          local fzf = require("fzf-lua")

          buf_map("n", "gd", fzf.lsp_definitions, "Перейти к определению")
          buf_map("n", "gD", vim.lsp.buf.declaration, "Перейти к объявлению")
          buf_map("n", "gi", fzf.lsp_implementations, "Перейти к реализации")
          buf_map("n", "gt", fzf.lsp_typedefs, "Перейти к типу")
          buf_map("n", "gR", fzf.lsp_references, "Показать использования")

          -- Действия над кодом
          buf_map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Быстрое исправление")
          buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Переименовать символ")
          -- В Neovim 0.12 появилась встроенная :lsp, и lspconfig из-за этого
          -- больше не создаёт свои :LspStart / :LspRestart / :LspStop
          buf_map("n", "<leader>rs", "<cmd>lsp restart<CR>", "Перезапустить языковой сервер")

          -- Диагностики
          buf_map("n", "<leader>d", vim.diagnostic.open_float, "Ошибка текущей строки")
          buf_map("n", "<leader>D", fzf.diagnostics_document, "Все ошибки файла")

          -- Inlay hints — серые подсказки, которые редактор дорисовывает прямо
          -- в строку: выведенный тип переменной и имена аргументов у вызова.
          -- В файле их нет, они не копируются и не сохраняются.
          --   было:  const items = getUsers()
          --   стало: const items: User[] = getUsers()
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method("textDocument/inlayHint") then
            buf_map("n", "<leader>uh", function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
            end, "Типы и имена аргументов прямо в коде")
          end
        end,
      })

      -- Список типов файлов задаём здесь, а не в lsp/vtsls.lua: одноимённый
      -- файл есть и внутри lspconfig, в runtimepath он идёт позже и затирает
      -- наш filetypes. Настройки при этом сливаются нормально.
      -- vue_ls сам TypeScript не разбирает — он пересылает запросы в vtsls,
      -- поэтому без "vue" в этом списке gd в .vue отваливается по таймауту.
      vim.lsp.config("vtsls", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
        },
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
          },
        },
        float = {
          border = "rounded",
          source = true, -- какой сервер или линтер выдал сообщение
        },
      })
    end,
  },

  {
    -- Автодополнение и типы для Lua в конфигах nvim: знает про vim.api,
    -- подтягивает аннотации установленных плагинов
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
