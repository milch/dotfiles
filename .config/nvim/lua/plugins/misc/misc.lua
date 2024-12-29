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
		opts = {},
	},

	{
		"echasnovski/mini.icons",
		lazy = true,
		config = function()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
		end,
	},

	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = {},
	},

	{
		"romainl/vim-cool",
		keys = { "/", "*", "#" },
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
			"echasnovski/mini.icons",
		},
		opts = {
			auto_open = false, -- automatically open the list when you have diagnostics
			auto_close = true, -- automatically close the list when you have no diagnostics
		},
		cmd = "Trouble",
		-- stylua: ignore
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xs", "<cmd>Trouble lsp_document_symbols toggle focus=false win.position=right<cr>", desc = "LSP Document Symbols (Trouble)" },
		},
	},
}
