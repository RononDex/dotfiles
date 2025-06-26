vim.lsp.config('xml', {
	cmd = { "lemminx" },
	filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
	root_markers = { '.git' },
	settings = {
		xml = {
			format = {
				joinContentLines = false
			}
		}
	}
})
