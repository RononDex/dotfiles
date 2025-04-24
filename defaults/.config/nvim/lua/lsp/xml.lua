local lemminx_install = require('mason-registry')
    .get_package('lemminx')
    :get_install_path()

vim.lsp.config('xml', {
	cmd = { vim.fs.joinpath(lemminx_install, "lemminx-linux") },
	filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
	root_markers = { '.git' },
})
