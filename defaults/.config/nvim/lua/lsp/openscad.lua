vim.lsp.config('openscad', {
	name = "openscad_lsp",
	cmd = { 'openscad-lsp', '--stdio' },
	filetypes = { 'openscad' },
	root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
	settings = {
	},
	single_file_support = true
});
