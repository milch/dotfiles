local M = {}

function M.setup()
	local harpoon = require("harpoon")

	harpoon:setup()

	harpoon:extend({
		UI_CREATE = function(cx)
			for i = 1, 9 do
				local strnum = tostring(i)
				vim.keymap.set("n", strnum, function()
					harpoon:list():select(i)
				end, { buffer = cx.bufnr, desc = "Directly open file #" .. strnum })
			end
			local update_display = function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end

			vim.keymap.set("n", "J", function()
				local position_pre = vim.api.nvim_win_get_cursor(0)
				local row = position_pre[1]
				local target = harpoon:list()["items"][row]
				if row < harpoon:list():length() then
					harpoon:list()["items"][row] = harpoon:list()["items"][row + 1]
					harpoon:list()["items"][row + 1] = target
					update_display()
					vim.api.nvim_win_set_cursor(0, { row + 1, position_pre[2] })
				end
			end, { buffer = cx.bufnr, desc = "Move item down in the list" })
			vim.keymap.set("n", "K", function()
				local position_pre = vim.api.nvim_win_get_cursor(0)
				local row = position_pre[1]
				if row > 0 then
					local target = harpoon:list()["items"][row]
					harpoon:list()["items"][row] = harpoon:list()["items"][row - 1]
					harpoon:list()["items"][row - 1] = target
					update_display()
					vim.api.nvim_win_set_cursor(0, { row - 1, position_pre[2] })
				end
			end, { buffer = cx.bufnr, desc = "Move item up in the list" })
			vim.keymap.set("n", "d", function()
				local position_pre = vim.api.nvim_win_get_cursor(0)
				harpoon:list():removeAt(position_pre[1])
				update_display()
				vim.api.nvim_win_set_cursor(0, { position_pre[1] - 1, position_pre[2] })
			end, { buffer = cx.bufnr, desc = "Remove the file the cursor is on" })
		end,
	})
end

return M
