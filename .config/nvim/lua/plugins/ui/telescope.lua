local bind = vim.keymap.set

local function get_visual_selection()
	local _, ls, cs = unpack(vim.fn.getpos("v"))
	local _, le, ce = unpack(vim.fn.getpos("."))

	-- nvim_buf_get_text requires start and end args be in correct order
	ls, le = math.min(ls, le), math.max(ls, le)
	cs, ce = math.min(cs, ce), math.max(cs, ce)

	local text = table.concat(vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {}), "\n")

	return text:gsub("([ %(%)])", "\\%1")
end

local function picker(kind, args)
	return function()
		local pickerOpts = args
		if type(args) == "function" then
			pickerOpts = args()
		end
		require("telescope.builtin")[kind](pickerOpts)
	end
end

local git_if_available = function()
	local gitFolder = vim.api.nvim_call_function("finddir", { ".git", ";" })
	if gitFolder == "" then
		return require("telescope.builtin").find_files()
	else
		return require("telescope.builtin").git_files({ show_untracked = true })
	end
end

local find_all = function()
	return require("telescope.builtin").find_files({
		prompt_title = "All Files",
		hidden = true,
		no_ignore = true,
		find_command = { "rg", "--files", "--color", "never", "--glob", "!.git" },
	})
end

return {
	{
		"dmtrKovalenko/fff.nvim",
		build = "nix run .#release",
		opts = { -- (optional)
			debug = {
				enabled = false,
			},
			layout = {
				preview_position = "top",
				prompt_position = "top",
				height = 0.5,
			},
			keymaps = {
				move_up = { "<C-k>" },
				move_down = { "<C-j>" },
				preview_scroll_up = "<C-b>",
				preview_scroll_down = "<C-f>",
			},
		},
		lazy = false,
		keys = {
			{
				"<leader><space>",
				function()
					require("fff").find_files()
				end,
				desc = "FFFind files",
			},
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
			local actions = require("telescope.actions")

			require("telescope").setup({
				pickers = {
					find_files = { theme = "dropdown" },
					git_files = { theme = "dropdown" },
					live_grep = { theme = "dropdown" },
					buffers = { theme = "dropdown" },
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					mappings = {
						i = {
							["<Up>"] = actions.cycle_history_prev,
							["<Down>"] = actions.cycle_history_next,
							["<C-r>"] = actions.to_fuzzy_refine,

							["<tab>"] = actions.toggle_selection + actions.move_selection_next,
							["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
							["<C-j>"] = {
								actions.move_selection_next,
								type = "action",
								opts = { nowait = true, silent = true },
							},
							["<C-k>"] = {
								actions.move_selection_previous,
								type = "action",
								opts = { nowait = true, silent = true },
							},
						},
						n = {
							["<tab>"] = actions.toggle_selection + actions.move_selection_next,
							["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
						},
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
		keys = {
			{
				"<leader>:",
				picker("command_history"),
				desc = "Search command history",
			},
			{
				"<leader>/",
				picker("search_history"),
				desc = "Search search history",
			},
			{
				"<leader><leader>",
				picker("live_grep", { additional_args = { "--hidden" } }),
				desc = "Live grep",
			},
			{
				"<leader><leader>",
				picker("live_grep", function()
					return {
						additional_args = { "--hidden" },
						default_text = get_visual_selection(),
					}
				end),
				desc = "Live grep for visual selection",
				mode = "v",
			},
			{
				"<leader>sg",
				picker("live_grep", function()
					return {
						additional_args = { "--hidden" },
						default_text = get_visual_selection(),
					}
				end),
				desc = "Live grep for visual selection",
				mode = "v",
			},
			{
				"<leader>sg",
				picker("live_grep", { additional_args = { "--hidden" } }),
				desc = "Live grep",
			},
			{
				"<leader>sh",
				picker("help_tags"),
				desc = "Search help tags",
			},
			{ "<leader>sa", find_all, desc = "Find all files" },
			{ "<leader>sf", git_if_available, desc = "Find git files" },
			{
				"<leader>sG",
				picker("live_grep", {
					additional_args = { "--no-ignore-vcs", "--hidden", "--glob", "!.git" },
				}),
				desc = "Live grep, including hidden & ignored files",
			},
			{ "<leader>sr", picker("resume"), desc = "Resume previous telescope" },
			{ "<leader>s'", picker("registers"), desc = "Find registers" },
			{ "<leader>li", picker("lsp_incoming_calls"), desc = "LSP incoming calls" },
			{ "<leader>lo", picker("lsp_outgoing_calls"), desc = "LSP outgoing calls" },
			{ "<leader>ld", picker("lsp_document_symbols"), desc = "LSP document symbols" },
			{ "<leader>ls", picker("lsp_workspace_symbols"), desc = "LSP workspace symbols" },
		},
	},
}
