local js_formatters = { { "prettierd", "prettier" } }

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
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = vim.list_extend({
				"typescript-language-server",
				"vtsls",
				"css-lsp",
				"html-lsp",
				"json-lsp",
			}, js_formatters[1]),
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				javascript = js_formatters,
				typescript = js_formatters,
				javascriptreact = js_formatters,
				typescriptreact = js_formatters,
				json = { { "prettierd", "prettier", "jq" } },
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
					pattern = "src/(.*).ts$",
					target = "tests/%1.test.ts",
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
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ts_ls = {
					enabled = false,
				},
				vtsls = {
					-- explicitly add default filetypes, so that we can extend
					-- them in related extras
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
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
				},
			},
		},
	},
}
