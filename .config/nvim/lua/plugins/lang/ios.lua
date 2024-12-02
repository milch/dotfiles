return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			opts.servers.sourcekit = {}
		end,
	},
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
		"rgroli/other.nvim",
		opts = {
			mappings = {
				{
					pattern = "Sources/(.*).swift$",
					target = "Tests/%1Tests.swift",
					context = "test",
				},
				{
					pattern = "Tests/(.*)Tests.swift$",
					target = "Sources/%1.swift",
					context = "source",
				},
			},
		},
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
