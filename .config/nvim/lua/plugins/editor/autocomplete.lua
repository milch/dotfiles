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
	Supermaven = "",
}

return {
	"iguanacucumber/magazine.nvim",
	name = "nvim-cmp", -- Otherwise highlighting gets messed up
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{ "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
		{ "iguanacucumber/mag-buffer", name = "cmp-buffer" },
		{ "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
		{ "https://codeberg.org/FelipeLema/cmp-async-path" },
		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	},
	opts = function()
		local cmp = require("cmp")

		vim.api.nvim_set_hl(0, "CmpGhostText", { link = "NonText", default = true })

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline({
				["<C-j>"] = cmp.mapping(function()
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				end, { "i", "c", "s" }),
				["<C-k>"] = cmp.mapping(function()
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				end, { "i", "c", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "async_path" },
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
			mapping = cmp.mapping.preset.cmdline({
				["<C-j>"] = cmp.mapping(function()
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				end, { "i", "c", "s" }),
				["<C-k>"] = cmp.mapping(function()
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				end, { "i", "c", "s" }),
			}),
			sources = {
				{ name = "buffer" },
			},
		})
		return {
			preselect = cmp.PreselectMode.None,
			performance = {
				debounce = 0,
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					if cmp_kinds[vim_item.kind] then
						vim_item.kind = cmp_kinds[vim_item.kind] .. "  "
					end
					local highlights = {}

					-- you will likely not want to get this query every single time for performance but this is an example
					local query = vim.treesitter.query.get(vim.bo.filetype, "highlights")
					local str = vim_item.abbr

					local success, parser = pcall(vim.treesitter.get_string_parser, str, vim.bo.filetype)
					if success then
						local tree = parser:parse(true)[1]
						local root = tree:root()
						for id, node in query:iter_captures(root, str, 0, -1) do
							local name = "@" .. query.captures[id] .. "." .. vim.bo.filetype
							local hl = vim.api.nvim_get_hl_id_by_name(name)
							local range = { node:range() }
							local _, nscol, _, necol = range[1], range[2], range[3], range[4]

							table.insert(highlights, { hl, range = { nscol, necol } })
						end
					end

					vim_item.abbr_hl_group = highlights

					return vim_item
				end,
			},
			window = {},
			view = {
				entries = {
					follow_cursor = true,
				},
			},
			mapping = {
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

				["<C-d>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 8 }),
				["<C-u>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 8 }),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "async_path" },
				{ name = "nvim_lsp_signature_help" },
			}),
			experimental = {
				ghost_text = {
					hl_group = "CmpGhostText",
				},
			},
		}
	end,
}
