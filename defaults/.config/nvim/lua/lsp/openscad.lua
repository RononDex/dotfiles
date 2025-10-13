local root_files = {
	'.git',
}

vim.lsp.config('openscad', {
	name = "openscad_lsp",
	cmd = { "openscad-lsp", "--stdio" },
	filetypes = { "openscad" },
	root_dir = function(fname)
		return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
	end,
	settings = {
	},
	single_file_support = true
});
