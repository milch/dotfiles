return {
	"lewis6991/gitsigns.nvim",
	event = { "LazyFile" },
	opts = {
		numhl = true,
	},
	keys = {
		{
			"]h",
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk()
				end)
				return "<Ignore>"
			end,
			{ expr = true, desc = "Go to next hunk" },
		},
		{
			"[h",
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk()
				end)
				return "<Ignore>"
			end,
			{ expr = true, desc = "Go to previous hunk" },
		},
		-- TODO: Find prefix
		-- { "s", ":Gitsigns stage_hunk<CR>", { silent = true } },
		-- { "u", gitsigns.undo_stage_hunk },
		-- { "S", gitsigns.stage_buffer },
		-- { "p", gitsigns.preview_hunk },
		-- { "x", gitsigns.toggle_deleted, { nowait = true } },
	},
}
