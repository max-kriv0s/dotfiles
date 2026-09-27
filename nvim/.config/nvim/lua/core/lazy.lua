-- Установка lazy.nvim при первом запуске
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Не удалось склонировать lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nНажмите любую клавишу для выхода..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Подкаталоги импортируются отдельными строками: lazy берёт только
    -- верхний уровень каталога plugins
    { import = "plugins" },
    { import = "plugins.themes" },
    { import = "plugins.lsp" },
  },
  checker = {
    enabled = true, -- проверять обновления плагинов
    notify = false, -- но не показывать всплывающие уведомления
  },
  change_detection = {
    notify = false, -- не сообщать о правках конфига
  },
  rocks = {
    enabled = false, -- luarocks не нужен ни одному нашему плагину
  },
  performance = {
    rtp = {
      -- lazy пересобирает runtimepath с нуля и выбрасывает каталог site,
      -- куда nvim-treesitter (ветка main) ставит парсеры. Возвращаем явно.
      paths = { vim.fn.stdpath("data") .. "/site" },
      -- отключить неиспользуемые встроенные vim-плагины
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "zipPlugin", "tutor" },
    },
  },
})

-- Тема применяется после загрузки плагинов, когда colorscheme уже доступны
require("core.colorscheme").setup()
