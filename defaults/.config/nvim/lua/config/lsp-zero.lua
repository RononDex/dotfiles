local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
	vim.keymap.set('n', 'gu', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
	vim.keymap.set('n', '<leader><space>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr })
	vim.keymap.set('v', '<leader><space>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr })
	vim.keymap.set({ 'n', 'x', 'v' }, '<leader>cf', function()
		vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
	end, { buffer = bufnr })
	lsp_zero.buffer_autoformat()

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

	if client.supports_method("textDocument/inlayHint") then
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(bufnr, true)
		end
	end
end)

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<Tab>'] = cmp_action.luasnip_supertab(),
		['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
		['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' })
	}),
	preselect = 'item',
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	formatting = {
		fields = { 'abbr', 'kind', 'menu' },
		format = require('lspkind').cmp_format({
			mode = 'symbol', -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters
			ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
		})
	}
})

require('mason').setup({
})
require('mason-lspconfig').setup({
	ensure_installed = {
		"lua_ls",
		"omnisharp",
		"clangd",
		"bashls",
		"html",
		"texlab",
		"tsserver",
		"eslint",
		"jdtls",
		"cssls",
		"typos_lsp",
		"yamlls",
		"sqlls",
		"cmake",
		"vimls",
	},
	handlers = {
		lsp_zero.default_setup,
		jdtls = lsp_zero.noop,
	},
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false })
