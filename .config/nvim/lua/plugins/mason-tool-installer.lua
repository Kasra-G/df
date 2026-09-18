return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "autoflake",
        "jdtls",
        "ty",
        "isort",
        "black",
        "prettier",
        "fixjson",
        "yamlfix",
        "kotlin-lsp",
        "bash-language-server",
        "stylua",
        "lua-language-server",
      },
      auto_update = false,
    },
  },
}
