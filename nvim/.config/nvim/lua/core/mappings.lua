-- Leader
vim.g.mapleader = " " -- leader клавиша — пробел (Space)
-- vim.o.timeoutlen = 1500 -- ВАЖНО: время в миллисекундах между клавишами маппинга; раскомментируй и подбери значение, если нужно больше времени между клавишами

-- Insert
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" }) -- jj — выход из insert ружима аналогично esc

-- Buffers
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save", silent = true }) -- Space+w — сохранить файл
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit", silent = true }) -- Space+q — выйти
vim.keymap.set("i", "<D-v>", "<C-r>+", { desc = "Paste from clipboard" }) -- Cmd+V — вставить из системного буфера

-- Neo-tree
vim.keymap.set("n", "<leader>e", "<cmd>Neotree left toggle reveal<CR>", { desc = "Open neotree to left", silent = true }) -- Space+e — открыть дерево файлов слева
-- vim.keymap.set("n", "<leader>e", "<cmd>Neotree float toggle reveal<CR>", { desc = "Open neotree in float", silent = true }) -- Space+e — открыть дерево файлов в отдельном окне


-- Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top pane" })

-- Splits
vim.keymap.set("n", "|", "<cmd>vsplit<CR>", { desc = "Vertical split", silent = true }) -- вертикальный сприт
vim.keymap.set("n", "\\", "<cmd>split<CR>", { desc = "Horizontal split", silent = true }) -- горизонтальный сприт

-- Tabs
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer", silent = true }) -- Tab — перейти к следующему буферу
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer", silent = true }) -- Shift+Tab — перейти к предыдущему буферу
-- vim.keymap.set("n", "<leader>x", "<cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close", silent = true }) -- Space+x — выбрать буфер для закрытия
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer", silent = true }) -- Space+x — закрыть текущий буфер
vim.keymap.set("n", "<C-x>", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers", silent = true }) -- Ctrl+x — закрыть остальные буферы
vim.keymap.set("n", "<leader><Tab>]", "<cmd>tabnext<CR>", { desc = "Next tab", silent = true }) -- Space+Tab ] — перейти к следующей вкладке Neovim
vim.keymap.set("n", "<leader><Tab>[", "<cmd>tabprevious<CR>", { desc = "Previous tab", silent = true }) -- Space+Tab [ — перейти к предыдущей вкладке Neovim
vim.keymap.set("n", "<leader><Tab><Tab>", "<cmd>tabnew<CR>", { desc = "New tab", silent = true }) -- Space+Tab Tab — создать новую вкладку Neovim
vim.keymap.set("n", "<leader><Tab>d", "<cmd>tabclose<CR>", { desc = "Close tab", silent = true }) -- Space+Tab d — закрыть текущую вкладку Neovim
vim.keymap.set("n", "<leader><Tab>o", "<cmd>tabonly<CR>", { desc = "Close other tabs", silent = true }) -- Space+Tab o — закрыть остальные вкладки Neovim
vim.keymap.set("n", "<leader><Tab>f", "<cmd>tabfirst<CR>", { desc = "First tab", silent = true }) -- Space+Tab f — перейти к первой вкладке Neovim
vim.keymap.set("n", "<leader><Tab>l", "<cmd>tablast<CR>", { desc = "Last tab", silent = true }) -- Space+Tab l — перейти к последней вкладке Neovim
