local Hydra = require('hydra')
local cmd = require('hydra.keymap-util').cmd

Hydra({
  name = 'Telescope',
  hint = [[
_o_: old files      _f_: files
_/_: search in file _r_: resume

_h_: vim help       _c_: execute command
_k_: keymaps        _;_: commands history
_O_: options        _?_: search history
^
_<Enter>_: Telescope           _<Esc>_
  ]],
  config = {
    color = 'teal',
    invoke_on_body = true,
    hint = {
      position = 'middle',
      border = 'rounded',
    },
  },
  mode = 'n',
  body = '<Leader>h',
  heads = {
    { 'f', cmd 'Telescope find_files hidden=true' },
    { 'o', cmd 'Telescope oldfiles', { desc = 'recently opened files' } },
    { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
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

local abc = 'def'

Hydra({
  name = 'Refactor',
  hint = [[
_e_: Extract Function  _E_: Extract Function To File
_v_: Extract Variable  _V_: Inline Variable
^
_<Esc>_
]],
  config = {
    color = 'teal',
    invoke_on_body = true,
    hint = {
      position = 'bottom',
      border = 'rounded',
    },
  },
  mode = {'v'},
  body = '<Leader>rf',
  heads = {
    { 'e', cmd 'lua require("refactoring").refactor("Extract Function")' },
    { 'E', cmd 'lua require("refactoring").refactor("Extract Function To File")' },
    { 'v', cmd 'lua require("refactoring").refactor("Extract Variable")' },
    { 'V', cmd 'lua require("refactoring").refactor("Inline Variable")' },
    { '<Esc>', nil, { exit = true, nowait = true } },
  }
})

Hydra({
  name = 'Refactor',
  hint = [[
_e_: Extract Block   _E_: Extract Block To File
^                   _i_: Inline Variable
_d_: Add debug print _D_: Remove debug print
^
_<Esc>_
]],
  config = {
    color = 'teal',
    invoke_on_body = true,
    hint = {
      position = 'bottom',
      border = 'rounded',
    },
  },
  mode = {'n'},
  body = '<Leader>rf',
  heads = {
    { 'e', cmd 'lua require("refactoring").refactor("Extract Block")' },
    { 'E', cmd 'lua require("refactoring").refactor("Extract Block To File")' },
    { 'i', cmd 'lua require("refactoring").refactor("Inline Variable")' },
    { 'd', cmd 'lua require("refactoring").debug.print_var({ normal = true })' },
    { 'D', cmd 'lua require("refactoring").debug.cleanup({})' },
    { '<Esc>', nil, { exit = true, nowait = true } },
  }
})
