require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	}
})
local mason_registry = require("mason-registry")

local function install_package_if_not_exists(name)
	if not mason_registry.is_installed(name) then
		vim.cmd("MasonInstall " .. name)
	end
end

mason_registry.refresh(function()
	-- Java related packages
	install_package_if_not_exists("jdtls")
	install_package_if_not_exists("java-test")
	install_package_if_not_exists("java-debug-adapter")

	-- Lua
	install_package_if_not_exists("lua-language-server")

	-- C#
	install_package_if_not_exists("netcoredbg")
	install_package_if_not_exists("roslyn")

	-- Latex
	install_package_if_not_exists("ltex-ls")

	-- Python
	install_package_if_not_exists("debugpy")
	install_package_if_not_exists("pyright")

	-- Go
	install_package_if_not_exists("gopls")

	-- XML
	install_package_if_not_exists("lemminx")

	-- Bash
	install_package_if_not_exists("bash-language-server")

	-- PHP
	install_package_if_not_exists("phpactor")

	-- HTML / CSS / JSON
	install_package_if_not_exists("html-lsp")
	install_package_if_not_exists("css-lsp")
	install_package_if_not_exists("json-lsp")

	-- Javascript
	install_package_if_not_exists("typescript-language-server")

	--OpenSCAD
	install_package_if_not_exists("openscad-lsp")

	-- CPP
	install_package_if_not_exists("clangd")
	install_package_if_not_exists("clang-format")
	install_package_if_not_exists("codelldb")

	-- Typos
	install_package_if_not_exists("harper-ls")
end)
