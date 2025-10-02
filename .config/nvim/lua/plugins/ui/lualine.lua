return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-mini/mini.icons",
		"catppuccin",
	},
	config = function()
		-- Not needed since lualine reports this
		vim.opt.showmode = false

		local colors = {
			red = "#ca1243",
			grey = "#a0a1a7",
			black = "#383a42",
			white = "#f3f3f3",
			light_green = "#83a598",
			orange = "#fe8019",
			green = "#8ec07c",
		}
		local empty = require("lualine.component"):extend()
		function empty:draw(default_highlight)
			self.status = ""
			self.applied_separator = ""
			self:apply_highlights(default_highlight)
			self:apply_section_separators()
			return self.status
		end

		-- Put proper separators and gaps between components in sections
		local function process_sections(sections)
			for name, section in pairs(sections) do
				local is_left = name:sub(9, 10) < "x"
				if is_left then
					for pos = 1, name == "lualine_a" and #section or #section - 1 do
						table.insert(section, pos * 2, { empty, color = { fg = colors.black, bg = colors.black } })
					end
					for id, comp in ipairs(section) do
						if type(comp) ~= "table" then
							comp = { comp }
							section[id] = comp
						end
						comp.separator = { right = "" }
					end
				end
			end
			return sections
		end

		local function getWords()
			if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
				if vim.fn.wordcount().visual_words == 1 then
					return tostring(vim.fn.wordcount().visual_words) .. " word"
				elseif not (vim.fn.wordcount().visual_words == nil) then
					return tostring(vim.fn.wordcount().visual_words) .. " words"
				else
					return tostring(vim.fn.wordcount().words) .. " words"
				end
			else
				return ""
			end
		end

		require("lualine").setup({
			options = {
				theme = "catppuccin",
				ignore_focus = { "NvimTree", "TelescopePrompt" },
				icons_enabled = true,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = process_sections({
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
					},
				},
				lualine_b = {
					{
						require("plugins.ui.lualine.harpoon-component"),
						hide_filename_extension = true,
						symbols = {
							modified = " ●", -- Text to show when the buffer is modified
							alternate_file = "", -- Text to show to identify the alternate file
							directory = " ", -- Text to show when the buffer is a directory
						},
					},
				},
				lualine_c = {},

				lualine_x = {
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = {
					{
						getWords,
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						diagnostics_color = {
							error = "LualineErrorHighlight",
						},
						sections = { "error" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						diagnostics_color = {
							warn = "LualineWarnHighlight",
						},
						sections = { "warn" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						diagnostics_color = {
							info = "LualineInfoHighlight",
						},
						sections = { "info" },
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						diagnostics_color = {
							hint = "LualineHintHighlight",
						},
						sections = { "hint" },
					},
				},
				lualine_z = {
					"filetype",
					"%l:%c",
				},
			}),
		})
	end,
}
