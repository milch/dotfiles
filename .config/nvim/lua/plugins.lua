require('packer').startup(function(use)
    -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Language support
  use 'sheerun/vim-polyglot'
  use {'slashmili/alchemist.vim', ft = { 'elixir' } }
  use 'milch/vim-fastlane'
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown'}
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins/nvim-treesitter') end,
    event = 'BufReadPost'
  }
  use {
    'romgrk/nvim-treesitter-context',
    event = "WinScrolled",
    config = function() require('plugins/nvim-treesitter-context') end,
    requires = 'nvim-treesitter/nvim-treesitter'
  }
  -- Search, Navigation, etc.
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function() require('plugins/nvim-tree') end
  }
  use { 'tpope/vim-surround', keys = {{'n', 'ds'}, {'n', 'cs'}}}
  use { 'tpope/vim-commentary', keys = {{ 'n', 'gc' }, { 'v', 'gc' }, { 'n', 'gcc' }}}
  use { 'romainl/vim-cool', keys = '/' }
  use { 'tpope/vim-projectionist', cmd = "A" }

  -- Aesthetics
  use { 'dracula/vim', as = 'dracula' }
  use 'milch/papercolor-theme'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function() require('plugins/lualine') end
  }

  -- SCM
  use { 'mhinz/vim-signify', event = 'BufReadPost' }

  -- Autocomplete, Snippets, Syntax
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function() require('plugins/coc-nvim') end,
    event = 'BufReadPost'
  }
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require('plugins/nvim-autopairs') end
  }

  -- Misc
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    },
    cmd = "Telescope",
    config = function() require('plugins/telescope') end,
    keys = {
      { 'n', '<leader>ff' },
      { 'n', '<leader>fg' },
      { 'n', '<leader>fb' },
      { 'n', '<leader>fh' },
      { 'n', '<leader>p', },
      { 'n', '<leader>gb' },
      { 'n', '<leader>gc' },
      { 'n', '<leader>gs' },
    }
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require('plugins/indent-blankline') end,
    event = 'BufReadPost'
  }
  use { '907th/vim-auto-save', event = 'InsertEnter' }
  use { 'critiqjo/lldb.nvim', ft = {'c', 'cpp', 'objc'} }
  use { 'janko-m/vim-test', ft = {'swift', 'go', 'javascript', 'typescript', 'ruby'} }
  use { 'kshenoy/vim-signature', event = 'BufReadPost' }
  use { 'tpope/vim-sleuth', event = 'BufReadPost' } -- Auto detect tab/space settings


  use { 'dstein64/vim-startuptime', cmd = "StartupTime" }
end)

-- Run PackerCompile whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])
