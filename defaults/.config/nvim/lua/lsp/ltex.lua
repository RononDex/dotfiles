local root_files = {
	'.git',
}

local home = os.getenv('HOME')

local filetypes = {
	'bib',
	'tex',
}

local function get_language_id(_, filetype)
	local language_id = language_id_mapping[filetype]
	if language_id then
		return language_id
	else
		return filetype
	end
end
local enabled_ids = {}
do
	local enabled_keys = {}
	for _, ft in ipairs(filetypes) do
		local id = get_language_id({}, ft)
		if not enabled_keys[id] then
			enabled_keys[id] = true
			table.insert(enabled_ids, id)
		end
	end
end

vim.lsp.config('latex', {
	name = "ltex_ls",
	cmd = { "ltex-ls-plus" },
	filetypes = filetypes,
	root_markers = root_files,
	get_language_id = get_language_id,
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
