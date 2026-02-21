local root_files = {
	'.git',
}

local home = os.getenv('HOME')


local language_id_mapping = {
	bib = 'bibtex',
	pandoc = 'markdown',
	plaintex = 'tex',
	rnoweb = 'rsweave',
	rst = 'restructuredtext',
	tex = 'latex',
	text = 'plaintext',
}

vim.lsp.config('latex', {
	name = "ltex_ls",
	cmd = { "ltex-ls-plus" },
	filetypes = {
		'asciidoc',
		'bib',
		'context',
		'gitcommit',
		'html',
		'markdown',
		'org',
		'pandoc',
		'plaintex',
		'quarto',
		'mail',
		'mdx',
		'rmd',
		'rnoweb',
		'rst',
		'tex',
		'text',
		'typst',
		'xhtml',
	},
	root_markers = root_files,
	get_language_id = function(_, filetype)
		return language_id_mapping[filetype] or filetype
	end,
	settings = {
		ltex = {
			enabled = {
				'asciidoc',
				'bib',
				'context',
				'gitcommit',
				'html',
				'markdown',
				'org',
				'pandoc',
				'plaintex',
				'quarto',
				'mail',
				'mdx',
				'rmd',
				'rnoweb',
				'rst',
				'tex',
				'latex',
				'text',
				'typst',
				'xhtml',
			},
			additionalRules = {
				languageModel = vim.fs.joinpath(home, ".cache/ngram-data/"),
			},
		},
	}
});
