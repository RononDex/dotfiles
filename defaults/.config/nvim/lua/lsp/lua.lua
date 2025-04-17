local root_files = {
	'.git',
}

local luals_install = require('mason-registry')
		.get_package('lua-language-server')
		:get_install_path()

print(luals_install)

vim.lsp.config('lua', {
		name = "lua",
		cmd = { "luals" },
		filetypes = { "lua" },
		root_markers = root_files,
});
