require("nvchad.configs.lspconfig").defaults()

-- vim.lsp.config("ty", {
--   settings = {
--     ty = {
--       analysis = {
--         useLibraryCodeForTypes = true,
--         typeCheckingMode = "basic",
--         diagnosticMode = "workspace",
--         autoSearchPath = true,
--         inlayHints = {
--           callArgumentNames = true,
--         },
--       },
--     },
--   },
-- })

vim.lsp.config("jdtls", {
  settings = {
    java = {
      format = { enabled = false },
    },
  },
})

local servers = {
  "html",
  "cssls",
  "ty",
  "jdtls",
  -- "ts_ls",
  -- "svelte",
  -- "typescript-tools",
  "bashls",
  "kotlin_lsp",
  -- "systemd_ls",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
