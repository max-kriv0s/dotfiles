-- Статусная строка.
-- Тема "auto" собирает цвета из активной colorscheme, поэтому строка
-- выглядит одинаково уместно и с coolnight, и с kanagawa, и с catppuccin,
-- и сама красит первую секцию по текущему режиму.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local lazy_status = require("lazy.status")

    local opts = {
      options = {
        theme = "auto",
        globalstatus = true, -- одна строка на всё окно, а не на каждый split
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- путь относительно корня проекта
        lualine_x = {
          {
            lazy_status.updates, -- сколько плагинов можно обновить
            cond = lazy_status.has_updates,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    }

    require("lualine").setup(opts)

    -- Тема "auto" вычисляется один раз при setup, поэтому после смены
    -- colorscheme статусную строку нужно пересобрать
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("user_lualine", { clear = true }),
      callback = function()
        require("lualine").setup(opts)
      end,
    })
  end,
}
