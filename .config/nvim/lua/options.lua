require "nvchad.options"

vim.opt.colorcolumn = "120"
local o = vim.o
o.so = 10
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.cmdheight = 0
o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldmethod = "expr"
o.foldenable = true
o.foldcolumn = "auto:9"
o.foldlevel = 99
o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"
-- add yours here!
vim.g.tmux_navigator_save_on_switch = 2
vim.g.tmux_navigator_no_mappings = 1
-- local o = vim.o
