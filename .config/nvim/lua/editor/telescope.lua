local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local custom_actions = {}

function custom_actions.fzf_multi_select(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local num_selections = table.getn(picker:get_multi_selection())

	if num_selections > 1 then
		actions.send_selected_to_qflist(prompt_bufnr)
		actions.open_qflist()
	else
		actions.file_edit(prompt_bufnr)
	end
end

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
		mappings = {
			i = {
				["<C-r>"] = actions.to_fuzzy_refine,
				["<C-i>"] = function(prompt_bufnr)
					local query = action_state:get_current_line()

					actions.close(prompt_bufnr)
					builtin.live_grep({
						default_text = query,
						additional_args = { "--no-ignore-vcs", "--hidden", "--glob", "!.git" },
					})
				end,

				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<cr>"] = custom_actions.fzf_multi_select,
			},
			n = {
				["<tab>"] = actions.toggle_selection + actions.move_selection_next,
				["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
				["<cr>"] = custom_actions.fzf_multi_select,
			},
		},
	},
})
require("telescope").load_extension("fzf")

local gitIfAvailable = function()
	local gitFolder = vim.api.nvim_call_function("finddir", { ".git", ";" })
	if gitFolder == "" then
		return builtin.find_files()
	else
		return builtin.git_files({ show_untracked = true })
	end
end

local find_all = function()
	return builtin.find_files({
		prompt_title = "All Files",
		hidden = true,
		no_ignore = false,
		find_command = { "rg", "--files", "--color", "never", "--glob", "!.git" },
	})
end

vim.keymap.set("n", "<leader>f", gitIfAvailable, {})
vim.keymap.set("n", "<leader>p", find_all, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
vim.keymap.set("n", "<leader>G", function()
	builtin.live_grep({
		additional_args = { "--no-ignore-vcs", "--hidden", "--glob", "!.git" },
	})
end, {})
vim.keymap.set("n", "<leader>b", builtin.buffers, {})

vim.keymap.set("n", "<leader>sb", builtin.git_bcommits, {})
vim.keymap.set("n", "<leader>sc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>ss", builtin.git_status, {})
