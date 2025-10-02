return {
	{

		"goolord/alpha-nvim",
		dependencies = {
			"nvim-mini/mini.icons",
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
				dashboard.button("<Space>", "󰈞  Find file", "<cmd>lua require('fff').find_files()<CR>"),
				dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
				dashboard.button("m", "󱌢 " .. " Mason", "<cmd>Mason <cr>"),
				dashboard.button("l", "󰒲 " .. " Lazy", "<cmd>Lazy <cr>"),
				dashboard.button("q", " " .. " Quit", "<cmd>qa <cr>"),
				-- stylua: ignore end
			}

			table.insert(theta.config.layout, { type = "padding", val = 2 })
			-- helper function for utf8 chars
			local function getCharLen(s, pos)
				local byte = string.byte(s, pos)
				if not byte then
					return nil
				end
				return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
			end

			local function applyColors(logo, colors, logoColors)
				theta.header.val = logo

				for key, color in pairs(colors) do
					local name = "Alpha" .. key
					vim.api.nvim_set_hl(0, name, color)
					colors[key] = name
				end

				theta.header.opts.hl = {}
				for i, line in ipairs(logoColors) do
					local highlights = {}
					local pos = 0

					for j = 1, #line do
						local opos = pos
						pos = pos + getCharLen(logo[i], opos + 1)

						local color_name = colors[line:sub(j, j)]
						if color_name then
							table.insert(highlights, { color_name, opos, pos })
						end
					end

					table.insert(theta.header.opts.hl, highlights)
				end
			end

			applyColors({
				[[  ███       ███  ]],
				[[  ████      ████ ]],
				[[  ████     █████ ]],
				[[ █ ████    █████ ]],
				[[ ██ ████   █████ ]],
				[[ ███ ████  █████ ]],
				[[ ████ ████ ████ ]],
				[[ █████  ████████ ]],
				[[ █████   ███████ ]],
				[[ █████    ██████ ]],
				[[ █████     █████ ]],
				[[ ████      ████ ]],
				[[  ███       ███  ]],
			}, {
				["b"] = { fg = "#3399ff", ctermfg = 33 },
				["a"] = { fg = "#53C670", ctermfg = 35 },
				["g"] = { fg = "#39ac56", ctermfg = 29 },
				["h"] = { fg = "#33994d", ctermfg = 23 },
				["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
				["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
				["k"] = { fg = "#30A572", ctermfg = 36 },
			}, {
				[[  kkkka       gggg  ]],
				[[  kkkkaa      ggggg ]],
				[[ b kkkaaa     ggggg ]],
				[[ bb kkaaaa    ggggg ]],
				[[ bbb kaaaaa   ggggg ]],
				[[ bbbb aaaaaa  ggggg ]],
				[[ bbbbb aaaaaa igggg ]],
				[[ bbbbb  aaaaaahiggg ]],
				[[ bbbbb   aaaaajhigg ]],
				[[ bbbbb    aaaaajhig ]],
				[[ bbbbb     aaaaajhi ]],
				[[ bbbbb      aaaaajh ]],
				[[  bbbb       aaaaa  ]],
			})

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
					if harpoon:list():length() ~= 0 then
						table.insert(theta.layout, 3, { type = "padding", val = 2 })
						table.insert(theta.layout, 4, section_harpoon)
					end
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					table.insert(theta.layout, { type = "padding", val = 1 })
					table.insert(theta.layout, {
						type = "text",
						val = "⚡ Neovim loaded "
							.. stats.loaded
							.. "/"
							.. stats.count
							.. " plugins in "
							.. ms
							.. "ms",
						opts = {
							hl = "NonText",
							position = "center",
						},
					})
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
