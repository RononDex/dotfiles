local root_files = {
	'.git',
}

local ltexls_install = require('mason-registry')
    .get_package('ltex-ls')
    :get_install_path()

local callback = function(success, version)
	vim.lsp.config('latex', {
		name = "ltex_ls",
		cmd = { vim.fs.joinpath(ltexls_install, version, "bin", "ltex-ls") },
		filetypes = { "tex" },
		root_markers = root_files,
		settings = {
			Lua = {
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true)
				}
			}
		}
	});
end

require('mason-registry')
    .get_package('ltex-ls')
    :get_installed_version(callback)
