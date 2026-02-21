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

local function createLtexConfig(lang)
	return {
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
				language = lang,
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
	}
end

vim.lsp.config('ltex_ls', createLtexConfig('en-US'));

function switchLtexLanguage(lang)
	vim.lsp.config("ltex_ls", createLtexConfig(lang))
	vim.notify("Ltex language set to " .. lang)
	vim.cmd("LspRestart")
end

vim.api.nvim_create_user_command("LtexSetLanguageToGerman",
	function(opts)
		switchLtexLanguage('de-CH')
	end
	, { nargs = 0 })
vim.api.nvim_create_user_command("LtexSetLanguageToEnglish",
	function(opts)
		switchLtexLanguage('en-US')
	end
	, { nargs = 0 })
