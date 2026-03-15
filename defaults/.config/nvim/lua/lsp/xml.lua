local lsp_utils = require("lsp.utils")

vim.lsp.config('xml', {
	cmd = { "lemminx" },
	filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = { '.git' },
	single_file_support = true,
	settings = {
		xml = {
			format = {
				enabled = true,
				joinContentLines = false
			}
		}
	}
})
