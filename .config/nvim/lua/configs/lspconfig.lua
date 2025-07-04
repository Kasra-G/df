require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",
        autoSearchPath = true,
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
  },
})

local servers = {
  "html",
  "cssls",
  "basedpyright",
  "ts_ls",
  "svelte",
  "bashls",
  "kotlin_lsp",
  -- "systemd_ls",
  "awk_ls",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
