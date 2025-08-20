return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "LazyFile", "VeryLazy" },
	lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"RRethy/nvim-treesitter-endwise",
		{
			"andymass/vim-matchup",
			init = function()
				vim.api.nvim_set_hl(0, "MatchWord", { underdashed = true })
				vim.api.nvim_set_hl(0, "MatchWordCur", { underdouble = true, bold = true })
			end,
		},
		{
			"romgrk/nvim-treesitter-context",
			event = "WinScrolled",
			opts = {
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						"class",
						"function",
						"method",
						-- 'for', -- These won't appear in the context
						-- 'while',
						-- 'if',
						-- 'switch',
						-- 'case',
					},
					-- Example for a specific filetype.
					-- If a pattern is missing, *open a PR* so everyone can benefit.
					--   rust = {
					--       'impl_item',
					--   },
					ruby = {
						"module",
						"def",
					},
				},
				exact_patterns = {
					-- Example for a specific filetype with Lua patterns
					-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
					-- exactly match "impl_item" only)
					-- rust = true,
				},
			},
		},
	},
	opts = {
		-- One of "all", "maintained" (parsers with maintainers), or a list of languages
		ensure_installed = {
			"bash",
			"fish",
			"regex",
			"smithy",
			"vimdoc",
			"yaml",
		},

		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- Install languages synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- List of parsers to ignore installing
		ignore_install = {},

		endwise = {
			enable = true,
		},

		matchup = {
			enable = true,
		},

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- list of language that will be disabled
			---@diagnostic disable-next-line: unused-local
			disable = function(_lang, bufnr)
				local lines_cutoff = 10000
				local size_cutoff = 1024 * 500 -- 500kb
				local disable = vim.api.nvim_buf_line_count(bufnr) > lines_cutoff
					or vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr)) > size_cutoff
				return disable
			end,

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
		textobjects = {
			move = {
				enable = true,
				-- stylua: ignore start
				goto_next_start =     { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
				goto_next_end =       { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
				goto_previous_end =   { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
				-- stylua: ignore end
			},
			select = {
				enable = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["ip"] = "@parameter.inner",
					["ap"] = "@parameter.outer",
				},
				-- You can choose the select mode (default is charwise 'v')
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * method: eg 'v' or 'o'
				-- and should return the mode ('v', 'V', or '<c-v>') or a table
				-- mapping query_strings to modes.
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>n"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>N"] = "@parameter.inner",
				},
			},
		},
	},
	opts_extend = { "ensure_installed" },
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
