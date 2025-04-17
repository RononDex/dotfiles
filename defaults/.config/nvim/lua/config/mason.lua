local mason = require("mason").setup()
local mason_registry = require("mason-registry")

local function install_package_if_not_exists(name)
		if not mason_registry.is_installed(name) then
				vim.cmd("MasonInstall " .. name)
		end
end

mason_registry.refresh(function ()

		install_package_if_not_exists("jdtls")
		install_package_if_not_exists("java-test")
		install_package_if_not_exists("java-debug-adapter")

		install_package_if_not_exists("lua-language-server")

end)

