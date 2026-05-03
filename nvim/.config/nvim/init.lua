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

-- Курсор блок в insert режиме
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50"

-- Тема
-- Устанавливается через плагин, пока используем встроенную тёмную
vim.cmd.colorscheme("habamax")

-- Клавиши
vim.g.mapleader = " "           -- leader клавиша — пробел

-- Нормальная вставка в insert режиме
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from clipboard" })

-- Сохранить
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })

-- Выйти
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Перемещение между панелями
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top pane" })
