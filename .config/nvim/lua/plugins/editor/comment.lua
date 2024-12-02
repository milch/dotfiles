return {
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "LazyFile", "VeryLazy" },
		opts = { enable_autocmd = false },
		init = function()
			local get_option = vim.filetype.get_option
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or get_option(filetype, option)
			end
		end,
	},
}