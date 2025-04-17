-- Leader -> to prefix your own keybindings
vim.g.mapleader = ","

-- Install lazy.nvim if it does not exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local specs = {
		{ import = "plugins.editor" },
		{ import = "plugins.lang" },
		{ import = "plugins.lsp" },
		{ import = "plugins.misc" },
		{ import = "plugins.ui" },
};

local opt_folder = vim.fn.stdpath('config') .. "/lua/opt"
if vim.uv.fs_stat(opt_folder) then
	for dir, type in vim.fs.dir(opt_folder, { depth = 1 }) do
		table.insert(specs, { import = "opt." .. dir })
	end
end

require("lazy_file").setup()
require("lazy").setup({
	spec = specs,
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
				"matchit",
				"matchparen",
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

require("opt")
require("keybindings").set()
require("disable_defaults")
if vim.g.neovide then
	require("neovide")
end

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
