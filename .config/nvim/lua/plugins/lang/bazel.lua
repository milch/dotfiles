return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "starlark" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				starpls = {
					cmd = { "starpls", "server", "--experimental_infer_ctx_attributes" },
				},
			},
		},
	},
}
