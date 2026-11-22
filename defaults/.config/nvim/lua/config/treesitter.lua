local language_list = { "c", "c_sharp", "lua", "vim", "vimdoc", "query", "java", "cpp", "json", "xml",
	"bash", "html", "javascript", "markdown", "make", "sql", "hyprlang", "javadoc", "python",
	"yaml", "rust", "razor", "latex", "regex" }

require('nvim-treesitter').install(language_list)

local filetypes = {}
for _, lang in ipairs(language_list) do
	vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

vim.api.nvim_create_autocmd('FileType', {
	pattern = filetypes,
	callback = function(event)
		-- shortcut: if installation is still running, reopen the buffer after it finishes.
		if not vim.treesitter.language.add(vim.treesitter.language.get_lang(event.match)) then
			return
		end
		-- syntax highlighting, provided by Neovim
		vim.treesitter.start(event.buf)
		-- folds, provided by Neovim
		vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.wo.foldmethod = 'expr'
		-- indentation, provided by nvim-treesitter
		-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.wo.foldlevel = 99;
	end,
})
