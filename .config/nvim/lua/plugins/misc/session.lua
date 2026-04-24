return {
	{
		"stevearc/resession.nvim",
		keys = {
			{
				"<leader>rs",
				[[:lua require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })<CR>]],
				silent = true,
				desc = "Load workspace session",
			},
		},
		lazy = false,
		init = function()
			local should_load = function()
				if vim.fn.argc(-1) ~= 0 then
					return false
				end
				local args = {}
				for _, arg in pairs(vim.v.argv) do
					-- Commands like +Man!
					local is_cmd = string.find(arg, "^+")
					-- ARGF
					local is_argf = string.find(arg, "^-$")
					if arg ~= "nvim" and arg ~= "--embed" or is_cmd or is_argf then
						args[#args + 1] = arg
					end
				end
				if #args == 0 then
					return true
				end
			end
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local restore_pid = vim.env.NVIM_RESTORE_FROM_PID
					if restore_pid ~= nil and restore_pid ~= "" then
						require("resession").load(restore_pid, { dir = "dirsession" })
					end
					require("resession").save(tostring(vim.fn.getpid()), { dir = "dirsession" })
					if restore_pid ~= nil and restore_pid ~= "" then
						-- delete old restore file after we've restored from it
						pcall(os.remove, vim.fn.stdpath("data") .. "/dirsession/" .. restore_pid .. ".json")
					end
				end,
				nested = true,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					-- We called it with truly empty args or a file/dir
					if should_load() or vim.fn.argc(-1) ~= 0 then
						require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
					end

					-- Clearly we're not crashing / restarting the term -> delete the session
					local pid = tostring(vim.fn.getpid())
					pcall(os.remove, vim.fn.stdpath("data") .. "/dirsession/" .. pid .. ".json")
				end,
			})
		end,
		opts = {
			autosave = {
				enabled = true,
				interval = 60,
				notify = false,
			},
		},
	},
}
