-- Основные настройки
vim.opt.number = true           -- номера строк
vim.opt.relativenumber = true   -- относительные номера строк
vim.opt.mouse = "a"             -- мышь
vim.opt.clipboard = "unnamedplus" -- системный буфер обмена
vim.opt.wrap = false            -- не переносить строки
vim.opt.tabstop = 2             -- размер таба
vim.opt.shiftwidth = 2          -- отступ
vim.opt.expandtab = true        -- табы как пробелы
vim.opt.ignorecase = true       -- поиск без учёта регистра
vim.opt.smartcase = true        -- но с учётом если есть заглавные
vim.opt.termguicolors = true    -- true color
vim.opt.scrolloff = 7           -- отступ при прокрутке
vim.opt.swapfile = false        -- отключить swap файлы
vim.opt.splitbelow = true       -- горизонтальный split открывается снизу
vim.opt.splitright = true       -- вертикальный split открывается справа
vim.opt.autoindent = true       -- сохранять отступ на новой строке
vim.opt.smartindent = true      -- умный отступ

-- Курсор блок везде
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50"

-- Прозрачный фон — подхватывает тему терминала
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE
]])

-- Клавиши
vim.g.mapleader = " "           -- leader клавиша — пробел (Space)

-- Вставка из системного буфера (только macOS)
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from clipboard" })
-- <D-v> = Cmd+V, <C-r>+ = вставить из системного буфера в insert режиме

-- Сохранить / Выйти
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" }) -- Space+w — сохранить файл
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" }) -- Space+q — выйти

-- Перемещение между панелями (вместо Ctrl+W затем h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top pane" })
