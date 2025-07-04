return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      sort = {
        sorter = "case_sensitive",
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        custom = { "node_modules", ".git" },
      },
    },
  },
}
