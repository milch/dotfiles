vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Leader -> to prefix your own keybindings
vim.g.mapleader = ","

require('plugins')
require('use_system_theme')

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Smart indentation of lines
vim.opt.smartindent = true

-- Highlight matching brackets
vim.opt.showmatch = true

-- Ignore case when searching, but not if keywords are capitalized
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Turn off backups
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.swapfile = true

-- No Arrow keys
vim.api.nvim_set_keymap('', '<Left>', '<Nop>', {})
vim.api.nvim_set_keymap('', '<Right>', '<Nop>', {})
vim.api.nvim_set_keymap('', '<Up>', '<Nop>', {})
vim.api.nvim_set_keymap('', '<Down>', '<Nop>', {})

-- Viewport will move if Cursor is 10 lines away from the edge
vim.opt.scrolloff=10

vim.opt.relativenumber = true -- relative line numbers
vim.opt.number = true -- But on the current line, show the absolute line number

vim.opt.hidden = true -- Allow hidden buffers

vim.opt.completeopt="menu,menuone,noinsert,noselect"

-- always show signcolumns
vim.opt.signcolumn = "yes"

-- Make Y behave like D
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

vim.api.nvim_create_augroup('Spelling', {})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'markdown','mkd','text','plaintex','tex'},
    command = 'set spell spelllang=en',
    group = 'Spelling'
})

-- Working with buffers
vim.api.nvim_set_keymap('n', '<Tab>', ':bn<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', ':bp<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':bd<CR>', { silent = true })

vim.api.nvim_create_augroup('fixAutoread', {})
vim.api.nvim_create_autocmd('FocusGained', {
    command = 'silent! checktime',
    group = 'fixAutoread'
})

vim.opt.mouse="a"
table.insert(vim.opt.shortmess, "c")
-- vim.opt.shortmess=vim.opt.shortmess .. "c"
vim.opt.listchars="tab:>·,trail:~,extends:>,precedes:<"
vim.opt.list = true

--[[
-- vim-test config - run Tests in local file
nmap <silent> <leader>u :TestNearest<CR>
nmap <silent> <leader>U :TestFile<CR>
nmap <silent> <leader>ua :TestSuite<CR>
nmap <silent> <leader>ul :TestLast<CR>
nmap <silent> <leader>uv :TestVisit<CR>

let test#strategy="dispatch"

let g:dispatch_compilers = {
      \ 'bundle exec': ''}
]]--

vim.opt.shada = "'1,/10,<50,s10,h"
vim.api.nvim_create_augroup('shareData', {})
vim.api.nvim_create_autocmd('FocusGained', { command = 'rshada' })
vim.api.nvim_create_autocmd('TextYankPost', { command = 'wshada' })


--[[
if filereadable($HOME . "/init_local.vim")
  source $HOME/init_local.vim
end ]]
