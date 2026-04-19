return {
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoQuickfix" },
		event = "LazyFile",
		opts = {
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--hidden",
				},
			},
		},
		config = function(_, opts)
			require("todo-comments").setup(opts)
			Snacks.picker.sources.todo = require("todo-comments.snacks").source
		end,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},
			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
			{
				"<leader>xT",
				"<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
				desc = "Todo/Fix/Fixme (Trouble)",
			},
			{
				"<leader>st",
				function() require("todo-comments.snacks").pick() end,
				desc = "Todo",
			},
			{
				"<leader>sT",
				function() require("todo-comments.snacks").pick({ keywords = { "TODO", "FIX", "FIXME" } }) end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},
}
