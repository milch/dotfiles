return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- set this if you want to always pull the latest change
		opts = {
			provider = "ollama",
			ollama = {
				endpoint = "http://localhost:11434",
				model = "deepseek-r1:32b",
			},
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.icons",
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
