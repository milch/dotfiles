return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "c", "swift" } },
	},
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "clangd" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				sourcekit = {
					capabilities = {
						workspace = {
							didChangeWatchedFiles = {
								dynamicRegistration = true,
							},
						},
					},
				},
				clangd = {
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
				},
			},
		},
	},
}
