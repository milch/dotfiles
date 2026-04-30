---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param lhs string           Left-hand side |{lhs}| of the mapping.
---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts|string
local bind = function(modes, lhs, rhs, opts)
	---@cast opts vim.keymap.set.Opts
	opts = type(opts) == "string" and { desc = opts } or opts
	vim.keymap.set(modes, lhs, rhs, opts)
end

local M = {}

function M.set()
	-- Make Y behave like D
	bind("n", "Y", "y$", { noremap = true, desc = "Make Y behave like D" })

	local function goto_buffer(num)
		return function()
			require("plugins.ui.lualine.harpoon-component").buffer_jump(num, true)
		end
	end

	bind("n", "<M-1>", goto_buffer(1), "Go directly to buffer 1")
	bind("n", "<M-2>", goto_buffer(2), "Go directly to buffer 2")
	bind("n", "<M-3>", goto_buffer(3), "Go directly to buffer 3")
	bind("n", "<M-4>", goto_buffer(4), "Go directly to buffer 4")
	bind("n", "<M-5>", goto_buffer(5), "Go directly to buffer 5")

	bind("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines up", silent = true })
	bind("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines down", silent = true })

	bind("n", "J", "mzJ`zmz", "Join lines (keep cursor position the same)")
	bind("n", "<C-d>", "<C-d>zz", "Move one page down (keep cursor centered)")
	bind("n", "<C-u>", "<C-u>zz", "Move one page up (keep cursor centered)")
	bind("n", "<C-o>", "<C-o>zz", "Move to previous location (keep cursor centered)")

	-- Scroll LSP hover / signature_help / diagnostic floats with <C-f>/<C-b>
	-- without entering the float. Falls back to normal page scrolling when no
	-- focusable floating window is open.
	local function scroll_float(key)
		local termcode = vim.api.nvim_replace_termcodes(key, true, false, true)
		return function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local cfg = vim.api.nvim_win_get_config(win)
				if cfg.relative ~= "" and cfg.focusable then
					vim.api.nvim_win_call(win, function()
						vim.cmd("normal! " .. termcode)
					end)
					return
				end
			end
			vim.api.nvim_feedkeys(termcode, "n", false)
		end
	end
	bind("n", "<C-f>", scroll_float("<C-d>"), { silent = true, desc = "Scroll float / page down" })
	bind("n", "<C-b>", scroll_float("<C-u>"), { silent = true, desc = "Scroll float / page up" })

	local sar = require("search_and_replace")
	bind("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")
	bind({ "n", "x" }, "gs", sar.searchAndReplaceOperator, { silent = true, desc = "Search and replace operator (gs* for word under cursor)" })

	bind("v", "<leader>p", [["_dP]], "Replace the selection with the paste buffer, preserve the buffer")
	bind({ "n", "v" }, "<leader>y", [["+y]], "Copy to system clipboard")
	bind("n", "<leader>Y", [["+Y]], "Copy to system clipboard")

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
	end, "Toggle quickfix list")

	-- Removes the quickfix entry that the cursor is on with `dd`
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qf",
		callback = function()
			bind("n", "dd", function()
				local currentId = vim.fn.line(".") - 1
				local quickfixList = vim.fn.getqflist()
				table.remove(quickfixList, currentId + 1)
				vim.fn.setqflist(quickfixList, "r")
				local newIdx = math.min(currentId + 1, #quickfixList)
				if #quickfixList > 0 then
					vim.api.nvim_win_set_cursor(0, { newIdx, 0 })
				else
					vim.cmd.cclose()
				end
			end, { buf = 0, noremap = true, silent = true })
		end,
	})

	bind("n", "<S-h>", function()
		require("plugins.ui.lualine.harpoon-component").bprev()
	end, "Prev Buffer")
	bind("n", "<S-l>", function()
		require("plugins.ui.lualine.harpoon-component").bnext()
	end, "Next Buffer")

	bind("n", "<leader>bd", vim.cmd.bdelete, "Delete Buffer")

	-- commenting
	bind("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", "Add Comment Below")
	bind("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", "Add Comment Above")

	bind("i", "<M-BS>", "<C-w>", "Delete a whole word in insert mode with Alt+Backspace")
end

function M.set_lsp(_, bufnr)
	---@param built_in string
	---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
	---@param lhs string           Left-hand side |{lhs}| of the mapping.
	---@param desc string
	local steer = function(built_in, modes, lhs, desc)
		local notif = function()
			local msg = desc .. ": Use " .. built_in .. " instead"
			Snacks.notifier.notify(msg, "info")
		end
		bind(modes, lhs, notif, { desc = desc })
	end
	local opts = { buf = bufnr, silent = true }

	steer("gri", "n", "gi", "Go to implementation")
	steer("gri", "n", "gI", "Goto Implementation")
	steer("grn", "n", "<leader>cr", "Rename symbol")
	steer("grr", "n", "gr", "Go to references")
	steer("grt", "n", "gy", "Goto T[y]pe Definition")
	steer("grx", { "v", "n" }, "<leader>cc", "Run Codelens")
	steer("<C-s>", "i", "<c-k>", "Signature Help")

	opts.desc = "Format code"
	bind({ "n", "v", "x" }, "<leader>cf", require("conform").format, opts)

	opts.desc = "Go to definition"
	bind("n", "gd", vim.lsp.buf.definition, opts)

	opts.desc = "Show code signature help"
	bind("n", "gS", vim.lsp.buf.signature_help, opts)

	opts.desc = "Lsp Info"
	bind("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", opts)

	opts.desc = "Goto Declaration"
	bind("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Refresh & Display Codelens"
	bind("n", "<leader>cC", function()
		vim.lsp.codelens.enable(true)
	end, opts)

	opts.desc = "Line diagnostic"
	bind("n", "<leader>cd", vim.diagnostic.open_float, opts)
end

return M
