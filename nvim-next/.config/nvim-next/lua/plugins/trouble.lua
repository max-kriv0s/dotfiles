-- Список проблем отдельным окном: ошибки LSP, линтеров, quickfix, TODO.
-- Отличие от <leader>d и <leader>D: там всплывающее окно с одной ошибкой
-- или быстрый список, здесь — постоянное окно, по которому можно ходить,
-- не теряя место в коде.
return {
  "folke/trouble.nvim",
  -- todo-comments здесь не ради подсветки, а ради источника `Trouble todo`:
  -- он лежит внутри этого плагина, и без зависимости trouble о нём не знает,
  -- пока todo-comments не загрузится сам.
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  cmd = "Trouble",
  opts = {
    -- Курсор сразу переходит в окно списка: обычно его и открывают,
    -- чтобы пройтись по ошибкам, а не чтобы посмотреть краем глаза.
    focus = true,
  },
  keys = {
    { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Ошибки по проекту" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Ошибки текущего файла" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix-список" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location-список" },
    { "<leader>xt", "<cmd>Trouble todo toggle<CR>", desc = "TODO и FIXME по проекту" },
  },
}
