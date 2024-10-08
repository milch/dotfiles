local M = {}

local timer = vim.loop.new_timer()

function Exec(command)
	local process = assert(io.popen(command, "r"))
	local output = string.gsub(process:read("*all"), "[%s%n]*$", "")
	process:close()
	return output
end

LastColorScheme = nil

M.GetColorScheme = function(theme)
	if theme == "dark" then
		return "catppuccin-macchiato"
	end

	return "catppuccin-latte"
end

M.UpdateColorScheme = function(theme)
	local colorscheme = M.GetColorScheme(theme)
	if theme == "dark" then
		if LastColorScheme ~= "dark" then
			vim.opt.background = "dark"
			vim.api.nvim_command("colorscheme " .. colorscheme)
			LastColorScheme = "dark"
		end
	else
		if LastColorScheme ~= "light" then
			vim.opt.background = "light"
			vim.api.nvim_command("colorscheme " .. colorscheme)
			LastColorScheme = "light"
		end
	end
end

M.DetermineTheme = function(arg)
	local theme = nil
	local iTermProfile = os.getenv("ITERM_PROFILE")
	if iTermProfile == "Dark" or iTermProfile == "Light" then
		return string.lower(iTermProfile)
	elseif arg == "startup" then
		theme = os.getenv("APPLE_INTERFACE_STYLE")
		return string.lower(theme or "")
	end

	return string.lower(Exec("defaults read -g AppleInterfaceStyle 2>/dev/null"))
end

M.ChangeToSystemColor = function(arg)
	local theme = M.DetermineTheme(arg)

	if arg == "startup" then
		-- Enable 24-bit color, since our colorschemes require it
		vim.opt.termguicolors = true
		LastColorScheme = nil
	end

	M.UpdateColorScheme(theme)
end

M.UpdateWhenSystemChanges = function()
	vim.fn.jobstart({ "dark-notify" }, {
		on_stdout = function(job_id, data, event)
			for _, line in ipairs(data) do
				if line ~= "" then
					M.UpdateColorScheme(line)
				end
			end
		end,
	})
end

return M
