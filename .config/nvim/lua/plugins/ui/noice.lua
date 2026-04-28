return {
	{
		"rachartier/tiny-cmdline.nvim",
		init = function()
			vim.o.cmdheight = 0
			vim.g.tiny_cmdline = {
				-- Window position ("N%" = fraction of available space, integer = absolute columns/rows)
				position = {
					x = "50%", -- horizontal: "0%" = left, "50%" = center, "100%" = right
					y = "40%", -- vertical:   "0%" = top,  "50%" = center, "100%" = bottom
				},

				-- Horizontal offset of the completion menu anchor from the window's left inner edge
				-- Used to align blink.cmp / nvim-cmp menus with the cmdline window
				menu_col_offset = 2,

				-- Optional callback invoked after every reposition
				on_reposition = require("tiny-cmdline").adapters.blink,
			}
		end,
	},
}
