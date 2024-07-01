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

local function yabai(args, completion)
	return function()
		local yabai_output = ""
		local yabai_error = ""
		-- Runs in background very fast
		local yabai_task = hs.task.new(yabai_bin, nil, function(task, stdout, stderr)
			--print("stdout:"..stdout, "stderr:"..stderr)
			if stdout ~= nil then
				yabai_output = yabai_output .. stdout
			end
			if stderr ~= nil then
				yabai_error = yabai_error .. stderr
			end
			return true
		end, args)
		if type(completion) == "function" then
			yabai_task:setCallback(function()
				completion(yabai_task:terminationStatus(), yabai_output, yabai_error)
			end)
		end
		yabai_task:start()
	end
end

local function exec(cmd)
	return function()
		local task = hs.task.new("/bin/zsh", nil, function()
			return true
		end, { "-c", cmd })
		task:start()
	end
end

local function yabai_focus(dir)
	return yabai({ "-m", "window", "--focus", dir }, function(status)
		if status ~= 0 then
			yabai({ "-m", "display", "--focus", dir })()
		end
	end)
end

bind(hyper, "h", yabai_focus("west"))
bind(hyper, "j", yabai_focus("south"))
bind(hyper, "k", yabai_focus("north"))
bind(hyper, "l", yabai_focus("east"))

local function yabai_swap(dir)
	return exec(
		yabai_bin
			.. " -m window --swap "
			.. dir
			.. " || ("
			.. yabai_bin
			.. " -m window --display "
			.. dir
			.. "; "
			.. yabai_bin
			.. " -m display --focus "
			.. dir
			.. ")"
	)
end
-- swap windows
bind(shiftHyper, "h", yabai_swap("west"))
bind(shiftHyper, "j", yabai_swap("south"))
bind(shiftHyper, "k", yabai_swap("north"))
bind(shiftHyper, "l", yabai_swap("east"))

bind(hyper, "x", yabai({ "-m", "space", "--mirror", "x-axis" }))
bind(hyper, "y", yabai({ "-m", "space", "--mirror", "y-axis" }))

bind(hyper, "r", yabai({ "-m", "space", "--rotate", "270" }))
bind(shiftHyper, "r", yabai({ "-m", "config", "--space", "mouse", "layout", "bsp" }))

bind(hyper, "t", yabai({ "-m", "window", "--toggle", "float", "--grid", "4:4:1:1:2:2" }))
bind(
	shiftHyper,
	"t",
	yabai({ "-m", "config", "--space", "mouse", "layout" }, function(_, out)
		local layout = string.match(out, "[a-zA-Z]+")
		if layout == "bsp" then
			hs.alert.show("Stack")
			yabai({ "-m", "config", "--space", "mouse", "layout", "stack" })()
		else
			hs.alert.show("BSP")
			yabai({ "-m", "config", "--space", "mouse", "layout", "bsp" })()
		end
	end)
)

-- maximize a window
bind(hyper, "f", yabai({ "-m", "window", "--toggle", "zoom-fullscreen" }))
-- balance out tree of windows (resize to occupy same area)
bind(hyper, "0", yabai({ "-m", "space", "--balance" }))

-- move window to prev and next space
local function yabai_move_and_follow(dir)
	local focusedWindow = hs.window.focusedWindow()
	return yabai({ "-m", "window", "--space", dir }, function()
		if dir == "prev" then
			hs.eventtap.keyStroke({ "ctrl", "fn" }, "left")
		else
			hs.eventtap.keyStroke({ "ctrl", "fn" }, "right")
		end
		focusedWindow:focus()
	end)
end
bind(hyper, "[", yabai_move_and_follow("prev"))
bind(hyper, "]", yabai_move_and_follow("next"))

-- Workaround for macOS' weird behaviour where when "Displays have their own spaces" is on,
-- it then treats the space numbers as absolute, i.e. if display 1 has 3 spaces and
-- display 2 has 3 spaces then pressing the shortcut to switch to space 1 will always
-- go to space 1 on display 1, even if the current focus is on display 2. I just keep
-- 9 spaces on every display and then assign different modifiers to each display. The shortcuts
-- need to be mutually exclusive, otherwise it doesn't trigger correctly, and (for some reason)
-- can't contain `fn`.
local function switch_to_space(num)
	return function()
		if hs.screen.primaryScreen() == hs.screen.mainScreen() then
			hs.eventtap.keyStroke({ "ctrl", "alt" }, num)
		else
			hs.eventtap.keyStroke({ "ctrl", "cmd" }, num)
		end
	end
