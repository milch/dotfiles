return {
	{

		"goolord/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons",
			"nvim-lua/plenary.nvim",
		},
		event = "VimEnter",
		enabled = true,
		init = false,
		opts = function()
			local dashboard = require("alpha.themes.dashboard")
			local theta = require("alpha.themes.theta")

			theta.buttons.val = {
				{ type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
				{ type = "padding", val = 1 },
				-- stylua: ignore start
				dashboard.button("e",  "  New file", "<cmd>ene <BAR> startinsert <CR>"),
				dashboard.button("rs", "󰁯  Load session", [[:lua require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })<CR>]]),
				dashboard.button("<Space>", "󰈞  Find file", "<cmd>Telescope find_files<CR>"),
				dashboard.button(",", "  Live grep", "<cmd>Telescope live_grep<CR>"),
				dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
				dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
				dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
				-- stylua: ignore end
			}

			table.insert(theta.config.layout, { type = "padding", val = 2 })
			return theta.config
		end,
		config = function(_, theta)
			require("alpha").setup(theta)
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "VeryLazy",
				callback = function()
					local harpoon = require("harpoon")
					local icons = require("mini.icons")
					local dashboard = require("alpha.themes.dashboard")

					local section_harpoon = {
						type = "group",
						val = {
							{ type = "text", val = "Pinned", opts = { hl = "SpecialComment", position = "center" } },
							{ type = "padding", val = 1 },
						},
					}

					local idx_to_shortcut = {
						"a",
						"r",
						"s",
						"t",
						"d",
					}
					for i = 1, harpoon:list():length(), 1 do
						local highlight = {}
						local item = harpoon:list():get(i)
						local ico, hl = icons.get("file", item.value)
						table.insert(highlight, { hl, 0, #ico })
						local button = dashboard.button(
							idx_to_shortcut[i],
							ico .. "  " .. item.value,
							"<cmd>e " .. vim.fn.fnameescape(item.value) .. " <CR>"
						)
						button.opts.hl = highlight

						local fn_start = item.value:match(".*[/\\]")
						if fn_start ~= nil then
							table.insert(highlight, { "Comment", #ico, #fn_start + #ico + 2 })
						end

						section_harpoon.val[#section_harpoon.val + 1] = button
					end
					table.insert(theta.layout, 3, { type = "padding", val = 2 })
					table.insert(theta.layout, 4, section_harpoon)
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
