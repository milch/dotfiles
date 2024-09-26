return {
	{
		"kosayoda/nvim-lightbulb",
		init = function()
			vim.api.nvim_set_hl(0, "LightBulbSign", { link = "DiagnosticSignHint" })
		end,
		opts = {
			autocmd = { enabled = true, updatetime = 0 },
		},
	},
}
