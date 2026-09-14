return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false,                -- neo-tree will lazily load itself
        init = function()
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                },
            })
        end,
        opts = {
            close_if_last_window = false,
            enable_git_status = true,
            enable_diagnostics = true,
            window = {
                position = "left",
                width = 35,
                popup = {
                    size = {
                        height = "80%",
                        width = "60%",
                    },
                    position = "50%",
                },
            },
            filesystem = {
                hijack_netrw_behavior = "open_default",
                window = {
                    mappings = {
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["<Right>"] = "open",
                        ["<Left>"] = "close_node",
                    },
                },
            },
        },
    }
}
