return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"tailwindcss-language-server",
			},
		},
	},
	{
		"nvim-cmp",
		dependencies = {
			{ "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
		},
		opts = function(_, opts)
			local format_kinds = opts.formatting.format
			opts.formatting.format = function(entry, item)
				format_kinds(entry, item) -- add icons
				return require("tailwindcss-colorizer-cmp").formatter(entry, item)
			end
		end,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		lazy = true,
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				tailwindcss = {
					init_options = {
						userLanguages = {
							-- Support completions in hugo html templates
							htmlhugo = "html",
							-- Defaults: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tailwindcss
							eelixir = "html-eex",
							eruby = "erb",
						},
					},
				},
			},
		},
	},
}
