require("lspconfig").ltex.setup({
	on_attach = function(client, bufnr)
		require("ltex-utils").on_attach(bufnr)
	end,
})
