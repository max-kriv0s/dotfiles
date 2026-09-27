-- Начальная страница при запуске без файла
return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    dashboard.section.buttons.val = {
      dashboard.button("e", "  Новый файл", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  Дерево файлов", "<cmd>Neotree toggle<CR>"),
      dashboard.button("SPC ff", "󰱼  Найти файл", "<cmd>FzfLua files<CR>"),
      dashboard.button("SPC fw", "  Найти текст", "<cmd>FzfLua live_grep<CR>"),
      dashboard.button("SPC fr", "  Недавние файлы", "<cmd>FzfLua oldfiles<CR>"),
      dashboard.button("SPC wr", "󰁯  Восстановить сессию каталога", "<cmd>AutoSession restore<CR>"),
      dashboard.button("q", "  Выйти", "<cmd>qa<CR>"),
    }

    require("alpha").setup(dashboard.opts)

    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
