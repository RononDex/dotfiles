local root_files = {
	'.git',
}

vim.lsp.config('openscad', {
	name = "openscad_lsp",
	cmd = { "openscad-lsp" },
	filetypes = { "openscad" },
	root_markers = root_files,
	settings = {
	},
	single_file_support = true
});
