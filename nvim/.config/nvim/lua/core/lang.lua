-- Поддержка русской раскладки.
--
-- Работает в двух местах и по двум разным причинам:
--
-- 1. `langmap` — встроенный механизм vim. Переводит нажатую клавишу для
--    ВСТРОЕННЫХ команд: в русской раскладке "ц" работает как "w".
--    На маппинги не распространяется: маппинги проверяются раньше langmap.
--
-- 2. `M.map` — обёртка над vim.keymap.set. Для каждого маппинга дополнительно
--    регистрирует его кириллический вариант, чтобы `<leader>sv` работал и как
--    `<leader>ым`. Без этого все <leader>-команды в русской раскладке мертвы.

local M = {}

-- Раскладки macOS и Linux/Windows отличаются: на Linux доступны ещё
-- ё/х/ъ/э. Наборы английских и русских символов обязаны быть одной длины —
-- иначе langmap молча работает неправильно.
local layouts = {
  macos = {
    lower_en = "qwertyuiopasdfghjkl;zxcvbnm",
    lower_ru = "йцукенгшщзфывапролджячсмить",
    upper_en = "QWERTYUIOPASDFGHJKL:ZXCVBNM",
    upper_ru = "ЙЦУКЕНГШЩЗФЫВАПРОЛДЖЯЧСМИТЬ",
  },
  other = {
    lower_en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]],
    lower_ru = "ёйцукенгшщзхъфывапролджэячсмить",
    upper_en = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM]],
    upper_ru = "ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬ",
  },
}

local layout = vim.uv.os_uname().sysname == "Darwin" and layouts.macos or layouts.other

-- Разбить строку на символы с учётом UTF-8: кириллица многобайтовая
local function chars(str)
  return vim.fn.split(str, "\\zs")
end

-- Таблица "английский символ -> русский символ"
local en_to_ru = {}

local function fill(en, ru)
  local en_chars = chars(en)
  local ru_chars = chars(ru)

  if #en_chars ~= #ru_chars then
    error(("core.lang: наборы разной длины — %d англ. и %d рус."):format(#en_chars, #ru_chars))
  end

  for i, char in ipairs(en_chars) do
    en_to_ru[char] = ru_chars[i]
  end
end

fill(layout.lower_en, layout.lower_ru)
fill(layout.upper_en, layout.upper_ru)

-- Значение для vim.opt.langmap
local function langmap_pair(from, to)
  return from .. ";" .. vim.fn.escape(to, [[;,."|\\]])
end

M.langmap = table.concat({
  langmap_pair(layout.lower_ru, layout.lower_en),
  langmap_pair(layout.upper_ru, layout.upper_en),
}, ",")

-- Перевести левую часть маппинга в кириллицу.
-- Спецклавиши в угловых скобках (<leader>, <C-h>, <Tab>) остаются как есть.
local function to_ru(lhs)
  local result = {}
  local i = 1

  while i <= #lhs do
    local char = lhs:sub(i, i)

    if char == "<" then
      local close = lhs:find(">", i, true)

      if close then
        table.insert(result, lhs:sub(i, close))
        i = close + 1
      else
        table.insert(result, char)
        i = i + 1
      end
    else
      table.insert(result, en_to_ru[char] or char)
      i = i + 1
    end
  end

  return table.concat(result)
end

-- Замена vim.keymap.set: ставит маппинг и его кириллический дубль
function M.map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)

  local ru_lhs = to_ru(lhs)

  if ru_lhs ~= lhs then
    vim.keymap.set(mode, ru_lhs, rhs, opts)
  end
end

return M
