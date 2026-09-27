-- Каталог как обычный буфер: правите имена и структуру текстом,
-- :w применяет изменения к диску. Работают все привычные команды —
-- dd удалить, p вставить, cw переименовать, визуальный режим, отмена.
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- иначе `nvim .` откроет netrw вместо oil
  opts = {
    default_file_explorer = true,
    delete_to_trash = true, -- удалённое уходит в корзину, а не в никуда
    skip_confirm_for_simple_edits = false,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      -- Как в дереве: l и стрелка вправо открывают, h и влево — на уровень выше
      ["l"] = "actions.select",
      ["<Right>"] = "actions.select",
      ["h"] = "actions.parent",
      ["<Left>"] = "actions.parent",
      ["q"] = "actions.close",
      ["g?"] = "actions.show_help",
      ["<C-p>"] = "actions.preview",
      ["gs"] = "actions.change_sort",
      ["g."] = "actions.toggle_hidden",
    },
    use_default_keymaps = false, -- полный набор задаём сами, без сюрпризов
  },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Каталог текущего файла" },
  },
}
