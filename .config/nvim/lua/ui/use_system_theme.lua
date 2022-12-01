local M = {}

local timer = vim.loop.new_timer()

function Exec(command)
  local process = assert(io.popen(command, "r"))
  local output = string.gsub(process:read('*all'), "[%s%n]*$", "")
  process:close()
  return output
end

LastColorScheme = nil
M.UpdateColorScheme = function (colorScheme)
  if colorScheme == 'dark' then
    if LastColorScheme ~= 'dark' then
      print('Changing to dark mode')
      vim.opt.background = 'dark'
      vim.api.nvim_command("colorscheme catppuccin-macchiato")
      LastColorScheme = 'dark'
    end
  else
    if LastColorScheme ~= 'light' then
      print('Changing to light mode')
      vim.opt.background = 'light'
      vim.api.nvim_command("colorscheme catppuccin-latte")
      LastColorScheme = 'light'
    end
  end
end

M.ChangeToSystemColor = function (arg)
  local theme = nil
  local iTermProfile = os.getenv('ITERM_PROFILE')
  if iTermProfile == 'Dark' or iTermProfile == 'Light' then
    theme = string.lower(iTermProfile)
  elseif arg == "startup" then
    -- Enable 24-bit color, since our colorschemes require it
    vim.opt.termguicolors = true
    LastColorScheme = nil

    theme = os.getenv("APPLE_INTERFACE_STYLE")
    -- Update immediately, otherwise the UI flashes a bit
    M.UpdateColorScheme(string.lower(theme or ""))
  else
    theme = string.lower(Exec("defaults read -g AppleInterfaceStyle 2>/dev/null"))
  end

  vim.schedule(function() M.UpdateColorScheme(theme) end)
end

M.UpdateWhenSystemChanges = function ()
  local timerInterval = 3000
  timer:start(timerInterval, timerInterval, M.ChangeToSystemColor)
end

return M
