-- Line Numbers
vim.opt.number = true         -- номера строк
vim.opt.relativenumber = true -- относительные номера строк

-- Mouse
vim.opt.mouse = "a" -- мышь
vim.opt.mousefocus = true

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- системный буфер обмена

-- Indent Settings
vim.opt.shiftwidth = 2     -- отступ
vim.opt.tabstop = 2        -- размер таба
vim.opt.softtabstop = 2
vim.opt.expandtab = true   -- табы как пробелы
vim.opt.autoindent = true  -- сохранять отступ на новой строке
vim.opt.smartindent = true -- умный отступ

-- Search
vim.opt.ignorecase = true -- поиск без учёта регистра
vim.opt.smartcase = true  -- но с учётом если есть заглавные

-- Wrap
vim.opt.wrap = false       -- переносить строки
vim.opt.linebreak = true   -- переносить по границам слов
vim.opt.breakindent = true -- сохранять отступ у перенесённых строк

-- Splits
vim.opt.splitbelow = true -- горизонтальный split открывается снизу
vim.opt.splitright = true -- вертикальный split открывается справа

-- Cursor
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50" -- блок везде

-- Files
vim.opt.swapfile = false -- отключить swap файлы

-- Other
vim.opt.scrolloff = 8        -- отступ при прокрутке
vim.opt.showmode = false     -- режим показывает lualine
vim.opt.termguicolors = true -- true color

-- Fillchars
vim.opt.fillchars = {
    vert = "│",
    fold = "⠀",
    eob = " ", -- suppress ~ at EndOfBuffer
    -- diff = "⣿", -- alternatives = ⣿ ░ ─ ╱
    msgsep = "‾",
    foldopen = "▾",
    foldsep = "│",
    foldclose = "▸",
}
