local w = require("wezterm")
local color = require("color")

local act = w.action

local config = {}

if w.config_builder then
	config = w.config_builder()
end

local function tmux_binding(key)
	return act.Multiple({
		act.SendKey({ key = "A", mods = "CTRL" }),
		act.SendKey({ key = key }),
	})
end

config.color_scheme = color.scheme_for_appearance(color.get_appearance())
config.hide_tab_bar_if_only_one_tab = true
config.default_prog = { "/opt/homebrew/bin/tmux", "new", "-A", "-s", "default" }
config.window_padding = {
	top = 18,
}
config.font = w.font_with_fallback({
	{ family = "SF Mono", weight = "Medium" },
	{ family = "SF Pro", weight = "Medium" }, -- For SF Symbols
})
config.font_size = 14.0
config.freetype_load_target = "Light"
config.freetype_load_flags = "NO_HINTING"
config.keys = {
	{
		key = "d",
		mods = "CMD",
		action = tmux_binding("%"),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = tmux_binding('"'),
	},
	{
		key = "k",
		mods = "CMD",
		action = tmux_binding("k"),
	},
	{
		key = "j",
		mods = "CMD",
		action = tmux_binding("t"),
	},
	{
		key = "t",
		mods = "CMD",
		action = tmux_binding("c"),
	},
	{
		key = "T",
		mods = "CMD|SHIFT",
		action = tmux_binding("T"),
	},
	{
		key = ",",
		mods = "CMD",
		action = tmux_binding(","),
	},
	{
		key = "f",
		mods = "CMD",
		action = tmux_binding("e"),
	},
	{
		key = "[",
		mods = "CMD|SHIFT",
		action = tmux_binding("p"),
	},
	{
		key = "]",
		mods = "CMD|SHIFT",
		action = tmux_binding("n"),
	},
}

for i = 1, 9, 1 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CMD",
		action = tmux_binding(tostring(i)),
	})
end

config.set_environment_variables = {
	-- Compatibility with `fish` cwd (OSC7) reporting
	VTE_VERSION = "6003",
}
config.window_decorations = "RESIZE"

return config
