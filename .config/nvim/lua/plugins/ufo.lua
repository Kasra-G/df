return {
  "kevinhwang91/nvim-ufo",
  lazy = false,
  dependencies = "kevinhwang91/promise-async",
  config = function()
    require("ufo").setup {
      close_fold_kinds_for_ft = {
        default = {'imports', 'comment'},
      },
      provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", "indent" }
      end,
      preview = {
        win_config = {
          winhighlight = "Normal:Folded",
        },
      },
      enable_get_fold_virt_text = true,
    }
    local ufo = require "ufo"
    vim.keymap.set("n", "zR", ufo.openAllFolds)
    vim.keymap.set("n", "zM", ufo.closeAllFolds)
    vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
    vim.keymap.set("n", "zm", ufo.closeFoldsWith)
    vim.keymap.set("n", "K", function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
