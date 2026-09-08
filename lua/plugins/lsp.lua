return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},

	config = function()
		-- inline errors
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 2 },
			signs = true,
			underline = true,
			--update_in_insert = true, -- Real-time errors as you type
			severity_sort = true,
		})

		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"basedpyright",
				"emmet_language_server",
			},
		})

		vim.lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "basic",
						diagnosticSeverityOverrides = {
							reportAny = "none",
							reportUnknownMemberType = "none",
							reportUnknownVariableType = "none",
							reportUnknownArgumentType = "none",
							reportAttributeAccessIssue = "none",
						},
					},
				},
			},
		})

		-- Override the default settings provided by nvim-lspconfig
		vim.lsp.config("emmet_language_server", {
			filetypes = {
				"css",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"pug",
				"typescriptreact",
			},
			init_options = {
				showExpandedAbbreviation = "always",
				showAbbreviationSuggestions = true,
				showSuggestionsAsSnippets = false,
			},
		})

		-- Enable the server so it attaches to Python files
		vim.lsp.enable("emmet_language_server")
		vim.lsp.enable("basedpyright")
		vim.lsp.enable("lua_ls")
		vim.lsp.enable("clangd")

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("my.lsp", {}),
			callback = function(ev)
				local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

				-- Auto-format ("lint") on save.
				-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
				if
					not client:supports_method("textDocument/willSaveWaitUntil")
					and client:supports_method("textDocument/formatting")
				then
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
						buffer = ev.buf,
						callback = function()
							vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
						end,
					})
				end
			end,
		})
	end,
}
