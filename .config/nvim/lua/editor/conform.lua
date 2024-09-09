local slow_format_filetypes = {}

local function filter_note_template(self, ctx)
	local templates_path = vim.fs.normalize("~/Notes/Templates/")
	local normalized_path = vim.fs.normalize(ctx.filename)
	local is_notes_path = normalized_path:sub(1, #templates_path) == templates_path
	return not is_notes_path
end

local js_formatters = { { "prettierd", "prettier" } }
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
		javascript = js_formatters,
		typescript = js_formatters,
		javascriptreact = js_formatters,
		typescriptreact = js_formatters,
		json = { { "prettierd", "prettier", "jq" } },
		ruby = { "rubocop" },
		markdown = { { "prettierd", "prettier" }, "markdownlint" },
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
		prettierd = {
			inherit = true,
			condition = filter_note_template,
		},
		prettier = {
			inherit = true,
			condition = filter_note_template,
		},
		markdownlint = {
			inherit = true,
			condition = filter_note_template,
		},
	},
})
