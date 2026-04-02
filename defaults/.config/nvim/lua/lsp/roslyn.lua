local lsp_utils = require("lsp.utils")

local group = vim.api.nvim_create_augroup('lspconfig.roslyn_ls', { clear = true })

vim.lsp.config("roslyn", {
	on_attach = function(client, bufnr)
		lsp_utils.default_on_attach(client, bufnr)
		-- avoid duplicate autocmds for same buffer
		if vim.api.nvim_get_autocmds({ buffer = bufnr, group = group })[1] then
			return
		end
	end,
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
			dotnet_enable_tests_code_lens = true,
		},
		["csharp|formatting"] = {
			dotnet_organize_imports_on_format = true,
		},
		['csharp|completion'] = {
			dotnet_show_name_completion_suggestions = true,
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_provide_regex_completions = true,
		},
		['csharp|symbol_search'] = {
			dotnet_search_reference_assemblies = true,
		},
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
