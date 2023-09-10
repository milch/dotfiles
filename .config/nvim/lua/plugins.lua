local function cmd(str)
  return "<Cmd>lua " .. str .. "<CR>"
end
local silentNoremap = { noremap = true, silent = true }

return {
  -- Languages
  { 'slashmili/alchemist.vim',      ft = { 'elixir' } },
  'milch/vim-fastlane',
  { "iamcco/markdown-preview.nvim", build = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown' },

  -- Editor
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    opts = require('editor.nvim-treesitter'),
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects'
    }
  },

  {
    'romgrk/nvim-treesitter-context',
    event = "WinScrolled",
    opts = require('editor.nvim-treesitter-context'),
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    opts = {},
    keys = {
      {
        '<leader>re',
        ":Refactor extract<CR>",
        mode = "v",
        noremap = true,
        silent = true,
        expr = false
      }
    }
  },

  {
    'nvim-treesitter/playground',
    cmd = "TSPlaygroundToggle"
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {}
  },

  {
    'echasnovski/mini.ai',
    event = "VeryLazy",
    opts = {}
  },

  {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gb', { 'gc', mode = "v" }, { 'gb', mode = "v" }, 'gcc', 'gbc' },
    opts = {}
  },
  {
    'romainl/vim-cool',
    keys = '/'
  },
  {
    'tpope/vim-projectionist',
    config = function()
      require('editor.projectionist')
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require('editor.nvim-autopairs') end
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      }
    },
    cmd = "Telescope",
    config = function() require('editor.telescope') end,
    keys = {
      { '<leader>f' },
      { '<leader>g' },
      { '<leader>b' },
      { '<leader>p', },
      { '<leader>sb' },
      { '<leader>sc' },
      { '<leader>ss' },
    },
  },

  -- UI
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = require('ui.catppuccin'),
    init = function()
      require('ui.use_system_theme').ChangeToSystemColor("startup")
    end
  },

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'catppuccin',
    },
    config = function() require('ui.nvim-tree').configure_tree(false) end,
  },

  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'catppuccin',
    },
    config = function() require('ui.lualine') end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function() require('ui.indent-blankline') end,
    event = 'BufReadPost',
    dependencies = {
      'catppuccin',
    },
  },

  {
    'kevinhwang91/nvim-ufo',
    event = "BufReadPost",
    dependencies = {
      'kevinhwang91/promise-async',
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup(
            {
              relculright = true,
              segments = {
                { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                { text = { "%s" },                  click = "v:lua.ScSa" },
                { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }
              }
            }
          )
        end
      }
    },
    init = function()
      vim.o.foldcolumn = '1'
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    end,
    opts = {
      ---@diagnostic disable-next-line: unused-local
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      close_fold_kinds = { "imports", "comment" },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local totalLines = vim.api.nvim_buf_line_count(0)
        local foldedLines = endLnum - lnum
        local suffix = ("  %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        local rAlignAppndx =
            math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
        suffix = (" "):rep(rAlignAppndx) .. suffix
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
    }
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    opts = {
      numhl = true,
    }
  },

  -- Completion
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function() require('completion.coc-nvim') end,
  },

  {
    'gelguy/wilder.nvim',
    dependencies = {
      { 'romgrk/fzy-lua-native' },
    },
    event = { 'CmdlineEnter' },
    build = ':UpdateRemotePlugins',
    config = function()
      require('completion.wilder')
    end,
  },

  -- Utils
  {
    "okuuva/auto-save.nvim",
    opts = {
      -- Only trigger when changing files. The default is annoying with linters
      -- that trigger on file save, as it makes it impossible to make some
      -- types of changes (e.g. add empty lines)
      trigger_events = { "FocusLost", "BufLeave" }
    }
  },

  {
    'kshenoy/vim-signature',
    event = { 'BufReadPost' }
  },
  {
    'tpope/vim-sleuth',
    event = { 'BufReadPost' }
  },

  {
    'anuvyklack/hydra.nvim',
    config = function()
      require('util.hydra')
    end,
    keys = {
      "<leader>h",
      "<leader>rf",
    }
  },

  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      '/',
      { 'n',  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], silentNoremap },
      { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        silentNoremap },
      { '*',  [[*<Cmd>lua require('hlslens').start()<CR>]],                                             silentNoremap },
      { '#',  [[#<Cmd>lua require('hlslens').start()<CR>]],                                             silentNoremap },
      { 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]],                                            silentNoremap },
      { 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]],                                            silentNoremap }
    },
    opts = {},
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust"
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require("neotest-rust")
        }
      })
    end,
    keys = {
      -- Run nearest test
      { "<leader>tt", cmd 'require("neotest").run.run()' },
      -- Run the current file
      { "<leader>tf", cmd 'require("neotest").run.run(vim.fn.expand("%"))' },
    }
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {}
  },

  {
    "arafatamim/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      mode = "coc_workspace_diagnostics",
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = true, -- automatically close the list when you have no diagnostics
    },
    cmd = { "TroubleToggle", "Trouble", "TroubleClose", "TroubleRefresh" },
    keys = {
      { "<leader>d", ":TroubleToggle<CR>" }
    }
  },

  --   -- Load additional plugins that are only local to the current machine
  --   local exists, localPlugins = pcall(require, 'plugins.local')
  --   if exists then
  --     localPlugins.setup(use)
  --   end
  -- end)
}
