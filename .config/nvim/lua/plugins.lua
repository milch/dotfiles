local function cmd(str)
	return "<cmd>lua " .. str .. "<CR>"
end

local bind = vim.keymap.set
local silentNoremap = { noremap = true, silent = true }
local extend = function(t1, t2)
	return vim.tbl_extend("keep", t1, t2)
end

bind("n", "<leader>l", function()
	require("lazy").home()
end, extend(silentNoremap, { desc = "Show lazy plugin manager" }))

local specs = {
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
		event = { "BufReadPost", "BufNewFile" },
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

			vim.treesitter.language.register("html", "htmlhugo")
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
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = require("ui.catppuccin"),
		init = function()
			require("ui.use_system_theme").ChangeToSystemColor("startup")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin",
		},
		config = function()
			require("ui.nvim-tree").configure_tree(false)
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
		event = "BufReadPost",
		dependencies = {
			"catppuccin",
		},
	},

	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
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
		event = "BufReadPost",
		opts = {
			numhl = true,
		},
	},

	-- Completion
	{
		"VonHeikemen/lsp-zero.nvim",
		event = { "BufReadPost", "BufNewFile" },
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
		keys = { "<leader>x" },
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
		event = "BufReadPost",
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
		event = { "BufReadPost" },
	},

	{
		"anuvyklack/hydra.nvim",
		lazy = true,
	},

	{
		"kevinhwang91/nvim-hlslens",
		keys = {
			"/",
			{
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]],
				extend(silentNoremap, { desc = "Go to next search result" }),
			},
			{
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'Nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]],
				extend(silentNoremap, { desc = "Go to previous search result" }),
			},
			{
				"*",
				[[*zz<Cmd>lua require('hlslens').start()<CR>]],
				extend(silentNoremap, { desc = "Find word under cursor" }),
			},
			{
				"#",
				[[#zz<Cmd>lua require('hlslens').start()<CR>]],
				extend(silentNoremap, { desc = "Find word under cursor before current position" }),
			},
			{
				"g*",
				[[g*zz<Cmd>lua require('hlslens').start()<CR>]],
				extend(silentNoremap, { desc = "Find word under cursor, including partial matches" }),
			},
			{
				"g#",
				[[g#zz<Cmd>lua require('hlslens').start()<CR>]],
				extend(
					silentNoremap,
					{ desc = "Find word under cursor before current position, including partial matches" }
				),
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
		cmd = { "TroubleToggle", "Trouble", "TroubleClose", "TroubleRefresh" },
		keys = {
			{ "<leader>d", ":TroubleToggle<CR>", { desc = "Toggle Trouble window" } },
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
		"phelipetls/vim-hugo",
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
				{ desc = "Remove file from Harpoon quick menu" },
			},

			{ "<leader>Ha", cmd([[require("harpoon"):list():append()]]), { desc = "Add file to Harpoon quick menu" } },
			{
				"<leader>h",
				cmd([[
				require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				]]),
				{ desc = "Toggle harpoon quick menu" },
			},
		},
		config = function()
			require("util.harpoon")
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
		cmd = { "Neogit" },
	},
	{
		"stevearc/resession.nvim",
		event = "BufReadPre",
		init = function()
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					-- Only load the session if nvim was started with no args
					if vim.fn.argc(-1) == 0 then
						-- Save these to a different directory, so our manual sessions don't get polluted
						require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
					end
				end,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
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
}

local loaded, local_specs = pcall(require, "local")
if loaded then
	for i = 1, #local_specs do
		table.insert(specs, local_specs[i])
	end
end

return specs
