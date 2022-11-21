-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
        { key = "-", action = "close" },
      },
    },
    float = {
      enable = true,
    }
  },
  renderer = {
    highlight_opened_files = "icon"
  },
  filters = {
  },
})

vim.api.nvim_set_keymap('n', '-', ':NvimTreeToggle .<CR>', { silent = true })
