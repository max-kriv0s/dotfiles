return {
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "pyright",
                "gopls",
                "ts_ls",
            },
            automatic_enable = true,
        },
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
    }
}
