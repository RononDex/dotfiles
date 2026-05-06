vim.diagnostic.config({
	virtual_lines = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	underline = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
})
