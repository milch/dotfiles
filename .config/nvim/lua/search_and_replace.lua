local M = {}

function M.searchAndReplace(word)
	local lazyredraw = vim.o.lazyredraw
	vim.o.lazyredraw = true

	-- Trigger search + highlight
	vim.fn.setreg("/", word)
	vim.cmd("let v:hlsearch = 1")

	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("cgn", true, false, true),
		"n", -- 'n' means as if typed by user
		true -- Do not remap keys
	)

	vim.o.lazyredraw = lazyredraw
end

-- Gets the command to yank the text specified by the motion part of the operator
local operatorYankCommand = {
	char = "`[v`]",
	line = "'[V']",
	block = "`[<C-V>`]",
}

_G.searchAndReplaceOperatorFunc = function(type)
	local save = {
		clipboard = vim.o.clipboard,
		selection = vim.o.selection,
		virtualedit = vim.o.virtualedit,
		register = vim.fn.getreg('"'),
		visualMarks = { vim.fn.getpos("'<"), vim.fn.getpos("'>") },
	}

	vim.o.clipboard = ""
	vim.o.selection = "inclusive"
	vim.o.virtualedit = ""

	vim.cmd("normal! " .. operatorYankCommand[type] .. "y")

	-- Get yanked text and escape it for search
	local text = vim.fn.escape(vim.fn.getreg('"'), "\\()[]{}.+*^$")

	M.searchAndReplace(text)

	vim.fn.setreg('"', save.register)
	vim.fn.setpos("'<", save.visualMarks[1])
	vim.fn.setpos("'>", save.visualMarks[2])
	vim.o.clipboard = save.clipboard
	vim.o.selection = save.selection
	vim.o.virtualedit = save.virtualedit
end

function M.searchAndReplaceOperator()
	vim.api.nvim_set_option_value("operatorfunc", "v:lua.searchAndReplaceOperatorFunc", { scope = "local" })
	return "g@"
end

-- Gets the word under the cursor and runs searchAndReplace
function M.searchAndReplaceCursorWord()
	local word = vim.fn.expand("<cword>")
	M.searchAndReplace(word)
end

return M
