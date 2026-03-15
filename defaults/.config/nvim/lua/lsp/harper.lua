local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
}

vim.lsp.config('harper', {
	name = "hbarper",
	cmd = { "harper-ls", "--stdio" },
	filetypes = {
		'asciidoc',
		'c',
		'cpp',
		'cs',
		'gitcommit',
		'go',
		'html',
		'java',
		'javascript',
		'lua',
		'markdown',
		'nix',
		'python',
		'ruby',
		'rust',
		'swift',
		'toml',
		'typescript',
		'typescriptreact',
		'haskell',
		'cmake',
		'typst',
		'php',
		'dart',
		'clojure',
		'sh',
	},
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	settings = {
	}
});
