vim.lsp.enable({ "solargraph", "rubocop" })

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
		"rgroli/other.nvim",
		opts = {
			mappings = {
				{
					pattern = "rails_root/(.*).rb$",
					target = "rails_root/spec/%1_spec.rb",
					context = "test",
				},
				{
					pattern = "rails_root/spec/(.*)_spec.rb$",
					target = "rails_root/lib/%1.rb",
					context = "source",
				},
				{
					pattern = "lib/(.*).rb$",
					target = "spec/%1_spec.rb",
					context = "test",
				},
				{
					pattern = "spec/(.*)_spec.rb$",
					target = "lib/%1.rb",
					context = "source",
				},
			},
		},
	},
}
