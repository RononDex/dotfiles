local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
	'package.json'
}

vim.lsp.config('css', {
	name = "css",
	cmd = { 'vscode-css-language-server', '--stdio' },
	filetypes = { "css", "scss", "less" },
	root_markers = root_files,
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
	init_options = {
		provideFormatter = true,
	}
});
