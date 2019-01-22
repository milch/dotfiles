call plug#begin('~/.config/nvim/bundle')

"Language support
Plug 'AlexKornitzer/cocoa.vim', { 'for': ['objc', 'swift'] }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
Plug 'sheerun/vim-polyglot'
Plug 'slashmili/alchemist.vim', { 'for': ['elixir'] }
Plug 'milch/vim-fastlane'

"Search, Navigation, etc.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'ervandew/supertab'
Plug 'ludovicchabant/vim-gutentags' | Plug 'majutsushi/tagbar'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'bling/vim-bufferline'
Plug 'romainl/vim-cool'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-dispatch'

"Aesthetics
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

"SCM
Plug 'mhinz/vim-signify'

"Autocomplete, Snippets, Syntax
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
Plug 'Rip-Rip/clang_complete', { 'for': ['cpp', 'c', 'objc'] }
Plug 'wellle/tmux-complete.vim'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise', {'for': ['lua', 'elixir', 'ruby', 'crystal', 'sh', 'zsh', 'vim', 'c', 'cpp', 'objc', 'snippets']}
Plug 'w0rp/ale'
Plug 'shime/vim-livedown'

"Misc
Plug 'tmux-plugins/vim-tmux-focus-events' " Enable FocusLost/FocusGained w/ tmux
Plug 'Shougo/denite.nvim', {'do':':UpdateRemotePlugins'}
Plug 'Yggdroot/indentLine'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug '907th/vim-auto-save', {'on': [] } " Defer loading
Plug 'critiqjo/lldb.nvim', { 'for': ['c', 'cpp', 'objc'] }
Plug 'janko-m/vim-test'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth' "Auto detect tab/space settings
Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp', 'objc'] }

call plug#end()

" Enable 24-bit color 
set termguicolors

" let g:dracula_italic=1
colorscheme Dracula

" Leader -> to prefix your own keybindings
let mapleader = ","

" Tab doesn't expand, Tab-Size is 4 spaces (all Hail the Tab-God)
set tabstop=4
set shiftwidth=4

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

set completeopt=menu,menuone,longest

" always show signcolumns
set signcolumn=yes

let g:indentLine_fileTypeExclude = ['json', 'markdown']

let g:airline_powerline_fonts=1
let g:airline_theme='dracula'
let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#bufferline#enabled = 1

let g:signify_sign_weight = "NONE"
let g:signify_sign_color_inherit_from_linenr = 1
let g:signify_sign_change = "~"
let g:signify_sign_change_delete = "~_"

let g:clang_auto_user_options = 'compile_commands.json, .clang_complete, path'
let g:clang_library_path = "/Library/Developer/CommandLineTools/usr/lib/libclang.dylib"
let g:clang_use_library = 1
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_omnicppcomplete_compliance = 0
let g:clang_make_default_keymappings = 0
let g:clang_snippets = 1

" Make Y behave like D
nnoremap Y y$

nnoremap <leader>t :TagbarToggle<CR>

let g:gofmt_command="gofmt -tabs=false -tabwidth=4"

nnoremap <leader>r :Make<CR>

autocmd FileType markdown,mkd set spell spelllang=en
autocmd FileType text set spell spelllang=en
autocmd FileType plaintex,tex set spell spelllang=en

let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0
let g:clang_format#auto_formatexpr = 0

" vim-test config - run Tests in local file
nmap <silent> <leader>u :TestNearest<CR>
nmap <silent> <leader>U :TestFile<CR>
nmap <silent> <leader>ua :TestSuite<CR>
nmap <silent> <leader>ul :TestLast<CR>
nmap <silent> <leader>uv :TestVisit<CR>

let test#strategy="dispatch"

let g:dispatch_compilers = {
      \ 'bundle exec': ''}

set keywordprg=:Nman

let g:bufferline_echo = 0
let g:bufferline_active_highlight = 'Comment'
let g:airline#extensions#bufferline#overwrite_variables = 1

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "+",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

if !has('gui_vimr')
  " Close vim if NERDTree is the only window left
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

let loaded_netrwPlugin = 1
map <leader>o :NERDTreeToggle<CR>

" Working with buffers
nmap <silent> <Tab> :bn<CR>
nmap <silent> <S-Tab> :bp<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nmap <silent> <leader>p :GFiles <CR>
nmap <leader>f :Rg 
nmap <silent> <leader>pp :Files <CR>
nmap <silent> <leader>pc :Commits <CR>

nmap / /\v

augroup shareData
  autocmd!
  autocmd FocusGained * rshada
  autocmd TextYankPost * wshada
augroup END

let g:auto_save = 1
let g:auto_save_events = ["FocusLost", "BufLeave"]

function! s:AdjustAutoSaveForMarkdown()
  set updatetime=200
  let g:auto_save_events += ["TextChanged", "CursorHold", "CursorHoldI"]
endfunction

autocmd FileType markdown,mkd call <SID>AdjustAutoSaveForMarkdown()
autocmd FileType * call plug#load('vim-auto-save')

let g:fzf_history_dir = '~/.config/fzf/history'

" Tag definitions
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records'
    \ ]
\ }

let g:gutentags_cache_dir = '~/.cache/gutentags/'

nmap <silent> <leader>q :bd<CR>

let g:ale_linters = {
\   'c': ['clang_check', 'cppcheck'],
\   'cpp': ['clang_check', 'cppcheck', 'clangtidy'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines'],
\   'javascript': ['prettier'],
\   'typescript': ['tslint', 'prettier'],
\   'ruby': ['rubocop']
\}
let g:ale_fix_on_save = 1

set mouse=a

set listchars=tab:>·,trail:~,extends:>,precedes:<
set list

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim' || &filetype == 'help'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for format selected region
vmap gf <Plug>(coc-format-selected)
nmap gf <Plug>(coc-format-selected)

" Show extension list
nnoremap <silent> <space>e  :<C-u>Denite coc-extension<cr>
" Show symbols of current buffer
nnoremap <silent> <space>o  :<C-u>Denite coc-symbols<cr>
" Search symbols of current workspace
nnoremap <silent> <space>t  :<C-u>Denite coc-workspace<cr>
" Show diagnostics of current workspace
nnoremap <silent> <space>a  :<C-u>Denite coc-diagnostic<cr>
" Show available commands
nnoremap <silent> <space>c  :<C-u>Denite coc-command<cr>
" Show available services
nnoremap <silent> <space>s  :<C-u>Denite coc-service<cr>
" Show links of current buffer
nnoremap <silent> <space>l  :<C-u>Denite coc-link<cr>

" Use <c-k> to trigger kompletion
inoremap <silent><expr> <c-k> coc#refresh()
