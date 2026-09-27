-- Автодополнение. Меню появляется само по мере набора,
-- Ctrl+n вызывает его принудительно.

return {
  "saghen/blink.cmp",
  version = "1.*", -- готовая сборка, не нужно собирать Rust локально
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" },
      config = function()
        -- Сниппеты в формате VS Code из friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  opts = {
    snippets = { preset = "luasnip" },

    keymap = {
      preset = "none", -- набор задаём целиком сами
      ["<C-n>"] = { "show", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      -- Enter подставляет только явно выбранный вариант: если ничего не
      -- выбрано клавишами, он просто переводит строку
      ["<CR>"] = { "accept", "fallback" },
      -- Tab прыгает по местам внутри развёрнутого сниппета
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },

    completion = {
      list = {
        selection = { preselect = false, auto_insert = false },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      menu = {
        draw = {
          treesitter = { "lsp" }, -- подсветка вариантов по правилам языка
        },
      },
    },

    signature = { enabled = true }, -- подсказка по аргументам при вводе скобки

    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
