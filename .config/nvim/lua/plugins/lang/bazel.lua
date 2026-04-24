vim.lsp.config("starpls", {
	cmd = { "starpls", "server", "--experimental_infer_ctx_attributes" },
})

vim.lsp.enable("starpls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "starlark" } },
	},
}
