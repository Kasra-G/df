require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>", { silent = true })
map("n", "<leader><cr>", ":nohlsearch<cr>", {silent = true})
map("v", "<leader>fs", function()
  require("conform").format({ async = true, lsp_fallback = true })
end)
map({"n", "i"}, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "window left" })
map({"n", "i"}, "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "window right" })
map({"n", "i"}, "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "window down" })
map({"n", "i"}, "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "window up" })
map({"n", "i"}, "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "window last" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
