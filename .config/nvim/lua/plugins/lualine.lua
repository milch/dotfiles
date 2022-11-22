require('lualine').setup({
  options = {
    theme = 'auto',
    ignore_focus = { 'NvimTree', 'TelescopePrompt' },
    icons_enabled = true
  },
  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1,1) end }
    },
    lualine_b = { { 'buffers', hide_filename_extension = true } },
    lualine_c = { },

    lualine_x = {
      { 'diagnostics', sources = { 'nvim_diagnostic', 'coc' }, colored = true }
    },
    lualine_y = {  },
    -- lualine_z = { { 'diagnostics', sources = { 'coc' } } },
  }
})
