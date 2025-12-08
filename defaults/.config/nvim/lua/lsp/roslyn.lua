local cmd = {
	"roslyn",
	"--stdio",
	"--logLevel=Information",
	"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
}

vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})

vim.lsp.config("roslyn", {
	name = "roslyn",
	cmd = cmd,
	filetypes = {
		"razor",
		"cs",
	},
	root_markers = { '.git', '.sln', '.csproj' },
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,

			csharp_enable_inlay_hints_for_lambda_parameter_types = true,
			csharp_enable_inlay_hints_for_types = true,
			dotnet_enable_inlay_hints_for_indexer_parameters = true,
			dotnet_enable_inlay_hints_for_literal_parameters = true,
			dotnet_enable_inlay_hints_for_object_creation_parameters = true,
			dotnet_enable_inlay_hints_for_other_parameters = true,
			dotnet_enable_inlay_hints_for_parameters = true,
			dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
			dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		}
	},
})

-- HOTFIX: suppress noice errors
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs" },
	callback = function()
		vim.api.nvim_clear_autocmds({
			group = "noice_lsp_progress",
			event = "LspProgress",
			pattern = "*",
		})
	end,
})
