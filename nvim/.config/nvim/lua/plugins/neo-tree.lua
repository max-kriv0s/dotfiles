-- Дерево файлов.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Neotree",
  -- Кириллический дубль указан рядом с каждой клавишей. Обёртка core.lang.map
  -- здесь не поможет: список keys lazy.nvim читает до загрузки плагина.
  -- В подсказках which-key кириллица отфильтрована и списка не удваивает.
  keys = {
    { "<leader>ee", "<cmd>Neotree left toggle<CR>", desc = "Открыть или закрыть дерево" },
    { "<leader>уу", "<cmd>Neotree left toggle<CR>", desc = "Открыть или закрыть дерево (рус)" },
    { "<leader>ef", "<cmd>Neotree left reveal toggle<CR>", desc = "Дерево на текущем файле" },
    { "<leader>уа", "<cmd>Neotree left reveal toggle<CR>", desc = "Дерево на текущем файле (рус)" },
    { "<leader>ec", "<cmd>Neotree close<CR>", desc = "Закрыть дерево" },
    { "<leader>ус", "<cmd>Neotree close<CR>", desc = "Закрыть дерево (рус)" },
    {
      "<leader>er",
      function()
        -- У команды :Neotree аргумента refresh нет, обновление делается вызовом
        require("neo-tree.sources.manager").refresh("filesystem")
      end,
      desc = "Обновить дерево",
    },
    {
      "<leader>ук",
      function()
        require("neo-tree.sources.manager").refresh("filesystem")
      end,
      desc = "Обновить дерево (рус)",
    },
  },
  opts = {
    close_if_last_window = true, -- не оставлять дерево единственным окном
    enable_git_status = true,
    enable_diagnostics = true,
    popup_border_style = "rounded",

    default_component_configs = {
      git_status = {
        -- Стандартный набор глифов Nerd Font, как у neo-tree по умолчанию
        -- и в большинстве чужих конфигов. В ghostty рисуются корректно,
        -- в alacritty часть символов может заменяться квадратами —
        -- это ограничение шрифтового fallback у него, не настройка nvim.
        symbols = {
          added = "",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          conflict = "",
          -- Пусто намеренно: neo-tree рисует две колонки git-статуса —
          -- состояние в индексе и в рабочем каталоге. Второй символ
          -- убираем, чтобы было по одному значку на файл, как в сборке B.
          unstaged = "",
          staged = "",
        },
      },
    },

    window = {
      position = "left",
      width = 32,
      mappings = {
        -- Открыть и закрыть как в vim: l вправо, h влево
        ["l"] = "open",
        ["д"] = "open",
        ["h"] = "close_node",
        ["р"] = "close_node",
        ["н"] = "copy_to_clipboard",
        ["ч"] = "cut_to_clipboard",
        ["з"] = "paste_from_clipboard",
        ["<Right>"] = "open",
        ["<Left>"] = "close_node",
        ["<Space>"] = "none", -- Space остаётся leader, не сворачивает узел
        ["s"] = "open_split",
        ["v"] = "open_vsplit",
      },
    },

    filesystem = {
      follow_current_file = { enabled = true }, -- подсвечивать открытый файл
      use_libuv_file_watcher = true, -- обновляться при изменениях на диске
      hijack_netrw_behavior = "open_default",
      -- Видно всё, кроме служебного: .env.local и node_modules бывают нужны.
      -- Спрятанное по имени показывает H.
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".DS_Store", ".git" },
      },
    },
  },
}
