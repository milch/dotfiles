vim.opt.guifont = "SF Mono,SF Pro,FiraCode Nerd Font:h14"
vim.g.neovide_floating_shadow = false
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_scroll_animation_length = 0.00
vim.g.autochdir = true

vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
vim.keymap.set("v", "<D-c>", '"+y') -- Copy
vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
vim.keymap.set("n", "<D-w>", ":qa!<CR>") -- Quit
