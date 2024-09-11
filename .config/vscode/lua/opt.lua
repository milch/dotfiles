vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Smart indentation of lines
vim.opt.smartindent = true

-- Ignore case when searching, but not if keywords are capitalized
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Turn off backups
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.swapfile = false

-- Viewport will move if Cursor is 10 lines away from the edge
vim.opt.scrolloff = 10

vim.opt.relativenumber = true -- relative line numbers
vim.opt.number = true -- But on the current line, show the absolute line number

vim.opt.listchars = "tab:>·,trail:~,extends:>,precedes:<"
vim.opt.list = true

vim.opt.shada = "'1,/10,<50,s10,h"

local shada_group = vim.api.nvim_create_augroup("shareData", {})
vim.api.nvim_create_autocmd("FocusGained", { command = "rshada", group = shada_group })
vim.api.nvim_create_autocmd("TextYankPost", { command = "wshada", group = shada_group })
