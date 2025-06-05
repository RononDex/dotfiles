local root_files = {
	'.git',
	'package.json'
}

vim.lsp.config('html', {
	name = "html",
	cmd = { 'vscode-html-language-server', '--stdio' },
	filetypes = { "html", "templ" },
	root_markers = root_files,
	settings = {
	},
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { 'html', 'css', 'javascript' },
	},
});
