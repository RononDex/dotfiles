local root_files = {
	'.git',
}

vim.lsp.config('lua', {
		name = "lua",
		cmd = "luals",
		filetypes = { "lua" },
		root_markers = root_files,
});
