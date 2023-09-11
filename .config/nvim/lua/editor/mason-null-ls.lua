local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
nls.setup({
	root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
	sources = {
		nls.builtins.code_actions.eslint_d,
		nls.builtins.code_actions.shellcheck,
		nls.builtins.diagnostics.cfn_lint,
		nls.builtins.diagnostics.eslint_d,
		nls.builtins.diagnostics.fish,
		nls.builtins.formatting.fish_indent,
		nls.builtins.formatting.shfmt,
		nls.builtins.formatting.stylua,
		nls.builtins.diagnostics.flake8,
		nls.builtins.diagnostics.markdownlint,
		nls.builtins.diagnostics.shellcheck,
		nls.builtins.diagnostics.swiftlint,
		nls.builtins.diagnostics.tidy,
		nls.builtins.formatting.clang_format,
		nls.builtins.formatting.eslint_d,
		nls.builtins.formatting.prettierd,
		nls.builtins.formatting.rustfmt,
		nls.builtins.formatting.swift_format,
		nls.builtins.formatting.xmllint,
		nls.builtins.formatting.yamlfmt,
		nls.builtins.formatting.rubocop,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_buf_create_user_command(bufnr, "LspFormatting", function(opts)
				local async = vim.stricmp(opts.fargs[1], "async") == 0
				vim.lsp.buf.format({ bufnr = bufnr, async = async })
			end, { nargs = 1 })

			-- you can leave this out if your on_attach is unique to null-ls,
			-- but if you share it with multiple servers, you'll want to keep it
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})
			local callback = function(opts)
				return function()
					vim.lsp.buf.format(opts)
				end
			end

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = callback({ bufnr = bufnr, async = false }),
			})
			-- vim.api.nvim_create_autocmd("User", {
			--   pattern = "AutoSaveWritePre",
			--   group = augroup,
			--   callback = callback(bufnr, false)
			-- })
		end
	end,
})
require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
})
