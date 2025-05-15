local bind = vim.keymap.set

local M = {}

function M.set()
	-- Make Y behave like D
	bind("n", "Y", "y$", { noremap = true, desc = "Make Y behave like D" })

	local function goto_buffer(num)
		return function()
			require("plugins.ui.lualine.harpoon-component").buffer_jump(num, true)
		end
	end

	bind("n", "<M-1>", goto_buffer(1), { desc = "Go directly to buffer 1" })
	bind("n", "<M-2>", goto_buffer(2), { desc = "Go directly to buffer 2" })
	bind("n", "<M-3>", goto_buffer(3), { desc = "Go directly to buffer 3" })
	bind("n", "<M-4>", goto_buffer(4), { desc = "Go directly to buffer 4" })
	bind("n", "<M-5>", goto_buffer(5), { desc = "Go directly to buffer 5" })

	bind("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines up", silent = true })
	bind("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selecetd lines down", silent = true })

	bind("n", "J", "mzJ`zmz", { desc = "Join lines (keep cursor position the same)" })
	bind("n", "<C-d>", "<C-d>zz", { desc = "Move one page down (keep cursor centered)" })
	bind("n", "<C-u>", "<C-u>zz", { desc = "Move one page up (keep cursor centered)" })
	bind("n", "<C-o>", "<C-o>zz", { desc = "Move to previous location (keep cursor centered)" })

	local sar = require("search_and_replace")
	bind("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
	bind({ "n", "x" }, "s", sar.searchAndReplaceOperator, { expr = true, desc = "Search and replace operator" })
	bind("n", "s*", sar.searchAndReplaceCursorWord, { silent = true, desc = "Search and replace word under cursor" })

	bind("v", "<leader>p", [["_dP]], { desc = "Replace the selection with the paste buffer, preserve the buffer" })
	bind({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
	bind("n", "<leader>Y", [["+Y]], { desc = "Copy to system clipboard" })

	bind("n", "<leader>w", [[<cmd>:w<CR>]], { desc = "Save", silent = true })

	bind(
		"n",
		"<leader>cs",
		[[:%s/\V<C-r>=escape(expand('<cword>'), '/\')<CR>/<C-r>=escape(expand('<cword>'), '/\')<CR>/gI<Left><Left><Left>]],
		{ desc = "Substitute word under cursor" }
	)
	bind(
		"n",
		"<leader>cS",
		[[:%s/\V<C-r>=escape(expand('<cword>'), '/\')<CR>//gI<Left><Left><Left>]],
		{ desc = "Substitue word under cursor (replace)" }
	)
	bind(
		"x",
		"<leader>cs",
		[[y:%s/\V<C-r>=escape(@", '/\')<CR>/<C-r>=escape(@", '/\')<CR>/gI<Left><Left><Left>]],
		{ desc = "Substitute selected text" }
	)
	bind(
		"x",
		"<leader>cS",
		[[y:%s/\V<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]],
		{ desc = "Substitute selected text (replace)" }
	)

	bind("n", "<leader>xq", function()
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

	bind("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
	bind("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

	-- buffers
	bind("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
	bind("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })

	bind("n", "<S-h>", function()
		require("plugins.ui.lualine.harpoon-component").bprev()
	end, { desc = "Prev Buffer" })
	bind("n", "<S-l>", function()
		require("plugins.ui.lualine.harpoon-component").bnext()
	end, { desc = "Next Buffer" })

	bind("n", "<leader>bd", vim.cmd.bdelete, { desc = "Delete Buffer" })

	-- commenting
	bind("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
	bind("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

	bind("i", "<M-BS>", "<C-w>", { desc = "Delete a whole word in insert mode with Alt+Backspace" })

	-- Groups from Lazy
	-- { "<leader><tab>", group = "tabs" },
	-- { "<leader>c", group = "code" },
	-- { "<leader>f", group = "file/find" },
	-- { "<leader>g", group = "git" },
	-- { "<leader>gh", group = "hunks" },
	-- { "<leader>q", group = "quit/session" },
	-- { "<leader>s", group = "search" },
	-- { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
	-- { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
	-- { "[", group = "prev" },
	-- { "]", group = "next" },
	-- { "g", group = "goto" },
	-- { "gs", group = "surround" },
	-- { "z", group = "fold" },
	-- {
	--   "<leader>b",
	--   group = "buffer",
	--   expand = function()
	--     return require("which-key.extras").expand.buf()
	--   end,
	-- },
	--
end

function M.set_lsp(_, bufnr)
	local opts = { buffer = bufnr, silent = true }

	opts.desc = "Format code"
	bind({ "n", "v", "x" }, "<leader>cf", require("conform").format, opts)

	opts.desc = "Rename symbol"
	bind("n", "<leader>cr", vim.lsp.buf.rename, opts)

	opts.desc = "Go to definition"
	bind("n", "gd", vim.lsp.buf.definition, opts)

	opts.desc = "Go to references"
	bind("n", "gr", vim.lsp.buf.references, opts)

	opts.desc = "Go to previous diagnostic"
	bind("n", "[d", vim.diagnostic.goto_prev, opts)

	opts.desc = "Go to next diagnostic"
	bind("n", "]d", vim.diagnostic.goto_next, opts)

	opts.desc = "Show documentation for symbol under cursor"
	bind("n", "K", vim.lsp.buf.hover, opts)

	opts.desc = "Go to implementation"
	bind("n", "gi", vim.lsp.buf.implementation, opts)

	opts.desc = "Show code signature help"
	bind("n", "gs", vim.lsp.buf.signature_help, opts)

	opts.desc = "Signature Help"
	bind("i", "<c-k>", vim.lsp.buf.signature_help, opts)

	opts.desc = "Code Action"
	bind({ "v", "n" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "Run Codelens"
	bind({ "v", "n" }, "<leader>cc", vim.lsp.codelens.run, opts)

	opts.desc = "Lsp Info"
	bind("n", "<leader>cl", "<cmd>LspInfo<cr>", opts)

	opts.desc = "Goto Implementation"
	bind("n", "gI", vim.lsp.buf.implementation, opts)

	opts.desc = "Goto T[y]pe Definition"
	bind("n", "gy", vim.lsp.buf.type_definition, opts)

	opts.desc = "Goto Declaration"
	bind("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Refresh & Display Codelens"
	bind("n", "<leader>cC", vim.lsp.codelens.refresh, opts)

	opts.desc = "Line diagnostic"
	bind("n", "<leader>cd", vim.diagnostic.open_float, opts)
end

return M
