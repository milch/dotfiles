local hyper = { "ctrl", "alt", "cmd" }
local fnHyper = { "ctrl", "alt", "cmd", "fn" }
local shiftHyper = { "ctrl", "alt", "cmd", "shift" }
local bind = hs.hotkey.bind

local yabai_bin = "/opt/homebrew/bin/yabai"

-- Helper functions

---Returns `true` if the file at the given `name` exists
---@param name string
---@return boolean
local function fileExists(name)
	if type(name) ~= "string" then
		return false
	end
	return hs.fs.displayName(name) ~= nil
end

-- Auto reload config on changes
local function reloadConfig(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

local hammerspoonConfigFolder = os.getenv("HOME") .. "/dotfiles/.hammerspoon/"
local spoonsFolder = os.getenv("HOME") .. "/.hammerspoon/Spoons/"

-- Install `SpoonInstall` if it doesn't exist
if not fileExists(spoonsFolder .. "SpoonInstall.spoon") then
	local tempLocation = "/tmp/spoon_install.zip"
	os.execute(
		'curl -L "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/SpoonInstall.spoon.zip" -o ' .. tempLocation
	)
	os.execute('unzip "' .. tempLocation .. '" -d "' .. spoonsFolder .. '"')
end

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("EmmyLua")

hs.pathwatcher.new(hammerspoonConfigFolder, reloadConfig):start()
hs.alert.show("Config loaded")
