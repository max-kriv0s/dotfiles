-- Автозакрытие скобок и кавычек.
-- Связка с автодополнением не нужна: blink сам следит за скобками
-- при подстановке функций.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- решение принимается по дереву кода, а не по тексту
    ts_config = {
      -- Внутри этих узлов пары не ставятся: в строках кавычка чаще
      -- закрывает уже открытую, а не начинает новую
      lua = { "string" },
      javascript = { "template_string" },
      typescript = { "template_string" },
      tsx = { "template_string" },
    },
  },
}
