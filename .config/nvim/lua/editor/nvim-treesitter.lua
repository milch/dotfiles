return {
	-- One of "all", "maintained" (parsers with maintainers), or a list of languages
	ensure_installed = "all",

	-- Install languages synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing
	ignore_install = {},

	endwise = {
		enable = true,
	},

	autotag = {
		enable = true,
		filetypes = { "html", "htmlhugo" },
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
}
