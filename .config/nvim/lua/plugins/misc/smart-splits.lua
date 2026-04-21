return {
	{
		"mrjones2014/smart-splits.nvim",
		keys = {
			-- moving between splits
			{ "<C-h>", ":lua require('smart-splits').move_cursor_left()<CR>", silent = true },
			{ "<C-j>", ":lua require('smart-splits').move_cursor_down()<CR>", silent = true },
			{ "<C-k>", ":lua require('smart-splits').move_cursor_up()<CR>", silent = true },
			{ "<C-l>", ":lua require('smart-splits').move_cursor_right()<CR>", silent = true },
		},
		opts = {
			at_edge = function(opts)
				if opts.mux == nil then
					-- Most likely in mistty -
					local dir_map = {
						left = "left",
						right = "right",
						up = "up",
						down = "down",
					}
					os.execute("mistty-cli pane focus --format quiet --direction " .. dir_map[opts.direction])
				end
			end,
		},
	},
}
