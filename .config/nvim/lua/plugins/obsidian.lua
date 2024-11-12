local function filter_note_template(_, ctx)
	local templates_path = vim.fs.normalize("~/Notes/Templates/")
	local normalized_path = vim.fs.normalize(ctx.filename)
	local is_notes_path = normalized_path:sub(1, #templates_path) == templates_path
	return not is_notes_path
end

return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/Notes/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/Notes/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>od", "<cmd>ObsidianToday<CR>" },
			{ "<leader>oo", "<cmd>ObsidianOpen<CR>" },
			{ "<leader>ob", "<cmd>ObsidianBacklinks<CR>" },
			{ "<leader>ot", "<cmd>ObsidianTemplate<CR>" },
			{ "<leader>os", "<cmd>ObsidianQuickSwitch<CR>" },
			{ "<leader>of", "<cmd>ObsidianSearch<CR>" },
			{ "<leader>op", "<cmd>ObsidianPasteImg<CR>" },
			{ "<leader>ol", "<cmd>ObsidianLinkNew<CR>" },
		},
		opts = {
			ui = { enable = false },
			workspaces = {
				{
					name = "notes",
					path = "~/Notes/",
				},
			},
			daily_notes = {
				folder = "0 Inbox",
				template = "daily-note.md",
			},
			notes_subdir = "0 Inbox",
			follow_url_func = function(url)
				vim.fn.jobstart({ "open", url })
			end,
			completion = {
				min_chars = 1,
			},
			new_notes_location = "notes_subdir",

			--- @param title string
			note_id_func = function(title)
				print("Getting id for title: " .. title)
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

			---@param spec { id: string, dir: obsidian.Path, title: string|? }
			note_path_func = function(spec)
				if spec.title == nil then
					return spec.dir / tostring(spec.id)
				else
					return spec.dir / tostring(spec.title)
				end
			end,

			---@param opts {path: string, label: string, id: string|?}
			---@return string
			wiki_link_func = function(opts)
				local parent = vim.fs.basename(vim.fs.dirname(opts.path))
				local parts = vim.split(parent, " - ", { plain = true })
				if #parts > 1 then
					parent = parts[#parts]
				end
				if parent == "0 Inbox" then
					return string.format("[[%s|%s]]", opts.path, opts.label)
				end
				if opts.id == "Index" then
					return string.format("[[%s|%s]]", opts.path, parent)
				end
				if opts.label ~= opts.path then
					return string.format("[[%s|%s]]", opts.path, parent .. "/" .. opts.label)
				else
					return string.format("[[%s]]", opts.path)
				end
			end,
			note_frontmatter_func = function(note)
				local out = {
					id = note.id,
					aliases = note.aliases,
					tags = note.tags,
					created_date = os.date("%Y-%m-%d", os.time()),
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

			open_app_foreground = true,

			use_advanced_uri = true,

			mappings = {
				-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
				-- Toggle check-boxes.
				["<CR>"] = {
					action = function()
						return require("obsidian").util.toggle_checkbox()
					end,
					opts = { buffer = true },
				},
			},

			attachments = {
				img_folder = "Attachments",
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
		},
		init = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
				group = vim.api.nvim_create_augroup("obsidian", { clear = true }),
				callback = function()
					vim.opt_local.conceallevel = 2
				end,
			})
		end,
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
