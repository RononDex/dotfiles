require 'lspconfig'.texlab.setup {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	single_file_support = true,
	settings = {
		texlab = {
			auxDirectory = ".",
			bibtexFormatter = "texlab",
			build = {
				executable = "pdflatex",
				forwardSearchAfter = true,
				onSave = true
			},
			chktex = {
				onEdit = true,
				onOpenAndSave = true
			},
			diagnosticsDelay = 100,
			formatterLineLength = 500,
			diagnostics = {
				ignoredPatterns = { ".*may.*" }
			},
			forwardSearch = {
				executable = "zathura",
				args = { "--synctex-forward", "%l:1:%f", "%p" }
			},
			latexFormatter = "latexindent",
			latexindent = {
				modifyLineBreaks = false
			}
		}
	}
}
