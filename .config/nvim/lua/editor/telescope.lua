local builtin = require('telescope.builtin')

require('telescope').setup {
  pickers = {
    find_files = { theme = "dropdown" },
    git_files = { theme = "dropdown" },
    live_grep = { theme = "dropdown" },
    buffers = { theme = "dropdown" },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}
require('telescope').load_extension('fzf')

local gitIfAvailable = function()
  local gitFolder = vim.api.nvim_call_function("finddir", { ".git", ";" })
  if gitFolder == '' then
    return builtin.find_files()
  else
    return builtin.git_files({ show_untracked = true })
  end
end

local find_all = function()
  return builtin.find_files({ hidden = true, no_ignore = false })
end

vim.keymap.set('n', '<leader>f', gitIfAvailable, {})
vim.keymap.set('n', '<leader>p', find_all, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})

vim.keymap.set('n', '<leader>sb', builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>sc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>ss', builtin.git_status, {})
