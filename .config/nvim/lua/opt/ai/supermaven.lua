return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		cmd = {
			"SupermavenUseFree",
			"SupermavenUsePro",
			"SupermavenStart",
			"SupermavenStatus",
			"SupermavenStop",
		},
		opts = {
			keymaps = {
				accept_suggestion = nil,
			},
			disable_inline_completion = true,
			ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
		},
		config = function(_, opts)
			-- HACK: Without nvim-cmp and inline completion disabled, supermaven logs
			-- a warning on startup, so we pretend there is a cmp module.
			package.loaded["cmp"] = {
				register_source = function() end,
			}
			require("supermaven-nvim").setup(opts)
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			{
				"supermaven-inc/supermaven-nvim",
			},
			{
				"huijiro/blink-cmp-supermaven",
			},
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			sources = {
				default = { "supermaven" },
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink-cmp-supermaven",
						async = true,
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.kind_icon = ""
								item.documentation = nil
							end
							return items
						end,
					},
				},
			},
		},
	},
}
