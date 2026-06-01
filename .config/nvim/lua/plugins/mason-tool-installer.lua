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
        "typescript-language-server",
        "fixjson",
        "yamlfix",
        "kotlin-lsp",
        -- "gradle-language-server",
        "bash-language-server",
        "stylua",
        "lua-language-server",
      },
      auto_update = true,
    },
  },
}
