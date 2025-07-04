-- Lua
return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewToggleFiles" },
    config = function()
      vim.opt.fillchars:append "diff:╱"

      local mix_col = require("base46.colors").mix
      local colors = dofile(vim.g.base46_cache .. "colors")
      dofile(vim.g.base46_cache .. "diffview")
      vim.api.nvim_set_hl(0, "DiffviewDiffAdd", { bg = mix_col(colors.green, colors.black, 85) })
      vim.api.nvim_set_hl(0, "DiffviewDiffText", { bg = mix_col(colors.green, colors.black, 70) })
      vim.api.nvim_set_hl(0, "DiffviewDiffChange", { bg = mix_col(colors.green, colors.black, 85) })
      vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = mix_col(colors.red, colors.black, 70) })
    end,
    opts = {
      enhanced_diff_hl = false,
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
        end,
        ---@diagnostic disable-next-line: unused-local
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match "^diff2" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAddAsDelete",
                "DiffDelete:DiffviewDiffDelete",
                "DiffChange:DiffviewDiffAddAsDelete",
                "DiffText:DiffviewDiffDelete",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAdd",
                "DiffDelete:DiffviewDiffDelete",
                "DiffChange:DiffviewDiffAdd",
                "DiffText:DiffviewDiffText",
              }, ",")
            end
          end
        end,
      },
    },
    keys = {
      {
        "<leader>gd",
        function()
          if next(require("diffview.lib").views) == nil then
            vim.cmd "DiffviewOpen"
          else
            vim.cmd "DiffviewClose"
          end
        end,
        { desc = "toggle diff view" },
      },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "git open file history" } },
    },
  },
}
