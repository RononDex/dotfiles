local language_list = { "c", "c_sharp", "lua", "vim", "vimdoc", "query", "java", "cpp", "json", "xml",
	"bash", "html", "javascript", "markdown", "make", "sql", "hyprlang", "javadoc", "python",
	"yaml", "rust" }

require('nvim-treesitter').install(language_list)
require('nvim-treesitter').update()

vim.api.nvim_create_autocmd('FileType', {
	pattern = language_list,
	callback = function()
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start()
		-- folds, provided by Neovim
		vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.wo.foldmethod = 'expr'
		-- indentation, provided by nvim-treesitter
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo.foldlevel = 99;
	end,
})
