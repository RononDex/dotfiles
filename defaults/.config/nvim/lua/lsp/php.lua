local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
	'composer.json',
	'.phpactor.json',
	'.phpactor.yml'
}

vim.lsp.config('phpactor', {
	name = "phpactor",
	cmd = { "phpactor", "language-server" },
	filetypes = { "php" },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	settings = {
	}
});
