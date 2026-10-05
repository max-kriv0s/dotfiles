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

-- То же для стрелок: без этого они прыгают через всю перенесённую строку
map({ "n", "v" }, "<Down>", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, desc = "Вниз по экранной строке" })
map({ "n", "v" }, "<Up>", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, desc = "Вверх по экранной строке" })

-- В Insert счётчика нет, поэтому просто gj / gk одной командой Normal
map("i", "<Down>", "<C-o>gj", { desc = "Вниз по экранной строке" })
map("i", "<Up>", "<C-o>gk", { desc = "Вверх по экранной строке" })

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

-- Запуск текущего файла без отладчика. Отладка — на F4, см. plugins/dap.lua.
local runners = {
  go = "go run",
  python = "python3",
  javascript = "node",
  typescript = "tsx",
  sh = "bash",
  lua = "lua",
}

map("n", "<F5>", function()
  -- Во время отладки F5 продолжает выполнение, как в VS Code. Смотрим
  -- package.loaded, чтобы не тянуть dap в память ради обычного запуска.
  local dap = package.loaded.dap

  if dap and dap.session() then
    dap.continue()
    return
  end

  -- Программа могла завершиться, а панели остаться открытыми. Пока они на
  -- экране, отладка считается незаконченной: результат уже виден внизу,
  -- и запускать файл заново незачем.
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local filetype = vim.bo[vim.api.nvim_win_get_buf(win)].filetype

    if filetype:match("^dapui_") or filetype == "dap-repl" then
      vim.notify("Панели отладки открыты, закрыть — <leader>dx", vim.log.levels.INFO)
      return
    end
  end

  local runner = runners[vim.bo.filetype]

  if not runner then
    vim.notify("Нечем запускать файлы типа " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  -- Путь запоминаем до открытия терминала: open() делает текущим буфером
  -- терминал, и "%" после него указывает уже на него, а не на файл.
  local path = vim.fn.expand("%:p")

  -- После отладки курсор нередко остаётся в чужом файле — в исходниках
  -- стандартной библиотеки, куда зашёл отладчик. Запускать их бессмысленно.
  if path == "" or not vim.startswith(path, vim.uv.cwd()) then
    vim.notify("Файл вне текущего каталога, запускать нечего", vim.log.levels.WARN)
    return
  end

  -- Запускаем то, что на диске, а не то, что в буфере
  vim.cmd("write")

  local file = vim.fn.shellescape(path)

  -- Берём тот же объект терминала, который открывает Ctrl+\, и отправляем
  -- команду в него, а не через toggleterm.exec: exec заводит свою запись.
  local term = require("toggleterm.terminal").get_or_create_term(1)

  if not term:is_open() then
    term:open()
  end

  term:send(runner .. " " .. file, false)
end, { desc = "Запустить файл, в отладке — продолжить" })
