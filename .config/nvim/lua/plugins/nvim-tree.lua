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
      git = {
        timeout = 1000,
      },
      filters = {
        -- dotfiles = false,
        -- git_clean = false,
        -- no_buffer = false,
        custom = { "node_modules", "\\.git" },
      },
    },
  },
}
