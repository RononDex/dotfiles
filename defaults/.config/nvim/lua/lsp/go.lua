local root_files = {
	'.git',
	'go.mod',
}

local gopls_install = require('mason-registry')
    .get_package('gopls')
    :get_install_path()

vim.lsp.config('go', {
	name = "gopls",
	cmd = { vim.fs.joinpath(gopls_install, "gopls") },
	filetypes = { "go" },
	root_markers = root_files,
	settings = {
	}
});
