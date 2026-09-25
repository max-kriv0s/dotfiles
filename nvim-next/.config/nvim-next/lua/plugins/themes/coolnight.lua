-- Тема coolnight. За основу взят tokyonight, палитра — наша,
-- та же, что в alacritty/themes/coolnight.toml.
-- Сама тема регистрируется в colors/coolnight.lua, здесь только плагин-основа.
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",
    transparent = true, -- фон терминала виден сквозь nvim
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_colors = function(colors)
      colors.bg = "#011628"
      colors.bg_dark = "#011423"
      colors.bg_float = "#011423"
      colors.bg_highlight = "#143652"
      colors.bg_popup = "#011423"
      colors.bg_search = "#0A64AC"
      -- bg_sidebar намеренно не задаём: при transparent = true тема обнуляет
      -- фон боковых окон, а явный цвет здесь вернул бы его обратно, и дерево
      -- отличалось бы от редактора. Плавающим окнам фон, наоборот, нужен —
      -- они всплывают поверх кода, их полезно отделять.
      colors.bg_statusline = "#011423"
      colors.bg_visual = "#275378"
      colors.border = "#547998"
      colors.fg = "#CBE0F0"
      colors.fg_dark = "#B4D0E9"
      colors.fg_float = "#CBE0F0"
      colors.fg_gutter = "#627E97"
      colors.fg_sidebar = "#B4D0E9"
    end,
  },
}
