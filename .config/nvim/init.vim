lua <<EOF
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
EOF

" Leader -> to prefix your own keybindings
let mapleader = ","

lua <<EOF
require('plugins')
require('use_system_theme')
EOF

set tabstop=2
set shiftwidth=2
set expandtab

" Smart indentation of lines
set smartindent

" Highlight matching brackets
set showmatch

" Ignore case when searching, but not if keywords are capitalized
set ignorecase smartcase

" Turn off backups
set nobackup
set nowritebackup
set noswapfile

" No Arrow keys
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" Viewport will move if Cursor is 10 lines away from the edge
set scrolloff=10

set relativenumber " relative line numbers
set number " But on the current line, show the absolute line number

set hidden " Allow hidden buffers

set guioptions-=T "No top toolbar
set guioptions-=r "no right scrollbar
set guioptions-=L "no left scrollbar

set completeopt=menu,menuone,noinsert,noselect

" always show signcolumns
set signcolumn=yes

" Make Y behave like D
nnoremap Y y$

autocmd FileType markdown,mkd set spell spelllang=en
autocmd FileType text set spell spelllang=en
autocmd FileType plaintex,tex set spell spelllang=en

" Working with buffers
nmap <silent> <Tab> :bn<CR>
nmap <silent> <S-Tab> :bp<CR>

augroup fixAutoread
  autocmd!
  autocmd FocusGained * silent! checktime
augroup END

nmap <silent> <leader>q :bd<CR>

set mouse=a

set shortmess+=c

set listchars=tab:>·,trail:~,extends:>,precedes:<
set list

let g:indentLine_fileTypeExclude = ['json', 'markdown']

let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#bufferline#enabled = 1
let g:airline_section_b=''
let g:airline_skip_empty_sections=1

" Only show line and column number in the bottom right
call airline#parts#define_raw('linenr', '%l')
call airline#parts#define_accent('linenr', 'bold')
let g:airline_section_z = airline#section#create([g:airline_symbols.linenr .' ', 'linenr', ':%c '])
let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype', '%f'])

let g:signify_sign_weight = "NONE"
let g:signify_sign_color_inherit_from_linenr = 1
let g:signify_sign_change = "~"
let g:signify_sign_change_delete = "~_"

" vim-test config - run Tests in local file
nmap <silent> <leader>u :TestNearest<CR>
nmap <silent> <leader>U :TestFile<CR>
nmap <silent> <leader>ua :TestSuite<CR>
nmap <silent> <leader>ul :TestLast<CR>
nmap <silent> <leader>uv :TestVisit<CR>

let test#strategy="dispatch"

let g:dispatch_compilers = {
      \ 'bundle exec': ''}

let g:bufferline_echo = 0
let g:bufferline_active_highlight = 'Comment'
let g:airline#extensions#bufferline#overwrite_variables = 1

augroup shareData
  autocmd!
  autocmd FocusGained * rshada
  autocmd TextYankPost * wshada
augroup END

let g:auto_save = 1
let g:auto_save_events = ["FocusLost", "BufLeave"]

let g:projectionist_heuristics = {
\ "rails-root/Rakefile": {
\   "rails-root/spec/*_spec.rb": { "alternate": "rails-root/{}.rb" },
\   "rails-root/*.rb": { "alternate": "rails-root/spec/{}_spec.rb" }
\ },
\ "Rakefile": {
\   "spec/*_spec.rb": { "alternate": "lib/{}.rb" },
\   "lib/*.rb": { "alternate": "spec/{}_spec.rb" }
\ },
\ "package.json": {
\   "lib/*.ts": { "alternate": "test/{}.test.ts" },
\   "test/*.test.ts": { "alternate": "lib/{}.ts" },
\   "src/*.ts": { "alternate": "tests/{}.test.ts" },
\   "tests/*.test.ts": { "alternate": "src/{}.ts" }
\ },
\ "src/*/main.go": {
\   "*.go": { "alternate": "{}_test.go" },
\   "*_test.go": { "alternate": "{}.go" }
\ },
\ "go.mod": {
\   "*.go": { "alternate": "{}_test.go" },
\   "*_test.go": { "alternate": "{}.go" }
\ }
\}

nmap <silent> <leader><leader> :A<CR>

if filereadable($HOME . "/init_local.vim")
  source $HOME/init_local.vim
end
