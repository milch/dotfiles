local wilder = require('wilder')
wilder.setup({ modes = { ':', '/', '?' } })
wilder.set_option('pipeline', {
  wilder.branch(
    wilder.python_file_finder_pipeline({
      file_command = function(_, arg)
        if string.find(arg, '.') ~= nil then
          return { 'rg', '--files', '--hidden' }
        else
          return { 'rg', '--files' }
        end
      end,
      dir_command = { 'fd', '-td' },
    }),
    wilder.substitute_pipeline({
      skip_cmdtype_check = 1,
    }),
    wilder.cmdline_pipeline({
      fuzzy = 2,
      fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    {
      wilder.check(function(ctx, x) return x == '' end),
      wilder.history(),
    },
    wilder.python_search_pipeline({
      pattern = 'fuzzy',
    })
  ),
})
local highlighters = {
  wilder.lua_fzy_highlighter(),
}
wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    border = 'rounded',
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
