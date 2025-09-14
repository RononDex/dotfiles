-- init.lua
local neogit = require('neogit')
neogit.setup {}

vim.keymap.set('n', '<leader>gs', '<cmd>Neogit<cr>', { buffer = bufnr })
vim.keymap.set('n', '<leader>gc', '<cmd>Neogit commit<cr>', { buffer = bufnr })
