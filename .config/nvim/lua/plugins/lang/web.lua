local js_formatters = { "prettierd", "prettier", stop_after_first = true }

vim.lsp.config("vtsls", {
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
	},
})

vim.lsp.enable({ "vtsls", "cssls", "html", "jsonls", "tailwindcss" })

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "windwp/nvim-ts-autotag", config = true },
		},
		opts = {
			ensure_installed = {
				"tsx",
				"javascript",
				"json",
				"css",
				"html",
				"jsonc",
				"typescript",
			},
		},
	},
	{
		"dmmulroy/ts-error-translator.nvim",
		event = { "LazyFile" },
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				javascript = js_formatters,
				typescript = js_formatters,
				javascriptreact = js_formatters,
				typescriptreact = js_formatters,
				json = { "prettierd", "prettier", "jq", stop_after_first = true },
			},
		},
	},
	{
		"rgroli/other.nvim",
		opts = {
			mappings = {
				{
					pattern = "lib/(.*).ts$",
					target = "test/%1.test.ts",
					context = "test",
				},
				{
					pattern = "test/(.*).test.ts$",
					target = "lib/%1.ts",
					context = "source",
				},
				{
					pattern = "(.*)/src/(.*).ts$",
					target = "%1/tests/%2.test.ts",
					context = "test",
				},
				{
					pattern = "tests/(.*).test.ts$",
					target = "src/%1.ts",
					context = "source",
				},
			},
		},
	},
}
