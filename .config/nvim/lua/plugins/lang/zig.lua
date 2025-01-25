return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = { zls = {} },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "zig" } },
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				zig = { "zigfmt" },
			},
		},
	},
}
