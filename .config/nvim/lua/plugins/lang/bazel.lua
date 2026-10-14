vim.lsp.config("starpls", {
	cmd = { "starpls", "server", "--bazel_path", "bazelisk", "--experimental_infer_ctx_attributes" },
})

vim.lsp.enable("starpls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "starlark" } },
	},
}
