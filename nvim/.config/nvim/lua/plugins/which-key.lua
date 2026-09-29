-- Подсказка по сочетаниям клавиш.
-- Всплывает через delay после нажатия leader. Это отдельный параметр,
-- не связанный с timeoutlen: подсказка появляется быстро, а времени
-- на набор комбинации остаётся полторы секунды.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    -- Раскладка окна подсказки: classic, modern, helix.
    -- По умолчанию окно внизу во всю ширину — так принято, чтобы подсказка
    -- не закрывала код. Центрирования готовым пресетом нет, только вручную
    -- через win = { col = ..., row = ... }.
    preset = "classic",
    -- preset = "modern",
    -- preset = "helix",
    -- Кириллические дубли маппингов (см. core/lang.lua) нужны для работы
    -- в русской раскладке, но в подсказках они только удваивают список
    filter = function(mapping)
      return mapping.lhs:match("[\128-\255]") == nil
    end,
    win = {
      -- По умолчанию окно подсказки не перекрывает строку с курсором. Если
      -- курсор внизу экрана, подсказке остаётся пара строк и список уезжает
      -- в скролл. Разрешаем перекрывать: строку под курсором всё равно видно
      -- по номеру, а листать подсказку каждый раз неудобно.
      no_overlap = false,
      -- Сколько строк занимать. max поднят, чтобы весь список leader-клавиш
      -- помещался целиком.
      height = { min = 4, max = 30 },
    },
    spec = {
      { "<leader>b", group = "Буферы" },
      { "<leader>e", group = "Дерево файлов" },
      { "<leader>c", group = "Код" },
      { "<leader>d", group = "Отладка" },
      { "<leader>f", group = "Поиск" },
      { "<leader>h", group = "Git-изменения" },
      { "<leader>l", group = "Lazygit" },
      { "<leader>n", group = "Подсветка поиска" },
      { "<leader>r", group = "Рефакторинг" },
      { "<leader>s", group = "Split-окна" },
      { "<leader>t", group = "Вкладки и терминал" },
      { "<leader>u", group = "Переключатели" },
      { "<leader>w", group = "Сессии" },
      { "<leader>x", group = "Списки проблем" },
      { "]", group = "Следующий" },
      { "[", group = "Предыдущий" },

      -- В группе <leader>t соседствуют терминал и вкладки. Порядок строк
      -- which-key задаёт сам по букве клавиши, поэтому различаем их значком
      -- и цветом: терминал зелёный, вкладки синие.
      { "<leader>t1", icon = { icon = "󰆍", color = "green" } },
      { "<leader>t2", icon = { icon = "󰆍", color = "green" } },
      { "<leader>t3", icon = { icon = "󰆍", color = "green" } },
      { "<leader>tf", icon = { icon = "󰆍", color = "green" } },
      { "<leader>th", icon = { icon = "󰆍", color = "green" } },
      { "<leader>tv", icon = { icon = "󰆍", color = "green" } },
      { "<leader>tt", icon = { icon = "󰆍", color = "green" } },
      { "<leader>to", icon = { icon = "󰓩", color = "blue" } },
      { "<leader>tn", icon = { icon = "󰓩", color = "blue" } },
      { "<leader>tp", icon = { icon = "󰓩", color = "blue" } },
      { "<leader>tb", icon = { icon = "󰓩", color = "blue" } },
      { "<leader>tx", icon = { icon = "󰓩", color = "blue" } },

      -- Клавиши LSP буферные: они появляются только там, где подключился
      -- языковой сервер, и вне такого буфера в подсказке не видны.
      -- Записи ниже ничего не выполняют, только показывают их в общем списке;
      -- сами маппинги заданы в lua/plugins/lsp/lspconfig.lua.
      { "gd", desc = "Перейти к определению" },
      { "gD", desc = "Перейти к объявлению" },
      { "gi", desc = "Перейти к реализации" },
      { "gt", desc = "Перейти к типу" },
      { "gR", desc = "Показать использования" },
      { "<leader>ca", desc = "Быстрое исправление" },
      { "<leader>cd", desc = "Ошибка текущей строки" },
      { "<leader>cD", desc = "Все ошибки файла" },
      { "<leader>cg", desc = "Перейти к определению" },
      { "<leader>ci", desc = "Перейти к реализации" },
      { "<leader>ct", desc = "Перейти к типу" },
      { "<leader>cu", desc = "Показать использования" },
      { "<leader>rn", desc = "Переименовать символ" },
      { "<leader>rs", desc = "Перезапустить языковой сервер" },
      { "<leader>uh", desc = "Типы и имена аргументов прямо в коде" },
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
