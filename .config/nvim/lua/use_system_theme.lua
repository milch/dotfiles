local timer = vim.loop.new_timer()

function Exec(command)
  local process = assert(io.popen(command, "r"))
  local output = string.gsub(process:read('*all'), "[%s%n]*$", "")
  process:close()
  return output
end

LastColorScheme = nil
function UpdateColorScheme(colorScheme)
  if colorScheme == 'dark' then
    if LastColorScheme ~= 'dark' then
      print('Changing to dark mode')
      vim.g.dracula_italic=1
      vim.api.nvim_command("colorscheme Dracula")
      LastColorScheme = 'dark'

      vim.cmd([[
        hi! LualineErrorHighlight guifg=NONE ctermfg=NONE guibg=#ff5555 ctermbg=237 gui=NONE cterm=NONE guisp=NONE
        hi! LualineWarnHighlight guifg=NONE ctermfg=NONE guibg=#ffb86c ctermbg=237 gui=NONE cterm=NONE guisp=NONE
        hi! LualineInfoHighlight guifg=NONE ctermfg=NONE guibg=#424450 ctermbg=237 gui=NONE cterm=NONE guisp=NONE
        hi! LualineHintHighlight guifg=NONE ctermfg=NONE guibg=#282A36 ctermbg=237 gui=NONE cterm=NONE guisp=NONE

        hi! link LualineBufferActive lualine_b_inactive
        hi! link LualineBufferInactive lualine_c_normal
      ]])
    end
  else
    if LastColorScheme ~= 'light' then
      print('Changing to light mode')
      vim.opt.background = 'light'
      vim.g.PaperColor_Theme_Options = {
        theme = {
          ['default.light'] = {
            allow_bold = 1,
            allow_italic = 1
          }
        }
      }
      vim.api.nvim_command("colorscheme PaperColor")
      vim.cmd([[
        hi! link LualineErrorHighlight CocErrorHighlight
        hi! link LualineWarnHighlight CocInfoHighlight
        hi! link LualineInfoHighlight CocWarnHighlight
        hi! link LualineHintHighlight CocHintHighlight

        hi! link LualineBufferActive lualine_b_inactive
        hi! link LualineBufferInactive lualine_b_normal

        hi GitSignsAdd guifg=#008700
        hi GitSignsChange guifg=#ec791b
        hi GitSignsDelete guifg=#af0000
      ]])
      LastColorScheme = 'light'
    end
  end
end

function ChangeToSystemColor(arg)
  local theme = nil
  local iTermProfile = os.getenv('ITERM_PROFILE')
  if iTermProfile == 'Dark' or iTermProfile == 'Light' then
    theme = string.lower(iTermProfile)
  elseif arg == "startup" then
    theme = os.getenv("APPLE_INTERFACE_STYLE")
    -- Update immediately, otherwise the UI flashes a bit
    UpdateColorScheme(string.lower(theme or ""))
  else
    theme = string.lower(Exec("defaults read -g AppleInterfaceStyle 2>/dev/null"))
  end

  vim.schedule(function() UpdateColorScheme(theme) end)
end

local timerInterval = 3000
timer:start(timerInterval, timerInterval, ChangeToSystemColor)

-- Enable 24-bit color, since our colorschemes require it
vim.opt.termguicolors = true
ChangeToSystemColor("startup")
