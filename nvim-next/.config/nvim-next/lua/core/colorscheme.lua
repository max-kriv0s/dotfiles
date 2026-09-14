-- Выбор темы.
--
-- Источник истины — симлинк ~/.config/theme/current, который переставляет
-- scripts/theme/change-theme. Имя colorscheme лежит в самой теме, в файле
-- themes/<тема>/nvim — маппинга "тема -> colorscheme" здесь нет намеренно.
--
-- О смене темы nvim узнаёт по сигналу SIGUSR1 от того же скрипта.
-- Опрос по FocusGained не используем: он срабатывал на каждое переключение
-- окна терминала и давал мигание.

local M = {}

local link = vim.fn.expand("~/.config/theme/current")

-- Имя colorscheme из текущей темы или nil
function M.name()
  local file = link .. "/nvim"

  if vim.fn.filereadable(file) ~= 1 then
    return nil
  end

  local value = vim.fn.trim(vim.fn.readfile(file)[1] or "")

  return value ~= "" and value or nil
end

-- Применить тему, если она изменилась
function M.apply()
  local name = M.name()

  if not name or name == vim.g.colors_name then
    return
  end

  if not pcall(vim.cmd.colorscheme, name) then
    vim.notify("Тема недоступна: " .. name, vim.log.levels.WARN)
  end
end

-- Применить текущую тему и подписаться на сигнал о смене
function M.setup()
  M.apply()

  vim.api.nvim_create_autocmd("Signal", {
    group = vim.api.nvim_create_augroup("user_colorscheme", { clear = true }),
    pattern = "SIGUSR1",
    callback = M.apply,
  })
end

return M
