-- Терминал внутри редактора.
-- Раскладка полностью как в сборке A. Вкладочная команда "буфер в новую
-- вкладку" ради этого переехала с <leader>tf на <leader>tb.
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { [[<C-\>]], desc = "Открыть или скрыть терминал" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Плавающий терминал" },
    { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Терминал снизу" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Терминал сбоку" },
    {
      "<leader>tt",
      "<cmd>ToggleTerm direction=tab<CR>",
      desc = "Терминал в отдельной вкладке",
    },
    { "<leader>t1", "<cmd>1ToggleTerm<CR>", desc = "Терминал 1" },
    { "<leader>t2", "<cmd>2ToggleTerm<CR>", desc = "Терминал 2" },
    { "<leader>t3", "<cmd>3ToggleTerm<CR>", desc = "Терминал 3" },
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = "horizontal",
    persist_size = true, -- запоминать размер, изменённый мышью или <C-w>
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      end

      if term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    float_opts = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    -- Внутри терминала обычные клавиши перехвачены самим шеллом,
    -- поэтому выход и перемещение по окнам назначаем отдельно
    vim.api.nvim_create_autocmd("TermOpen", {
      group = vim.api.nvim_create_augroup("user_toggleterm", { clear = true }),
      pattern = "term://*",
      callback = function()
        local function map(lhs, rhs, desc)
          vim.keymap.set("t", lhs, rhs, { buffer = 0, silent = true, desc = desc })
        end

        map("<Esc>", [[<C-\><C-n>]], "Выйти в Normal")
        -- Только jj: jk в кириллице даёт «ол», которое встречается в словах
        map("jj", [[<C-\><C-n>]], "Выйти в Normal")
        map("<C-h>", [[<Cmd>wincmd h<CR>]], "Окно слева")
        map("<C-j>", [[<Cmd>wincmd j<CR>]], "Окно снизу")
        map("<C-k>", [[<Cmd>wincmd k<CR>]], "Окно сверху")
        map("<C-l>", [[<Cmd>wincmd l<CR>]], "Окно справа")
      end,
    })
  end,
}
