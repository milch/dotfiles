local bind = vim.keymap.set
local silentNoremap = { noremap = true, silent = true }
local extend = function(t1, t2)
	return vim.tbl_extend("keep", t1, t2)
end

bind("n", "<leader>l", function()
	require("lazy").home()
end, extend(silentNoremap, { desc = "Show lazy plugin manager" }))

local specs = {
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},

	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = {},
	},

	{
		"romainl/vim-cool",
		keys = { "/", "*", "#" },
	},

	{
		-- Automatically set the indent width based on what is already used in the file
		"tpope/vim-sleuth",
		event = { "LazyFile" },
	},
}

return specs
