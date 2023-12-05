return {
	'nvim-neo-tree/neo-tree.nvim',
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = {
			close_if_last_window = true,
			popup_border_style = 'rounded',
			enable_git_status = true,
			enable_diagnostics = true,
			window = {
				mappings = {
					["s"] = "noop",
					["<C-s>"] = "open_vsplit",
				},
			},
			filesystem = {
				filtered_items = {
					visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
					hide_dotfiles = false,
					hide_gitignored = true,
					respect_gitignore = true,
				},
				follow_current_file = { enabled=true },
				use_libuv_file_watcher = true,
			}
		}
	}

}
