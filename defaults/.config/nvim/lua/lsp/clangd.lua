vim.lsp.config('clang', {
	name = "clang",
	cmd = { 'clangd' },
	filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
	root_markers = {
		'.clangd',
		'.clang-tidy',
		'.clang-format',
		'compile_commands.json',
		'compile_flags.txt',
		'configure.ac', -- AutoTools
		'.git',
	},
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-8', 'utf-16' },
	},
});
