local npairs = require('nvim-autopairs')
npairs.setup({
  disable_filetype = { "TelescopePrompt", "NvimTree" },
  map_cr = false
})

local remap = vim.api.nvim_set_keymap

-- skip it, if you use another global object
_G.MUtils = {}

MUtils.completion_confirm = function()
  if vim.fn["coc#pum#visible"]() ~= 0 then
    return vim.fn["coc#pum#confirm"]()
  else
    return npairs.autopairs_cr()
  end
end
remap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })


-- npairs.add_rules(require('nvim-autopairs.rules.basic'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
