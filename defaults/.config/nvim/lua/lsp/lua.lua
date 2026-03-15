local lsp_utils = require("lsp.utils")

local root_files = {
	'.git',
	'init.lua',
}

vim.lsp.config('lua', {
	name = "lua_ls",
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
	end,
	root_markers = root_files,
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
});
