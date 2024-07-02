local function cmd(str)
	return "<cmd>lua " .. str .. "<CR>"
end

local bind = vim.keymap.set
local silentNoremap = { noremap = true, silent = true }
local extend = function(t1, t2)
	return vim.tbl_extend("keep", t1, t2)
end

local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

-- https://github.com/LazyVim/LazyVim/blob/a50f92f7550fb6e9f21c0852e6cb190e6fcd50f5/lua/lazyvim/util/plugin.lua#L60
local function lazy_file()
	local use_lazy_file = vim.fn.argc(-1) > 0

	-- Add support for the LazyFile event
	local Event = require("lazy.core.handler.event")

	if use_lazy_file then
		-- We'll handle delayed execution of events ourselves
		Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
		Event.mappings["User LazyFile"] = Event.mappings.LazyFile
	else
		-- Don't delay execution of LazyFile events, but let lazy know about the mapping
		Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
		Event.mappings["User LazyFile"] = Event.mappings.LazyFile
		return
	end

	local events = {} ---@type {event: string, buf: number, data?: any}[]

	local done = false
	local function load()
		if #events == 0 or done then
			return
		end
		done = true
		vim.api.nvim_del_augroup_by_name("lazy_file")

		---@type table<string,string[]>
		local skips = {}
		for _, event in ipairs(events) do
			skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
		end

		vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
		for _, event in ipairs(events) do
			if vim.api.nvim_buf_is_valid(event.buf) then
				Event.trigger({
					event = event.event,
					exclude = skips[event.event],
					data = event.data,
					buf = event.buf,
				})
				if vim.bo[event.buf].filetype then
					Event.trigger({
						event = "FileType",
						buf = event.buf,
					})
				end
			end
		end
		vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
		events = {}
	end

	-- schedule wrap so that nested autocmds are executed
	-- and the UI can continue rendering without blocking
	load = vim.schedule_wrap(load)

	vim.api.nvim_create_autocmd(lazy_file_events, {
		group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
		callback = function(event)
			table.insert(events, event)
			load()
		end,
	})
end

lazy_file()

bind("n", "<leader>l", function()
	require("lazy").home()
end, extend(silentNoremap, { desc = "Show lazy plugin manager" }))

