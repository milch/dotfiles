call plug#begin('~/.config/nvim/bundle')

"Language support
Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby'] }
Plug 'sheerun/vim-polyglot'
Plug 'slashmili/alchemist.vim', { 'for': ['elixir'] }
Plug 'milch/vim-fastlane'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

"Search, Navigation, etc.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'bling/vim-bufferline'
Plug 'romainl/vim-cool'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-dispatch'

"Aesthetics
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

"SCM
Plug 'mhinz/vim-signify'

"Autocomplete, Snippets, Syntax
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise', {'for': ['lua', 'elixir', 'ruby', 'crystal', 'sh', 'zsh', 'vim']}

"Misc
Plug 'Shougo/denite.nvim', {'do':':UpdateRemotePlugins'}
Plug 'Yggdroot/indentLine'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug '907th/vim-auto-save'
Plug 'critiqjo/lldb.nvim', { 'for': ['c', 'cpp', 'objc'] }
Plug 'janko-m/vim-test'
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-sleuth' "Auto detect tab/space settings

call plug#end()

" Enable 24-bit color 
set termguicolors

func ChangeToSystemColor(timer)
  let darkModeEnabled = ''
  if $ITERM_PROFILE == 'Dark'
    echo "Using Dark profile from iTerm"
    let darkModeEnabled = 'dark'
  elseif $ITERM_PROFILE == 'Light'
    echo "Using Light profile from iTerm"
    let darkModeEnabled = 'light'
  elseif a:timer == 'startup'
    " This is the first call, and calling `system` would slow down loading the
    " init.vim file. In fish I export an env var which is reasonably
    " up-to-date as a workaround
    let darkModeEnabled = $APPLE_INTERFACE_STYLE
  else
    let darkModeEnabled = systemlist("defaults read -g AppleInterfaceStyle")[0]
  endif

  if darkModeEnabled =~ 'dark'
    let g:airline_theme='dracula'
    let g:dracula_italic=1
    colorscheme Dracula
  else
    set background=light
    let g:airline_theme='papercolor'
    let g:PaperColor_Theme_Options = {
          \ 'theme': {
          \   'default.light': {
          \     'allow_bold': 1,
          \     'allow_italic': 1
          \   }
          \  }
          \ }
    colorscheme PaperColor
  endif
endfunc
exec ChangeToSystemColor('startup')
call timer_start(3000, 'ChangeToSystemColor', {'repeat': -1})

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

set completeopt=menu,menuone,noinsert,noselect

" always show signcolumns
set signcolumn=yes

let g:indentLine_fileTypeExclude = ['json', 'markdown']

let g:airline_powerline_fonts=1
let g:airline_theme='dracula'
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

" Make Y behave like D
nnoremap Y y$

let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 0
nnoremap <silent> <leader>t :Vista!!<CR>

nnoremap <leader>r :Make<CR>

autocmd FileType markdown,mkd set spell spelllang=en
autocmd FileType text set spell spelllang=en
autocmd FileType plaintex,tex set spell spelllang=en

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

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q       denite#do_map('quit')
  nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
endfunction

autocmd FileType denite-filter call s:denite_filter_settings()
function! s:denite_filter_settings() abort
  inoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <C-c>   denite#do_map('quit')
  nnoremap <silent><buffer><expr> q       denite#do_map('quit')
endfunction

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
      \ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

let g:float_width = &columns/4*3
call denite#custom#option('_', {
      \ 'winwidth': &columns/4 * 3,
      \ 'wincol': (&columns - &columns/4 * 3) / 2,
      \ 'split': 'floating',
      \ 'start_filter': 'true'
      \ })

" Sets recursive search to git search if in a git project, regular recursive
" search otherwise
function! s:SetDeniteRecursiveSearchMapping()
  if finddir('.git', ';') != ''
    nmap <silent> <leader>p :<C-u>Denite file/rec/git<CR>
  else
    nmap <silent> <leader>p :<C-u>Denite file/rec<CR>
  endif
endfunction

call <SID>SetDeniteRecursiveSearchMapping()
augroup DeniteRecursiveMapping
  autocmd!
  autocmd DirChanged * call <SID>SetDeniteRecursiveSearchMapping()
augroup END

nmap <silent> <leader>f :Denite grep<CR>
nmap <silent> <leader>c :Commits <CR>

augroup shareData
  autocmd!
  autocmd FocusGained * rshada
  autocmd TextYankPost * wshada
augroup END

let g:auto_save = 1
let g:auto_save_events = ["FocusLost", "BufLeave"]

let g:fzf_history_dir = '~/.config/fzf/history'

nmap <silent> <leader>q :bd<CR>

set mouse=a

set shortmess+=c

set listchars=tab:>·,trail:~,extends:>,precedes:<
set list

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

" Coc only does snippet and additional edit on confirm.
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <C-R>=...<CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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
