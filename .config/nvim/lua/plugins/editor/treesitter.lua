return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		event = { "LazyFile", "VeryLazy" },
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		dependencies = {
			"RRethy/nvim-treesitter-endwise",
			{
				"andymass/vim-matchup",
				init = function()
					vim.api.nvim_set_hl(0, "MatchWord", { underdashed = true })
					vim.api.nvim_set_hl(0, "MatchWordCur", { underdouble = true, bold = true })
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-context",
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
		},
		opts_extend = { "ensure_installed" },
		config = function(_, opts)
			local TS = require("nvim-treesitter")
			TS.setup(opts)

			local installed = TS.get_installed("parsers")
			local want = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, opts.ensure_installed)

			if #want > 0 then
				TS.install(want, { summary = true }):await(function()
					installed = TS.get_installed("parsers")
				end)
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local ft = ev.match
					local lang = vim.treesitter.language.get_lang(ft)
					if vim.tbl_contains(installed, lang) then
						vim.treesitter.start()
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-mini/mini.ai",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				keys = {
					-- stylua: ignore start
					{ "<leader>n", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end },
					{ "<leader>N", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")  end },

					{ "]f", function() require("nvim-treesitter-textobjects.move").goto_next("@function.outer", "textobjects")  end },
					{ "[f", function() require("nvim-treesitter-textobjects.move").goto_previous("@function.outer", "textobjects")  end },
					{ "]c", function() require("nvim-treesitter-textobjects.move").goto_next("@class.outer", "textobjects")  end },
					{ "[c", function() require("nvim-treesitter-textobjects.move").goto_previous("@class.outer", "textobjects")  end },
					{ "]a", function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")  end },
					{ "[a", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")  end },
					-- stylua: ignore end
				},
			},
		},
		event = "VeryLazy",
		config = function()
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				custom_textobjects = {
					f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
					c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
				},
				n_lines = 500,
			})
		end,
	},
}
