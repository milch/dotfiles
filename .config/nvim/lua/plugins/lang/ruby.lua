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
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				solargraph = {
					root_dir = ruby_root,
				},
				rubocop = {
					root_dir = ruby_root,
				},
			},
		},
	},
}
