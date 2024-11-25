return {
	"altermo/ultimate-autopair.nvim",
	event = { "InsertEnter", "CmdlineEnter", "TermEnter", "CursorMoved" },
	opts = {
		bs = { space = "balance", indent_ignore = true, single_delete = true },
		cr = { autoclose = true },
		close = { enable = true },
		fastwarp = {
			multi = true,
			{},
			{
				faster = true,
				map = "<C-A-e>",
				cmap = "<C-A-e>",
			},
		},
		tabout = { enable = true, hopout = true },
	},
}
