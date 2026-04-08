vim.lsp.enable("zls")

return {
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
