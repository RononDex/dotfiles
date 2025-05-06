local util = require 'lspconfig.util'

require("venv-selector").setup()

local root_files = {
	'pyproject.toml',
	'setup.py',
	'setup.cfg',
	'requirements.txt',
	'Pipfile',
	'pyrightconfig.json',
	'.git',
}

local pyright_install = require('mason-registry')
    .get_package('pyright')
    :get_install_path()

vim.lsp.config("pyright", {
	name = "pyright",
	cmd = { vim.fs.joinpath(pyright_install, 'pyright-langserver'), '--stdio' },
	filetypes = { 'python' },
	root_dir = function(fname)
		return util.root_pattern(unpack(root_files))(fname)
	end,
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
