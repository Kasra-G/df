require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>", { silent = true })

map({ "n", "i" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "window left" })
map({ "n", "i" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "window right" })
map({ "n", "i" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "window down" })
map({ "n", "i" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "window up" })
map({ "n", "i" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "window last" })
map(
  "n",
  "<leader>fg",
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "telescope live grep args" }
)
