local opt = vim.opt
local wo = vim.wo

opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
wo.number = true -- Show line numbers
opt.list = true
opt.listchars = { trail = '·', tab = '│ ', leadmultispace = '│···', precedes = '<', extends = '>' }
opt.cursorline = true
wo.fillchars='eob: '
opt.wrap = true
opt.sidescroll = 1
--opt.sidescrolloff = 5
--opt.laststatus = 0 -- To disable status line
opt.termguicolors = true
opt.showmode = false
opt.history = 1000
opt.completeopt = { "menuone", "longest", "preview", "noselect" }
vim.inccommand=nosplit
