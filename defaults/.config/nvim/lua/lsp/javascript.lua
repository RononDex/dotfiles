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
	root_markers = root_files,
	init_options = { hostInfo = 'neovim' },
});
