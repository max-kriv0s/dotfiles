-- Treesitter: разбор кода в дерево. На этом строятся подсветка,
-- отступы, текст-объекты, автозакрытие тегов и комментарии в JSX.

local parsers = {
  -- разработка
  "javascript",
  "typescript",
  "tsx",
  "vue",
  "python",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "lua",
  "luadoc",
  -- разметка и стили
  "html",
  "css",
  "scss",
  "graphql",
  -- инфраструктура
  "bash",
  "dockerfile",
  "hcl",
  "terraform",
  "yaml",
  "json", -- отдельного парсера jsonc нет, .jsonc разбирает этот же
  "toml",
  "sql",
  "make",
  -- git и прочее
  "diff",
  "git_config",
  "git_rebase",
  "gitcommit",
  "gitignore",
  "markdown",
  "markdown_inline",
  "regex",
  "query",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(parsers)

      -- Подсветка и отступы включаются для любого буфера, для которого
      -- нашёлся парсер. Не нашёлся — файл остаётся без подсветки, без ошибки.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    -- Текст-объекты: выделять и прыгать по функциям, классам, аргументам
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true, -- если объекта нет под курсором, взять ближайший дальше
        },
      })

      local map = require("core.lang").map
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      -- Выделение: "a" — вместе с обёрткой, "i" — только содержимое
      local objects = {
        { key = "f", query = "function", desc = "функция" },
        { key = "c", query = "class", desc = "класс" },
        { key = "a", query = "parameter", desc = "аргумент" },
      }

      for _, object in ipairs(objects) do
        map({ "x", "o" }, "a" .. object.key, function()
          select.select_textobject("@" .. object.query .. ".outer", "textobjects")
        end, { desc = "Выделить " .. object.desc .. " целиком" })

        map({ "x", "o" }, "i" .. object.key, function()
          select.select_textobject("@" .. object.query .. ".inner", "textobjects")
        end, { desc = "Выделить тело: " .. object.desc })
      end

      -- Прыжки по функциям и классам
      map({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Следующая функция" })

      map({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Предыдущая функция" })

      map({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Следующий класс" })

      map({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Предыдущий класс" })
    end,
  },

  {
    -- Закрывающий тег появляется сам: JSX, TSX, Vue, HTML
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    -- Правильный символ комментария внутри JSX и Vue: встроенный gc
    -- сам по себе ставит // там, где нужно {/* */}
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false, -- значение запрашивается по месту, а не автокомандой
      })

      -- Подмена commentstring для встроенного gc
      local get_option = vim.filetype.get_option

      vim.filetype.get_option = function(filetype, option)
        if option ~= "commentstring" then
          return get_option(filetype, option)
        end

        return require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
}
