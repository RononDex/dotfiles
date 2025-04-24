local root_files = {
	'.git',
}

local filetypes = {
	'bib',
	'gitcommit',
	'markdown',
	'org',
	'plaintex',
	'rst',
	'rnoweb',
	'tex',
	'pandoc',
	'quarto',
	'rmd',
	'context',
	'html',
	'xhtml',
	'mail',
	'text',
}

local language_id_mapping = {
	bib = 'bibtex',
	plaintex = 'tex',
	rnoweb = 'rsweave',
	rst = 'restructuredtext',
	tex = 'latex',
	pandoc = 'markdown',
	text = 'plaintext',
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

local ltexls_install = require('mason-registry')
    .get_package('ltex-ls')
    :get_install_path()

local callback = function(success, version)
	vim.lsp.config('latex', {
		name = "ltex_ls",
		cmd = { vim.fs.joinpath(ltexls_install, "ltex-ls-" .. version, "bin", "ltex-ls") },
		filetypes = filetypes,
		root_markers = root_files,
		get_language_id = get_language_id,
		settings = {
			ltex = {
				enabled = enabled_ids,
			},
		}
	});
end

require('mason-registry')
    .get_package('ltex-ls')
    :get_installed_version(callback)
