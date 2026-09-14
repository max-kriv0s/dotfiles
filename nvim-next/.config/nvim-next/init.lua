-- Точка входа. Порядок важен:
-- options -> keymaps -> autocmds -> lazy (плагины)
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.lazy")
