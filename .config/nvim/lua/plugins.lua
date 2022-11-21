require('packer').startup(function(use)
    -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Language support
  use 'sheerun/vim-polyglot'
  use {'slashmili/alchemist.vim',  ft = { 'elixir' } }
  use 'milch/vim-fastlane'
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown'}
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'romgrk/nvim-treesitter-context'

  -- Search, Navigation, etc.
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    }
  }
  -- use {
  --   'junegunn/fzf.vim',
  --   requires = { 'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  -- }
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  -- use 'bling/vim-bufferline'
  use 'romainl/vim-cool'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-projectionist'

  -- Aesthetics
  use { 'dracula/vim', as = 'dracula' }
  use 'milch/papercolor-theme'
  use {
    'vim-airline/vim-airline',
    requires = { 'vim-airline/vim-airline-themes' }
  }

  -- SCM
  use 'mhinz/vim-signify'

  -- Autocomplete, Snippets, Syntax
  use { 'neoclide/coc.nvim', branch = 'release' }
  use 'Raimondi/delimitMate'
  use 'tpope/vim-endwise'

  -- Misc
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    }
  }
  use "lukas-reineke/indent-blankline.nvim"
  use '907th/vim-auto-save'
  use { 'critiqjo/lldb.nvim', ft = {'c', 'cpp', 'objc'} }
  use { 'janko-m/vim-test', ft = {'swift', 'go', 'javascript', 'typescript', 'ruby'} }
  use 'kshenoy/vim-signature'
  use 'tpope/vim-sleuth' -- Auto detect tab/space settings
end)

-- Run PackerCompile whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
