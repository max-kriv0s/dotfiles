-- Общие клавиши перехода для сплитов nvim и панелей tmux.
-- Плагин сначала пробует перейти внутри nvim, и только если в эту сторону
-- окон больше нет — передаёт управление tmux. Вторая половина настройки
-- живёт в tmux/.config/tmux/tmux.conf, без неё переход из nvim не сработает.
--
-- Эти клавиши перекрывают <C-w>h и остальные из core/keymaps.lua —
-- так и задумано, там про это стоит комментарий.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Окно или панель слева" },
    { "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Окно или панель снизу" },
    { "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Окно или панель сверху" },
    { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Окно или панель справа" },
    -- Кириллические дубли: core/lang.lua здесь не применить, список клавиш
    -- lazy.nvim читает до загрузки конфига, поэтому пишем руками
    { "<C-р>", "<cmd>TmuxNavigateLeft<CR>", desc = "Окно или панель слева" },
    { "<C-о>", "<cmd>TmuxNavigateDown<CR>", desc = "Окно или панель снизу" },
    { "<C-л>", "<cmd>TmuxNavigateUp<CR>", desc = "Окно или панель сверху" },
    { "<C-д>", "<cmd>TmuxNavigateRight<CR>", desc = "Окно или панель справа" },
  },
}
