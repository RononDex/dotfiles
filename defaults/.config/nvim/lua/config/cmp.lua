local cmp = require('cmp')
local luasnip = require("luasnip")
local lspkind = require('lspkind')

cmp.setup({
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		}
	},
	mapping = cmp.mapping.preset.insert({
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
		['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
		['<C-Space>'] = cmp.mapping.complete()
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
			fields = { 'abbr', 'icon', 'kind', 'menu' },
			format = lspkind.cmp_format({
				maxwidth = {
					-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					-- can also be a function to dynamically calculate max width such as
					-- menu = function() return math.floor(0.45 * vim.o.columns) end,
					menu = 50, -- leading text (labelDetails)
					abbr = 50, -- actual suggestion item
				},
				ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
				show_labelDetails = true, -- show labelDetails in menu. Disabled by default

				-- The function below will be called before any actual modifications from lspkind
				-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
				before = function(entry, vim_item)
					-- ...
					return vim_item
				end
			})
		})
	}
})
