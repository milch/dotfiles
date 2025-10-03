local bind = vim.keymap.set

bind("n", "<leader>xl", function()
	require("lazy").home()
end, { desc = "Show lazy plugin manager", silent = true, noremap = true })

return {
	{ "nvim-lua/plenary.nvim", lazy = true }, -- Everything uses plenary
	-- Editor
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {
			aliases = {
				["b"] = { ")", "]", "}" },
				["q"] = { '"', "'", "`" },
				["s"] = { "}", "]", ")", ">", '"', "'", "`" },
			},
		},
	},

	{
		"nvim-mini/mini.icons",
		lazy = true,
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
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
		dependencies = {
			"nvim-mini/mini.icons",
		},
		opts = {
			auto_open = false, -- automatically open the list when you have diagnostics
			auto_close = true, -- automatically close the list when you have no diagnostics
		},
		cmd = "Trouble",
		-- stylua: ignore
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                                         desc = "Diagnostics (Trouble)" },
			{ "<leader>xs", "<cmd>Trouble lsp_document_symbols toggle focus=false win.position=right<cr>", desc = "LSP Document Symbols (Trouble)" },
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				-- stylua: ignore
				callback = function()
					vim.g.snacks_animate = false

					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>as")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>aw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>aL")
					Snacks.toggle.diagnostics():map("<leader>ad")
					Snacks.toggle.line_number():map("<leader>al")
					Snacks.toggle.treesitter():map("<leader>aT")
					Snacks.toggle.inlay_hints():map("<leader>ah")
					Snacks.toggle.dim():map("<leader>aD")
				end,
			})
		end,
		---@module 'snacks'
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			image = {
				doc = {
					enabled = true,
					inline = true,
				},
				math = {
					enabled = true,
				},
			},
			quickfile = {},
			statuscolumn = { enabled = true },
		},
		-- stylua: ignore
		keys = {
			{ "<leader>xz",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
			{ "<leader>xZ",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
			{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@module 'flash'
		---@type Flash.Config
		opts = {
			search = {
				mode = "fuzzy",
			},
			jump = {
				-- Automatically jump if there is only one match
				autojump = true,
			},
			modes = {
				-- Disable flash for fFtT movements
				char = {
					enabled = false,
				},
			},
		},
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
}
