local slow_format_filetypes = {}

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		fish = { "fish_indent" },
		python = { "flake8" },
		rust = { "rustfmt" },
		swift = { "swift_format" },
		javascript = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		json = { { "prettierd", "prettier", "jq" } },
		ruby = { "rubocop" },
		markdown = { "markdown_lint" },
		yaml = { "yamlfmt" },
	},

	-- Set up format-on-save => Detect slow formatters and run them asynchronously
	format_on_save = function(bufnr)
		if slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end
		local function on_format(err)
			if err and err:match("timeout$") then
				slow_format_filetypes[vim.bo[bufnr].filetype] = true
			end
		end

		return { timeout_ms = 200, lsp_fallback = true }, on_format
	end,

	format_after_save = function(bufnr)
		if not slow_format_filetypes[vim.bo[bufnr].filetype] then
			return
		end
		return { lsp_fallback = true }
	end,

	-- Customize formatters
	formatters = {
		shfmt = {
			prepend_args = { "-i", "2" },
		},
	},
})
