return {
	{ "ryleelyman/latex.nvim", opts = {}, ft = { "markdown" } },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			latex = { enabled = false },
			win_options = { conceallevel = { rendered = 2 } },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "latex" } },
	},
}
