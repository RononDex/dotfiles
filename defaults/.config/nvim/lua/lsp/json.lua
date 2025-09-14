local root_files = {
	'.git',
}

vim.lsp.config('json', {
	name = "json",
	cmd = { 'vscode-json-language-server', '--stdio' },
	filetypes = { "json", "jsonc" },
	root_markers = root_files,
	settings = {
	},
	init_options = {
		provideFormatter = true,
	},
});
