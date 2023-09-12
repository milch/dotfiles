local wezterm = require("wezterm")

local M = {}

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function M.get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

function M.scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "catppuccin-macchiato"
  else
    return "catppuccin-latte"
  end
end

return M
