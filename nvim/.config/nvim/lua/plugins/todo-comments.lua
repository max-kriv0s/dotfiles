-- Подсветка пометок в комментариях: TODO, FIXME, HACK, NOTE, WARNING, PERF.
-- В сборке B плагин был записан зависимостью trouble, но не настраивался.
-- Здесь он самостоятельный: подсветка нужна всегда, а не только когда
-- открывают список проблем.
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  keys = {
    -- Прыжки по пометкам в текущем файле — рядом с ]d и ]h
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Следующая пометка TODO",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Предыдущая пометка TODO",
    },
    -- Поиск по проекту тем же fzf-lua, что и остальные <leader>f
    { "<leader>ft", "<cmd>TodoFzfLua<CR>", desc = "Пометки TODO по проекту" },
  },
}
