local w = require("wezterm")
local balance = require("balance")
local color = require("color")
local splits = require("smart-splits")

local act = w.action

local config = {
  color_scheme = color.scheme_for_appearance(color.get_appearance()),
  hide_tab_bar_if_only_one_tab = true,
  window_padding = {
    top = 18,
  },
  font = w.font("SF Mono", { weight = "Medium" }),
  font_size = 14.0,
  freetype_load_target = "Light",
  freetype_load_flags = "NO_HINTING",
  keys = {
    {
      key = "d",
      mods = "CMD",
      action = balance.split_and_balance({
        direction = "Right",
        size = { Percent = 50 },
      }),
    },
    {
      key = "d",
      mods = "CMD|SHIFT",
      action = balance.split_and_balance({
        direction = "Down",
        size = { Percent = 50 },
      }),
    },
    { -- Default new tab automatically goes to the same cwd as the current pane - this defaults to home dir
      key = "t",
      mods = "CMD",
      action = act.SpawnCommandInNewTab({
        cwd = w.home_dir,
      }),
    },
    { -- Default is to close the tab, this closes the pane (+tab if last pane, +window if last tab) instead
      key = "w",
      mods = "CMD",
      action = act.CloseCurrentPane({ confirm = true }),
    },
    -- Clears the scrollback and viewport leaving the prompt line the new first line.
    {
      key = "k",
      mods = "CMD",
      action = act.Multiple({
        act.ClearScrollback("ScrollbackAndViewport"),
        act.SendKey({ key = "L", mods = "CTRL" }),
      }),
    },
    -- move between split panes
    splits.split_nav("move", "h"),
    splits.split_nav("move", "j"),
    splits.split_nav("move", "k"),
    splits.split_nav("move", "l"),
    -- resize panes
    splits.split_nav("resize", "h"),
    splits.split_nav("resize", "j"),
    splits.split_nav("resize", "k"),
    splits.split_nav("resize", "l"),
  },
  set_environment_variables = {
    -- Compatibility with `fish` cwd (OSC7) reporting
    VTE_VERSION = "6003",
  },
  inactive_pane_hsb = {
    saturation = 0.95,
    brightness = 0.95,
  },
  window_decorations = "RESIZE",
}

return config
