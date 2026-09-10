return {
  {
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

      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },

  {
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

      -- vim.cmd.colorscheme("catppuccin-mocha") -- uncomment to enable
    end,
  },
}
