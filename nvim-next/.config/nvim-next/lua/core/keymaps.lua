-- Leader должен быть задан до того, как плагины зарегистрируют свои маппинги
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Обёртка, которая дополнительно регистрирует кириллический вариант маппинга
local map = require("core.lang").map

-- Выход из Insert.
-- Только jj: jk в кириллице превращается в "ол", а это сочетание есть
-- в обычных словах — "около", "сколько", "долго" — и выбрасывало бы
-- из режима вставки посреди набора.
map("i", "jj", "<Esc>", { desc = "Выйти из Insert" })

-- Движение по экранным строкам, когда строка перенесена.
-- С счётчиком (5j) работает по строкам файла, чтобы относительные номера не сломались.
map({ "n", "v" }, "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, desc = "Вниз по экранной строке" })
map({ "n", "v" }, "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, desc = "Вверх по экранной строке" })

-- Поиск
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })

-- Числа под курсором
map("n", "<leader>+", "<C-a>", { desc = "Увеличить число" })
map("n", "<leader>-", "<C-x>", { desc = "Уменьшить число" })

-- Отступы в Visual: не терять выделение после сдвига
map("v", "<", "<gv", { desc = "Сдвинуть влево" })
map("v", ">", ">gv", { desc = "Сдвинуть вправо" })

-- Переход между окнами (позже это перехватит vim-tmux-navigator)
map("n", "<C-h>", "<C-w>h", { desc = "Окно слева" })
map("n", "<C-j>", "<C-w>j", { desc = "Окно снизу" })
map("n", "<C-k>", "<C-w>k", { desc = "Окно сверху" })
map("n", "<C-l>", "<C-w>l", { desc = "Окно справа" })

-- Splits — области экрана
map("n", "<leader>sv", "<C-w>v", { desc = "Split вертикально" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split горизонтально" })
map("n", "<leader>se", "<C-w>=", { desc = "Уравнять размеры split" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Закрыть текущий split" })

-- Развернуть текущее окно на весь экран и вернуть обратно.
-- Логика взята из плагина szw/vim-maximizer: winrestcmd() отдаёт строку
-- команд, восстанавливающую размеры всех окон точно как было, поэтому
-- возврат не «уравнивает», а именно возвращает прежнюю раскладку.
-- Состояние хранится в переменной вкладки — на каждой вкладке своё.
map("n", "<leader>sm", function()
  if vim.t.maximized then
    vim.cmd(vim.t.maximized)
    vim.t.maximized = nil
  elseif vim.fn.winnr("$") > 1 then
    vim.t.maximized = vim.fn.winrestcmd()
    vim.cmd("vertical resize")
    vim.cmd("resize")
  end
end, { desc = "Развернуть/вернуть окно" })

-- Tabs — раскладки окон
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Новая вкладка" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Закрыть вкладку" })
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Следующая вкладка" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Предыдущая вкладка" })
-- tb, а не tf: tf отдан плавающему терминалу, как было в сборке A
map("n", "<leader>tb", "<cmd>tabnew %<CR>", { desc = "Текущий буфер в новой вкладке" })

-- Buffers — вся группа <leader>b и переключение Tab / Shift+Tab
-- заданы в plugins/bufferline.lua, рядом с самой полосой буферов.

-- Переключатели
map("n", "<leader>uw", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, { desc = "Перенос длинных строк" })
map("n", "<leader>un", function()
  vim.opt_local.relativenumber = not vim.opt_local.relativenumber:get()
end, { desc = "Относительные номера строк" })
