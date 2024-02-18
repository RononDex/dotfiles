local utils = {
	neotree_open_before_debug = nil,
	autoclose_debug_windows = false,
	debugging = false,
}

function utils.is_editable()
	local current_buffer = vim.fn.bufnr("%")
	local is_modifiable = vim.api.nvim_buf_get_option(current_buffer, "modifiable")
	local is_readonly = vim.api.nvim_buf_get_option(current_buffer, "readonly")
	return is_modifiable and not is_readonly
end

function utils.start_debugger(autoclose_windows)
	if not utils.debugging then
		utils.debugging = true
		utils.autoclose_debug_windows = autoclose_windows
		if utils.is_editable() then
			vim.cmd("silent! wall")
		end

		local cwd = vim.fn.getcwd()
		local config_path = cwd .. "/.vscode/launch.json"
		if vim.fn.filereadable(config_path) then
			require("dap.ext.vscode").load_launchjs(config_path, {})
		end
	end
	require("dap").continue()
end

function utils.close_debugger()
	utils.debugging = false
	require("dapui").close()
	-- if not utils.is_neotree_open() and utils.neotree_open_before_debug == true then
	-- 	utils.neotree_open_before_debug = false
	-- 	vim.cmd("Neotree show")
	-- end
end

-- function utils.is_neotree_open()
-- 	local manager = require("neo-tree.sources.manager")
-- 	local renderer = require("neo-tree.ui.renderer")
-- 	local state = manager.get_state("filesystem")
-- 	local window_exists = renderer.window_exists(state)
-- 	return window_exists
-- end
