-- Python: debugpy. Путь указываем на venv самого mason, иначе плагин ищет
-- debugpy в интерпретаторе проекта, где его обычно нет.
return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = { "mfussenegger/nvim-dap" },
  keys = {
    {
      "<leader>dt",
      function()
        require("dap-python").test_method()
      end,
      ft = "python",
      desc = "Отладить тест под курсором",
    },
  },
  config = function()
    require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
  end,
}
