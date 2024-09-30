local group = vim.api.nvim_create_augroup("qmk", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	pattern = "*.c",
	callback = function()
		require("qmk").setup({
			name = "lilly58",
			layout = { "x x" },
			variant = "qmk",
		})
	end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	pattern = "*.keymap",
	callback = function()
		require("qmk").setup({
			name = "lilly58",
			layout = { "x x" },
			variant = "zmk",
		})
	end,
})
return {
	{
		"codethread/qmk.nvim",
		lazy = true,
	},
}
