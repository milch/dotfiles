return {
	{
		"nvim-cmp",
		dependencies = {
			{
				"garymjr/nvim-snippets",
				opts = {
					friendly_snippets = true,
				},
				dependencies = {
					"rafamadriz/friendly-snippets",
					"andys8/vscode-jest-snippets",
				},
			},
		},
		opts = function(_, opts)
			opts.snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			}
			table.insert(opts.sources, { name = "snippets", group_index = 2 })
		end,
		keys = {
			{
				"<C-n>",
				function()
					return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
			{
				"<C-p>",
				function()
					return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
		},
	},
}
