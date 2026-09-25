-- Python: линтер и форматтер.
-- Hover отключён, чтобы K показывал документацию от basedpyright,
-- а не пустую подсказку от ruff — иначе два сервера спорят за K.
return {
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
