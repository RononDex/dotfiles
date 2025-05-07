local root_files = {
	'.git',
	'go.mod',
}

vim.lsp.config('go', {
	name = "gopls",
	cmd = { "gopls" },
	filetypes = { "go" },
	root_markers = root_files,
	settings = {
	}
});
