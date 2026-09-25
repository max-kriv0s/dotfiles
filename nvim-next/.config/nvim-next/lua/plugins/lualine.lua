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

    -- Имена языковых серверов, подключённых к текущему буферу.
    -- Пусто — значит сервер не подключился, и это сразу видно.
    local function lsp_clients()
      local names = {}

      for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
      end

      if #names == 0 then
        return ""
      end

      return " " .. table.concat(names, ", ")
    end

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
          lsp_clients,
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
