return {
	{
		"nvimtools/hydra.nvim",
		lazy = true,
		keys = { { "<leader>xg", { desc = "Git operations" } } },
		config = function()
			local Hydra = require("hydra")
			local gitsigns = require("gitsigns")

			local hint = [[
 _J_: next hunk      _s_: stage hunk        _x_: show deleted   _b_: blame line
 _K_: prev hunk      _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full
 _S_: stage buffer   _d_: diff this         _D_: close diff     _/_: show base file
 _R_: reset hunk
 ^
 ^ ^                                             _q_: exit
 ]]

			Hydra({
				hint = hint,
				config = {
					color = "pink",
					invoke_on_body = true,
					hint = {
						position = "bottom",
						border = "rounded",
					},
					on_enter = function()
						vim.bo.modifiable = false
						gitsigns.toggle_signs(true)
						gitsigns.toggle_linehl(true)
					end,
					on_exit = function()
						gitsigns.toggle_linehl(false)
						gitsigns.toggle_deleted(false)
						vim.cmd("echo") -- clear the echo area
					end,
				},
				mode = { "n", "x" },
				body = "<leader>xg",
				heads = {
					{
						"J",
						function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gitsigns.next_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true },
					},
					{
						"K",
						function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gitsigns.prev_hunk()
							end)
							return "<Ignore>"
						end,
						{ expr = true },
					},
					{ "s", ":Gitsigns stage_hunk<CR>", { silent = true } },
					{ "u", gitsigns.undo_stage_hunk },
					{ "S", gitsigns.stage_buffer },
					{ "p", gitsigns.preview_hunk },
					{ "x", gitsigns.toggle_deleted, { nowait = true } },
					{ "d", gitsigns.diffthis },
					{
						"D",
						function()
							vim.cmd("only")
						end,
					},
					{ "b", gitsigns.blame_line },
					{
						"B",
						function()
							gitsigns.blame_line({ full = true })
						end,
					},
					{ "/", gitsigns.show, { exit = true } }, -- show the base of the file
					{
						"R",
						function()
							vim.bo.modifiable = true
							gitsigns.reset_hunk()
							vim.bo.modifiable = false
						end,
					},
					{ "q", nil, { exit = true, nowait = true } },
				},
			})
		end,
	},
}
