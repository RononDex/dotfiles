local root_files = {
	'.git',
}

vim.lsp.config('bashls', {
	name = "bashls",
	cmd = { 'bash-language-server', 'start' },
	filetypes = { "bash", "sh" },
	root_markers = root_files,
	settings = {
	},
	single_file_support = true,
});
