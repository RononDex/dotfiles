-- Load hop from nvim installation
-- Has to be defined before any other settings
vim.g.mapleader = ','
vim.g.maplocalleader = ','

--vim.opt.background = 'dark'
vim.opt.clipboard = 'unnamedplus' -- Use global clipboard
vim.opt.number = true             -- Show LineNumbers
vim.opt.smartcase = true
vim.opt.mouse = 'a'               -- Enable all mouse features
vim.opt.tabstop = 4
vim.opt.termguicolors = true
--Save undo history
vim.opt.undofile = true
vim.opt.encoding = "utf-8"

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakat = ' \t;,!?'

vim.opt.rtp:append(vim.fn.expand('~/.local/share/nvim/lazy/hop.nvim'))
vim.opt.rtp:append(vim.fn.expand('~/.local/share/nvim/lazy/onedark.nvim'))

-- Configure hop
local window = require('hop.window')
local orig_clip = window.clip_line_context
window.clip_line_context = function(line_ctx, win_ctx)
	if line_ctx == nil or line_ctx.line == nil then
		return nil
	end
	if type(line_ctx.line) ~= 'string' then
		line_ctx.line = ''
	end
	return orig_clip(line_ctx, win_ctx)
end

require('hop').setup({
	keys = 'etvxpdygfblzhckisuan',
})
local function set_hop_map()
	vim.keymap.set("n", " ", "<cmd>HopWord<cr>", { buffer = true, nowait = true })
end

-- Configure color scheme
require('onedark').setup {
	style = 'darker',
	colors = {
		bg0 = "#1b1d21",
		bg1 = "#24272b",
		bg2 = "#2e3238",
		bg3 = "#30323b",
	}
}
require('onedark').load()

vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter" }, {
	callback = function()
		vim.defer_fn(set_hop_map, 100)
	end
})

vim.api.nvim_set_hl(0, 'UrlHighlight', { fg = '#756025', underline = true })
vim.fn.matchadd('UrlHighlight', 'https\\?://[^ )>\\]]*')
vim.fn.matchadd('UrlHighlight', 'http\\?://[^ )>\\]]*')
vim.fn.matchadd('UrlHighlight', 'mailto\\?://[^ )>\\]]*')
