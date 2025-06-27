require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>", { silent = true })
map("n", "<leader><cr>", ":nohlsearch<cr>", { silent = true })
map("v", "<leader>fs", function()
  require("conform").format { async = true, lsp_fallback = true }
end)

map("n", "<leader>r", vim.lsp.buf.rename)
map("n", "<leader>gr", vim.lsp.buf.references)

map({ "n", "i" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "window left" })
map({ "n", "i" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "window right" })
map({ "n", "i" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "window down" })
map({ "n", "i" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "window up" })
map({ "n", "i" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "window last" })
map("n", "<leader>eo", "<cmd>NvimTreeFindFile<return>", { desc = "open tree to file" })
map(
  "n",
  "<leader>fg",
  ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
  { desc = "telescope live grep args" }
)
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
