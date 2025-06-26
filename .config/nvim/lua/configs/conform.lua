local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "fixjson" },
    yaml = { "yamlfix" },
    python = { "autopep8" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    javascript = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
