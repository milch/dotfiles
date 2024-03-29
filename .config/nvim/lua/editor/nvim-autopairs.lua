local npairs = require('nvim-autopairs')
npairs.setup({
  disable_filetype = { "TelescopePrompt", "NvimTree" },
})

npairs.add_rules(require('nvim-autopairs.rules.endwise-elixir'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
