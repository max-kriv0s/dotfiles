-- Тема kanagawa — вариант dragon, имя colorscheme "kanagawa-dragon"
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true, -- фон терминала виден сквозь nvim
    theme = "dragon",
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
  },
}
