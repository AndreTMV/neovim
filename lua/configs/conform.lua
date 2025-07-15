local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "autopep8", "djlint" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    css = { "prettier" },
    html = { "prettier" },
    dart = { "dart_format" },
    javascript = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
