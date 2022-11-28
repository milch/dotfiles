      require("catppuccin").setup({
        integrations = {
          coc_nvim = false,
          gitsigns = true,
          markdown = true,
          neotest = false,
          nvimtree = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
        },
        custom_highlights = function ()
          local lsp = require('catppuccin.groups.integrations.native_lsp').get()
          -- Overwrite the native colors to remove the italics
          return {
            LualineErrorHighlight = { fg = lsp.DiagnosticVirtualTextError.fg, bg = lsp.DiagnosticVirtualTextError.bg },
            LualineWarnHighlight = { fg = lsp.DiagnosticVirtualTextWarn.fg, bg = lsp.DiagnosticVirtualTextWarn.bg },
            LualineInfoHighlight = { fg = lsp.DiagnosticVirtualTextInfo.fg, bg = lsp.DiagnosticVirtualTextInfo.bg },
            LualineHintHighlight = { fg = lsp.DiagnosticVirtualTextHint.fg, bg = lsp.DiagnosticVirtualTextHint.bg },
          }
        end
      })
