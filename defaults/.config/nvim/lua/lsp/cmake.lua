vim.lsp.config('cmake', {
	cmd = { 'neocmakelsp', 'stdio' },
	filetypes = { 'cmake' },
	root_markers = { '.neocmake.toml', '.git', 'build', 'cmake' },
})
