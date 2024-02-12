local bind = vim.keymap.set

-- Make Y behave like D
bind("n", "Y", "y$", { noremap = true, desc = "Make Y behave like D" })

-- Working with buffers
bind("n", "<Tab>", ":bn<CR>", { silent = true, desc = "Open next buffer" })
bind("n", "<S-Tab>", ":bp<CR>", { silent = true, desc = "Open previous buffer" })
bind("n", "<leader>q", ":bd<CR>", { silent = true, desc = "Close current buffer" })

local function goto_buffer(num)
	-- Buffer numbers don't necessarily start at 1, and change as buffers get
	-- deleted. This goes to the first buffer listed, same order as `:ls`
	return function()
		local buffers = vim.api.nvim_list_bufs()
		local listed = vim.tbl_filter(function(val)
			return vim.fn.buflisted(val) == 1
		end, buffers)
		vim.api.nvim_set_current_buf(listed[num])
	end
end

bind("n", "<M-a>", goto_buffer(1), { desc = "Go directly to buffer 1" })
bind("n", "<M-r>", goto_buffer(2), { desc = "Go directly to buffer 2" })
bind("n", "<M-s>", goto_buffer(3), { desc = "Go directly to buffer 3" })
bind("n", "<M-t>", goto_buffer(4), { desc = "Go directly to buffer 4" })
bind("n", "<M-d>", goto_buffer(5), { desc = "Go directly to buffer 5" })

bind("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines up" })
bind("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selecetd lines down" })

bind("n", "J", "mzJ`zmz", { desc = "Join lines (keep cursor position the same)" })
bind("n", "<C-d>", "<C-d>zz", { desc = "Move one page down (keep cursor centered)" })
bind("n", "<C-u>", "<C-u>zz", { desc = "Move one page up (keep cursor centered)" })
bind("n", "<C-o>", "<C-o>zz", { desc = "Move to previous location (keep cursor centered)" })

bind("v", "<leader>p", [["_dP]], { desc = "Replace the selection with the paste buffer, preserve the buffer" })
bind({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
bind("n", "<leader>Y", [["+Y]], { desc = "Copy to system clipboard" })

bind("n", "<leader>w", [[:w<CR>]], { desc = "Save" })

bind(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Write :%s for the word under the cursor" }
)
bind(
	"x",
	"<leader>s",
	[[y:%s/\<<C-r>0\>/<C-r>0/gI<Left><Left><Left>]],
	{ desc = "Write :%s for the word under the cursor" }
)

bind("n", "<leader>c", function()
	local qf_exists = false
	for _, win in pairs(vim.fn.getwininfo()) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end

	if qf_exists then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, { desc = "Toggle quickfix list" })
