return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "rust" } },
	},
	{
		"stevearc/conform.nvim",
		opts = { formatters_by_ft = { rust = { "rustfmt" } } },
	},
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "rustfmt" } },
	},
	{
		"simrat39/rust-tools.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"mfussenegger/nvim-dap",
		},
		ft = "rust",
		config = function()
			local codelldb_root = require("mason-registry").get_package("codelldb"):get_install_path()
			local liblldb_path = codelldb_root .. "/extension/lldb/lib/liblldb.dylib"

			require("mason-lspconfig").setup_handlers({
				["rust_analyzer"] = function()
					require("rust-tools").setup({
						server = {
							settings = {
								["rust-analyzer"] = {
									checkOnSave = {
										command = "clippy",
									},
								},
							},
						},
						dap = {
							adapter = require("rust-tools.dap").get_codelldb_adapter(
								vim.fn.exepath("codelldb"),
								liblldb_path
							),
						},
					})
				end,
			})
		end,
	},
}