local specs = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = require("ui.catppuccin"),
		init = function()
			require("ui.use_system_theme").ChangeToSystemColor("startup")
		end,
	},
	-- Languages
	"milch/vim-fastlane",
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
	},

	-- Editor
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = require("editor.nvim-treesitter"),
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"RRethy/nvim-treesitter-endwise",
			"windwp/nvim-ts-autotag",
			{
				"romgrk/nvim-treesitter-context",
				event = "WinScrolled",
				opts = require("editor.nvim-treesitter-context"),
				dependencies = { "nvim-treesitter/nvim-treesitter" },
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},

	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = {},
	},

	{
		"numToStr/Comment.nvim",
		keys = { "gc", "gb", { "gc", mode = "v" }, { "gb", mode = "v" }, "gcc", "gbc" },
		opts = {},
	},
	{
		"romainl/vim-cool",
		keys = { "/", "*", "#" },
	},
	{
		"tpope/vim-projectionist",
		config = function()
			require("editor.projectionist")
		end,
	},
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter", "TermEnter", "CursorMoved" },
		opts = {
			bs = { space = "balance", indent_ignore = true, single_delete = true },
			cr = { autoclose = true },
			close = { enable = true },
			fastwarp = {
				multi = true,
				{},
				{
					faster = true,
					map = "<C-A-e>",
					cmap = "<C-A-e>",
				},
			},
			tabout = { enable = true, hopout = true },
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
		},
		cmd = "Telescope",
		config = function()
			require("editor.telescope")
		end,
		keys = {
			{ "<leader>f" },
			{ "<leader>g" },
			{ "<leader>G" },
			{ "<leader>b" },
			{ "<leader>p" },
			{ "<leader>sb" },
			{ "<leader>sc" },
			{ "<leader>ss" },
		},
	},

	-- UI

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin",
		},
		config = function()
			require("ui.nvim-tree").configure_tree(true)
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin",
		},
		config = function()
			require("ui.lualine")
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ui.indent-blankline")
		end,
		event = { "LazyFile" },
		dependencies = {
			"catppuccin",
		},
	},

	{
		"kevinhwang91/nvim-ufo",
		event = { "LazyFile" },
		dependencies = {
			"kevinhwang91/promise-async",
			{
				"luukvbaal/statuscol.nvim",
				config = function()
					require("ui.statuscol")
				end,
			},
		},
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			bind("n", "zR", cmd([[require("ufo").openAllFolds()]]), { desc = "Open all folds" })
			bind("n", "zM", cmd([[require("ufo").closeAllFolds()]]), { desc = "Close all folds" })
		end,
		opts = require("ui.nvim-ufo"),
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "LazyFile" },
		opts = {
			numhl = true,
		},
	},

	-- Completion
	{
		"VonHeikemen/lsp-zero.nvim",
		event = { "LazyFile" },
		branch = "v3.x",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		init = function()
			vim.opt.updatetime = 50
		end,
		config = function()
			require("completion.lsp-zero")
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"mfussenegger/nvim-dap",
		},
		ft = "rust",
		config = function()
			require("lang.rust")
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		keys = { "<leader>xd" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			require("editor.debugging")
		end,
	},

	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
		},
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets", "andys8/vscode-jest-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			require("completion.nvim-cmp")
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		opts = {
			lightbulb = {
				sign = false,
			},
			finder = {
				keys = {
					toggle_or_open = "<CR>",
					quit = { "q", "<ESC>" },
				},
			},
			diagnostic = {
				keys = {
					quit = { "q", "<ESC>" },
				},
			},
			rename = {
				keys = {
					quit = { "<C-c>" },
				},
			},
			code_action = {
				keys = {
					quit = { "q", "<ESC>" },
				},
			},
		},
		event = "LspAttach",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
		keys = {
			{ "[n", ":Lspsaga diagnostic_jump_next<CR>", silent = true },
			{ "[p", ":Lspsaga diagnostic_jump_prev<CR>", silent = true },
			{ "<leader>a", ":Lspsaga code_action<CR>" },
		},
	},
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			progress = {
				display = {
					format_message = function(msg)
						if
							msg.title == "diagnostics_on_open"
							or msg.title == "diagnostics"
							or msg.title == "code_action"
						then
							return nil
						end

						return require("fidget.progress.display").default_format_message(msg)
					end,
				},
			},
		},
	},
	{
		"gelguy/wilder.nvim",
		dependencies = {
			{ "romgrk/fzy-lua-native" },
		},
		event = { "CmdlineEnter" },
		build = ":UpdateRemotePlugins",
		config = function()
			require("completion.wilder")
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		opts = {
			hint_enable = false,
		},
		event = { "VeryLazy" },
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonLog", "MasonUpdate" },
		opts = {
			ensure_installed = {
				"cfn_lint",
				"eslint_d",
				"fish_indent",
				"flake8",
				"jsonlint",
				"markdown_lint",
				"markdownlint",
				"prettier",
				"prettierd",
				"rubocop",
				"shellcheck",
				"shfmt",
				"stylua",
				"swift_format",
				"yamlfmt",
				"yamllint",
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = require("editor.nvim-lint").events,
		config = function()
			require("editor.nvim-lint").setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function()
			require("editor.conform")
		end,
	},

	-- Utils
	{
		"pocco81/auto-save.nvim",
		event = { "LazyFile" },
		config = function()
			require("auto-save").setup({
				-- Only trigger when changing files. The default is annoying with linters
				-- that trigger on file save, as it makes it impossible to make some
				-- types of changes (e.g. add empty lines)
				trigger_events = { "FocusLost", "BufLeave" },
			})
			-- Something is causing the trigger events above to be ignored
			-- until AS is toggled off and on again
			require("auto-save").off()
			require("auto-save").on()
		end,
	},

	{
		-- Automatically set the indent width based on what is already used in the file
		"tpope/vim-sleuth",
		event = { "LazyFile" },
	},

	{
		"anuvyklack/hydra.nvim",
		lazy = true,
		keys = { "<leader>xg" },
		config = function()
			require("util.hydra")
		end,
	},

	{
		"kevinhwang91/nvim-hlslens",
		keys = {
			"/",
			{
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Go to next search result",
			},
			{
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'Nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]],
				desc = "Go to previous search result",
			},
			{
				"*",
				[[*zz<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Find word under cursor",
			},
			{
				"#",
				[[#zz<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Find word under cursor before current position",
			},
			{
				"g*",
				[[g*zz<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Find word under cursor, including partial matches",
			},
			{
				"g#",
				[[g#zz<Cmd>lua require('hlslens').start()<CR>]],
				desc = "Find word under cursor before current position, including partial matches",
			},
		},
		opts = {},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},

	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			auto_resize_height = true,
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			auto_open = false, -- automatically open the list when you have diagnostics
			auto_close = true, -- automatically close the list when you have no diagnostics
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			-- recommended mappings
			-- resizing splits
			-- these keymaps will also accept a range,
			-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
			vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
			vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)
			-- moving between splits
			vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
			-- swapping buffers between windows
			vim.keymap.set("n", "<A-S-h>", require("smart-splits").swap_buf_left)
			vim.keymap.set("n", "<A-S-j>", require("smart-splits").swap_buf_down)
			vim.keymap.set("n", "<A-S-k>", require("smart-splits").swap_buf_up)
			vim.keymap.set("n", "<A-S-l>", require("smart-splits").swap_buf_right)
		end,
	},

	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		lazy = true,
		opts = {},
	},

	{
		"mbbill/undotree",
		keys = {
			"<leader>u",
		},
		cmd = { "UndotreeToggle" },
		config = function()
			require("util.undotree")
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		keys = {
			{
				"<leader>Hr",
				cmd([[require("harpoon"):list:remove()]]),
				desc = "Remove file from Harpoon quick menu",
			},

			{ "<leader>Ha", cmd([[require("harpoon"):list():append()]]), desc = "Add file to Harpoon quick menu" },
			{
				"<leader>h",
				cmd([[
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				]]),
				desc = "Toggle harpoon quick menu",
			},
			{
				"<M-n>", -- Right hand
				cmd([[ require("harpoon"):list():select(1) ]]),
				desc = "Go to harpoon file #1",
			},
			{
				"<M-e>", -- Right hand
				cmd([[ require("harpoon"):list():select(2) ]]),
				desc = "Go to harpoon file #2",
			},
			{
				"<M-i>", -- Right hand
				cmd([[ require("harpoon"):list():select(3) ]]),
				desc = "Go to harpoon file #3",
			},
			{
				"<M-o>", -- Right hand
				cmd([[ require("harpoon"):list():select(4) ]]),
				desc = "Go to harpoon file #4",
			},
		},
		config = function()
			require("util.harpoon").setup()
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			integration = {
				diffview = true,
			},
		},
		cmd = { "Neogit" },
	},
	{
		"stevearc/resession.nvim",
		init = function()
			local should_load = function()
				if vim.fn.argc(-1) ~= 0 then
					return false
				end
				local args = {}
				for _, arg in pairs(vim.v.argv) do
					-- Commands like +Man!
					local is_cmd = string.find(arg, "^+")
					-- ARGF
					local is_argf = string.find(arg, "^-$")
					if arg ~= "nvim" and arg ~= "--embed" or is_cmd or is_argf then
						args[#args + 1] = arg
					end
				end
				if #args == 0 then
					return true
				end
			end
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if should_load() then
						require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = false })
					end
				end,
				nested = true,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					-- We called it with truly empty args or a file/dir
					if should_load() or vim.fn.argc(-1) ~= 0 then
						require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
					end
				end,
			})
		end,
		opts = {
			autosave = {
				enabled = true,
				interval = 60,
				notify = false,
			},
		},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>od", ":ObsidianToday<CR>" },
			{ "<leader>oo", ":ObsidianOpen<CR>" },
			{ "<leader>ob", ":ObsidianBacklinks<CR>" },
			{ "<leader>ot", ":ObsidianTemplate<CR>" },
			{ "<leader>oqs", ":ObsidianQuickSwitch<CR>" },
			{ "<leader>of", ":ObsidianSearch<CR>" },
			{ "<leader>op", ":ObsidianPasteImg<CR>" },
			{ "<leader>ol", ":ObsidianLinkNew<CR>" },
			{ "<leader>f", ":ObsidianQuickSwitch<CR>" },
		},
		opts = {
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
		},
		cond = function()
			local normalized_obsidian_vault = vim.fs.normalize("~/Notes/")
			local normalized_path = vim.fs.normalize(vim.fn.getcwd())
			return normalized_path:sub(1, #normalized_obsidian_vault) == normalized_obsidian_vault
		end,
		init = function()
			vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
				group = vim.api.nvim_create_augroup("obsidian", { clear = true }),
				callback = function()
					local opts = { noremap = true, silent = true, buffer = true }
					vim.keymap.set("n", "<leader>f", ":ObsidianQuickSwitch<CR>", opts)
					vim.opt_local.conceallevel = 2
				end,
			})
		end,
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			plugins = {
				tmux = { enabled = true },
			},
		},
	},
}

local loaded, local_specs = pcall(require, "local")
if loaded then
	for i = 1, #local_specs do
		table.insert(specs, local_specs[i])
	end
end

return specs