end

bind(hyper, "1", switch_to_space("1"))
bind(hyper, "2", switch_to_space("2"))
bind(hyper, "3", switch_to_space("3"))
bind(hyper, "4", switch_to_space("4"))
bind(hyper, "5", switch_to_space("5"))
bind(hyper, "6", switch_to_space("6"))
bind(hyper, "7", switch_to_space("7"))
bind(hyper, "8", switch_to_space("8"))
bind(hyper, "9", switch_to_space("9"))

local cached_space_ids = {}
-- # move window to space #
local function move_window(space_num)
	return function()
		-- This returns the space's ID, which is different from the mission control index that yabai uses
		local target_space_id = hs.spaces.spacesForScreen()[tonumber(space_num)]
		yabai({ "-m", "query", "--spaces", "id,index" }, function(_, result)
			local space_id_to_idx = hs.json.decode(result)
			local find_id = function(elem)
				return elem.id == target_space_id
			end
			local ok, space = pcall(hs.fnutils.find, space_id_to_idx, find_id)
			if ok then
				cached_space_ids = space_id_to_idx
			else
				print("yabai sporadically errorred ... using cached space id to index mappings: " .. result)
				space = hs.fnutils.find(cached_space_ids, find_id)
			end
			if space ~= nil and space.index ~= nil then
				local cmd = { "-m", "window", "--space", tostring(space.index), "--focus" }
				print(hs.inspect(cmd))
				yabai(cmd)()
			else
				hs.alert("No space found :(")
			end
		end)()
	end
end

bind(shiftHyper, "1", move_window("1"))
bind(shiftHyper, "2", move_window("2"))
bind(shiftHyper, "3", move_window("3"))
bind(shiftHyper, "4", move_window("4"))
bind(shiftHyper, "5", move_window("5"))
bind(shiftHyper, "6", move_window("6"))
bind(shiftHyper, "7", move_window("7"))
bind(shiftHyper, "8", move_window("8"))
bind(shiftHyper, "9", move_window("9"))

bind(hyper, "q", yabai({ "--stop-service" }))
bind(shiftHyper, "q", yabai({ "--start-service" }))

-- Toggle whether a window is split vertically or horizontally
bind(hyper, "s", yabai({ "-m", "window", "--toggle", "split" }))

-- Move window to a different screen
bind(hyper, "Tab", yabai({ "-m", "window", "--display", "next" }))

bind(
	hyper,
	"`",
	yabai({ "-m", "config", "--space", "mouse", "layout" }, function(_, out)
		local layout = string.match(out, "[a-zA-Z]+")
		if layout == "stack" then
			exec(yabai_bin .. " -m window --focus stack.next || " .. yabai_bin .. " -m window --focus stack.first")()
		else
			local windows = hs.window.visibleWindows()
			local mainScreen = hs.screen.mainScreen()
			local focusedWindow = hs.window.focusedWindow()
			for index, window in ipairs(windows) do
				if
					window:isVisible()
					and window:isStandard()
					and window:screen():id() == mainScreen:id()
					and window:id() ~= focusedWindow:id()
				then
					window:focus()
					break
				end
			end
		end
	end)
)

local delta = "40"
bind(
	hyper,
	"left",
	exec(
		yabai_bin
			.. " -m window --resize left:-"
			.. delta
			.. ":0 || "
			.. yabai_bin
			.. "-m window --resize right:-"
			.. delta
			.. ":0"
	)
)
bind(hyper, "right", yabai({ "-m", "window", "--resize", "left:" .. delta .. ":0" }))
bind(hyper, "up", yabai({ "-m", "window", "--resize", "top:0:-" .. delta }))
bind(hyper, "down", yabai({ "-m", "window", "--resize", "top:0:" .. delta }))
