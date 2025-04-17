return {
	{
		"supermaven-inc/supermaven-nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"nvim-cmp",
		},
		opts = {
			-- For use with cmp
			disable_inline_completion = true,
		},
	},
	{
		"nvim-cmp",
		opts = function(_, opts)
			table.insert(opts.sources, { name = "supermaven", group_index = 1 })
		end,
	},
}
