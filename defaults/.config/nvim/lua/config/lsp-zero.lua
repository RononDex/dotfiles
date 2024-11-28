local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
	vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
	vim.keymap.set('n', 'gu', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
	vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = bufnr })
	vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = bufnr })
	vim.keymap.set('v', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = bufnr })
	vim.keymap.set('n', '<leader><space>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = bufnr })
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
			vim.lsp.inlay_hint.enable(true)
		end
	end
end

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<Tab>'] = cmp_action.luasnip_supertab(),
		['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
		['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' })
	}),
	-- mapping = cmp.mapping.preset.insert({}),
	preselect = 'item',
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	snippet = {
		expand = function(args)
			-- You need Neovim v0.10 to use vim.snippet
			vim.snippet.expand(args.body)
		end,
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

lsp_zero.extend_lspconfig({
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	lsp_attach = lsp_attach,
	float_border = 'rounded',
	sign_text = true,
})

vim.g.rustaceanvim = {
	server = {
		capabilities = lsp_zero.get_capabilities()
	},
}

require('mason').setup({
})
require('mason-lspconfig').setup({
	ensure_installed = {
		"lua_ls",
		"omnisharp",
		"clangd",
		"bashls",
		"rust_analyzer",
		"html",
		"texlab",
		"ltex",
		"eslint",
		"jdtls",
		"cssls",
		"yamlls",
		"sqlls",
		"cmake",
		"vimls",
		"basedpyright",
		"gopls",
		"golangci_lint_ls",
		"glslls"
	},
	handlers = {
		lsp_zero.default_setup,
		jdtls = lsp_zero.noop,
		rust_analyzer = lsp_zero.noop,
		gopls = function()
			require('lspconfig').gopls.setup({
				capabilities = lsp_zero.get_capabilities(),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					}
				}
			})
		end
	},
})

vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = false })

vim.filetype.add({
	extension = {
		vert = "glsl",
		tesc = "glsl",
		tese = "glsl",
		frag = "glsl",
		geom = "glsl",
		comp = "glsl",
	},
})
