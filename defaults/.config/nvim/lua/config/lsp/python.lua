vim.api.nvim_create_autocmd('VimEnter', {
	desc = 'Auto select virtualenv Nvim open',
	pattern = '*',
	callback = function()
		require('venv-selector').retrieve_from_cache()
	end,
	once = true,
})
