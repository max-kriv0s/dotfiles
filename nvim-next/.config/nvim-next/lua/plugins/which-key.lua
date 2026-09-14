-- Подсказка по сочетаниям клавиш.
-- Всплывает через delay после нажатия leader. Это отдельный параметр,
-- не связанный с timeoutlen: подсказка появляется быстро, а времени
-- на набор комбинации остаётся полторы секунды.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    -- Кириллические дубли маппингов (см. core/lang.lua) нужны для работы
    -- в русской раскладке, но в подсказках они только удваивают список
    filter = function(mapping)
      return mapping.lhs:match("[\128-\255]") == nil
    end,
    spec = {
      { "<leader>b", group = "Буферы" },
      { "<leader>s", group = "Split-окна" },
      { "<leader>t", group = "Вкладки" },
      { "<leader>u", group = "Переключатели" },
      { "]", group = "Следующий" },
      { "[", group = "Предыдущий" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Сочетания клавиш этого буфера",
    },
  },
}
