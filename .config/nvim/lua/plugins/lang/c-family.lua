vim.lsp.config("clangd", {
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
})

vim.lsp.enable("clangd")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "c", "swift" } },
	},
}
