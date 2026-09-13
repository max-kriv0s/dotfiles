return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				bash = { "shfmt" },
				css = { "prettier" },
				dockerfile = { "dockerfmt" },
				go = { "goimports", "gofmt" },
				graphql = { "prettier" },
				html = { "prettier" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				typescriptreact = { "prettier" },
				typescript = { "prettier" },
				vue = { "prettier" },
				scss = { "prettier" },
				yaml = { "prettier" },
				xcompose = { "prettier" },
				toml = { "taplo" },
				terraform = { "terraform_fmt" },
				sh = { "shfmt" },
				sql = { "sql_formatter" },
				python = { "isort", "black" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
