return {
	{ 'williamboman/mason.nvim' },
	-- { 'williamboman/mason-lspconfig.nvim' },
	-- { 'VonHeikemen/lsp-zero.nvim' },
	-- { 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },
	{ 'onsails/lspkind.nvim' },
	{
		"mfussenegger/nvim-jdtls",
		dependencies = { "folke/which-key.nvim" },
	},
	{
		"jhofscheier/ltex-utils.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-telescope/telescope.nvim",
			-- "nvim-telescope/telescope-fzf-native.nvim", -- optional
		},
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	}
}
