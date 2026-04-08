vim.lsp.enable("lua_ls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "lua", "luadoc" } },
	},
	{
		"stevearc/conform.nvim",
		opts = { formatters_by_ft = { lua = { "stylua" } } },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				default = { "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- show at a higher priority than lsp
					},
				},
			},
		},
	},
}
