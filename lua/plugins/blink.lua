return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"echasnovski/mini.snippets",
	},

	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = true },
		},
		signature = {
			enabled = true,
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		snippets = {
			preset = "mini_snippets",
		},
	},
	opts_extend = { "sources.default" },
}