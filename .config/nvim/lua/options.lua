require "nvchad.options"

vim.opt.colorcolumn = "120"
local o = vim.o
o.so = 10
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.cmdheight = 0
o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- add yours here!
vim.g.tmux_navigator_save_on_switch = 2
vim.g.tmux_navigator_no_mappings = 1
-- local o = vim.o
