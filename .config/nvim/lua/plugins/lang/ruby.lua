local function ruby_root(startpath)
	-- If I used this directly in `opts` it would load lspconfig at startup
	local root_dir_func = require("lspconfig.util").root_pattern(".git", "Gemfile", "Rakefile", "Guardfile")
	return root_dir_func(startpath)
end

return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				ruby = { "rubocop" },
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "ruby" } },
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"rubocop",
				"solargraph",
				"ruby-lsp",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				solargraph = {
					root_dir = ruby_root,
					enabled = false,
				},
				rubocop = {
					root_dir = ruby_root,
				},
				ruby_lsp = {
					root_dir = ruby_root,
				},
			},
		},
	},
}
