local cmd = {
	"roslyn",
	"--stdio",
	"--logLevel=Information",
	"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
}

local group = vim.api.nvim_create_augroup('lspconfig.roslyn_ls', { clear = true })

---@param client vim.lsp.Client
local function refresh_diagnostics(client)
	for buf, _ in pairs(vim.lsp.get_client_by_id(client.id).attached_buffers) do
		if vim.api.nvim_buf_is_loaded(buf) then
			client:request(
				vim.lsp.protocol.Methods.textDocument_diagnostic,
				{ textDocument = vim.lsp.util.make_text_document_params(buf) },
				nil,
				buf
			)
		end
	end
end

local function roslyn_handlers()
	return {
		['workspace/projectInitializationComplete'] = function(_, _, ctx)
			vim.notify('Roslyn project initialization complete', vim.log.levels.INFO, { title = 'roslyn_ls' })
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			refresh_diagnostics(client)
			return vim.NIL
		end,
		['workspace/_roslyn_projectNeedsRestore'] = function(_, result, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

			---@diagnostic disable-next-line: param-type-mismatch
			client:request('workspace/_roslyn_restore', result, function(err, response)
				if err then
					vim.notify(err.message, vim.log.levels.ERROR, { title = 'roslyn_ls' })
				end
				if response then
					for _, v in ipairs(response) do
						vim.notify(v.message, vim.log.levels.INFO, { title = 'roslyn_ls' })
					end
				end
			end)

			return vim.NIL
		end,
		['razor/provideDynamicFileInfo'] = function(_, _, _)
			vim.notify(
				'Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim',
				vim.log.levels.WARN,
				{ title = 'roslyn_ls' }
			)
			return vim.NIL
		end,
	}
end

vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})

vim.lsp.config("roslyn", {
	name = "roslyn",
	cmd = cmd,
	offset_encoding = 'utf-8',
	filetypes = {
		"razor",
		"cs",
	},
	commands = {
		['roslyn.client.completionComplexEdit'] = function(command, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			local args = command.arguments or {}
			local uri, edit = args[1], args[2]

			---@diagnostic disable: undefined-field
			if uri and edit and edit.newText and edit.range then
				local workspace_edit = {
					changes = {
						[uri.uri] = {
							{
								range = edit.range,
								newText = edit.newText,
							},
						},
					},
				}
				vim.lsp.util.apply_workspace_edit(workspace_edit, client.offset_encoding)
				---@diagnostic enable: undefined-field
			else
				vim.notify('roslyn_ls: completionComplexEdit args not understood: ' .. vim.inspect(args),
					vim.log.levels.WARN)
			end
		end,
	},
	handlers = roslyn_handlers(),
	capabilities = {
		-- HACK: Doesn't show any diagnostics if we do not set this to true
		textDocument = {
			diagnostic = {
				dynamicRegistration = true,
			},
		},
	},
	on_attach = function(client, bufnr)
		-- avoid duplicate autocmds for same buffer
		if vim.api.nvim_get_autocmds({ buffer = bufnr, group = group })[1] then
			return
		end

		vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
			group = group,
			buffer = bufnr,
			callback = function()
				refresh_diagnostics(client)
			end,
			desc = 'roslyn_ls: refresh diagnostics',
		})
	end,
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
