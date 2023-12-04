local hop = require('hop').setup({
	keys = 'etovxqpdygfblzhckisuran',
})

vim.keymap.set("n", " ", "<cmd>HopWord<cr>")

