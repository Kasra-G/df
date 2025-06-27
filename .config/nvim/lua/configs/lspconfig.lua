require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("jedi_language_server", {
  settings = {
    initializationOptions = {
      semanticTokens = {
        enable = true,
      },
    },
  },
})

local servers = {
  "html",
  "cssls",
  "jedi_language_server",
  "ts_ls",
  "svelte",
  "bashls",
  "systemd_ls",
  "awk_ls",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
