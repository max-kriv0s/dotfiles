-- Отладка. Адаптеры (delve, debugpy, js-debug-adapter) ставит mason-tool-installer,
-- см. lua/plugins/lsp/mason.lua. Языковые обвязки — в отдельных файлах dap-*.lua.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      -- F4 запускает отладку, F5 занят обычным запуском файла (core/keymaps.lua).
      -- dap.continue() при нескольких конфигурациях каждый раз спрашивает, какую
      -- запускать. Для обычного прогона это лишний шаг, поэтому F4 берёт первую
      -- конфигурацию текущего языка, а выбор вынесен на <leader>dc.
      {
        "<F4>",
        function()
          local dap = require("dap")

          if dap.session() then
            dap.continue()
            return
          end

          local configs = dap.configurations[vim.bo.filetype]

          if configs and configs[1] then
            dap.run(configs[1])
          else
            dap.continue()
          end
        end,
        desc = "Отладка: старт",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue({ new = true })
        end,
        desc = "Выбрать конфигурацию отладки",
      },
      -- Пауза останавливает программу там, где она сейчас: нужна, когда процесс
      -- не доходит до точки останова — завис, крутит цикл, ждёт запрос.
      { "<F6>", function() require("dap").pause() end, desc = "Отладка: пауза" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Отладка: точка останова" },
      { "<F10>", function() require("dap").step_over() end, desc = "Отладка: шаг через" },
      { "<F11>", function() require("dap").step_into() end, desc = "Отладка: шаг внутрь" },
      -- Shift+F11 доходит не из каждого терминала, поэтому есть дубль под leader
      { "<S-F11>", function() require("dap").step_out() end, desc = "Отладка: шаг наружу" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Шаг наружу" },
      {
        "<leader>db",
        function()
          require("dap").set_breakpoint(vim.fn.input("Условие остановки: "))
        end,
        desc = "Точка останова с условием",
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Панели отладки" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Консоль отладки" },
      -- Панели закрываем всегда: программа могла завершиться сама, и тогда
      -- завершать нечего, а окна остаются висеть.
      {
        "<leader>dx",
        function()
          local dap = require("dap")

          if dap.session() then
            dap.terminate()
          end

          require("dapui").close()
        end,
        desc = "Завершить отладку",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Раскладка панелей — штатная, как в документации dap-ui: слева
      -- переменные, точки останова, стек и watch, снизу консоль и repl.
      -- Своё только раскрытие веток на l и h, как в дереве файлов; обе
      -- клавиши переключают узел, отдельной команды "свернуть" здесь нет.
      dapui.setup({
        mappings = {
          expand = { "<CR>", "l", "h", "<2-LeftMouse>" },
        },
      })
      require("nvim-dap-virtual-text").setup({})

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

      -- Панели открываются со стартом сессии и закрываются вместе с ней.
      -- Обёртки обязательны: dap зовёт обработчик с аргументами сессии, а
      -- dap-ui принял бы их за свои опции и не отработал.
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
      end

      -- Единственное отличие от примеров в документации: автозакрытия по
      -- завершении программы нет. Вывод приходит в консоль отладчика внизу,
      -- и вместе с панелями исчезал бы результат. Закрываем по <leader>dx.

      -- Node и TypeScript. Плагина-обёртки нет намеренно: nvim-dap-vscode-js
      -- заброшен, а js-debug из mason подключается к dap напрямую.
      local js_debug = vim.fn.stdpath("data")
        .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug, "${port}" },
        },
      }

      local attach = {
        type = "pwa-node",
        request = "attach",
        name = "Подключиться к процессу",
        processId = function()
          return require("dap.utils").pick_process()
        end,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
      }

      for _, lang in ipairs({ "javascript", "javascriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Запустить файл",
            program = "${file}",
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**" },
          },
          attach,
        }
      end

      for _, lang in ipairs({ "typescript", "typescriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Запустить файл",
            program = "${file}",
            cwd = "${workspaceFolder}",
            -- tsx выполняет .ts без предварительной сборки
            runtimeArgs = { "--import", "tsx" },
            sourceMaps = true,
            skipFiles = { "<node_internals>/**" },
          },
          attach,
        }
      end
    end,
  },
}
