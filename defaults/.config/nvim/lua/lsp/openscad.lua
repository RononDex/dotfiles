vim.lsp.config('openscad', {
	name = "openscad_lsp",
	cmd = { 'openscad-lsp', '--stdio' },
	filetypes = { 'openscad' },
	root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
	settings = {
	},
	single_file_support = true
});

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('openscad.lsp', {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client.name == "openscad" then
			vim.keymap.set("n", "<F5>", exec_openscad, { buffer = args.buf })
		end
	end,
})

function exec_openscad()
	local jobCommand;
	local filename = '"' .. vim.fn.expand("%:p") .. '"'

	-- If Linux, just use basecommand, if on MacOS, use a special command
	if vim.fn.has('mac') == 1 then
		jobCommand = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ' .. filename
	else
		-- TODO: What about Windows?
		jobCommand = 'openscad ' .. filename .. ' --autocenter --viewall'
	end

	vim.fn.jobstart(jobCommand)
end
