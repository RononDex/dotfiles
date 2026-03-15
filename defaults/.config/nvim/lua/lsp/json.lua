local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
}

vim.lsp.config('json', {
	name = "json",
	cmd = { 'vscode-json-language-server', '--stdio' },
	filetypes = { "json", "jsonc" },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	settings = {
	},
	init_options = {
		provideFormatter = true,
	},
});
