require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		message = {
			enabled = false,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
	cmdline = {
		view = "cmdline",
	},
	routes = {
		{ -- route long messages to split
			filter = {
				event = "msg_show",
				any = { { min_height = 5 }, { min_width = 200 } },
				["not"] = {
					kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
				},
				blocking = false,
			},
			view = "messages",
			opts = { stop = true },
		},
		{ -- route long messages to split
			filter = {
				event = "msg_show",
				any = { { min_height = 5 }, { min_width = 200 } },
				["not"] = {
					kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
				},
				blocking = true,
			},
			view = "mini",
		},
		{ -- hide `written` message
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
			opts = { skip = true },
		},
		{ -- hide "codelense not supported" messages
			filter = {
				event = 'notify.error',
				find = 'textDocument/codeLens is not supported'
			},
			opts = { skip = true },
		},
	},
})
