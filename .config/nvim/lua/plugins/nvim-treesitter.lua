return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- dependencies = {"AJamesyD/tree-sitter-jsonl" },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install {
        "lua",
        "python",
        "kotlin",
        "java",
        "typescript",
        "svelte",
        "html",
        "css",
        "sql",
        "json",
        "markdown",
        "javascript",
      }
    end,
  },
}
