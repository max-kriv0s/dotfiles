-- Полноценный git-клиент в плавающем окне. Сам lazygit ставится через brew,
-- плагин только открывает его поверх nvim и подхватывает текущий репозиторий.
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>lg", "<cmd>LazyGit<CR>", desc = "Открыть lazygit" },
  },
}
