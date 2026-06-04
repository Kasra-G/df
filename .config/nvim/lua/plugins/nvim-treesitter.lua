return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
  },
  {
    "themixednuts/nvim-treesitter-svelte",
    main = "nvim-treesitter-svelte",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      detect_filetypes = false,
    },
  },
}
