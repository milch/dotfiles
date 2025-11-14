local function filter_note_template(_, ctx)
	local templates_path = vim.fs.normalize("~/Notes/Templates/")
	local normalized_path = vim.fs.normalize(ctx.filename)
	local is_notes_path = normalized_path:sub(1, #templates_path) == templates_path
	return not is_notes_path
end

return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/Notes/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/Notes/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"folke/snacks.nvim",
				opts = {
					image = {
						--- @param path string
						--- @param src string
						resolve = function(path, src)
							if src:find("^https?://") then
								return src
							elseif require("obsidian.api").path_is_note(path) then
								return require("obsidian.api").resolve_image_path(src)
							end
						end,
					},
				},
			},
		},
		keys = {
			{ "<leader>od", "<cmd>Obsidian today<CR>" },
			{ "<leader>oo", "<cmd>Obsidian open<CR>" },
			{ "<leader>ob", "<cmd>Obsidian backlinks<CR>" },
			{ "<leader>ot", "<cmd>Obsidian template<CR>" },
			{ "<leader>os", "<cmd>Obsidian quick_switch<CR>" },
			{ "<leader>of", "<cmd>Obsidian search<CR>" },
			{ "<leader>op", "<cmd>Obsidian paste_img<CR>" },
			{ "<leader>ol", "<cmd>Obsidian link_new<CR>", mode = "v" },
		},
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/Notes/",
				},
			},
			notes_subdir = "0 Inbox",

			daily_notes = {
				folder = "0 Inbox",
				template = "daily-note.md",
			},
			completion = {
				min_chars = 1,
				nvim_cmp = false,
				blink = true,
			},
			new_notes_location = "notes_subdir",

			---@param title string|?
			---@return string
			note_id_func = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", "")
				else
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.date("%Y%m%d%H%M")) .. "-" .. suffix
			end,

			-- Optional, customize how note file names are generated given the ID, target directory, and title.
			-- note_path_func = function(spec)
			-- 	if spec.title == nil then
			-- 		return spec.dir / tostring(spec.id)
			-- 	else
			-- 		return spec.dir / tostring(spec.title)
			-- 	end
			-- end,

			wiki_link_func = function(opts)
				return require("obsidian.util").wiki_link_path_prefix(opts)
			end,

			frontmatter = {
				func = function(note)
					local out = {
						id = note.id,
						aliases = note.aliases,
						tags = note.tags,
						created_date = os.date("%Y-%m-%d"),
					}
					-- `note.metadata` contains any manually added fields in the frontmatter.
					-- So here we just make sure those fields are kept in the frontmatter.
					if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
						for k, v in pairs(note.metadata) do
							out[k] = v
						end
					end
					return out
				end,
			},

			-- Optional, for templates (see below).
			templates = {
				subdir = "Templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
				-- A map for custom variables, the key should be the variable and the value a function
				substitutions = {
					yesterday = function()
						return os.date("%Y-%m-%d", os.time() - 24 * 60 * 60)
					end,
					tomorrow = function()
						return os.date("%Y-%m-%d", os.time() + 24 * 60 * 60)
					end,
					today_alias = function()
						return tostring(os.date("%B %-d, %Y", os.time()))
					end,
				},
			},

			open = {
				use_advanced_uri = true,
				func = function(uri)
					vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
				end,
			},

			callbacks = {
				enter_note = function(note)
					vim.keymap.set("n", "<CR>", "<cmd>Obsidian toggle_checkbox<cr>", {
						buffer = note.bufnr,
						desc = "Toggle checkbox",
					})
					vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<cr>", {
						buffer = note.bufnr,
						desc = "Follow link",
					})
					vim.opt_local.conceallevel = 2
				end,
			},

			ui = { enable = false },

			attachments = {
				img_folder = "Attachments",
			},

			legacy_commands = false,

			footer = {
				enabled = false,
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				prettierd = {
					inherit = true,
					condition = filter_note_template,
				},
				prettier = {
					inherit = true,
					condition = filter_note_template,
				},
				markdownlint = {
					inherit = true,
					condition = filter_note_template,
				},
			},
		},
	},
}
