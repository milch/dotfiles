return {
	"rgroli/other.nvim",
	config = function(_, opts)
		require("other-nvim").setup(opts)
	end,
	opts_extend = { "mappings" },
	opts = {
		hooks = {
			onOpenFile = function(file, exists)
				-- Creates directories if they don't exist yet
				if not exists then
					local dirname = vim.fs.dirname(file)
					vim.fn.mkdir(dirname, "p")
				end
				return true
			end,
		},
	},
	keys = {
		{ "<leader>so", "<cmd>Other<CR>", silent = true, desc = "[S]witch to [O]ther file" },
	},
	cmd = { "Other", "OtherTabNew", "OtherSplit", "OtherVSplit" },
}
