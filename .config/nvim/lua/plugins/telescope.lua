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

return {
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
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local custom_actions = {}

		function custom_actions.fzf_multi_select(prompt_bufnr)
			local picker = action_state.get_current_picker(prompt_bufnr)
			local num_selections = table.getn(picker:get_multi_selection())

			if num_selections > 1 then
				actions.send_selected_to_qflist(prompt_bufnr)
				actions.open_qflist(prompt_bufnr)
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
						["<Up>"] = actions.cycle_history_prev,
						["<Down>"] = actions.cycle_history_next,
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

		-- TODO: Move to `keys`
		bind("n", "<leader>f", gitIfAvailable, { desc = "Find git files" })
		bind("n", "<leader>p", find_all, { desc = "Find all files" })
		bind("n", "<leader>g", function()
			builtin.live_grep({ additional_args = { "--hidden" } })
		end, { desc = "Live grep" })
		bind("v", "<leader>g", function()
			builtin.live_grep({ additional_args = { "--hidden" }, default_text = get_visual_selection() })
		end, { desc = "Live grep for visual selection" })
		bind("n", "<leader>G", function()
			builtin.live_grep({
				additional_args = { "--no-ignore-vcs", "--hidden", "--glob", "!.git" },
			})
		end, { desc = "Live grep, including hidden & ignored files" })
		bind("n", "<leader>b", builtin.buffers, { desc = "Find open buffers" })
	end,
	keys = {
		{ "<leader>f" },
		{ "<leader>g" },
		{ "<leader>G" },
		{ "<leader>b" },
		{ "<leader>p" },
	},
}
