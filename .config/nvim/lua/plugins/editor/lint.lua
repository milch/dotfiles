-- Below is adapted from LazyVim
local events = { "BufWritePost", "BufReadPost", "InsertLeave" }

-- TODO: Move the filetypes here to per-lang config

local function lint_file()
	-- Use nvim-lint's logic first:
	-- * checks if linters exist for the full filetype first
	-- * otherwise will split filetype by "." and add all those linters
	-- * this differs from conform.nvim which only uses the first filetype that has a formatter
	local lint = require("lint")
	local names = lint._resolve_linter_by_ft(vim.bo.filetype)

	-- Filter out linters that don't exist or don't match the condition.
	local ctx = { filename = vim.api.nvim_buf_get_name(0) }
	ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
	names = vim.tbl_filter(function(name)
		local linter = lint.linters[name]
		return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
	end, names)

	-- Run linters.
	if #names > 0 then
		lint.try_lint(names)
	end
end

local function debounce(ms, fn)
	local timer = vim.uv.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

return {
	{
		"mfussenegger/nvim-lint",
		event = events,
		config = function()
			local lint = require("lint")

			-- LazyVim extension to easily override linter options
			-- or add custom linters.
			---@type table<string,table>
			local linters = {
				eslint_d = {
					condition = function(ctx)
						local found_files = vim.fs.find(
							{ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml", ".eslintrc.yml", ".eslintrc.json" },
							{ path = ctx.filename, upward = true, stop = vim.loop.os_homedir() }
						)
						return #found_files > 0
					end,
				},
				markdownlint = {
					condition = function(ctx)
						local normalized_obsidian_vault = vim.fs.normalize("~/Notes/")
						local normalized_path = vim.fs.normalize(ctx.filename)
						return normalized_path:sub(1, #normalized_obsidian_vault) ~= normalized_obsidian_vault
					end,
				},
				cfn_lint = {
					condition = function()
						local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
						local buffer_contents = table.concat(lines, "\n")
						local matches = vim.fn.matchlist(buffer_contents, [[\C\(Resources\|AWSTemplateFormatVersion\)]])

						return #matches > 0
					end,
				},
			}

			for name, linter in pairs(linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
				else
					lint.linters[name] = linter
				end
			end
			lint.linters_by_ft = {
				markdown = { "markdownlint" },
				fish = { "fish" },
				sh = { "shellcheck" },
				yaml = { "cfn_lint", "yamllint" },
				json = { "cfn_lint" },
				ruby = { "ruby" },
				html = { "tidy" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				javascript = { "eslint_d" },
				python = { "flake8" },
			}

			vim.api.nvim_create_autocmd(events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = debounce(100, lint_file),
			})
		end,
	},
}
