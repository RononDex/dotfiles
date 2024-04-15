require("dapui").setup()

local home = os.getenv("HOME")

local dap, dapui = require("dap"), require("dapui")
local utils = require("utils")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
	if utils.is_neotree_open() then
		utils.neotree_open_before_debug = true
		vim.cmd("Neotree close")
	end
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	if utils.autoclose_debug_windows then
		utils.close_debugger()
	end
end
dap.listeners.before.event_exited["dapui_config"] = function()
	if utils.autoclose_debug_windows then
		utils.close_debugger()
	end
end

dap.adapters.netcoredbg = {
	type = 'executable',
	command = '/usr/local/bin/netcoredbg/netcoredbg',
	args = { '--interpreter=vscode' }
}

dap.adapters.coreclr = dap.adapters.netcoredbg

dap.configurations.cs = {
	{
		type = "netcoredbg",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
		end,
	}
}

vim.keymap.set('n', '<F9>', '<cmd>lua require("dap").toggle_breakpoint()<cr>')
vim.keymap.set('n', '<F21>', '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>') -- Set Breakpoint condition
vim.keymap.set('n', '<F5>', '<cmd>lua require("utils").start_debugger(true)<cr>')
vim.keymap.set('n', '<F29>', '<cmd>lua require("dap").run_last()<cr>')                                             -- Run last debug again
vim.keymap.set('n', '<F17>', '<cmd>lua require("dap").disconnect({ terminateDebuggee = true })<cr>')               -- Stop debugging
vim.keymap.set('n', '<F10>', '<cmd>lua require("dap").step_over()<cr>')
vim.keymap.set('n', '<F11>', '<cmd>lua require("dap").step_into()<cr>')
vim.keymap.set('n', '<F12>', '<cmd>lua require("dap").step_out()<cr>')

-- Breakpoints appearance
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

vim.fn.sign_define('DapBreakpoint', {
	text = '',
	texthl = 'DapBreakpoint',
	linehl = 'DapBreakpoint',
	numhl =
	'DapBreakpoint'
})
vim.fn.sign_define('DapBreakpointCondition',
	{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
	{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

-- Load vscode / launch.json by default
require('dap.ext.vscode').load_launchjs(nil, { coreclr = { 'cs' } })
