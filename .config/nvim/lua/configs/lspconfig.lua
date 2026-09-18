require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("jdtls", {
  settings = {
    java = {
      format = { enabled = false },
    },
  },
})

vim.lsp.enable {
  "html",
  "cssls",
  "ty",
  "jdtls",
  "svelte",
  "bashls",
  "kotlin_lsp",
}
