-- Leader -> to prefix your own keybindings
vim.g.mapleader = ","

-- Install lazy.nvim if it does not exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local theme = require("ui.use_system_theme")
theme.UpdateWhenSystemChanges()

local startupTheme = theme.DetermineTheme("startup")
vim.opt.background = startupTheme

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
	install = {
		colorscheme = { theme.GetColorScheme(startupTheme) },
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

pcall(require, "init_local")
require("opt")
require("keybindings")

-- Blink the thing that you just yanked
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 100,
		})
	end,
})
