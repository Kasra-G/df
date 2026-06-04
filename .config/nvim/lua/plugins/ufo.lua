return {
  "kevinhwang91/nvim-ufo",
  lazy = false,
  dependencies = "kevinhwang91/promise-async",
  config = function()
    require("ufo").setup {
      provider_selector = function(bufnr, filetype, buftype)
        return ""
      end,
      preview = {
        win_config = {
          winhighlight = "Normal:Normal",
        },
      },
      enable_get_fold_virt_text = true,
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate, ctx)
        local result = {}
        local first_line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
        local is_import = first_line:match "^%s*import" or first_line:match "^%s*require"

        -- Build suffix chunks (skip for import blocks)
        local suffix_chunks = {}
        if not is_import then
          local suffix_virt = ctx.get_fold_virt_text(end_lnum)
          local trimming = true
          for _, chunk in ipairs(suffix_virt) do
            if trimming then
              local trimmed = chunk[1]:match "^%s*(.*)"
              if trimmed and trimmed ~= "" then
                table.insert(suffix_chunks, { trimmed, chunk[2] })
                trimming = false
              end
            else
              table.insert(suffix_chunks, chunk)
            end
          end
        end

        local suffix_width = 0
        for _, chunk in ipairs(suffix_chunks) do
          suffix_width = suffix_width + vim.fn.strdisplaywidth(chunk[1])
        end

        local ellipsis = { " ⋯ ", "NonText" }
        local ellipsis_width = vim.fn.strdisplaywidth(ellipsis[1])
        local target_width = width - suffix_width - ellipsis_width
        local cur_width = 0

        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            table.insert(result, { chunk_text, chunk[2] })
            break
          end
          cur_width = cur_width + chunk_width
        end

        table.insert(result, ellipsis)
        for _, chunk in ipairs(suffix_chunks) do
          table.insert(result, chunk)
        end
        return result
      end,
    }
    local ufo = require "ufo"
    -- vim.keymap.set("n", "zR", ufo.openAllFolds)
    -- vim.keymap.set("n", "zM", ufo.closeAllFolds)
    -- vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds)
    -- vim.keymap.set("n", "zm", ufo.closeFoldsWith)
    vim.keymap.set("n", "K", function()
      local winid = ufo.peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
