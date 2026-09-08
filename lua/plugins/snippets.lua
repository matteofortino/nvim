return {
	{
		"echasnovski/mini.snippets",
		version = "*",
		dependencies = {
			-- Snippet collection covering JS/TS, Python, Go, Rust, C++, Lua, HTML, etc.
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local mini_snippets = require("mini.snippets")

			mini_snippets.setup({
				snippets = {
					-- Automatically loads language snippets from runtime paths (friendly-snippets)
					mini_snippets.gen_loader.from_lang(),
				},
				mappings = {
					expand = "<C-j>", -- Expand snippet at cursor
					jump_next = "<C-l>", -- Jump to next snippet field
					jump_prev = "<C-h>", -- Jump to previous snippet field
					stop = "<C-c>", -- Stop snippet session
				},
			})
		end,
	},
}
