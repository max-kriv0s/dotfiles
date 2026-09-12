return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            local bufferline = require("bufferline")

            bufferline.setup({
                options = {
                    mode = "buffers",
                    numbers = "none",
                    color_icons = false,
                    indicator = {
                        style = "none",
                    },
                    modified_icon = "●",
                    left_trunc_marker = "",
                    right_trunc_marker = "",
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local s = " "
                        for e, _ in pairs(diagnostics_dict) do
                            local sym = e == "error" and " " or (e == "warning" and " " or " ")
                            s = s .. sym
                        end
                        return s
                    end,
                    always_show_bufferline = true,
                    custom_filter = function(bufnr, bufnums)
                        local is_first = bufnr == bufnums[1]
                        local has_other_buffers = #bufnums > 1
                        local is_no_name = vim.api.nvim_buf_get_name(bufnr) == ""
                        local is_unmodified = not vim.api.nvim_get_option_value("modified", { buf = bufnr })
                        local is_normal = vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
                        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                        local is_empty = #lines == 1 and lines[1] == ""

                        return not (is_first and has_other_buffers and is_no_name and is_unmodified and is_normal and is_empty)
                    end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Neo-tree",
                            highlight = "Directory",
                            text_align = "left",
                        },
                    },
                },
            })
        end,
    }
}
