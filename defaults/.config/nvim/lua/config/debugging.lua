require("dapui").setup()
local home = os.getenv("HOME")

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set('n', '<F9>', '<cmd>lua require("dap").toggle_breakpoint()<cr>')
vim.keymap.set('n', '<S-F9>', '<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")<cr>') -- Set Breakpoint condition
vim.keymap.set('n', '<F5>', '<cmd>lua require("dap").continue()<cr>')
vim.keymap.set('n', '<C-F5>', '<cmd>lua require("dap").run_last()<cr>')                                            -- Run last debug again
vim.keymap.set('n', '<S-F5>', '<cmd>lua require("dap").disconnect({ terminateDebuggee = true })<<cr>')             -- Stop debugging
vim.keymap.set('n', '<F10>', '<cmd>lua require("dap").step_over()<cr>')
vim.keymap.set('n', '<F11>', '<cmd>lua require("dap").step_into()<cr>')
vim.keymap.set('n', '<F12>', '<cmd>lua require("dap").step_out()<cr>')

dap.adapters.coreclr = {
	type = 'executable',
	command = home .. '/.local/share/netcoredbg/netcoredbg',
	args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
		end,
	},
}
