vim.lsp.config('xml', {
	cmd = { "lemminx-linux" },
	filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
	root_markers = { '.git' },
})
