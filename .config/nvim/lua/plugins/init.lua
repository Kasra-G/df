return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "vim-crystal/vim-crystal",
    ft = "crystal",
    config = function(_)
      vim.g.crystal_auto_format = 1
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    lazy = false,
    config = function()
      local mc = require "multicursor-nvim"
      mc.setup()

      local map = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      map({ "n", "x" }, "<up>", function()
        mc.lineAddCursor(-1)
      end)
      map({ "n", "x" }, "<down>", function()
        mc.lineAddCursor(1)
      end)
      map({ "n", "x" }, "<leader><up>", function()
        mc.lineSkipCursor(-1)
      end)
      map({ "n", "x" }, "<leader><down>", function()
        mc.lineSkipCursor(1)
      end)

      -- Add or skip adding a new cursor by matching word/selection
      map({ "n", "x" }, "<leader>n", function()
        mc.matchAddCursor(1)
      end)
      map({ "n", "x" }, "<leader>s", function()
        mc.matchSkipCursor(1)
      end)
      map({ "n", "x" }, "<leader>N", function()
        mc.matchAddCursor(-1)
      end)
      map({ "n", "x" }, "<leader>S", function()
        mc.matchSkipCursor(-1)
      end)

      -- Add and remove cursors with control + left click.
      map("n", "<c-leftmouse>", mc.handleMouse)
      map("n", "<c-leftdrag>", mc.handleMouseDrag)
      map("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      map({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "duane9/nvim-rg",
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>:LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gg", "<cmd>:LazyGitCurrentFile<cr>", desc = "LazyGit" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },

    opts = {
      extensions_list = { "themes", "terms", "live_grep_args" },
      extensions = {},
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
