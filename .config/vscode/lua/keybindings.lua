local bind = vim.keymap.set

-- Make Y behave like D
bind("n", "Y", "y$", { noremap = true, desc = "Make Y behave like D" })

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

bind("x", "gc", "<Plug>VSCodeCommentary")
bind("n", "gc", "<Plug>VSCodeCommentary")
bind("o", "gc", "<Plug>VSCodeCommentary")
bind("n", "gcc", "<Plug>VSCodeCommentaryLine")

-- TODO
local opts = { silent = true }
bind("x", "gf", ":LspZeroFormat<CR>", opts)
bind("v", "gf", ":LspZeroFormat<CR>", opts)
bind("n", "gf", ":LspZeroFormat<CR>", opts)

bind("n", "<leader>rn", ":Lspsaga rename<CR>", opts)
bind("n", "gd", ":Lspsaga goto_definition<CR>", opts)
bind("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
bind("n", "[d", ":Lspsaga diagnostic_jump_next<CR>", opts)
bind("n", "]d", ":Lspsaga diagnostic_jump_prev<CR>", opts)
bind("n", "<leader>a", ":Lspsaga code_action<CR>", opts)
bind("n", "K", ":Lspsaga hover_doc<CR>", opts)
bind("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
bind("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
bind("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)

vim.keymap.set("n", "<leader>f", gitIfAvailable, { desc = "Find git files" })
vim.keymap.set("n", "<leader>p", find_all, { desc = "Find all files" })
vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>G", function()
	builtin.live_grep({
		additional_args = { "--no-ignore-vcs", "--hidden", "--glob", "!.git" },
	})
end, { desc = "Live grep, including hidden & ignored files" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find open buffers" })
