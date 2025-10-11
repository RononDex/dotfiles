local root_files = {
	'.git',
}

vim.lsp.config('openscad', {
	name = "openscad_lsp",
	cmd = { "openscad-lsp" },
	filetypes = { "scad" },
	root_markers = root_files,
	settings = {
	}
});
