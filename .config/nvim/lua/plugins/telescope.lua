return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    lazy = false,

    opts = {
      extensions_list = { "themes", "terms", "live_grep_args" },
      extensions = {},
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
        },
      },
    },
  },
}
