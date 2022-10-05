call plug#begin('~/.config/nvim/bundle')

"Language support
Plug 'sheerun/vim-polyglot'
Plug 'slashmili/alchemist.vim', { 'for': ['elixir'] }
Plug 'milch/vim-fastlane'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'romgrk/nvim-treesitter-context'

"Search, Navigation, etc.
Plug 'lambdalisue/fern.vim', { 'branch': 'main' } " Much faster than netrw
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'bling/vim-bufferline'
Plug 'romainl/vim-cool'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'

"Aesthetics
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'milch/papercolor-theme'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

"SCM
Plug 'mhinz/vim-signify'

"Autocomplete, Snippets, Syntax
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-endwise'

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

let g:_init_previous_bg = 'undefined'
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
      if g:_init_previous_bg != 'dark'
          echo "Changing to dark mode"
          let g:_init_previous_bg = 'dark'
          let g:airline_theme='dracula'
          let g:dracula_italic=1
          colorscheme Dracula
      endif
  else
    if g:_init_previous_bg != 'light'
      echo "Changing to light mode"
      let g:_init_previous_bg='light'
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
  endif
endfunc
exec ChangeToSystemColor('startup')
call timer_start(3000, 'ChangeToSystemColor', {'repeat': -1})

" Leader -> to prefix your own keybindings
let mapleader = ","

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

" Replace netrw with the (much faster) fern.vim
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let l:target = expand('%')
  if !isdirectory(l:target)
    return
  endif
  bwipeout %
  execute "Fern " . l:target
endfunction

function! s:init_fern() abort
    nmap <buffer><expr>
      \ <Plug>(fern-my-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )

  " Open node with 'o'
  nmap <buffer><nowait> o <Plug>(fern-my-expand-or-collapse)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

nmap <silent> - :Fern .<CR>

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
  nnoremap <silent><buffer>       <ESC>   :q<CR>
endfunction

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
call denite#custom#var('file/rec', 'command',
      \ ['fd', '--hidden', '--exclude', '.git', '--follow', '--color', 'never', '--full-path', '--type', 'file'])

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
      \ 'start_filter': 'true',
      \ 'match-highlight': 'true'
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
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" See https://github.com/tpope/vim-endwise/issues/22
let g:endwise_no_mappings = v:true
inoremap <expr> <Plug>CustomCocCR coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
imap <CR> <Plug>CustomCocCR<Plug>DiscretionaryEnd

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Perform code action
nmap <leader>a <Plug>(coc-codeaction)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use <c-a> to trigger completion.
inoremap <silent><expr> <c-a> coc#refresh()

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for format selected region
vmap gf <Plug>(coc-format-selected)
nmap gf <Plug>(coc-format-selected)

" Disable autoformat for temporary files
autocmd BufRead,VimEnter * if expand('%') =~ "/private/var/folders" | call coc#config('coc.preferences.formatOnSaveFiletypes', []) | endif

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

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "dart",
    "dockerfile",
    "dot",
    "elixir",
    "fish",
    "go",
    "gomod",
    "gowork",
    "graphql",
    "help",
    "html",
    "http",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "kotlin",
    "latex",
    "llvm",
    "make",
    "markdown",
    "markdown_inline",
    "ninja",
    "nix",
    "perl",
    "php",
    "python",
    "regex",
    "ruby",
    "rust",
    "swift",
    "typescript",
    "vim",
    "yaml"
  },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- List of parsers to ignore installing
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    throttle = true, -- Throttles plugin updates (may improve performance)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
        ruby = {
            'module',
            'def'
             },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true, 
    }
}
EOF
