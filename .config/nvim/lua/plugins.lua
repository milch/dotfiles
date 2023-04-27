require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }
  use {
    'lewis6991/impatient.nvim',
    config = function() require('impatient') end
  }

  -- Languages
  use { 'slashmili/alchemist.vim', ft = { 'elixir' } }
  use 'milch/vim-fastlane'
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown' }

  -- Editor
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('editor.nvim-treesitter') end,
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' }
    }
  }

  use {
    'romgrk/nvim-treesitter-context',
    event = "WinScrolled",
    config = function() require('editor.nvim-treesitter-context') end,
    requires = 'nvim-treesitter/nvim-treesitter',
  }
  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require('refactoring').setup({})
      local opts = { noremap = true, silent = true, expr = false }
      vim.api.nvim_set_keymap("v", "<leader>re",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        opts)
    end,
    keys = {
      { 'v', '<leader>re' },
      { 'v', '<leader>r' },
      { 'n', '<leader>r' },
    }
  }

  use {
    'nvim-treesitter/playground',
    cmd = "TSPlaygroundToggle"
  }

  use {
    'kylechui/nvim-surround',
    keys = { { 'n', 'ds' }, { 'n', 'cs' }, { 'n', 'ys' } },
    config = function()
      require('nvim-surround').setup()
    end
  }

  use {
    'echasnovski/mini.ai',
    config = function()
      require('mini.ai').setup()
    end
  }

  use {
    'numToStr/Comment.nvim',
    keys = { { 'n', 'gc' }, { 'n', 'gb' }, { 'v', 'gc' }, { 'v', 'gb' }, { 'n', 'gcc' }, { 'n', 'gbc' } },
    config = function()
      require('Comment').setup()
    end
  }
  use { 'romainl/vim-cool', keys = '/' }
  use {
    'tpope/vim-projectionist',
    config = function()
      require('editor.projectionist')
    end,
  }
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require('editor.nvim-autopairs') end
  }

  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    },
    cmd = "Telescope",
    config = function() require('editor.telescope') end,
    keys = {
      { 'n', '<leader>f' },
      { 'n', '<leader>g' },
      { 'n', '<leader>b' },
      { 'n', '<leader>p', },
      { 'n', '<leader>gb' },
      { 'n', '<leader>gc' },
      { 'n', '<leader>gs' },
    },
    module = 'telescope'
  }

  -- UI
  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require('ui.catppuccin')
    end
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function() require('ui.nvim-tree').configure_tree(false) end,
    after = 'catppuccin'
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function() require('ui.lualine') end,
    after = 'catppuccin'
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require('ui.indent-blankline') end,
    event = 'BufReadPost',
    after = 'catppuccin'
  }

  use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async', config = function()
    -- See https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1157716294
    vim.o.foldcolumn = '0'
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    require('ufo').setup()
  end
  }

  use {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    config = function()
      require('gitsigns').setup({
        numhl = true,
      })
    end
  }

  -- Completion
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function() require('completion.coc-nvim') end,
  }

  use {
    'gelguy/wilder.nvim',
    requires = {
      { 'romgrk/fzy-lua-native' },
    },
    event = { 'CmdlineEnter' },
    run = ':UpdateRemotePlugins',
    config = function()
      require('completion.wilder')
    end,
  }

  -- Utils
  use({
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        -- Only trigger when changing files. The default is annoying with linters
        -- that trigger on file save, as it makes it impossible to make some
        -- types of changes (e.g. add empty lines)
        trigger_events = { "FocusLost", "BufLeave" }
      })
    end
  })

  use {
    'kshenoy/vim-signature',
    event = { 'BufReadPost' }
  }
  use {
    'tpope/vim-sleuth',
    event = { 'BufReadPost' }
  }


  use { 'dstein64/vim-startuptime', cmd = "StartupTime" }

  use {
    'anuvyklack/hydra.nvim',
    config = function()
      require('util.hydra')
    end
  }

  use {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
      local kopts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end
  }

  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rust") {
          }
        }
      })
    end
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {
    "arafatamim/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        mode = "coc_workspace_diagnostics",
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = true, -- automatically close the list when you have no diagnostics
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }

      vim.api.nvim_set_keymap("n", "<leader>d", ":TroubleToggle<CR>", {})
    end
  }

  -- Load additional plugins that are only local to the current machine
  local exists, localPlugins = pcall(require, 'plugins.local')
  if exists then
    localPlugins.setup(use)
  end
end)

-- Run PackerCompile whenever this file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost .config/nvim/lua/**/*.lua source <afile>
  augroup end
]])
