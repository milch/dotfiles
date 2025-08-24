return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		keys = {
			-- moving between splits
			{ "<C-h>", ":lua require('smart-splits').move_cursor_left()<CR>", silent = true },
			{ "<C-j>", ":lua require('smart-splits').move_cursor_down()<CR>", silent = true },
			{ "<C-k>", ":lua require('smart-splits').move_cursor_up()<CR>", silent = true },
			{ "<C-l>", ":lua require('smart-splits').move_cursor_right()<CR>", silent = true },
		},
	},
}
