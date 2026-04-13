local lsp_utils = require("lsp.utils")

vim.lsp.config("pyright", {
	name = "pyright",
	cmd = { 'pyright-langserver', '--stdio' },
	filetypes = { 'python' },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = {
		'pyrightconfig.json',
		'pyproject.toml',
		'setup.py',
		'setup.cfg',
		'requirements.txt',
		'Pipfile',
		'.git',
	},
	single_file_support = true,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = 'openFilesOnly',
			},
		},
	},
})
