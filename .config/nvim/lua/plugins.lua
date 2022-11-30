require('packer').startup(function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim' }
  use {
    'lewis6991/impatient.nvim',
    config = function() require('impatient') end
  }

  -- Language support
  use 'sheerun/vim-polyglot'
  use { 'slashmili/alchemist.vim', ft = { 'elixir' } }
  use 'milch/vim-fastlane'
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown' }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins.nvim-treesitter') end,
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' }
    }
  }
  use {
    'romgrk/nvim-treesitter-context',
    event = "WinScrolled",
    config = function() require('plugins.nvim-treesitter-context') end,
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
      { 'v', '<leader>re' }
    }
  }

  use {
    'nvim-treesitter/playground',
    cmd = "TSPlaygroundToggle"
  }
  -- Search, Navigation, etc.
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function() require('plugins.nvim-tree').configure_tree(false) end
  }
  use {
    'kylechui/nvim-surround',
    keys = { { 'n', 'ds' }, { 'n', 'cs' }, { 'n', 'ys' } },
    config = function()
      require('nvim-surround').setup()
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
      require('plugins.projectionist')
    end,
  }

  -- Aesthetics
  use {
    "catppuccin/nvim",
    as = "catppuccin",
    config = function()
      require('plugins.catppuccin')
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function() require('plugins.lualine') end,
    after = 'catppuccin'
  }

  -- SCM
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        numhl = true,
      })
    end
  }

  -- Autocomplete, Snippets, Syntax
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function() require('plugins/coc-nvim') end,
  }
  use {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require('plugins.nvim-autopairs') end
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
    config = function() require('plugins.telescope') end,
    keys = {
      { 'n', '<leader>ff' },
      { 'n', '<leader>fg' },
      { 'n', '<leader>fb' },
      { 'n', '<leader>fh' },
      { 'n', '<leader>p', },
      { 'n', '<leader>gb' },
      { 'n', '<leader>gc' },
      { 'n', '<leader>gs' },
    },
    module = 'telescope'
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require('plugins.indent-blankline') end,
    event = 'BufReadPost'
  }
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
  use { 'critiqjo/lldb.nvim', ft = { 'c', 'cpp', 'objc' } }
  use { 'janko-m/vim-test', ft = { 'swift', 'go', 'javascript', 'typescript', 'ruby' } }
  use {
    'kshenoy/vim-signature',
    event = 'BufReadPost'
  }
  -- Auto detect tab/space settings
  use {
    'tpope/vim-sleuth',
    event = 'BufReadPost'
  }


  use { 'dstein64/vim-startuptime', cmd = "StartupTime" }

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
    'anuvyklack/hydra.nvim',
    config = function()
      local Hydra = require('hydra')
      -- TODO: Refactoring
      local cmd = require('hydra.keymap-util').cmd

      local hint = [[
      _f_: files       _m_: marks
      🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: live grep
      🭉🭁🭠🭘    🭣🭕🭌🬾   _/_: search in file _r_: resume      
      🭅█ ▁     █🭐
      ██🬿      🭊██ 
      🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
      🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history 
      _O_: options     _?_: search history
      ^
      _<Enter>_: Telescope           _<Esc>_
      ]]

      Hydra({
        name = 'Telescope',
        hint = hint,
        config = {
          color = 'teal',
          invoke_on_body = true,
          hint = {
            position = 'middle',
            border = 'rounded',
          },
        },
        mode = 'n',
        body = '<Leader>ft',
        heads = {
          { 'f', cmd 'Telescope find_files' },
          { 'g', cmd 'Telescope live_grep' },
          { 'o', cmd 'Telescope oldfiles', { desc = 'recently opened files' } },
          { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
          { 'm', cmd 'MarksListBuf', { desc = 'marks' } },
          { 'k', cmd 'Telescope keymaps' },
          { 'O', cmd 'Telescope vim_options' },
          { 'r', cmd 'Telescope resume' },
          { '/', cmd 'Telescope current_buffer_fuzzy_find', { desc = 'search in file' } },
          { '?', cmd 'Telescope search_history', { desc = 'search history' } },
          { ';', cmd 'Telescope command_history', { desc = 'command-line history' } },
          { 'c', cmd 'Telescope commands', { desc = 'execute command' } },
          { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
          { '<Esc>', nil, { exit = true, nowait = true } },
        }
      })
    end
  }

  use {
    'gelguy/wilder.nvim',
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })
      local highlighters = {
        wilder.pcre2_highlighter(),
        wilder.basic_highlighter(),
      }
      wilder.set_option('renderer', wilder.popupmenu_renderer(
        wilder.popupmenu_border_theme({
          highlighter = highlighters,
          left = {
            ' ',
            wilder.popupmenu_devicons(),
            wilder.popupmenu_buffer_flags({
              flags = ' a + ',
              icons = { ['+'] = '', a = '', h = '' },
            }),
          },
          right = {
            ' ',
            wilder.popupmenu_scrollbar(),
          },
          highlights = {
            accent = wilder.make_hl('WilderAccent', 'Pmenu', { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }),
          },
        }))
      )
    end,
  end

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
  augroup end
]])
