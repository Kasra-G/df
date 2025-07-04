return {
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "duane9/nvim-rg",
  },
  {
    "nvim-lua/plenary.nvim",
    rm_default_ops = true,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },
}
