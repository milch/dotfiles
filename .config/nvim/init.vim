call plug#begin('~/.config/nvim/bundle')

"Language support
Plug 'AlexKornitzer/cocoa.vim', { 'for': ['objc', 'swift'] }
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
Plug 'sheerun/vim-polyglot'
Plug 'slashmili/alchemist.vim', { 'for': ['elixir'] }
Plug 'milch/vim-fastlane'
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }

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
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neoinclude.vim'
Plug 'Rip-Rip/clang_complete', { 'for': ['cpp', 'c', 'objc'] }
Plug 'wellle/tmux-complete.vim'
Plug 'landaire/deoplete-swift', { 'for': ['swift'] }
Plug 'osyo-manga/vim-monster', { 'for': ['ruby', 'eruby'] }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise', {'for': ['lua', 'elixir', 'ruby', 'crystal', 'sh', 'zsh', 'vim', 'c', 'cpp', 'objc', 'snippets']}
Plug 'w0rp/ale'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'shime/vim-livedown'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

"Misc
Plug 'Yggdroot/indentLine'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug '907th/vim-auto-save'
Plug 'critiqjo/lldb.nvim', { 'for': ['c', 'cpp', 'objc'] }
Plug 'janko-m/vim-test'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth' "Auto detect tab/space settings
Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp', 'objc'] }

call plug#end()

" Enable plugins based on filetype
filetype plugin indent on

" Enables syntax highlighting
syntax on

" How many lines of history VIM remembers
set history=1000

" Solarized all the way
" if $ITERM_PROFILE =~ 'Light$'
"     set background=light
" else
"     set background=dark
" endif

set termguicolors
let g:dracula_italic=1
colorscheme Dracula

" Leader -> to prefix your own keybindings
let mapleader = ","

" Tab doesn't expand, Tab-Size is 4 spaces (all Hail the Tab-God)
set tabstop=4
set shiftwidth=4
set noexpandtab

" Smart indentation of lines
set smartindent

" Enables Statusbar
set laststatus=2

" Highlight searches & searches while typing
set hlsearch
set incsearch

" For regular expressions
set magic

" Highlight matching brackets
set showmatch

" No error sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Ignore case when searching, but not if keywords are capitalized
set ignorecase smartcase

" Turn off backups
set nobackup
set nowb
set noswapfile

" Allows Backspace to loop over everything
set backspace=indent,eol,start

" No Arrow keys
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" Viewport will move if Cursor is 10 lines away from the edge
set so=10

" Show current position
set ruler

" Height of the command bar
set cmdheight=1

" Automatically reload file when it is changed from the outside
set autoread

" Set default encoding to utf-8
set encoding=utf8

" Change split with Ctrl+Direction
" map <C-j> <C-W>j
" map <C-k> <C-W>k
" map <C-h> <C-W>h
" map <C-l> <C-W>l

set relativenumber "relative line numbers
set number "But on the current line, show the absolute line number

set hidden " Allow hidden buffers

set guioptions-=T "No top toolbar
set guioptions-=r "no right scrollbar
set guioptions-=L "no left scrollbar

set completeopt=menu,menuone,longest

let g:airline_powerline_fonts=1
let g:airline_theme='dracula'
let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#bufferline#enabled = 1

let g:signify_sign_weight = "NONE"
let g:signify_sign_color_inherit_from_linenr = 1
let g:signify_sign_change = "~"
let g:signify_sign_change_delete = "~_"

let g:monster#completion#solargraph#backend = "async_solargraph_suggest"

let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
let g:deoplete#sources#omni#input_patterns = {
\   "ruby" : '[^. *\t]\.\w*\|\h\w*::',
\}

let g:clang_auto_user_options = 'compile_commands.json, .clang_complete, path'
let g:clang_library_path = "/Library/Developer/CommandLineTools/usr/lib/libclang.dylib"
let g:clang_use_library = 1
let g:clang_complete_auto = 0
let g:clang_auto_select = 0
let g:clang_omnicppcomplete_compliance = 0
let g:clang_make_default_keymappings = 0
let g:clang_snippets = 1
let g:clang_snippets_engine = 'ultisnips'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

nnoremap Y y$

nnoremap <leader>t :TagbarToggle<CR>

let g:gofmt_command="gofmt -tabs=false -tabwidth=4"

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

nnoremap <leader>r :Make<CR>

autocmd FileType markdown,mkd set spell spelllang=de,en
autocmd FileType text set spell spelllang=de,en
autocmd FileType plaintex,tex set spell spelllang=de,en

if $SHELL =~ 'bin/fish'
    set shell=/bin/bash
endif

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

let g:auto_save = 1
let g:auto_save_events = ["InsertLeave", "TextChanged", "BufLeave"]

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
  " Open NERDTree automatically if no files were specified
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

  " Close vim if NERDTree is the only window left
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
else

endif

map <leader>o :NERDTreeToggle <CR>

" Working with buffers
nmap <silent> <Tab> :bn<CR>
nmap <silent> <S-Tab> :bp<CR>

nmap <silent> <leader>1 :b 1<CR>
nmap <silent> <leader>2 :b 2<CR>
nmap <silent> <leader>3 :b 3<CR>
nmap <silent> <leader>4 :b 4<CR>
nmap <silent> <leader>5 :b 5<CR>
nmap <silent> <leader>6 :b 6<CR>
nmap <silent> <leader>7 :b 7<CR>
nmap <silent> <leader>8 :b 8<CR>
nmap <silent> <leader>9 :b 9<CR>

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

" Workaround for files not auto-reloading https://github.com/neovim/neovim/issues/2127
augroup AutoSwap
  autocmd!
  autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
augroup END

function! AS_HandleSwapfile (filename, swapname)
  " if swapfile is older than file itself, just get rid of it
  if getftime(v:swapname) < getftime(a:filename)
    call delete(v:swapname)
    let v:swapchoice = 'e'
  endif
endfunction
autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
      \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

augroup checktime
  au!
  if !has("gui_running")
    "silent! necessary otherwise throws errors when using command
    "line window.
    autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
  endif
augroup END

let g:ale_linters = {
\   'c': ['clang_check', 'cppcheck'],
\   'cpp': ['clang_check', 'cppcheck', 'clangtidy'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines'],
\   'javascript': ['eslint', 'prettier'],
\}
let g:ale_fix_on_save = 1

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ 'ruby': ['solargraph', 'stdio']
    \ }


set mouse=a

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
set list

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
