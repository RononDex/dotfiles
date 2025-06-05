local root_files = {
	'.git',
	'composer.json',
	'.phpactor.json',
	'.phpactor.yml'
}

vim.lsp.config('phpactor', {
	name = "phpactor",
	cmd = { "phpactor", "language-server" },
	filetypes = { "php" },
	root_markers = root_files,
	settings = {
	}
});
