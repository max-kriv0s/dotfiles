-- Поиск: файлы, текст по проекту, буферы, символы, диагностики.
-- Он же показывает списки от LSP — определения, реализации, использования.
-- Требует установленных fzf и ripgrep.
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Не cmd и не keys: маппинги объявляются ниже в config, а он выполняется
  -- только при загрузке плагина. С cmd клавиши не работали бы до первого
  -- ручного вызова :FzfLua.
  event = "VeryLazy",
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      winopts = {
        height = 0.85,
        width = 0.85,
        preview = {
          layout = "vertical", -- предпросмотр снизу: в узком окне так читаемее
          vertical = "down:45%",
        },
      },
      -- Дополняем штатные клавиши на уровне fzf, без перехвата в nvim.
      keymap = {
        fzf = {
          ["ctrl-j"] = "down",
          ["ctrl-k"] = "up",
        },
      },
    })

    local map = require("core.lang").map

    map("n", "<leader>ff", fzf.files, { desc = "Найти файл по имени" })
    map("n", "<leader>fw", fzf.live_grep, { desc = "Найти текст по проекту" })
    -- Поиск слова под курсором без набора запроса. Для кода это почти всегда
    -- заменяет gR от LSP, поэтому выключено.
    -- map("n", "<leader>fc", fzf.grep_cword, { desc = "Найти слово под курсором" })
    map("n", "<leader>fr", fzf.oldfiles, { desc = "Недавние файлы" })
    map("n", "<leader>fb", fzf.buffers, { desc = "Открытые буферы" })
    map("n", "<leader>fh", fzf.helptags, { desc = "Справка nvim" })
    map("n", "<leader>fk", fzf.keymaps, { desc = "Все сочетания клавиш" })
    map("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Ошибки по проекту" })
    map("n", "<leader>fg", fzf.git_status, { desc = "Изменённые файлы git" })
    map("n", "<leader>fR", fzf.resume, { desc = "Вернуться к прошлому поиску" })
  end,
}
