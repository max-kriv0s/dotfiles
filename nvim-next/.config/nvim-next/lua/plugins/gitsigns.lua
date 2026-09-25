-- Git-изменения прямо в колонке слева от номеров строк.
-- Блок изменений в терминах git называется hunk — отсюда группа <leader>h.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- По умолчанию gitsigns рисует тонкую вертикальную черту — на тёмном фоне
    -- её легко не заметить. Обычные +, ~ и - читаются сразу и совпадают с тем,
    -- как git показывает изменения в текстовом выводе.
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "-" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
      untracked = { text = "?" },
    },
    -- Маппинги живут в on_attach, а не в keys: они нужны только в буферах
    -- внутри git-репозитория, в остальных <leader>h ничего не делает.
    on_attach = function(bufnr)
      local gs = require("gitsigns")

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Навигация
      map("n", "]h", function()
        gs.nav_hunk("next")
      end, "Следующее изменение")
      map("n", "[h", function()
        gs.nav_hunk("prev")
      end, "Предыдущее изменение")

      -- Просмотр
      map("n", "<leader>hp", gs.preview_hunk, "Показать изменение")
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Кто менял эту строку")
      map("n", "<leader>hB", gs.toggle_current_line_blame, "Blame у каждой строки")
      map("n", "<leader>hd", gs.diffthis, "Сравнить с индексом")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Сравнить с последним коммитом")

      -- Изменение. stage_hunk работает как переключатель: повторное нажатие
      -- на том же блоке убирает его из индекса, отдельная клавиша не нужна.
      map("n", "<leader>hs", gs.stage_hunk, "Блок в индекс")
      map("n", "<leader>hr", gs.reset_hunk, "Откатить блок")
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Выделенное в индекс")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Откатить выделенное")
      map("n", "<leader>hS", gs.stage_buffer, "Весь файл в индекс")
      map("n", "<leader>hR", gs.reset_buffer, "Откатить весь файл")

      -- Текст-объект: vih выделит блок изменений, dih удалит
      map({ "o", "x" }, "ih", gs.select_hunk, "Блок изменений")
    end,
  },
}
