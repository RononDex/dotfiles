local root_files = {
	'.git',
}

local luals_install = require('mason-registry')
		.get_package('lua-language-server')
		:get_install_path()

vim.lsp.config('lua', {
		name = "lua",
		cmd = { vim.fs.joinpath(luals_install, "lua-language-server") },
		filetypes = { "lua" },
		root_markers = root_files,
});
