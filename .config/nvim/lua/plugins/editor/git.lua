return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "LazyFile" },
		opts = {
			numhl = true,
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns
				local function map(l, r, desc, mode)
					if mode == nil then
						mode = "n"
					end
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end
				map("<leader>gs", gs.stage_hunk, "Stage hunk")
				map("<leader>gS", gs.stage_buffer, "Stage buffer")
				map("<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
				map("<leader>gP", gs.preview_hunk, "Preview hunk")
				map("<leader>gp", gs.preview_hunk_inline, "Preview hunk inline")
				map("<leader>gx", gs.toggle_deleted, "Show deleted lines")

				map("<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk", { "n", "v" })
				map("<leader>gR", gs.reset_buffer, "Reset buffer")

				-- stylua: ignore start
				map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
				map("<leader>gB", gs.blame, "Blame Buffer")
				map("<leader>gd", gs.diffthis, "Diff This")
				map("<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
				-- stylua: ignore end

				map("[h", gs.prev_hunk, "Previous Hunk")
				map("]h", gs.next_hunk, "Next Hunk")
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = {},
	},
}
