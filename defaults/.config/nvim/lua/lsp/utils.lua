return {
	default_on_attach = function(client, bufnr)
		vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
		vim.keymap.set('n', 'gu', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = bufnr })
		vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = bufnr })
		vim.keymap.set('v', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = bufnr })
		vim.keymap.set('n', '<leader><space>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr })
		vim.keymap.set({ 'n', 'x', 'v' }, '<leader>cf', function()
			vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
		end, { buffer = bufnr })

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
