return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "rust" } },
	},
	{
		"stevearc/conform.nvim",
		opts = { formatters_by_ft = { rust = { "rustfmt" } } },
	},
	{
		"saecki/crates.nvim",
		tag = "stable",
		event = { "BufRead Cargo.toml" },
		opts = {
			open_programs = { "open" },
			popup = {
				autofocus = true,
			},
			lsp = {
				enabled = true,
				on_attach = function(client, bufnr)
					require("keybindings").set_lsp()
				end,
				actions = true,
				completion = true,
				hover = true,
			},
			completion = {
				cmp = {
					enabled = true,
				},
				crates = {
					enabled = true,
					min_chars = 2,
					max_results = 10,
				},
			},
		},
	},
	{
		"mrcjkb/rustaceanvim",
		opts = {
			server = {
				on_attach = function(_, bufnr)
					vim.lsp.buf.code_action = function()
						vim.cmd.RustLsp("codeAction")
					end
					vim.keymap.set("n", "<leader>dr", function()
						vim.cmd.RustLsp("debuggables")
					end, { desc = "Rust Debuggables", buffer = bufnr })
				end,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							loadOutDirsFromCheck = true,
							buildScripts = {
								enable = true,
							},
						},
						-- Add clippy lints for Rust.
						checkOnSave = true,
						procMacro = {
							enable = true,
							ignored = {
								["async-trait"] = { "async_trait" },
								["napi-derive"] = { "napi" },
								["async-recursion"] = { "async_recursion" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
		end,
	},
}
