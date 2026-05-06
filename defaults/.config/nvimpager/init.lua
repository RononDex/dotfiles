-- Load hop from nvim installation
vim.opt.rtp:append(vim.fn.expand('~/.local/share/nvim/lazy/hop.nvim'))

require('hop').setup({
	keys = 'etovxqpdygfblzhckisuran',
})
vim.keymap.set("n", " ", "<cmd>HopWord<cr>")
