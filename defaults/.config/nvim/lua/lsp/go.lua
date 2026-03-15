local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
	'go.mod',
}

vim.lsp.config('go', {
	name = "gopls",
	cmd = { "gopls" },
	filetypes = { "go" },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	settings = {
	}
});
