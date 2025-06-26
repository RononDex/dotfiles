vim.lsp.config('xml', {
	cmd = { "lemminx" },
	filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
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
