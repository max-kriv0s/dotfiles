-- Go: delve. Плагин сам добавляет конфигурации запуска и умеет отлаживать
-- один тест под курсором, чего голый nvim-dap не делает.
return {
  "leoluz/nvim-dap-go",
  ft = "go",
  dependencies = { "mfussenegger/nvim-dap" },
  keys = {
    {
      "<leader>dt",
      function()
        require("dap-go").debug_test()
      end,
      ft = "go",
      desc = "Отладить тест под курсором",
    },
  },
  config = function()
    require("dap-go").setup()
  end,
}
