local cmp_kinds = {
	Text = "",
	Method = "",
	Function = "󰊕",
	Constructor = "󰎔",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

return {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer",
	},
	opts = function()
		local cmp = require("cmp")

		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "NonText", default = true })

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
		return {
			preselect = cmp.PreselectMode.None,
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(_, vim_item)
					if cmp_kinds[vim_item.kind] then
						vim_item.kind = cmp_kinds[vim_item.kind] .. "  "
					end

					return vim_item
				end,
			},
			window = {},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),

				["<CR>"] = cmp.mapping({
					i = function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						else
							fallback()
						end
					end,
				}),

				["<C-j>"] = cmp.mapping(function()
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				end, { "i", "c", "s" }),
				["<C-k>"] = cmp.mapping(function()
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				end, { "i", "c", "s" }),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "path" },
			}),
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
		}
	end,
}
