return {
	-- General
	{ "<C-p>",         function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
	{ "<leader><tab>", function() Snacks.picker.buffers() end,               desc = "Find open buffers" },
	{ "fg",            function() Snacks.picker.grep() end,                  desc = "Grep Files" },
	{ "<C-c>",         function() Snacks.picker.commands() end,              desc = "Commands" },

	-- LSP
	{ "gd",            function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
	{ "gD",            function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
	{ "gr",            function() Snacks.picker.lsp_references() end,        nowait = true,                           desc = "References" },
	{ "gu",            function() Snacks.picker.lsp_references() end,        nowait = true,                           desc = "References" },
	{ "gi",            function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
	{ "gy",            function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
	{ "gai",           function() Snacks.picker.lsp_incoming_calls() end,    desc = "C[a]lls Incoming" },
	{ "gao",           function() Snacks.picker.lsp_outgoing_calls() end,    desc = "C[a]lls Outgoing" },
	{ "<leader>ss",    function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
	{ "<leader>sS",    function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

	-- Explorer
	{ "<leader>bb",    function() Snacks.explorer.open() end,                desc = "Open file explorer" },
	{ "<leader>bf",    function() Snacks.explorer.reveal() end,              desc = "Reveal current file in explorer" },

	-- Diagnostics keybinds
	{ "<leader>dh",    function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
	{ "<leader>dd",    function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
}
