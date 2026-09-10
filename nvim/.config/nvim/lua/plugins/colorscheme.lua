local theme_link = vim.fn.expand("~/.config/theme/current")

-- Ключ темы — имя каталога, куда указывает симлинк
local function theme_key()
  local target = vim.fn.resolve(theme_link)

  if target == theme_link then
    return nil
  end

  return vim.fn.fnamemodify(target, ":t")
end

-- Имя colorscheme лежит в самой теме, маппинга в Lua нет
local function apply_theme()
  local path = theme_link .. "/nvim"

  if vim.fn.filereadable(path) ~= 1 then
    return
  end

  local name = vim.fn.trim(vim.fn.readfile(path)[1] or "")

  if name == "" or name == vim.g.colors_name then
    return
  end

  if not pcall(vim.cmd.colorscheme, name) then
    vim.notify("Colorscheme not available: " .. name, vim.log.levels.ERROR)
  end
end

local function reload_on_focus()
  vim.api.nvim_create_autocmd("FocusGained", {
    group = vim.api.nvim_create_augroup("UserThemeReload", { clear = true }),
    callback = apply_theme,
  })
end

local kanagawa = {
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      transparent = true, -- do not set background color
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
    })

    if theme_key() == "kanagawa" then
      apply_theme()
    end

    reload_on_focus()
  end,
}

local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      custom_highlights = function()
        return {
          LineNr = { bg = "NONE" },
          CursorLineNr = { bg = "NONE" },
          SignColumn = { bg = "NONE" },
          FoldColumn = { bg = "NONE" },
        }
      end,
    })

    if theme_key() == "catppuccin" then
      apply_theme()
    end

    reload_on_focus()
  end,
}

return {
  kanagawa,
  catppuccin,
}
