return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {"AJamesyD/tree-sitter-jsonl" },
    lazy = false,
    opts = function(_, opts)
      require('nvim-treesitter.parsers').get_parser_configs().jsonl = {
        install_info = {
          url = "https://github.com/AJamesyD/tree-sitter-jsonl",
          files = { "src/parser.c" },
          branch = "mainline",
        }
      }
      opts.ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "kotlin",
        "java",
        "sql",
        "python",
        "typescript",
        "markdown",
        "markdown_inline",
        "jsonl",
      }
    end,
  },
}
