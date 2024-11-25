return {
	{
		"mrjones2014/smart-splits.nvim",
		keys = {
			-- recommended mappings
			-- resizing splits
			-- these keymaps will also accept a range,
			-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
			-- TODO: Bindings conflict with Aerospace
			{ "<A-h>", ":lua require('smart-splits').resize_left()<CR>", silent = true },
			{ "<A-j>", ":lua require('smart-splits').resize_down()<CR>", silent = true },
			{ "<A-k>", ":lua require('smart-splits').resize_up()<CR>", silent = true },
			{ "<A-l>", ":lua require('smart-splits').resize_right()<CR>", silent = true },
			-- moving between splits
			{ "<C-h>", ":lua require('smart-splits').move_cursor_left()<CR>", silent = true },
			{ "<C-j>", ":lua require('smart-splits').move_cursor_down()<CR>", silent = true },
			{ "<C-k>", ":lua require('smart-splits').move_cursor_up()<CR>", silent = true },
			{ "<C-l>", ":lua require('smart-splits').move_cursor_right()<CR>", silent = true },
			-- swapping buffers between windows
			{ "<A-S-h>", ":lua require('smart-splits').swap_buf_left()<CR>", silent = true },
			{ "<A-S-j>", ":lua require('smart-splits').swap_buf_down()<CR>", silent = true },
			{ "<A-S-k>", ":lua require('smart-splits').swap_buf_up()<CR>", silent = true },
			{ "<A-S-l>", ":lua require('smart-splits').swap_buf_right()<CR>", silent = true },
		},
	},
}
