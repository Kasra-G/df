return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
          else
            gitsigns.nav_hunk("next", { target = "all" })
          end
        end, { desc = "git navigate next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
          else
            gitsigns.nav_hunk("prev", { target = "all" })
          end
        end, { desc = "git navigate previous hunk" })

        -- Actions
        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "git stage hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git reset hunk" })

        map("v", "<leader>gs", function()
          gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "git stage hunk" })

        map("v", "<leader>gr", function()
          gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
        end, { desc = "git reset hunk" })

        map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git stage buffer" })
        map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git reset buffer" })
        map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git preview hunk" })
        map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "git preview hunk inline" })

        map("n", "<leader>gU", gitsigns.reset_buffer_index, { desc = "git unstage buffer" })
        map("n", "<leader>gb", gitsigns.blame, { desc = "git toggle blame for file" })

        map("n", "<leader>gD", function()
          gitsigns.diffthis "~"
        end, { desc = "git diff ~" })

        map("n", "<leader>gQ", function()
          gitsigns.setqflist "all"
        end)
        map("n", "<leader>gq", gitsigns.setqflist)

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle current line blame" })
        map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "toggle word diff" })

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "git select hunk" })
      end,
    },
  },
}
