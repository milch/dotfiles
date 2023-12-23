local function cmd(str)
	return "<cmd>lua " .. str .. "<CR>"
end

local bind = vim.keymap.set
local silentNoremap = { noremap = true, silent = true }
local extend = function(t1, t2)
	return vim.tbl_extend("keep", t1, t2)
end

bind("n", "<leader>l", ":Lazy<CR>", extend(silentNoremap, { desc = "Show lazy plugin manager" }))

return {
	-- Languages
	{ "slashmili/alchemist.vim", ft = { "elixir" } },
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
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"romgrk/nvim-treesitter-context",
		event = "WinScrolled",
		opts = require("editor.nvim-treesitter-context"),
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		opts = {},
		keys = {
			{
				"<leader>re",
				":Refactor extract<CR>",
				mode = "v",
				noremap = true,
				silent = true,
				expr = false,
			},
		},
	},

	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
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
		event = { "InsertEnter", "CmdlineEnter" },
		opts = {},
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
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			text = {
				spinner = "dots",
			},
			sources = {
				["null-ls"] = {
					ignore = true,
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
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {
			func_map = {
				openc = "<CR>",
				open = "o",
			},
			auto_resize_height = true,
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		opts = {
			hint_enable = false,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("editor.mason-null-ls")
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
		"kshenoy/vim-signature",
		event = { "BufReadPost" },
	},
	{
		"tpope/vim-sleuth",
		event = { "BufReadPost" },
	},

	{
		"anuvyklack/hydra.nvim",
		config = function()
			require("util.hydra")
		end,
		keys = {
			"<leader>h",
			"<leader>rf",
		},
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
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"rouge8/neotest-rust",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-rust"),
				},
			})
		end,
		keys = {
			-- Run nearest test
			{ "<leader>tt", cmd('require("neotest").run.run()') },
			-- Run the current file
			{ "<leader>tf", cmd('require("neotest").run.run(vim.fn.expand("%"))') },
		},
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
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			auto_open = false, -- automatically open the list when you have diagnostics
			auto_close = true, -- automatically close the list when you have no diagnostics
		},
		cmd = { "TroubleToggle", "Trouble", "TroubleClose", "TroubleRefresh" },
		keys = {
			{ "<leader>d", ":TroubleToggle<CR>" },
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
			vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
			vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
			vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
			vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
		end,
	},

	{
		"phelipetls/vim-hugo",
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
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
}
