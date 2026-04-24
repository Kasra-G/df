local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    java = {},
    css = { "prettier" },
    html = { "prettier" },
    json = { "fixjson" },
    yaml = { "yamlfix" },
    python = { "autoflake", "black", "isort" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    javascript = { "prettier" },
  },

  formatters = {
    autoflake = {
      prepend_args = { "--in-place", "--remove-all-unused-imports" },
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
