return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup()

            treesitter.install({
                "go",
                "lua",
                "python",
                "typescript",
                "javascript",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "go",
                    "lua",
                    "python",
                    "typescript",
                    "javascript",
                },
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    }
}
