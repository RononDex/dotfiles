require("mason").setup()
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
	install_package_if_not_exists("omnisharp")

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
end)
