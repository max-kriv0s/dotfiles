return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",

        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    end

                    if term.direction == "vertical" then
                        return math.floor(vim.o.columns * 0.4)
                    end
                end,
                persist_size = true, -- ВАЖНО: запоминать вручную измененный размер terminal split в текущей сессии
                direction = "horizontal",
                open_mapping = [[<c-\>]], -- Ctrl+\ — открыть/скрыть toggleterm
            })

            vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle float terminal", silent = true }) -- Space+t f — открыть/скрыть плавающий терминал
            vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal", silent = true }) -- Space+t h — открыть/скрыть горизонтальный терминал на 15 строк
            vim.keymap.set("n", "<leader>tv", function()
                vim.cmd("ToggleTerm direction=vertical size=" .. math.floor(vim.o.columns * 0.4))
            end, { desc = "Toggle vertical terminal", silent = true }) -- Space+t v — открыть/скрыть вертикальный терминал на 40% ширины
            vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=tab<CR>", { desc = "Toggle tab terminal", silent = true }) -- Space+t t — открыть/скрыть терминал в отдельной вкладке
            vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<CR>", { desc = "Toggle terminal 1", silent = true }) -- Space+t 1 — открыть/скрыть терминал N1
            vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<CR>", { desc = "Toggle terminal 2", silent = true }) -- Space+t 2 — открыть/скрыть терминал N2
            vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<CR>", { desc = "Toggle terminal 3", silent = true }) -- Space+t 3 — открыть/скрыть терминал N3

            local function set_terminal_keymaps()
                local opts = { buffer = 0, silent = true }
                vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts) -- Esc — выйти из Terminal в Normal
                vim.keymap.set('t', 'jj', [[<C-\><C-n>]], opts) -- jj — выйти из Terminal в Normal
                vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts) -- Ctrl+h — перейти в левое окно
                vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts) -- Ctrl+j — перейти в нижнее окно
                vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts) -- Ctrl+k — перейти в верхнее окно
                vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts) -- Ctrl+l — перейти в правое окно
                vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts) -- Ctrl+w — выйти в Normal и начать оконную команду
            end

            vim.api.nvim_create_autocmd("TermOpen", {
                pattern = "term://*",
                callback = set_terminal_keymaps,
            })
        end,
    },
}
