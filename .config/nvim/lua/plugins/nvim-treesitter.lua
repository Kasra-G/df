return {
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      auto_install = true, -- Automatically installs the parser when you open a file
    },
    cmd = { "TSManager" },
  },
}
