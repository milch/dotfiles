return {
	{
		"wojciech-kulik/xcodebuild.nvim",
		ft = { "objc", "swift" },
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				swift = { "swiftformat" },
			},
		},
	},
}
