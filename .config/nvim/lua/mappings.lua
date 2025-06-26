require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>", { silent = true })
map("n", "<leader><cr>", ":nohlsearch<cr>", {silent = true})
map("v", "<leader>fs", function()
  require("conform").format({ async = true, lsp_fallback = true })
end)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
