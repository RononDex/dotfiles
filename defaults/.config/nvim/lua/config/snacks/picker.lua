return {
	enabled = true,
	sources = {
		explorer = {
			auto_close = true,
			layout = function()
				return {
					preset = 'sidebar',
					preview = false,
					layout = {
						width = (vim.g.explorer_size or {}).width,
					},
				}
			end,
			on_close = function(picker)
				vim.g.explorer_size = picker.layout.root:size()
			end,
		}
	}
}
