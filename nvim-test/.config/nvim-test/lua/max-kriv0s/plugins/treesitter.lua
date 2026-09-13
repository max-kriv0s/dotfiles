return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local parsers = {
      "bash",
      "css",
      "diff",
      "dockerfile",
      "git_config",
      "git_rebase",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "graphql",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "prisma",
      "python",
      "query",
      "regex",
      "scss",
      "sql",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "xcompose",
      "yaml",
    }

    vim.filetype.add({
      filename = {
        ["compose.yaml"] = "xcompose",
        ["compose.yml"] = "xcompose",
        ["docker-compose.yaml"] = "xcompose",
        ["docker-compose.yml"] = "xcompose",
      },
    })

    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require("nvim-ts-autotag").setup()
  end,
}
