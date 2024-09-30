vim.opt.tabstop = 2
vim.opt.expandtab = false

-- Smart indentation of lines
vim.opt.smartindent = true

-- Ignore case when searching, but not if keywords are capitalized
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Turn off backups
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.swapfile = false

-- Persistent undos for working with undotree
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.opt.undofile = true

-- Viewport will move if Cursor is 10 lines away from the edge
vim.opt.scrolloff = 10

vim.opt.relativenumber = true -- relative line numbers
vim.opt.number = true -- But on the current line, show the absolute line number

vim.opt.hidden = true -- Allow hidden buffers

-- always show signcolumns
vim.opt.signcolumn = "yes"

vim.opt.mouse = "a"
vim.opt.listchars = "tab:>·,trail:~,extends:>,precedes:<"
vim.opt.list = true

vim.opt.shada = "'1,/10,<50,s10,h"

local spelling_group = vim.api.nvim_create_augroup("Spelling", {})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "mkd", "text", "plaintex", "tex" },
	command = "set spell spelllang=en",
	group = spelling_group,
})

local shada_group = vim.api.nvim_create_augroup("shareData", {})
vim.api.nvim_create_autocmd("FocusGained", { command = "rshada", group = shada_group })
vim.api.nvim_create_autocmd("TextYankPost", { command = "wshada", group = shada_group })
