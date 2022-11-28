local colors = {
  red = '#ca1243',
  grey = '#a0a1a7',
  black = '#383a42',
  white = '#f3f3f3',
  light_green = '#83a598',
  orange = '#fe8019',
  green = '#8ec07c',
}
local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
  self.status = ''
  self.applied_separator = ''
  self:apply_highlights(default_highlight)
  self:apply_section_separators()
  return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
  for name, section in pairs(sections) do
    local is_left = name:sub(9, 10) < 'x'
    if is_left then
      for pos = 1, name == 'lualine_a' and #section or #section - 1 do
        table.insert(section, pos * 2, { empty, color = { fg = colors.black, bg = colors.black } })
      end
      for id, comp in ipairs(section) do
        if type(comp) ~= 'table' then
          comp = { comp }
          section[id] = comp
        end
        comp.separator = { right = ' ' }
      end
    end
  end
  return sections
end

require('lualine').setup({
  options = {
    theme = 'catppuccin',
    ignore_focus = { 'NvimTree', 'TelescopePrompt' },
    icons_enabled = true,
    component_separators = '',
    section_separators = { left = ' ', right = ' ' },
  },
  sections = process_sections {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1,1) end },
    },
    lualine_b = {
      {
        'buffers',
        hide_filename_extension = true,
        symbols = {
          modified = ' ●', -- Text to show when the buffer is modified
          alternate_file = '', -- Text to show to identify the alternate file
          directory = ' ', -- Text to show when the buffer is a directory
        },
      }
    },
    lualine_c = {
      {'g:coc_status'}
    },

    lualine_x = {
      { 'filename', path = 1, file_status = false },
    },
    lualine_y = {
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'coc' },
        diagnostics_color = {
          error = "LualineErrorHighlight",
        },
        sections = { 'error' }
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'coc' },
        diagnostics_color = {
          warn =  "LualineWarnHighlight",
        },
        sections = { 'warn' }
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'coc' },
        diagnostics_color = {
          info = "LualineInfoHighlight",
        },
        sections = { 'info' }
      },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'coc' },
        diagnostics_color = {
          hint = "LualineHintHighlight",
        },
        sections = { 'hint' }
      }
    },
    lualine_z = {
      'filetype',
      '%l:%c'
    },
  }
})

vim.api.nvim_create_augroup("Lualine", {})
vim.api.nvim_create_autocmd("User CocStatusChange", {
  group = "Lualine",
  command = "call v:lua.require('lualine').refresh()",
  desc = "Refresh when CoC status changes"
})
