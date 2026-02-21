vim.lsp.config('texlab', {
	name = "texlab",
	cmd = { "texlab" },
	filetypes = { 'tex', 'plaintex', 'bib' },
	root_markers = { '.git', '.latexmkrc', 'latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' },
	settings = {
		texlab = {
			rootDirectory = nil,
			build = {
				executable = 'xelatex',
				onSave = true,
				forwardSearchAfter = true,
			},
			forwardSearch = {
				executable = "zathura",
				args = { "--synctex-forward", "%l:1:%f", "%p" }
			},
			chktex = {
				onOpenAndSave = false,
				onEdit = false,
			},
			diagnosticsDelay = 300,
			latexFormatter = 'latexindent',
			latexindent = {
				['local'] = nil, -- local is a reserved keyword
				modifyLineBreaks = false,
			},
			bibtexFormatter = 'texlab',
			formatterLineLength = 80,
		},
	},
});
