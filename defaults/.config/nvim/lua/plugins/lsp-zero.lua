return {
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'VonHeikemen/lsp-zero.nvim' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'onsails/lspkind.nvim' },
	{
		"mfussenegger/nvim-jdtls",
		dependencies = { "folke/which-key.nvim" },
		ft = java_filetypes,
		opts = function()
			return {
				-- How to find the root dir for a given filename. The default comes from
				-- lspconfig which provides a function specifically for java projects.
				root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,

				-- How to find the project name for a given root dir.
				project_name = function(root_dir)
					return root_dir and vim.fs.basename(root_dir)
				end,

				-- Where are the config and workspace dirs for a project?
				jdtls_config_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
				end,
				jdtls_workspace_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
				end,

				-- How to run jdtls. This can be overridden to a full java command-line
				-- if the Python wrapper script doesn't suffice.
				cmd = { vim.fn.exepath("jdtls") },
				full_cmd = function(opts)
					local fname = vim.api.nvim_buf_get_name(0)
					local root_dir = opts.root_dir(fname)
					local project_name = opts.project_name(root_dir)
					local cmd = vim.deepcopy(opts.cmd)
					if project_name then
						vim.list_extend(cmd, {
							"-configuration",
							opts.jdtls_config_dir(project_name),
							"-data",
							opts.jdtls_workspace_dir(project_name),
						})
					end
					return cmd
				end,

				-- Here you can configure eclipse.jdt.ls specific settings
				-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				-- for a list of options
				settings = {
					java = {
						referenceCodeLens = { enabled = true }
					}
				},

				-- These depend on nvim-dap, but can additionally be disabled by setting false here.
				dap = { hotcodereplace = "auto", config_overrides = {} },
				test = true,

				init_options = {
					bundles = { "~/.local/share/jdtls/extensions/lombok/lombok.jar" }
				},
			}
		end
	}
}
