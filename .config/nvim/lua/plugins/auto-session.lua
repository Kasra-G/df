return {
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      pre_save_cmds = {
        "NvimTreeClose",
      },
      post_restore_cmds = {},
      -- log_level = 'debug',
    },
  },
}
