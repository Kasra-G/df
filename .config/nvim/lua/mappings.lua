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
map("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "close quickfix menu" })

map("n", "<leader>bcu", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local file = vim.api.nvim_buf_get_name(buf)
      local modified = vim.api.nvim_buf_get_option(buf, "modified")

      if file and not modified then
        local git_status = vim.fn.system("git status --porcelain " .. vim.fn.shellescape(file))

        if git_status == "" or git_status == "\n" then
          vim.api.nvim_buf_delete(buf, {})
        end
      end
    end
  end
end, { desc = "Close unchanged buffers" })

map("n", "<leader>bco", function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current_buf and vim.api.nvim_buf_is_loaded(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end
  end
end, { desc = "Close all other buffers except current one" })
