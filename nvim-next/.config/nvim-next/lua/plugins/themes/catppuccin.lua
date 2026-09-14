-- Тема catppuccin — вариант mocha, имя colorscheme "catppuccin-mocha"
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true, -- фон терминала виден сквозь nvim
    custom_highlights = function()
      return {
        LineNr = { bg = "NONE" },
        CursorLineNr = { bg = "NONE" },
        SignColumn = { bg = "NONE" },
        FoldColumn = { bg = "NONE" },
      }
    end,
  },
}
