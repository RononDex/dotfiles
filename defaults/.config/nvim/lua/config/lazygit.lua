vim.keymap.set('n', '<leader>gr', '<cmd>lua require("telescope").extensions.lazygit.lazygit()<cr>', { buffer = bufnr })
vim.keymap.set('n', '<leader>gs', '<cmd>LazyGit<cr>', { buffer = bufnr })
vim.keymap.set('n', '<leader>gf', '<cmd>LazyGitFilterCurrentFile<cr>', { buffer = bufnr })
vim.keymap.set('n', '<leader>gc', '<cmd>LazyGitFilter<cr>', { buffer = bufnr })

require('telescope').load_extension('lazygit')
