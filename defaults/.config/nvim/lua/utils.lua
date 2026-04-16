local utils = {
	autoclose_debug_windows = false,
	debugging = false,
}

function utils.is_editable()
	local current_buffer = vim.api.nvim_get_current_buf()
	local is_modifiable = vim.api.nvim_get_option_value("modifiable", { scope = "local", buf = current_buffer })
	local is_readonly = vim.api.nvim_get_option_value("readonly", { scope = "local", buf = current_buffer })
	return is_modifiable and not is_readonly
end

function utils.start_debugger(autoclose_windows)
	if not utils.debugging then
		utils.debugging = true
		utils.autoclose_debug_windows = autoclose_windows
		if utils.is_editable() then
			vim.cmd("silent! wall")
		end
	end
	require("dap").continue()
end

function utils.close_debugger()
	utils.debugging = false
	require("dapui").close()
end

function utils.get_python_path()
	local cwd = vim.fn.getcwd()
	if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
		return cwd .. "/venv/bin/python"
	elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
		return cwd .. "/.venv/bin/python"
	else
		return "python"
	end
end

return utils
