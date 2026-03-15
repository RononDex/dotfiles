local lsp_utils = require("lsp.utils")

local root_files = {
	'tsconfig.json',
	'"jsconfig.json',
	'package.json',
	'.git',
}

vim.lsp.config('javascript', {
	name = "javascript",
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx', },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	init_options = { hostInfo = 'neovim' },
});
