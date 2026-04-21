local function get_visual_selection()
	local _, ls, cs = unpack(vim.fn.getpos("v"))
	local _, le, ce = unpack(vim.fn.getpos("."))

	ls, le = math.min(ls, le), math.max(ls, le)
	cs, ce = math.min(cs, ce), math.max(cs, ce)

	return table.concat(vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {}), "\n")
end

return {
	{
		"dmtrKovalenko/fff.nvim",
		build = "nix run .#release",
		opts = {
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
		"folke/snacks.nvim",
		keys = {
			{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Search command history" },
			{ "<leader>/", function() Snacks.picker.search_history() end, desc = "Search search history" },
			{
				"<leader><leader>",
				function() Snacks.picker.grep({ hidden = true, exclude = { ".git" } }) end,
				desc = "Live grep",
			},
			{
				"<leader><leader>",
				function() Snacks.picker.grep({ hidden = true, search = get_visual_selection(), regex = false, live = false }) end,
				desc = "Live grep for visual selection",
				mode = "v",
			},
			{
				"<leader>sg",
				function() Snacks.picker.grep({ hidden = true, search = get_visual_selection(), regex = false, live = false }) end,
				desc = "Live grep for visual selection",
				mode = "v",
			},
			{ "<leader>sg", function() Snacks.picker.grep({ hidden = true }) end, desc = "Live grep" },
			{ "<leader>sh", function() Snacks.picker.help() end, desc = "Search help tags" },
			{
				"<leader>sa",
				function() Snacks.picker.files({ hidden = true, ignored = true, exclude = { ".git" } }) end,
				desc = "Find all files",
			},
			{
				"<leader>sf",
				function()
					if vim.fn.finddir(".git", ";") ~= "" then
						Snacks.picker.git_files({ untracked = true })
					else
						Snacks.picker.files()
					end
				end,
				desc = "Find git files",
			},
			{
				"<leader>sG",
				function() Snacks.picker.grep({ hidden = true, ignored = true, exclude = { ".git" } }) end,
				desc = "Live grep, including hidden & ignored files",
			},
			{ "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume previous picker" },
			{ "<leader>s'", function() Snacks.picker.registers() end, desc = "Find registers" },
			{ "<leader>li", function() Snacks.picker.lsp_incoming_calls() end, desc = "LSP incoming calls" },
			{ "<leader>lo", function() Snacks.picker.lsp_outgoing_calls() end, desc = "LSP outgoing calls" },
			{ "<leader>ld", function() Snacks.picker.lsp_symbols() end, desc = "LSP document symbols" },
			{ "<leader>ls", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
		},
	},
}
