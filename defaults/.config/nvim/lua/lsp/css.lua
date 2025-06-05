local root_files = {
	'.git',
	'package.json'
}

vim.lsp.config('css', {
	name = "css",
	cmd = { 'vscode-css-language-server', '--stdio' },
	filetypes = { "css", "scss", "less" },
	root_markers = root_files,
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
	init_options = {
		provideFormatter = true,
	}
});
