return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = { 'mfussenegger/nvim-dap-python' },
		cmd = "VenvSelect",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts, {
				name = {
					"venv",
					".venv",
					"env",
					".env",
				},
			})
		end,
		keys = {
			-- Keymap to open VenvSelector to pick a venv.
			{ '<leader>vs', '<cmd>VenvSelect<cr>' },
			-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
			{ '<leader>vc', '<cmd>VenvSelectCached<cr>' },
		},
	},
}
