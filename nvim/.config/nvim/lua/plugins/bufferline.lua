-- Полоса открытых буферов сверху.
-- Режим "buffers", а не "tabs": Tab / Shift+Tab у нас ходят по буферам,
-- а вкладки живут отдельно на <leader>t.
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  event = "VeryLazy",
  opts = {
    options = {
      -- "buffers" — полоса показывает открытые файлы, ходим по ним Tab / Shift+Tab
      -- "tabs" — полоса показывает вкладки nvim, как было в сборке B
      mode = "buffers",
      -- mode = "tabs",
      numbers = "none",
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      modified_icon = "●",
      left_trunc_marker = "",
      right_trunc_marker = "",
      indicator = {
        style = "none",
      },
      diagnostics_indicator = function(_, _, diagnostics, _)
        local symbols = { error = " ", warning = " ", info = " " }
        local result = " "

        for level, _ in pairs(diagnostics) do
          result = result .. (symbols[level] or " ")
        end

        return result
      end,
      -- Пустые безымянные буферы в полосе не показываем: такой создаётся
      -- при старте nvim и при каждом :tabnew, а после закрытия вкладки
      -- остаётся висеть в списке. Текущий буфер показываем всегда, иначе
      -- только что созданный через :enew исчез бы из полосы.
      custom_filter = function(bufnr)
        if bufnr == vim.api.nvim_get_current_buf() then
          return true
        end

        local is_unnamed = vim.api.nvim_buf_get_name(bufnr) == ""
        local is_unmodified = not vim.api.nvim_get_option_value("modified", { buf = bufnr })
        local is_normal = vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local is_empty = #lines == 1 and lines[1] == ""

        return not (is_unnamed and is_unmodified and is_normal and is_empty)
      end,
      -- Место под дерево файлов, чтобы полоса не заезжала под него (Фаза 4)
      offsets = {
        {
          filetype = "neo-tree",
          text = "Проводник",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    local map = require("core.lang").map

    -- Именно команды bufferline, а не :bnext — они ходят по тому списку,
    -- который показан в полосе, и скрытые буферы пропускают
    map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Следующий буфер" })
    map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Предыдущий буфер" })

    -- Своей команды "закрыть текущий буфер" у bufferline нет, поэтому здесь
    -- штатная :bdelete — но держим её рядом с остальной группой <leader>b
    map("n", "<leader>bx", "<cmd>bdelete<CR>", { desc = "Закрыть буфер" })
    map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Закрыть остальные буферы" })
    map("n", "<leader>ba", "<cmd>%bdelete<CR>", { desc = "Закрыть все буферы" })
    map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Выбрать буфер по букве" })
    map("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", { desc = "Закрыть буфер по букве" })
  end,
}
