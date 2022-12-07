local builtin = require('telescope.builtin')

require('telescope').setup{
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
  local gitFolder = vim.api.nvim_call_function("finddir", {".git", ";"})
  if gitFolder == '' then
    return builtin.find_files()
  else
    return builtin.git_files()
  end
end

vim.keymap.set('n', '<leader>f', gitIfAvailable, {})
vim.keymap.set('n', '<leader>p', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})

vim.keymap.set('n', '<leader>gb', builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})
