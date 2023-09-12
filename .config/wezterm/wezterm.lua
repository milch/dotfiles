local w = require('wezterm')
local balance = require('balance')

local function split_and_balance(split_opts)
  return w.action_callback(function(window, pane)
    local axis
    if split_opts.direction == "Up" or split_opts.direction == "Down" then
      axis = "y"
    else
      axis = "x"
    end
    window:perform_action(
      w.action.SplitPane(split_opts),
      pane
    )
    balance.balance_panes(axis)(window, pane)
  end)
end

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = w.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

local config = {
  color_scheme = "catppuccin-latte",
  hide_tab_bar_if_only_one_tab = true,
  font = w.font('SF Mono', { weight = 'Medium' }),
  font_size = 14.0,
  freetype_load_target = "Light",
  freetype_load_flags = 'NO_HINTING',
  keys = {
    {
      key = "d",
      mods = "CMD",
      action = split_and_balance({
        direction = 'Right',
        size = { Percent = 50 }
      })
    },
    {
      key = "d",
      mods = "CMD|SHIFT",
      action = split_and_balance({
        direction = 'Down',
        size = { Percent = 50 }
      })
    },
    { -- Default new tab automatically goes to the same cwd as the current pane - this defaults to home dir
      key = "t",
      mods = "CMD",
      action = w.action.SpawnCommandInNewTab {
        cwd = w.home_dir
      }
    },
    { -- Default is to close the tab, this closes the pane (+tab if last pane, +window if last tab) instead
      key = 'w',
      mods = 'CMD',
      action = w.action.CloseCurrentPane { confirm = true },
    },
    -- move between split panes
    split_nav('move', 'h'),
    split_nav('move', 'j'),
    split_nav('move', 'k'),
    split_nav('move', 'l'),
    -- resize panes
    split_nav('resize', 'h'),
    split_nav('resize', 'j'),
    split_nav('resize', 'k'),
    split_nav('resize', 'l'),
  },
  set_environment_variables = {
    -- Compatibility with `fish` cwd (OSC7) reporting
    VTE_VERSION = '6003',
  },
  inactive_pane_hsb = {
    saturation = 0.95,
    brightness = 0.95,
  },
}

return config
