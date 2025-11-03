return {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	dependencies = {
		{
			-- By loading as a dependencies, we ensure that we are available to set
			-- the handlers for Roslyn.
			"tris203/rzls.nvim",
			config = true,
		},
	},
	ft = { "cs", "razor" },
	opts = {
		-- your configuration comes here; leave empty for default settings
	},
}
