local root_files = {
	'.git',
	'init.lua',
}

vim.lsp.config('lua', {
	name = "lua_ls",
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = root_files,
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
});
