require "nvchad.options"

vim.opt.colorcolumn = "120"
local o = vim.o
o.so = 10
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.cmdheight = 0

-- add yours here!
vim.g["tmux_navigator_no_wrap"] = 1
-- local o = vim.o
