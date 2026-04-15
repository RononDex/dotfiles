return {
	default_on_attach = function(client, bufnr)
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true)
		end
		vim.lsp.codelens.enable(true)

		local codelense_cmds = vim.api.nvim_create_augroup('codelense_cmds', { clear = true })

		vim.api.nvim_create_autocmd('BufWritePost', {
			buffer = bufnr,
			group = codelense_cmds,
			desc = 'refresh codelens',
			callback = function()
				vim.lsp.codelens.enable(true)
			end,
		})
	end
}
