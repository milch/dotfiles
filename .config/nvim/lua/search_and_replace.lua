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

	-- Get yanked text and escape it for search. Use \V (very nomagic) so only
	-- backslashes are special; everything else (parens, braces, dots, ...) is literal.
	local text = "\\V" .. vim.fn.escape(vim.fn.getreg('"'), "\\"):gsub("\n", "\\n")

	M.searchAndReplace(text)

	vim.fn.setreg('"', save.register)
	vim.fn.setpos("'<", save.visualMarks[1])
	vim.fn.setpos("'>", save.visualMarks[2])
	vim.o.clipboard = save.clipboard
	vim.o.selection = save.selection
	vim.o.virtualedit = save.virtualedit
end

-- Gets the word under the cursor and runs searchAndReplace
function M.searchAndReplaceCursorWord()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end
	-- Match whole word only (like `*`) and use \V for literal matching
	M.searchAndReplace("\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>")
end

-- Single entry point. We can't naively bind both `gs` (operator) and `gs*`
-- (cword shortcut): if the user pauses between `gs` and `*` long enough for
-- 'timeoutlen' to fire, Vim invokes the `gs` operator with `*` as the motion.
-- The `*` motion jumps from cursor to the next match of <cword>, so the
-- operator yanks "current word ... next match" as the search pattern — wrong.
-- Instead, only `gs` is mapped, and we read the next keystroke ourselves to
-- intercept `*`/`#` (and `g*`/`g#`) before Vim treats them as a motion.
function M.searchAndReplaceOperator()
	local mode = vim.api.nvim_get_mode().mode
	-- Visual modes: apply operator to the current selection directly.
	if mode:sub(1, 1) == "v" or mode == "V" or mode:byte(1) == 22 then
		vim.api.nvim_set_option_value("operatorfunc", "v:lua.searchAndReplaceOperatorFunc", { scope = "local" })
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g@", true, false, true), "n", false)
		return
	end

	local count = vim.v.count
	local ok, ch = pcall(vim.fn.getcharstr)
	if not ok or ch == "" or ch == "\27" or ch == "\3" then
		return
	end

	if ch == "*" or ch == "#" then
		M.searchAndReplaceCursorWord()
		return
	end

	if ch == "g" then
		local ok2, ch2 = pcall(vim.fn.getcharstr)
		if not ok2 then
			return
		end
		if ch2 == "*" or ch2 == "#" then
			M.searchAndReplaceCursorWord()
			return
		end
		ch = ch .. ch2
	end

	vim.api.nvim_set_option_value("operatorfunc", "v:lua.searchAndReplaceOperatorFunc", { scope = "local" })
	local count_str = (count > 0 and tostring(count) or "")
	-- Insert at the START of typeahead ("i" flag) so any remaining motion
	-- chars the user already typed (e.g. the `w` of `gsiw`) come AFTER our
	-- fed `g@<consumed-char>`, not before.
	vim.api.nvim_feedkeys(count_str .. "g@" .. ch, "ni", false)
end

return M
