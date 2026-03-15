local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
	'package.json'
}

vim.lsp.config('html', {
	name = "html",
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { "html", "templ" },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	settings = {
	},
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { 'html', 'css', 'javascript' },
	},
});
