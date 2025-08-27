return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		cmd = {
			"SupermavenUseFree",
			"SupermavenUsePro",
		},
		opts = {
			keymaps = {
				accept_suggestion = nil,
			},
			disable_inline_completion = true,
			ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
		},
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
