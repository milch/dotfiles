-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function configure_tree(quit_on_focus_loss)
  require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
        relativenumber = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
            { key = "-", action = "close" },
          },
        },
        float = {
          enable = quit_on_focus_loss,
          quit_on_focus_loss = quit_on_focus_loss
        },
      },
      renderer = {
        highlight_opened_files = "icon"
      },
      filters = {
      },
      actions = {
        open_file = {
          quit_on_open = true
        }
      }
    })
end

-- vim.api.nvim_set_keymap('n', '-', ':NvimTreeToggle .<CR>', { silent = true })

function _G.toggle_tree()
  configure_tree(true)
  require('nvim-tree.api').tree.toggle()
end


local api = require('nvim-tree.api')
local Event = api.events.Event
api.events.subscribe(Event.TreeClose, function()
  configure_tree(false)
end)

vim.api.nvim_set_keymap('n', '-', ':lua toggle_tree()<CR>', { silent = true })

return {
  configure_tree = configure_tree
}
