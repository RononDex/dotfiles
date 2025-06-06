local home = os.getenv("HOME")
local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local lsp_utils = require("lsp.utils")
local cache_vars = {}

local root_files = {
	'.git',
	'mvnw',
	'gradlew',
	'build.gradle',
}

local mason_dir = os.getenv("MASON")
local found_root_dir = require("jdtls.setup").find_root(root_files)
local root_dir = nil

if found_root_dir then
	root_dir = vim.fn.expand(found_root_dir)
end

local features = {
	-- change this to `true` to enable codelens
	codelens = true,

	-- change this to `true` if you have `nvim-dap`,
	-- `java-test` and `java-debug-adapter` installed
	debugger = true,
}

local function get_jdtls_paths()
	if cache_vars.paths then
		return cache_vars.paths
	end

	local path = {}

	path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

	local jdtls_install = vim.fs.joinpath(mason_dir, "/share/jdtls")

	path.java_agent = vim.fs.joinpath(jdtls_install ,'lombok.jar')
	path.launcher_jar = vim.fn.glob(vim.fs.joinpath(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar'))

	if vim.fn.has('mac') == 1 then
		path.platform_config = jdtls_install .. '/config_mac'
	elseif vim.fn.has('unix') == 1 then
		-- path.platform_config = jdtls_install .. '/config_linux'
		path.platform_config = jdtls_install .. '/config'
	elseif vim.fn.has('win32') == 1 then
		path.platform_config = jdtls_install .. '/config_win'
	end

	path.bundles = {}

	---
	-- Include java-test bundle if present
	---
	local java_test_path = vim.fs.joinpath(mason_dir, "/share/java-test")

	local java_test_bundle = vim.split(
		vim.fn.glob(java_test_path .. '/*.jar'),
		'\n'
	)

	if java_test_bundle[1] ~= '' then
		vim.list_extend(path.bundles, java_test_bundle)
	end

	---
	-- Include java-debug-adapter bundle if present
	---
	local java_debug_path = vim.fs.joinpath(mason_dir, "/share/java-debug-adapter")
	local java_debug_bundle = vim.split(
		vim.fn.glob(java_debug_path .. '/*.jar'),
		'\n'
	)

	if java_debug_bundle[1] ~= '' then
		vim.list_extend(path.bundles, java_debug_bundle)
	end

	---
	-- Useful if you're starting jdtls with a Java version that's
	-- different from the one the project uses.
	---
	path.runtimes = {
		-- Note: the field `name` must be a valid `ExecutionEnvironment`,
		-- you can find the list here:
		-- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		{
			name = "JavaSE-1.8",
			path = "/usr/lib/jvm/java-8-openjdk"
		},
		{
			name = "JavaSE-17",
			path = "/usr/lib/jvm/java-17-openjdk",
		},
		{
			name = "JavaSE-21",
			path = "/usr/lib/jvm/java-21-openjdk",
			default = true
		}
	}

	cache_vars.paths = path

	return path
end

local function enable_codelens(bufnr)
	pcall(vim.lsp.codelens.refresh)

	vim.api.nvim_create_autocmd('BufWritePost', {
		buffer = bufnr,
		group = java_cmds,
		desc = 'refresh codelens',
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})
end

local function enable_debugger(bufnr)
	require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end

local function jdtls_on_attach(client, bufnr)
	if features.debugger then
		enable_debugger(bufnr)
	end

	if features.codelens then
		enable_codelens(bufnr)
	end

	-- The following mappings are based on the suggested usage of nvim-jdtls
	-- https://github.com/mfussenegger/nvim-jdtls#usage

	local opts = { buffer = bufnr }
end

local function jdtls_setup(event)
	local jdtls = require('jdtls')

	local path = get_jdtls_paths()
	local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

	if cache_vars.capabilities == nil then
		jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
		jdtls.extendedClientCapabilities.onCompletionItemSelectedCommand = "editor.action.triggerParameterHints"

		local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
		cache_vars.capabilities = vim.tbl_deep_extend(
			'force',
			vim.lsp.protocol.make_client_capabilities(),
			ok_cmp and cmp_lsp.default_capabilities() or {}
		)
	end

	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	local cmd = {
		'java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-javaagent:' .. path.java_agent,
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens',
		'java.base/java.util=ALL-UNNAMED',
		'--add-opens',
		'java.base/java.lang=ALL-UNNAMED',
		'-jar',
		path.launcher_jar,
		'-configuration',
		path.platform_config,
		'-data',
		data_dir,
	}

	local lsp_settings = {
		java = {
			-- jdt = {
			--   ls = {
			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
			--   }
			-- },
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = 'interactive',
				runtimes = path.runtimes,
				saveActions = {
					organizeImports = true,
				}
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = 'all' -- literals, all, none
				}
			},
			format = {
				enabled = true,
				settings = {
					--   profile = 'asdf'
					url = home .. "/.config/nvim/eclipse-java-style.xml",
				},
			},
			saveActions = {
				organizeImports = true,
			}
		},
		signatureHelp = {
			enabled = true,
		},
		completion = {
			favoriteStaticMembers = {
				'org.hamcrest.MatcherAssert.assertThat',
				'org.hamcrest.Matchers.*',
				'org.hamcrest.CoreMatchers.*',
				'org.junit.Assert.*',
				'org.junit.jupiter.api.Assertions.*',
				'java.util.Objects.requireNonNull',
				'java.util.Objects.requireNonNullElse',
				'org.mockito.Mockito.*',
				'org.mockito.ArgumentMatchers.*'
			},
		},
		contentProvider = {
			preferred = 'fernflower',
		},
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			}
		},
		codeGeneration = {
			toString = {
				template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
			},
			useBlocks = true,
		},
	}

	local extendedClientCapabilities = jdtls.extendedClientCapabilities;


	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

	local jdtls_config = {
		name = "jdtls",
		cmd = cmd,
		root_markers = root_files,
		filetypes = { "java" },
		capabilities = cache_vars.capabilities,
		settings = lsp_settings,
		on_attach = function(client, bufnr)
			jdtls_on_attach()
			lsp_utils.default_on_attach(client, bufnr)
		end,
		flags = {
			allow_incremental_sync = true,
		},
		init_options = {
			bundles = path.bundles,
			extendedClientCapabilities = extendedClientCapabilities
		},
	}

	vim.lsp.config('jdtls', jdtls_config)
end


if root_dir then
	jdtls_setup()
end
