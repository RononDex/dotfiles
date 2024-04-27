return {
	"scalameta/nvim-metals",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	ft = { "scala", "sbt" },
	opts = function()
		local metals_config = require("metals").bare_config()
		metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- Example of settings
		metals_config.settings = {
			showImplicitArguments = true,
			excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
		}
		metals_config.on_attach = function(client, bufnr)
			require("metals").setup_dap()
		end

		return metals_config
	end,
	config = function(self, metals_config)
		local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = self.ft,
			callback = function()
				require("metals").initialize_or_attach(metals_config)
			end,
			group = nvim_metals_group,
		})
	end
}
