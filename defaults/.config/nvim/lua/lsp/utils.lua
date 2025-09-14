return {
	default_on_attach = function(client, bufnr)
		if client.supports_method("textDocument/inlayHint") then
			if vim.lsp.inlay_hint then
				vim.lsp.inlay_hint.enable(true)
			end
		end
		if client.supports_method("textDocument/codeLens") then
			pcall(vim.lsp.codelens.refresh)

			local codelense_cmds = vim.api.nvim_create_augroup('codelense_cmds', { clear = true })

			vim.api.nvim_create_autocmd('BufWritePost', {
				buffer = bufnr,
				group = codelense_cmds,
				desc = 'refresh codelens',
				callback = function()
					pcall(vim.lsp.codelens.refresh)
				end,
			})
		end
	end
}
