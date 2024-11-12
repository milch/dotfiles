return {
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			select = {
				enabled = true,
				backend = "builtin",
				show_numbers = true,
				get_config = function(opts)
					if opts.kind == "codeaction" then
						return {
							backend = "builtin",
							builtin = {
								min_height = 0,
								max_width = 0.5,
								relative = "cursor",
								border = "none",
								show_numbers = true,
								buf_options = {},
								win_options = {
									cursorline = true,
									cursorlineopt = "both",
									number = true,
								},
								override = function(config)
									config.row = 1
									return config
								end,
							},
						}
					end
				end,
				format_item_override = {
					codeaction = function(kind)
						print(kind.action.kind)
						local symbols = {
							quickfix = { "󰁨", { link = "DiagnosticInfo" } },
							others = { "?", { link = "DiagnosticWarning" } },
							refactor = { "", { link = "DiagnosticWarning" } },
							["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
							["refactor.extract"] = { "", { link = "DiagnosticError" } },
							["refactor.rewrite"] = { "󰑕", { link = "DiagnosticError" } },
							["source.organizeImports"] = { "", { link = "TelescopeResultVariable" } },
							["source.fixAll"] = { "", { link = "TelescopeResultVariable" } },
							["source"] = { "", { link = "DiagnosticError" } },
							["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
							["codeAction"] = { "", { link = "DiagnosticError" } },
						}
						return string.format("%s%s", symbols[kind.action.kind][1] .. " ", kind.action.title)
					end,
				},
			},
		},
	},
	-- lazy.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		-- stylua: ignore
		keys = {
			{ "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
			{ "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
			{ "<leader>xn", "<cmd>Noice<CR>", desc = "Open Noice" },
		},
		opts = {
			views = {
				cmdline_popup = {
					position = {
						row = "40%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 8,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
	},
}
