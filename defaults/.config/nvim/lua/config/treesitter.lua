require('nvim-treesitter.configs').setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "c_sharp", "lua", "vim", "vimdoc", "query", "java", "cpp", "json", "xml", "yaml" },
})
