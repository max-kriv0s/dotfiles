-- Leader
vim.g.mapleader = " " -- leader клавиша — пробел (Space)

-- Insert
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" }) -- jj — выход из insert ружима аналогично esc

-- Buffers
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" }) -- Space+w — сохранить файл
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" }) -- Space+q — выйти
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from clipboard" }) -- Cmd+V — вставить из системного буфера

-- Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top pane" })

-- Splits
vim.keymap.set("n", "|", ":vsplit<CR>", { desc = "Vertical split", silent = true }) -- вертикальный сприт
vim.keymap.set("n", "\\", ":split<CR>", { desc = "Horizontal split", silent = true }) -- горизонтальный сприт
