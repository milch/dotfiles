vim.g.coc_global_extensions = {
  -- JS/TS
  'coc-html',
  'coc-prettier',
  'coc-eslint',
  'coc-jest',
  'coc-webpack',
  'coc-tsserver',

  -- Languages
  'coc-sh',
  'coc-docker',
  'coc-go',
  'coc-java',
  'coc-jedi', -- Python
  'coc-json',
  'coc-perl',
  'coc-rust-analyzer', -- Rust
  'coc-solargraph', -- Ruby
  'coc-sourcekit', -- C-family/Swift
  'coc-sql',
  'coc-sumneko-lua', -- Lua
  'coc-yaml',

  -- Misc
  'coc-lightbulb',
  'coc-marketplace',
  'coc-snippets',
  'https://github.com/rafamadriz/friendly-snippets@main'
}

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Use tab for trigger completion with characters ahead and navigate.
-- Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
vim.g.coc_snippet_next = '<Tab>'
vim.g.coc_snippet_prev = '<S-Tab>'

local keyset = vim.keymap.set
-- Auto complete
function _G.check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use tab for trigger completion with characters ahead and navigate.
-- NOTE: There's always complete item selected by default, you may want to enable
-- no select by `"suggest.noselect": true` in your configuration file.
-- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- other plugin before putting this into your config.
local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset("i", "<TAB>", string.gsub([[
  coc#pum#visible() ?
    coc#pum#next(1) :
    v:lua.check_back_space() ? "<TAB>" :
    coc#refresh()
]], "\n", ""), opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

keyset('n', 'gd', '<Plug>(coc-definition)', { silent = true })
keyset('n', 'gy', '<Plug>(coc-type-definition)', { silent = true })
keyset('n', 'gi', '<Plug>(coc-implementation)', { silent = true })
keyset('n', 'gr', '<Plug>(coc-references)', { silent = true })

keyset('n', '<leader>a', '<Plug>(coc-codeaction)')
keyset('n', '<leader>rn', '<Plug>(coc-rename)')
keyset('i', '<c-a>', 'coc#refresh()', { noremap = true, silent = true, expr = true })

keyset("n", "[p", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "[n", "<Plug>(coc-diagnostic-next)", { silent = true })

-- Use K to show documentation in preview window.
function _G.show_docs()
  local cw = vim.fn.expand('<cword>')
  if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
    vim.api.nvim_command('h ' .. cw)
  elseif vim.api.nvim_eval('coc#rpc#ready()') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
  end
end

keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

-- Highlight the symbol and its references when holding the cursor.
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
  group = "CocGroup",
  command = "silent call CocActionAsync('highlight')",
  desc = "Highlight symbol under cursor on CursorHold"
})

-- Formatting selected code.
keyset("x", "gf", "<Plug>(coc-format-selected)", { silent = true })
keyset("v", "gf", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "gf", "<Plug>(coc-format-selected)", { silent = true })

-- Update signature help on jump placeholder.
vim.api.nvim_create_autocmd("User", {
  group = "CocGroup",
  pattern = "CocJumpPlaceholder",
  command = "call CocActionAsync('showSignatureHelp')",
  desc = "Update signature help on jump placeholder"
})

vim.api.nvim_create_autocmd({ "BufRead", "VimEnter" }, {
  group = "CocGroup",
  command = "if expand('%') =~ \"/private/var/folders\" | call coc#config('coc.preferences.formatOnSaveFiletypes', []) | endif",
  desc = "Disable autoformat on save for temporary folders"
})
