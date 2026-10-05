local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Подсветить скопированный фрагмент
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Вернуть курсор на место, где он был при прошлом открытии файла
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Go и Makefile требуют настоящих табов, а не пробелов
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("hard_tabs"),
  pattern = { "go", "make" },
  callback = function()
    vim.bo.expandtab = false
  end,
})

-- В терминале номера строк не нужны
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Пустой безымянный буфер создаётся при старте nvim и при каждом :tabnew,
-- а после закрытия вкладки остаётся в списке и мешает при переключении.
-- Удаляем такие буферы, если они не показаны ни в одном окне.
vim.api.nvim_create_autocmd({ "TabClosed", "BufEnter" }, {
  group = augroup("wipe_empty_buffers"),
  callback = function()
    -- Во время восстановления сессии не вмешиваться: файл сессии сам
    -- распоряжается буферами, и если удалить буфер раньше него, восстановление
    -- падает с E517. vim.g.SessionLoad выставляется на время загрузки.
    if vim.g.SessionLoad == 1 then
      return
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local is_candidate = vim.api.nvim_buf_is_loaded(buf)
        and vim.api.nvim_buf_get_name(buf) == ""
        and vim.bo[buf].buftype == ""
        and not vim.bo[buf].modified
        and vim.fn.bufwinid(buf) == -1 -- не показан ни в одном окне

      if is_candidate then
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

        if #lines == 1 and lines[1] == "" then
          pcall(vim.api.nvim_buf_delete, buf, {})
        end
      end
    end
  end,
})

-- Время ожидания следующей клавиши в комбинации разное по режимам.
--
-- В обычном режиме нужно много: успеть набрать <leader>tp и подобное.
-- В режиме вставки — мало: там после "j" или "о" (это тот же "j" в другой
-- раскладке) nvim ждёт, не будет ли второй такой же буквы для выхода jj,
-- и набранный символ всё это время висит ненапечатанным.
--
-- Значение для обычного режима берётся из core/options.lua, менять там.
-- Здесь подбирается только время для режима вставки: уменьшить, если в
-- тексте заметна задержка после "о" и "j".
local timeout_normal = vim.o.timeoutlen
local timeout_insert = 250

local timeout_group = augroup("timeoutlen")

vim.api.nvim_create_autocmd("InsertEnter", {
  group = timeout_group,
  callback = function()
    vim.o.timeoutlen = timeout_insert
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = timeout_group,
  callback = function()
    vim.o.timeoutlen = timeout_normal
  end,
})

-- При изменении размера окна терминала уравнять split-ы
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- При переходе в другое приложение сохранить изменённые файлы
vim.api.nvim_create_autocmd("FocusLost", {
  group = augroup("autosave"),
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf)
        and vim.api.nvim_buf_get_name(buf) ~= ""
        and vim.bo[buf].buftype == ""
        and vim.bo[buf].modified
        and vim.bo[buf].modifiable
        and not vim.bo[buf].readonly
      then
        local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
          vim.cmd("update")
        end)

        if not ok then
          vim.notify("Автосохранение: " .. tostring(err), vim.log.levels.ERROR)
        end
      end
    end
  end,
})
