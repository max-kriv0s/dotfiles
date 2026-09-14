local opt = vim.opt

-- Номера строк
opt.number = true -- абсолютный номер текущей строки
opt.relativenumber = true -- относительные номера остальных строк

-- Отступы
opt.tabstop = 2 -- ширина таба
opt.shiftwidth = 2 -- ширина сдвига при >> и <<
opt.softtabstop = 2 -- сколько пробелов вставляет Tab
opt.expandtab = true -- Tab вставляет пробелы (для go и make отключается в autocmds.lua)
opt.autoindent = true -- сохранять отступ на новой строке
opt.smartindent = true -- умный отступ по синтаксису

-- Поиск
opt.ignorecase = true -- игнорировать регистр
opt.smartcase = true -- но учитывать, если в запросе есть заглавные

-- Перенос строк
opt.wrap = true -- переносить длинные строки, чтобы экран не ездил вбок
opt.linebreak = true -- переносить по границам слов, а не посреди слова
opt.breakindent = true -- сохранять отступ у перенесённых строк

-- Split-окна
opt.splitbelow = true -- горизонтальный split открывается снизу
opt.splitright = true -- вертикальный split открывается справа

-- Внешний вид
opt.termguicolors = true -- true color
opt.cursorline = true -- подсветка текущей строки
opt.signcolumn = "yes" -- колонка знаков всегда видна, текст не прыгает
opt.scrolloff = 8 -- минимум строк до края при прокрутке
opt.showmode = false -- режим показывает lualine
opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50" -- курсор-блок

opt.fillchars = {
  vert = "│",
  fold = "⠀",
  eob = " ", -- убрать ~ после конца файла
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}

-- Буфер обмена и мышь
opt.clipboard = "unnamedplus" -- y и p работают с системным буфером
opt.mouse = "a"
opt.mousefocus = true

-- Файлы и история
opt.swapfile = false -- без swap-файлов
opt.backup = false -- без backup-файлов, история отмен живёт только пока открыт редактор

-- Отзывчивость
opt.updatetime = 250 -- задержка перед CursorHold (диагностики, gitsigns)
-- Сколько ждать следующую клавишу в комбинации.
-- Если не дождаться — набранное выполнится как обычные команды:
-- <leader>s превратится в "сдвиг вправо" + "substitute" и съест символ.
-- Скорость всплытия подсказок задаётся отдельно, параметром delay в which-key.
opt.timeoutlen = 1500

-- Разное
opt.backspace = "indent,eol,start" -- backspace работает везде
opt.confirm = true -- вместо ошибки о несохранённом файле — вопрос

-- Провайдеры — мосты для старых vim-плагинов на этих языках.
-- Ни один наш плагин их не использует, отключаем, чтобы не мешали в :checkhealth.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Русская раскладка: команды Normal-режима работают, не переключая язык.
-- Пример: в русской раскладке "ц" работает как "w", "ф" как "a".
-- Таблица раскладок и обёртка для маппингов — в core/lang.lua
opt.langmap = require("core.lang").langmap
