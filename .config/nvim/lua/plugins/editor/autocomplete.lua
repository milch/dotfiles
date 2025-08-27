return {
	"saghen/blink.cmp",
	build = "cargo build --release",
	event = "InsertEnter",
	dependencies = {
		"xzbdmw/colorful-menu.nvim", -- Nice treesitter-based completion item formatting
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		signature = { enabled = true },
		completion = {
			documentation = { auto_show = true },
			ghost_text = {
				enabled = true,
			},
			menu = {
				draw = {
					-- We don't need label_description now because label and label_description are already
					-- combined together in label by colorful-menu.nvim.
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
			-- list = { selection = { auto_insert = true } },
		},
		keymap = {
			preset = "default",
			["<c-j>"] = { "select_next", "fallback" },
			["<c-k>"] = { "select_prev", "fallback" },

			["<C-b>"] = { "scroll_documentation_up" },
			["<C-f>"] = { "scroll_documentation_down" },

			["<C-n>"] = { "snippet_forward" },
			["<C-p>"] = { "snippet_backward" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {},
		},
		cmdline = {
			keymap = {
				preset = "inherit",
				["<Tab>"] = { "accept" },
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
			completion = { menu = { auto_show = true } },
		},
	},
	opts_extend = { "sources.default" },
}
