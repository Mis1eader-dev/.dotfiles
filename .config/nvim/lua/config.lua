vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.wo.number = true -- Show line numbers
vim.opt.list = true
vim.opt.listchars = { trail = '·', tab = '| ', leadmultispace = '|···', precedes = '<', extends = '>' }
vim.opt.cursorline = true
vim.wo.fillchars='eob: '
vim.opt.wrap = false
vim.opt.sidescroll = 1
--vim.opt.sidescrolloff = 5
--vim.opt.laststatus = 0 -- To disable status line
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.history = 1000
vim.opt.completeopt = { "menuone", "longest", "preview", "noselect" }
vim.inccommand=nosplit
