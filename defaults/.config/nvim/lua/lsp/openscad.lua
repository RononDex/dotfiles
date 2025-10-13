local root_files = {
	'.git',
}

vim.lsp.config('openscad', {
	name = "openscad_lsp",
	cmd = { 'openscad-lsp', '--stdio' },
	filetypes = { 'openscad' },
	root_dir = root_files,
	settings = {
	},
	single_file_support = true
});
