return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	---@module 'catppuccin'
	---@type CatppuccinOptions
	opts = {
		float = {
			transparent = true,
			solid = false,
		},
		integrations = {
			cmp = true,
			lsp_trouble = true,
			blink_cmp = true,
			gitsigns = true,
			markdown = true,
			neotest = false,
			nvimtree = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			indent_blankline = {
				enabled = true,
				colored_indent_levels = true,
			},
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
		},
		custom_highlights = function(C)
			local darken = require("catppuccin.utils.colors").darken
			local error = C.red
			local warning = C.yellow
			local info = C.sky
			local hint = C.teal
			local darkening_percentage = 0.095

			return {
				LualineErrorHighlight = {
					bg = darken(error, darkening_percentage, C.base),
					fg = error,
				},
				LualineWarnHighlight = {
					bg = darken(warning, darkening_percentage, C.base),
					fg = warning,
				},
				LualineInfoHighlight = {
					bg = darken(info, darkening_percentage, C.base),
					fg = info,
				},
				LualineHintHighlight = {
					bg = darken(hint, darkening_percentage, C.base),
					fg = hint,
				},
			}
		end,
	},
	init = function()
		require("ui.use_system_theme").ChangeToSystemColor("startup")
	end,
}
