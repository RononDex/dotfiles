-- Has to be defined before any other settings
vim.g.mapleader = ','
vim.g.maplocalleader = ','

--vim.opt.background = 'dark'
vim.opt.clipboard = 'unnamedplus' -- Use global clipboard
vim.opt.number = true             -- Show LineNumbers
vim.opt.smartcase = true
vim.opt.mouse = 'a'               -- Enable all mouse features
vim.opt.tabstop = 4
vim.opt.termguicolors = true
--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
