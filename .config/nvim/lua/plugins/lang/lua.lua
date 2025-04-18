return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "lua", "luadoc" } },
	},
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "stylua", "lua_ls" } },
	},
	{
		"stevearc/conform.nvim",
		opts = { formatters_by_ft = { lua = { "stylua" } } },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},
}
